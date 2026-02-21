import 'dart:convert';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/blockListController.dart';
import 'package:educationapp/coreFolder/Controller/chatController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/blockBodyModel.dart';
import 'package:educationapp/coreFolder/Model/blockListModel.dart';
import 'package:educationapp/coreFolder/Model/chatHistoryResMdel.dart';
import 'package:educationapp/coreFolder/Model/reportResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatingPage extends ConsumerStatefulWidget {
  final String name;
  final String id;
  final String otherUesrid;

  const ChatingPage({
    super.key,
    required this.name,
    required this.id,
    required this.otherUesrid,
  });

  @override
  ConsumerState<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends ConsumerState<ChatingPage>
    with WidgetsBindingObserver {
  WebSocketChannel? channel;
  final messController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Chat> _messages = [];
  bool isBlocked = false;
  bool isLoading = false;
  String isConnect = "connecting";
  bool _historyLoaded = false; // Add this to prevent state override


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectWS();
    Future.microtask(() {
      ref.invalidate(chatHistoryController(widget.otherUesrid));
    });
  }

  void _connectWS() {
    final box = Hive.box("userdata");
    final userid = box.get("userid");
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(
            "wss://websocket.educatservicesindia.com/chat/ws/user/$userid"),
      );
      setState(() => isConnect = "connected");


      channel!.stream.listen(

        (data) {
          if (data is String) {
            _handleIncomingMessage(data);
          }
        },

        onError: (error) {
          log("WS Error: $error");
          setState(() => isConnect = "disconnected");
          _reconnectWebSocket();
        },

        onDone: () {
          log("WS Closed");
          _reconnectWebSocket();
        },

      );


    } catch (e) {
      log("WS Connect Error: $e");
    }


  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        log("Reconnecting...", name: "WEBSOCKET");
        _connectWS();
      }
    });
  }

  void _handleIncomingMessage(String raw) {
    try {
      final jsonMap = jsonDecode(raw);
      final senderId = int.tryParse(jsonMap["sender_id"].toString()) ?? 0;
      final message = jsonMap["message"]?.toString() ?? "";
      final timestamp =
          jsonMap["timestamp"]?.toString() ?? DateTime.now().toIso8601String();

      if (message.isEmpty) return;

      final box = Hive.box("userdata");
      final myId = int.parse(box.get("userid").toString());

      if (senderId == myId) return;

      final alreadyExists = _messages.any((m) =>
          m.message == message &&
          m.timestamp == timestamp &&
          m.sender == senderId);

      if (alreadyExists) return;

      if (mounted) {
        setState(() {
          _messages.add(Chat(
            sender: senderId,
            message: message,
            timestamp: timestamp,
          ));
        });
        _scrollToBottom();
      }
    } catch (e, st) {
      log("WS Parse Error: $e");
    }
  }



  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    final box = Hive.box("userdata");
    final userid = box.get("userid");

    final outgoingData = {
      "receiver_id": widget.otherUesrid,
      "message": message.trim(),
    };

    log("OUTGOING (PRETTY):\n${JsonEncoder.withIndent('  ').convert(outgoingData)}",
        name: "CHAT_SEND");

    channel?.sink.add(jsonEncode(outgoingData));

    setState(() {
      _messages.add(Chat(
        sender: int.tryParse(userid.toString()),
        message: message.trim(),
        timestamp: DateTime.now().toIso8601String(),
      ));
    });

    messController.clear();
    _scrollToBottom();
  }



  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    channel?.sink.close();
    messController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> showReportDialog(BuildContext context) async {
    final reportController = TextEditingController();
    bool isReport = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              title: Text("Report",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              content: TextField(
                controller: reportController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your report reason...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: isReport
                      ? null
                      : () async {
                          if (reportController.text.trim().isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter a reason");
                            return;
                          }
                          setStateDialog(() => isReport = true);
                          try {
                            final body = ReportBodyModel(
                              reportedId: widget.otherUesrid,
                              reason: reportController.text,
                            );
                            final service = APIStateNetwork(createDio());
                            final response = await service.report(body);
                            Fluttertoast.showToast(
                                msg: response.message ??
                                    "Report submitted successfully");
                            if (response.data != null) Navigator.pop(context);
                          } catch (e, st) {
                            Fluttertoast.showToast(
                                msg: "API Error: ${e.toString()}");
                            log("Report Error: $e\n$st");
                          } finally {
                            setStateDialog(() => isReport = false);
                          }
                        },
                  child: isReport
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDateHeader(DateTime dateTime, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(messageDate).inDays;
    if (difference == 0) return "Today";
    if (difference == 1) return "Yesterday";
    return DateFormat('MMM d, yyyy').format(dateTime);
  }



  @override
  Widget build(BuildContext context) {
    final historyData = ref.watch(chatHistoryController(widget.otherUesrid));
    final box = Hive.box("userdata");
    final userid = box.get("userid");
    final themeMode = ref.watch(themeProvider);
    historyData.whenData((snap) {
      if (!_historyLoaded && snap.chat != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _messages = List<Chat>.from(snap.chat!);
              _historyLoaded = true;
            });
            _scrollToBottom();
          }
        });
      }
    });

    final blockListAsync = ref.watch(blockListController);

    if (blockListAsync is AsyncData<BlockListModel>) {
      isBlocked = blockListAsync.value.data!.any(
        (block) =>
            block.blockedId.toString() == widget.otherUesrid &&
            block.status == true,
      );
    }

    return Scaffold(

      backgroundColor: themeMode == ThemeMode.dark
          ? const Color(0xFF1B1B1B)
          : const Color(0xff9088F1),

      body: historyData.when(

        data: (snap) {
          String statusText = "online";
          final myId = int.parse(userid.toString());
          final otherMessages =
              _messages.where((m) => m.sender != myId).toList();

          if (otherMessages.isNotEmpty) {
            try {
              final lastOtherTime = otherMessages.last.timestamp!;
              final lastTime = DateTime.parse(lastOtherTime);
              final diff = DateTime.now().difference(lastTime);
              if (diff.inMinutes > 5) {
                statusText =
                    "Last seen ${DateFormat('MMM d, h:mm a').format(lastTime)}";
              }
            } catch (_) {}
          }

          final sortedMessages = List<Chat>.from(_messages)
            ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

          return Column(
            children: [
              SizedBox(height: 30.h),
              _buildHeader(context, themeMode, statusText, isConnect),
              SizedBox(height: 25.h),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : const Color(0xFF1B1B1B),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _historyLoaded = false;
                            await ref.refresh(
                                chatHistoryController(widget.otherUesrid)
                                    .future);
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                                left: 20.w, right: 20.w, top: 20.h),
                            itemCount: sortedMessages.length,
                            itemBuilder: (context, index) {
                              final msg = sortedMessages[index];
                              final date = DateTime.parse(msg.timestamp!);
                              final prevDate = index > 0
                                  ? DateTime.parse(
                                      sortedMessages[index - 1].timestamp!)
                                  : null;
                              final showHeader = prevDate == null ||
                                  DateFormat('yyyy-MM-dd').format(prevDate) !=
                                      DateFormat('yyyy-MM-dd').format(date);

                              return Column(
                                children: [
                                  if (showHeader)
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Text(
                                          _formatDateHeader(
                                              date, DateTime.now()),
                                          style: GoogleFonts.dmSans(
                                              fontSize: 12.sp,
                                              color: Colors.grey)),
                                    ),
                                  ChatBubble(
                                    message: msg.message!,
                                    isSender: msg.sender.toString() ==
                                        userid.toString(),
                                    dateTime: msg.timestamp!,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (isBlocked)
                        _buildBlockedLabel()
                      else
                        MessageInput(
                          controller: messController,
                          onSend: () => _sendMessage(messController.text),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },

        error: (err, st) => const Center(child: Text("Error loading chat")),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
      ),


    );
  }



  // --- UI Components to keep code clean ---


  Widget _buildHeader(
      BuildContext context, ThemeMode themeMode, String status, String socket) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
          const Spacer(),
          Column(
            children: [
              Text(widget.name,
                  style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Text(status,
                  style: GoogleFonts.roboto(
                      fontSize: 14.sp, color: const Color(0xFFDCF881))),

            ],
          ),
          const Spacer(),
          _buildPopup()
        ],
      ),
    );
  }

  Widget _buildBlockedLabel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      color: Colors.red.withOpacity(0.1),
      child: Text("You cannot send messages to this user",
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
              color: Colors.red, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPopup() {
    return PopupMenuButton<String>(
      onSelected: (val) async {
        if (val == "report") showReportDialog(context);
        if (val == "block") {
          setState(() => isLoading = true);
          try {
            final service = APIStateNetwork(createDio());
            final body = BlockbodyModel(blockedId: widget.otherUesrid);

            if (!isBlocked) {
              final res = await service.block(body);
              Fluttertoast.showToast(msg: res.message ?? "User Blocked");
            } else {
              final res = await service.unblock(body);
              Fluttertoast.showToast(msg: res.message ?? "User Unblocked");
            }
            ref.invalidate(blockListController);
          } catch (e) {
            Fluttertoast.showToast(msg: "Error: $e");
          } finally {
            setState(() => isLoading = false);
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: "report", child: Text("Report")),
        PopupMenuItem(
            value: "block",
            child: isLoading
                ? Row(
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 10),
                    ],
                  )
                : Text(isBlocked ? "Unblock" : "Block")),
      ],
      child: const Icon(Icons.more_horiz, color: Colors.white),
    );
  }
}

// Keep your MessageInput and ChatBubble classes as they are below this...

class MessageInput extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput(
      {super.key, required this.controller, required this.onSend});

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Container(
      //color: Colors.white,
      color: themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B),
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                color: themeMode == ThemeMode.dark
                    ? Color(0xFF1B1B1B)
                    : Color(0xFF1B1B1B),
              ),
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                filled: true,
                fillColor: Color(0xFFF1F2F6),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: BorderSide(color: Color(0xff9088F1))),
                hintText: "Type a message ...",
                hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC8C8C8)),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: widget.onSend,
            child: Container(
              width: 53.w,
              height: 53.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xff9088F1)),
              child: Icon(Icons.send_sharp, color: Colors.white, size: 28),
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String dateTime;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isSender,
      required this.dateTime});

  String _formatTime(String dt) {
    try {
      return DateFormat('h:mm a').format(DateTime.parse(dt).toLocal());
    } catch (_) {
      return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTime(dateTime);

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isSender ? Color(0xff9088F1) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 16.r : 0),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(isSender ? 0 : 16.r),
          ),
          border: isSender ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: isSender ? Colors.white : Color(0xFF2B2B2B))),
            SizedBox(height: 4.h),
            Text(formattedTime,
                style: GoogleFonts.dmSans(
                    fontSize: 10.sp,
                    color: isSender ? Colors.white70 : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
