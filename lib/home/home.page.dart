import 'dart:convert';
import 'dart:developer';
import 'package:educationapp/MyListing/MyListingPage.dart';
import 'package:educationapp/Profile/profileScreen.dart';
import 'package:educationapp/apiService.dart';
import 'package:educationapp/complete/complete.page.dart';
import 'package:educationapp/coreFolder/Controller/getRequestStudentController.dart';
import 'package:educationapp/coreFolder/Controller/getSaveSkillListController.dart';
import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/CollegeDetail.dart';
import 'package:educationapp/home/CompanyDetail.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/chatInbox.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:educationapp/home/notification.page.dart';
import 'package:educationapp/home/onlineMentor.page.dart';
import 'package:educationapp/home/requestPage.dart';
import 'package:educationapp/home/savedSkillList.page.dart';
import 'package:educationapp/home/settingProfile.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:educationapp/home/yourBidsPage.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/notificationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../MyListing/CreateListPage.dart';
import '../wallet/wallet.page.dart';
import 'TendingSkill.dart';
import 'findAColllege.dart';
import 'findACompany.dart';
import '../coreFolder/Controller/homeDataController.dart';

class HomePage extends ConsumerStatefulWidget {
  int index;
  HomePage(this.index, {super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String filterQuery = "";
  int _currentIndex = 0; // Track the selected tab index
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  final List<Widget> _pages = [
    HomePageContent(),
    Chatinbox(),
    MyListing(),
    ProfilePage(),
  ];

  String limitString(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}..';
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    var box = Hive.box('userdata');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor:
            themeMode == ThemeMode.dark ? Color(0xFF05040F) : Color(0xFFFFFFFF),
        key: _scaffoldKey,
        drawer: drawerWidget(box),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.light
                ? const Color(0xFF05040F)
                : const Color(0xFFF5F5FA),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(themeMode == ThemeMode.dark ? 0.35 : 0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, -6), // upar ki taraf shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: themeMode == ThemeMode.light
                ? const Color(0xFF4988C4)
                : const Color(0xFF1C4D8D),
            unselectedItemColor: themeMode == ThemeMode.light
                ? const Color(0xFFA2A1B3)
                : const Color(0xFF585671),
            selectedLabelStyle: GoogleFonts.roboto(fontSize: 12.sp),
            unselectedLabelStyle: GoogleFonts.roboto(fontSize: 12.sp),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.sp),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_sharp, size: 24.sp),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined, size: 24.sp),
                label: 'My Listing',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.star_border, size: 24.sp),
              //   label: 'Your Review',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 24.sp),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerWidget(Box box) {
    final userType = box.get('userType');
    final asyncProfile = ref.watch(userProfileController);
    // 2. Hive StateProvider से डेटा पढ़ें (यह अपडेट होने पर UI को री-रेंडर करेगा)
    final profile = ref.watch(hiveProfileProvider);
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 280.w,
        decoration: BoxDecoration(
            // color: Colors.white,
            color:
                themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(30.r)),
        child: Column(
          children: [
            Container(
              height: 250.h,
              width: 280.w,
              decoration: BoxDecoration(
                color: const Color(0xff9088F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w, top: 20.h),
                      width: 40.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: themeMode == ThemeMode.dark
                                ? Color(0xFF1B1B1B)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50.w,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(25, 255, 255, 255),
                            borderRadius: BorderRadius.circular(500.r),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              // profileImage['profile_picture']?.toString() ??
                              profile?['profile_picture'] ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return ClipOval(
                                  child: Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         CupertinoPageRoute(
                        //           builder: (context) =>
                        //               ProfileCompletionWidget(true),
                        //         ));
                        //   },
                        //   child: Container(
                        //     height: 38.h,
                        //     decoration: BoxDecoration(
                        //         color: const Color(0xFFDCF881),
                        //         borderRadius: BorderRadius.circular(40.r)),
                        //     child: Center(
                        //       child: Padding(
                        //         padding: EdgeInsets.symmetric(horizontal: 12.w),
                        //         child: Text(
                        //           "Edit Profile",
                        //           style: GoogleFonts.roboto(
                        //               color: const Color(0xFF1B1B1B),
                        //               fontSize: 12.sp),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Text(
                          // profile['full_name'] ?? "User",
                          profile?['full_name'] ?? "User",
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Text(
                          "${box.get('email') ?? 'N/A'}",
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            if (userType == "Student")
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindMentorPage(),
                      ));
                },
                leading: Image.asset(
                  "assets/drawer1.png",
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xff9088F1),
                ),
                title: Text(
                  "Find a Mentor",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    //color: const Color.fromARGB(255, 27, 27, 27),
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : Color(0xFF1B1B1B),
                  ),
                ),
              ),
            if (userType == "Student")
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FindSkillPage(),
                      ));
                },
                leading: Image.asset(
                  "assets/drawer2.png",
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xff9088F1),
                ),
                title: Text(
                  "Trending Skills",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    //color: const Color.fromARGB(255, 27, 27, 27),
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : Color(0xFF1B1B1B),
                  ),
                ),
              ),
            if (userType == "Student")
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FindCollegePage(),
                      ));
                },
                leading: Image.asset(
                  "assets/drawer3.png",
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xff9088F1),
                ),
                title: Text(
                  "Explore Colleges",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    // color: const Color.fromARGB(255, 27, 27, 27),
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : Color(0xFF1B1B1B),
                  ),
                ),
              ),

            // if (userType == "Student")

            ListTile(
              dense: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FindCompanyPage(),
                    ));
              },
              leading: Image.asset(
                "assets/drawer4.png",
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(0xff9088F1),
              ),
              title: Text(
                "Explore Companies",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  // color: const Color.fromARGB(255, 27, 27, 27),
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                ),
              ),
            ),

            // if (userType == "Student")
            //   ListTile(
            //     dense: true,
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const SavedList(),
            //           ));
            //     },
            //     leading: Image.asset(
            //       "assets/drawer3.png",
            //       color: themeMode == ThemeMode.light ? Colors.white : null,
            //     ),
            //     title: Text(
            //       "Saved List",
            //       style: GoogleFonts.roboto(
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.w600,
            //         // color: const Color.fromARGB(255, 27, 27, 27),
            //         color: themeMode == ThemeMode.light
            //             ? Colors.white
            //             : Color(0xFF1B1B1B),
            //       ),
            //     ),
            //   ),

            if (userType == "Student")
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateListPage(),
                      ));
                },
                leading: Image.asset(
                  "assets/list.png",
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xff9088F1),
                ),
                title: Text(
                  // "Create New List",
                  "Upload Request",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    // color: const Color.fromARGB(255, 27, 27, 27),
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : Color(0xFF1B1B1B),
                  ),
                ),
              ),

            if (userType == "Professional" || userType == "Mentor")
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletPage(),
                      ));
                },
                leading: Image.asset(
                  "assets/drawer5.png",
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xff9088F1),
                ),
                title: Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    // color: const Color.fromARGB(255, 27, 27, 27),
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : Color(0xFF1B1B1B),
                  ),
                ),
              ),
            ListTile(
              dense: true,
              onTap: () {
                Fluttertoast.showToast(
                    msg: themeMode == ThemeMode.light
                        ? "Light Mode On"
                        : "Dark Mode On");
                ref.read(themeProvider.notifier).toggleTheme();
              },
              leading: Image.asset(
                "assets/drawer6.png",
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(0xff9088F1),
              ),
              title: Text(
                themeMode == ThemeMode.light ? "Light Mode" : "Dark Mode",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  // color: const Color.fromARGB(255, 27, 27, 27),
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SettingProfilePage(),
                    ));
              },
              leading: Image.asset(
                "assets/drawer7.png",
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(0xff9088F1),
              ),
              title: Text(
                "Settings",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  //  color: const Color.fromARGB(255, 27, 27, 27),
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: Image.asset(
                "assets/insta.png",
                // width: 35.w,
                // height: 35.h,
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(0xff9088F1),
              ),
              title: Text(
                "Instagram",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  //  color: const Color.fromARGB(255, 27, 27, 27),
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                ),
              ),
              onTap: () async {
                final url =
                    "https://www.instagram.com/educat.in?igsh=MWd4aHF3bThiMnJnZg==";
                await launchUrl(
                  Uri.parse(url),
                  // mode: LaunchMode.externalApplication,
                );
              },
            ),
            const Divider(),
            ListTile(
              dense: true,
              leading: Image.asset(
                "assets/logoutIcon.png",
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(0xff9088F1),
              ),
              title: Text(
                "Logout",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  //color: const Color.fromARGB(255, 27, 27, 27),
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(0xFF1B1B1B),
                ),
              ),
              onTap: () async {
                box.clear();
                log("Clearing data...");
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
                Fluttertoast.showToast(msg: "Logout Successfully");
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted HomePage content into a separate widget
class HomePageContent extends ConsumerStatefulWidget {
  const HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends ConsumerState<HomePageContent> {
  String filterQuery = "";

  String limitString(String text, int limit) {
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}..';
  }

  bool isAccept = false;
  String? requestLenght;
  String? wallet;
  int? yourBid;
  late WebSocketChannel channel;
  late int userId;
  String status = 'Connecting...';
  String statusMemtnro = 'ConnectingMentor...';
  int onlineMentorCount = 0;
  List<Map<String, dynamic>> onlineMentors =
      []; // mentor list store karne ke liye
  String? fcmToken;
  final api = ApiService();

  @override
  void initState() {
    super.initState();
    var box = Hive.box("userdata");
    userId = box.get("userid");
    _connectWebSocket();
    _connectedUsersCount();
    NotificationService.init();
    _loadToken();
  }

  Future<void> _loadToken() async {
    fcmToken = await NotificationService.getToken();
    setState(() {});
  }

  void _connectWebSocket() {
    try {
      final url =
          'wss://websocket.educatservicesindia.com/chat/ws/user/$userId';

      channel = WebSocketChannel.connect(Uri.parse(url));

      // 🔹 Connected message
      log('WebSocket connected successfully');
      setState(() {
        status = 'Connected successfully';
      });

      channel.stream.listen(
        (message) {
          // 🔹 Message received
          log('WebSocket message: $message');
        },
        onError: (error) {
          // 🔴 Error case
          log('WebSocket error: $error');
          setState(() {
            status = 'Connection error';
          });
        },
        onDone: () {
          // 🔴 Disconnected case
          log('WebSocket disconnected');
          setState(() {
            status = 'Disconnected from server';
          });

          // 🔁 Auto reconnect (optional)
          Future.delayed(const Duration(seconds: 3), () {
            log('Reconnecting WebSocket...');
            _connectWebSocket();
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      log('WebSocket connection failed: $e');
      setState(() {
        status = 'Connection failed';
      });
    }
  }

  /* void _connectWebSocket() {
    try {
      final url =
          'wss://websocket.educatservicesindia.com/chat/ws/user/${userId}';

      channel = WebSocketChannel.connect(Uri.parse(url));

      setState(() {
        status = 'Connected';
      });

      // Incoming messages listen karo
      channel.stream.listen(
        (message) {
          // log('Received: $message');
          // Yahan message handle karo (JSON parse etc.)
        },
        onError: (error) {
          log('WebSocket error: $error');
          setState(() {
            status = 'Error: $error';
          });
        },
        onDone: () {
          log('WebSocket closed: ${channel.closeReason}');
          setState(() {
            status = 'Disconnected';
          });
          // Optional: reconnect logic
          Future.delayed(const Duration(seconds: 3), _connectWebSocket);
        },
      );
    } catch (e) {
      setState(() {
        status = 'Connection failed: $e';
      });
    }
  }*/
  void _connectedUsersCount() {
    try {
      final url =
          'wss://websocket.educatservicesindia.com/chat/ws/presence/connected-users';
      channel = WebSocketChannel.connect(Uri.parse(url));
      setState(() {
        statusMemtnro = 'ConnectedMentor';
      });
      // Incoming messages listen karo
      channel.stream.listen(
        (message) {
          log('connectedUsersCount Received :$message');
          // Yahan message handle karo (JSON parse etc.)
          try {
            final data = jsonDecode(message) as Map<String, dynamic>;

            // Sirf "connected_users" type ke messages process karo
            if (data['type'] == 'connected_users') {
              final int count = data['count'] ?? 0;
              final List<dynamic> usersList = data['users'] ?? [];

              setState(() {
                onlineMentorCount = count;
                onlineMentors = usersList
                    .map((user) => user as Map<String, dynamic>)
                    .toList();
              });

              log('Updated Online Mentors: $count');
            }
            // Agar future mein aur types aayein (jaise single user online/offline), to yahan handle kar sakte ho
          } catch (e) {
            print('JSON Parse Error in Presence: $e');
          }
        },
        onError: (error) {
          log('WebSocket error: $error');
          setState(() {
            statusMemtnro = 'Error: $error';
          });
        },
        onDone: () {
          log('WebSocket closed: ${channel.closeReason}');
          setState(() {
            statusMemtnro = 'DisconnectedMentor';
          });
          // Optional: reconnect logic
          Future.delayed(const Duration(seconds: 3), _connectedUsersCount);
        },
      );
    } catch (e) {
      setState(() {
        statusMemtnro = 'Connection failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    var box = Hive.box('userdata');

    final asyncProfile = ref.watch(userProfileController);
    final profile = ref.watch(hiveProfileProvider);
    final getHomeStudentData = ref.watch(getHomeStudentDataProvider);
    final getHomeMentorData = ref.watch(getHomeMentorDataProvider);
    final getRequestHomeData = ref.watch(getRequestStudentController);
    final userType = box.get('userType');
    final profileCompletion = box.get('profileCompletion')?.toDouble() ?? 0.45;
    final getSaveSkillListProvider = ref.watch(getSaveSkillListControlelr);

    final isLoading = getHomeStudentData.isLoading;

    if (isLoading) {
      return ShimmerHomePage();
    }
    if (getHomeMentorData.hasError || getHomeStudentData.hasError) {
      final errorMessage = getHomeMentorData.error?.toString() ??
          getHomeStudentData.error?.toString() ??
          "Something went wrong";
      return Scaffold(
        backgroundColor:
            themeMode == ThemeMode.dark ? Color(0xFFFFFFFF) : Color(0xFF05040F),
        body: Center(
          child: Text(
            errorMessage,
            style: GoogleFonts.inter(fontSize: 20.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    asyncProfile.whenData(
      (data) {
        wallet = (data.data!.coins ?? 0) as String?;
      },
    );

    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xFFFFFFFF) : Color(0xFF05040F),
      body: RefreshIndicator(
        backgroundColor:
            themeMode == ThemeMode.dark ? Color(0xFFFFFFFF) : Color(0xFF05040F),
        color: themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Colors.white,
        onRefresh: () async {
          _connectWebSocket();
          _connectedUsersCount();
          ref.invalidate(getRequestStudentController);
          ref.invalidate(getHomeStudentDataProvider);
          ref.invalidate(getHomeMentorDataProvider);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        height: 50.w,
                        width: 50.w,
                        decoration: BoxDecoration(
                            color: themeMode == ThemeMode.dark
                                ? Color(0xFFF0F0F7)
                                : Color(0xFF171621),
                            borderRadius: BorderRadius.circular(500.r)),
                        child: Center(
                          child: Icon(
                            Icons.menu,
                            color: themeMode == ThemeMode.light
                                ? Color(0xffFFFFFF)
                                : Color(0xFF33323F),
                            // color: Color(0xFF33323F),
                            size: 22.w,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 30.w,
                    ),
                    Center(
                      child: Image.asset("assets/mentorLogo.png",
                          width: 100.w,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF4988C4)
                              : Color(0xFF1C4D8D)),
                    ),
                    const Spacer(),
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: themeMode == ThemeMode.light
                              ? Color(0xFF171621)
                              : Color(0xFFF0F0F7),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => NotificationPage(),
                              ));
                        },
                        icon: Icon(
                          Icons.notifications_none,
                          // color: Color(0xFF33323F),
                          color: themeMode == ThemeMode.light
                              ? Color(0xffFFFFFF)
                              : Color(0xFF33323F),
                          size: 22.w,
                        )),
                    SizedBox(width: 3.w),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         CupertinoPageRoute(
                    //             builder: (context) => HomePage(3)));
                    //   },
                    //   child: Container(
                    //     height: 50.w,
                    //     width: 50.w,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         width: 2.0,
                    //         color: Color(0xff9088F1),
                    //       ),
                    //       color: const Color.fromARGB(25, 255, 255, 255),
                    //       borderRadius: BorderRadius.circular(500.r),
                    //     ),
                    //     child: ClipOval(
                    //       child: Image.network(
                    //         // profileImage['profile_picture']?.toString() ??
                    //         profile?['profile_picture'] ??
                    //             "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                    //         fit: BoxFit.cover,
                    //         errorBuilder: (context, error, stackTrace) {
                    //           return ClipOval(
                    //             child: Image.network(
                    //               "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                    //               fit: BoxFit.cover,
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('WebSocket Status: $status'),
                          // Text('WebSocket Mentor: $statusMemtnro'),

                          Row(
                            children: [
                              Text(
                                "Welcome, ",
                                style: GoogleFonts.roboto(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: themeMode == ThemeMode.dark
                                      ? Color(0xFF1F1F26)
                                      : Color(0xFFC5C3D9),
                                ),
                              ),
                              Text(
                                // profile['full_name'] ?? "User",
                                profile?['full_name'] ?? "User",
                                style: GoogleFonts.roboto(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1C4D8D)),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Let’s plan your bright future.",
                          //   style: GoogleFonts.roboto(
                          //       fontSize: 14.sp,
                          //       fontWeight: FontWeight.w400,
                          //       color: themeMode == ThemeMode.dark
                          //           ? Color(0xFF1B1B1B)
                          //           : Colors.white),
                          // ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (userType == "Student")
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SavedSkilListPage(),
                                ));
                          },
                          child: Container(
                            height: 120.h,
                            width: 185.w,
                            decoration: BoxDecoration(
                              color: themeMode == ThemeMode.dark
                                  ? Color(0xFFBDE8F5)
                                  : Color(0xFF00264B),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // "Skills Available",
                                    "Saved Skill",
                                    style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xFF33323F)
                                            : Color(0xFFC5C3D9)),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // getHomeStudentData.when(
                                      //   data: (data) => Text(
                                      //     "${data.skills?.length ?? 0}",
                                      //     style: GoogleFonts.roboto(
                                      //         fontSize: 24.sp,
                                      //         fontWeight: FontWeight.w500,
                                      //         color: themeMode == ThemeMode.dark
                                      //             ? Color(0xFF4988C4)
                                      //             : Color(0xFF1C4D8D)),
                                      //   ),
                                      //   loading: () => SizedBox(
                                      //     width: 20.w,
                                      //     height: 20.h,
                                      //     child:
                                      //         const CircularProgressIndicator(
                                      //             color: Colors.white,
                                      //             strokeWidth: 2),
                                      //   ),
                                      //   error: (error, stack) => Text(
                                      //     "N/A",
                                      //     style: GoogleFonts.roboto(
                                      //         fontSize: 16.sp,
                                      //         fontWeight: FontWeight.w600,
                                      //         color: Colors.white),
                                      //   ),
                                      // ),
                                      getSaveSkillListProvider.when(
                                          data: (data) => Text(
                                                "${data.data?.length ?? 0}",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeMode ==
                                                            ThemeMode.dark
                                                        ? Color(0xFF4988C4)
                                                        : Color(0xFF1C4D8D)),
                                              ),
                                          loading: () => SizedBox(
                                                width: 20.w,
                                                height: 20.h,
                                                child:
                                                    const CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2),
                                              ),
                                          error: (error, stack) {
                                            log(error.toString());
                                            log(stack.toString());
                                            return Text(
                                              "N/A",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            );
                                          }),
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF0F2854)
                                              : Color(0xFF1C4D8D),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.white
                                                : Color(0xFFBDE8F5),
                                            size: 15.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // SizedBox(width: 15.w),
                      if (userType == "Student")
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => OnlineMentorPage(
                                    onlineMentors: onlineMentors,
                                  ),
                                ));
                          },
                          child: Container(
                            height: 120.h,
                            width: 185.w,
                            decoration: BoxDecoration(
                              color: themeMode == ThemeMode.dark
                                  ? Color(0xFFFFF4D7)
                                  : Color.fromARGB(76, 174, 126, 0),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mentors Online",
                                    style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xFF33323F)
                                            : Color(0xFFC5C3D9)),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$onlineMentorCount",
                                        style: GoogleFonts.roboto(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w500,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1C4D8D)
                                                : Color(0xFF4988C4)),
                                      ),
                                      Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF0F2854)
                                              : Color(0xFF1C4D8D),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.white
                                                : Color(0xFFBDE8F5),
                                            size: 15.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // SizedBox(width: 15.w),
                    ],
                  ),
                ),
                if (userType == "Professional" || userType == "Mentor")
                  Container(
                    margin: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => RequestPage(),
                                ));
                          },
                          child: Container(
                            height: 130.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff9088F1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/mask1.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "New Requests",
                                        style: GoogleFonts.roboto(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        // "20",
                                        requestLenght ?? "0",
                                        style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => WalletPage(),
                                ));
                          },
                          child: Container(
                            height: 130.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF485C07),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/mask1.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Wallet",
                                        style: GoogleFonts.roboto(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      wallet == null
                                          ? SizedBox()
                                          : Text(
                                              wallet!,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => YourBidsPage(),
                                ));
                          },
                          child: Container(
                            height: 130.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C4D8D),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/mask1.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Bid",
                                        style: GoogleFonts.roboto(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      yourBid == null
                                          ? SizedBox()
                                          : Text(
                                              yourBid.toString(),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20.h),
                if (userType == "Professional" || userType == "Mentor")
                  Container(
                    // height: 500.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Color(0xFF1B1B1B),

                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          getHomeMentorData.when(
                            data: (mentorData) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  // wallet = mentorData.data!.coins.toString();
                                  // yourBid = mentorData.data!.notification_count
                                  //     .toString();
                                  yourBid =
                                      mentorData.data?.acceptedStudents?.length;
                                });
                              });
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ProfileCompletionWidget(true),
                                          ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      // width: 400.w.clamp(0, 400.w),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        color: themeMode == ThemeMode.dark
                                            ? Color.fromARGB(38, 0, 128, 128)
                                            : Color(0xff9088F1),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20.w,
                                                right: 20.w,
                                                top: 10.h),
                                            height: 5.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: LinearProgressIndicator(
                                                // value: profileCompletion.clamp(
                                                //     0.0, 1.0),
                                                value: (((mentorData.data!
                                                                    .profileCompletion ??
                                                                0.0) /
                                                            100)
                                                        .clamp(0.0, 1.0))
                                                    .toDouble(),
                                                // backgroundColor:
                                                //     Colors.transparent,
                                                backgroundColor: themeMode ==
                                                        ThemeMode.light
                                                    ? const Color(0xFFE0E0E0)
                                                    : const Color(0xFF2A2A2A),

                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  // Color(0xff9088F1),
                                                  themeMode == ThemeMode.dark
                                                      ? Color(0xff9088F1)
                                                      : Color(0xFF1B1B1B),
                                                ),
                                                minHeight: 20.h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Container(
                                            margin:
                                                EdgeInsets.only(right: 16.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: Text(
                                                    "Profile Completed",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      // color: Color.fromARGB(
                                                      //     204, 0, 0, 0),
                                                      color: themeMode ==
                                                              ThemeMode.dark
                                                          ? Color.fromARGB(
                                                              204, 0, 0, 0)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  //  "${(profileCompletion * 100).toInt()}%",
                                                  "${(mentorData.data!.profileCompletion ?? 0.0).toStringAsFixed(0)}%",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: themeMode ==
                                                            ThemeMode.dark
                                                        ? Color.fromARGB(
                                                            204, 0, 0, 0)
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15.w,
                                                right: 20.w,
                                                top: 16.h),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    // profileImage['profile_picture']
                                                    //         ?.toString() ??
                                                    //     "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                    mentorData
                                                            .data!.profilePic ??
                                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                    fit: BoxFit.cover,
                                                    height: 50.w,
                                                    width: 50.w,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return ClipOval(
                                                        child: Image.network(
                                                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                                          fit: BoxFit.cover,
                                                          height: 50.w,
                                                          width: 50.w,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      // "Mike Pena",
                                                      "${mentorData.data!.fullName ?? "Mentor"}!",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: themeMode ==
                                                                ThemeMode.dark
                                                            ? Color.fromARGB(
                                                                204, 0, 0, 0)
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Placement | Interview",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: themeMode ==
                                                                ThemeMode.dark
                                                            ? Color.fromARGB(
                                                                204, 0, 0, 0)
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20.w,
                                                right: 15.w,
                                                top: 16.h),
                                            child: Text(
                                              // "With over 5 years of experience, "
                                              // "I've guided 300+ students to land jobs "
                                              // "in top companies like Google, TCS, and Deloitte. "
                                              // "My sessions focus on mock interviews, resume building, "
                                              // "and effective communication",
                                              mentorData.data!.description ??
                                                  "No descripion",
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color.fromARGB(
                                                            204, 0, 0, 0)
                                                        : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w, top: 20.h),
                                    child: Text(
                                      "Your Bids",
                                      style: GoogleFonts.inter(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        //color: Color(0xFF1B1B1B),
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xFF1B1B1B)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  mentorData.data!.acceptedStudents!.isEmpty
                                      ? Center(
                                          child: Text(
                                            "No Accepted Student",
                                            style: GoogleFonts.inter(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w300,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xFF1B1B1B)
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: mentorData
                                              .data!.acceptedStudents!.length,
                                          itemBuilder: (context, index) {
                                            final student = mentorData
                                                .data!.acceptedStudents![index];
                                            return InkWell(
                                              onTap: () {
                                                log(box
                                                    .get("userid")
                                                    .toString());
                                                log(
                                                  mentorData
                                                      .data!
                                                      .acceptedStudents![index]
                                                      .id
                                                      .toString(),
                                                );
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) => ChatingPage(
                                                          id: box
                                                              .get("userid")
                                                              .toString(),
                                                          otherUesrid: mentorData
                                                              .data!
                                                              .acceptedStudents![
                                                                  index]
                                                              .id
                                                              .toString(),
                                                          name: student
                                                                  .fullName ??
                                                              "No Name"),
                                                    ));
                                              },
                                              child: MyContainer(
                                                image: student.profilePic ??
                                                    "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                                                title:
                                                    student.fullName ?? "N/A",
                                                email:
                                                    student.email ?? "No Email",
                                                description:
                                                    student.description ?? "",
                                              ),
                                            );
                                          },
                                        ),
                                  SizedBox(height: 10.h),
                                ],
                              );
                            },
                            error: (error, stackTrace) {
                              log(stackTrace.toString());
                              return Center(
                                child: Text(error.toString()),
                              );
                            },
                            loading: () => Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, top: 10.h),
                            child: Row(
                              children: [
                                Text(
                                  "New Request",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    //color: Color(0xFF1B1B1B),
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          getRequestHomeData.when(
                            data: (requestData) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  requestLenght =
                                      requestData.data.length.toString();
                                });
                              });

                              if (requestData.data.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No Request Available",
                                    style: GoogleFonts.inter(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w300,
                                      //color: Color(0xFF1B1B1B),
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF1B1B1B)
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: requestData.data.length,
                                itemBuilder: (context, index) {
                                  final student = requestData.data[index];
                                  return GetRequestStudentBody(
                                    image: student.studentProfile ??
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                    title: student.studentName,
                                    subtitle: student.studentType,
                                    email: student.studentEmail,
                                    phone: student.studentPhone,
                                    callBack: () async {
                                      final body = AcceptRequestBodyModel(
                                          requestId: requestData.data[index].id
                                              .toString());
                                      try {
                                        setState(() {
                                          isAccept = true;
                                        });

                                        final service =
                                            APIStateNetwork(createDio());
                                        final response =
                                            await service.acceptRequest(body);

                                        if (response.status == true) {
                                          api.sendNotificationMentor(
                                              title:
                                                  'Mentorship Request Accepted 🎉',
                                              b:
                                                  'Great news! Your mentorship request has been accepted.',
                                              user_Id:
                                                  student.studentId.toString());

                                          Fluttertoast.showToast(
                                              msg: response.message);
                                          ref.invalidate(
                                              getHomeMentorDataProvider);
                                          ref.invalidate(
                                              getRequestStudentController);
                                          ref.invalidate(myListingController);
                                        } else {
                                          // Fluttertoast.showToast(
                                          //     msg: response.message);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please upgrade the membership for mentor",
                                              toastLength: Toast.LENGTH_LONG);
                                        }
                                      } catch (e, st) {
                                        log("${e.toString()} /n ${st.toString()}");
                                        Fluttertoast.showToast(
                                            msg: "Not Accept");
                                      } finally {
                                        setState(() {
                                          isAccept = false;
                                        });
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              log(stackTrace.toString());
                              return Center(
                                child: Text(error.toString()),
                              );
                            },
                            loading: () => Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  )
                else
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Explore Trending Skills",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: themeMode == ThemeMode.light
                                        ? Color(0xFFC5C3D9)
                                        : Color(0xFF1F1F26)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => FindSkillPage(),
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "View All",
                                      style: GoogleFonts.roboto(
                                        color: themeMode == ThemeMode.light
                                            ? Color(0xFF4988C4)
                                            : Color(0xFF1C4D8D),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: themeMode == ThemeMode.light
                                          ? Color(0xFF4988C4)
                                          : Color(0xFF1C4D8D),
                                      size: 15.sp,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        getHomeStudentData.when(
                          data: (data) {
                            final skills = data.skills ?? [];
                            if (skills.isEmpty) {
                              return Center(
                                child: Text(
                                  "No skills available",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: skills.length,
                                itemBuilder: (context, index) {
                                  final skill = skills[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 15.w),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  TrendingExprtPage(
                                                id: skill.id ?? 0,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        width: 125.w,
                                        decoration: BoxDecoration(
                                          color: themeMode == ThemeMode.light
                                              ? null
                                              : Color(0xFFFFFFFF),
                                          border: Border.all(
                                              color:
                                                  themeMode == ThemeMode.light
                                                      ? Color.fromARGB(
                                                          25, 255, 255, 255)
                                                      : Color.fromARGB(
                                                          25,
                                                          88,
                                                          86,
                                                          113,
                                                        )),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 20.h, top: 20.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  //color: Color(0xFFF0F0F7),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        skill.image ?? ""),
                                                    fit: BoxFit.cover,
                                                    onError: (exception,
                                                            stackTrace) =>
                                                        const AssetImage(
                                                            "assets/placeholder.png"),
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   width: 40.w,
                                              //   height: 40.h,
                                              //   decoration: BoxDecoration(
                                              //       shape: BoxShape.circle,
                                              //       color: Color(0xFFF0F0F7)),
                                              //   child: Center(
                                              //     child: Image.asset(
                                              //         "assets/skillsImage.png"),
                                              //   ),
                                              // ),
                                              Spacer(),
                                              Center(
                                                child: Text(
                                                  skill.level
                                                          ?.toString()
                                                          .split('.')
                                                          .last ??
                                                      "N/A",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeMode ==
                                                            ThemeMode.light
                                                        ? Color(0xFF4988C4)
                                                        : Color(0xFF1C4D8D),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  limitString(
                                                      skill.title ?? "Unknown",
                                                      18),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: themeMode ==
                                                            ThemeMode.light
                                                        ? Color(0xFFC5C3D9)
                                                        : Color(0xFF33323F),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xff9088F1)),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              "Error loading skills",
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomePageBody(
                                callBack: (String category) {
                                  setState(() {
                                    filterQuery = category;
                                  });
                                },
                              ),
                              SizedBox(height: 10.h),
                              getHomeStudentData.when(
                                data: (data) {
                                  final mentors = filterQuery == "All" ||
                                          filterQuery.isEmpty
                                      ? data.mentors?.values
                                              .expand((list) => list)
                                              .toList() ??
                                          []
                                      : data.mentors?[filterQuery]?.toList() ??
                                          [];
                                  final limitedMentors =
                                      mentors.take(5).toList();
                                  if (mentors.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No mentors available",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                          //color: Colors.white,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    itemCount: limitedMentors.length,
                                    itemBuilder: (context, index) {
                                      final mentor = limitedMentors[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    MentorDetailPage(
                                                        id: mentor.id ?? 0),
                                              ));
                                        },
                                        child: UserTabs(
                                          id: mentor.id ?? 0,
                                          fullname:
                                              mentor.fullName ?? "Unknown",
                                          // skill: mentor.skills
                                          //         ?.elementAtOrNull(0)
                                          //         ?.title ??
                                          //     "No skill",
                                          skill: mentor.jobRole ?? "No",
                                          servicetype: [
                                            mentor.serviceType ?? "N/A"
                                          ],
                                          image: mentor.profilePic ?? "",
                                          language: mentor.languageKnown ?? "",
                                          experience:
                                              mentor.totalExperience ?? "0",
                                          otherUserId: mentor.id.toString(),
                                          education:
                                              mentor.highestQualification ?? "",
                                        ),
                                      );
                                    },
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xff9088F1)),
                                ),
                                error: (error, stack) {
                                  log("Mentors Error: $error");
                                  log("StackTrace: $stack");
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Error loading mentors: $error",
                                          style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              color: Colors.white),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => ref.refresh(
                                              getHomeStudentDataProvider),
                                          child: const Text("Retry"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: 350.h,
                          // width: double.infinity,
                          // decoration: const BoxDecoration(
                          //   // color: Colors.white,
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(20),
                          //     topRight: Radius.circular(20),
                          //     bottomLeft: Radius.circular(20),
                          //     bottomRight: Radius.circular(20),
                          //   ),
                          // ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20.w, top: 20.h),
                                    child: Text(
                                      "Explore Collage Review ",
                                      style: GoogleFonts.roboto(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.light
                                              ? Color(0xFFC5C3D9)
                                              : Color(0xFF1F1F26)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                FindCollegePage(),
                                          ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 20.w, top: 20.h),
                                      child: Row(
                                        children: [
                                          Text(
                                            "View All",
                                            style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  themeMode == ThemeMode.light
                                                      ? Color(0xFF4988C4)
                                                      : Color(0xFF1C4D8D),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: themeMode == ThemeMode.light
                                                ? Color(0xFF4988C4)
                                                : Color(0xFF1C4D8D),
                                            size: 15.sp,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              getHomeStudentData.when(
                                data: (data) {
                                  final colleges = data.colleges ?? [];
                                  if (colleges.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No colleges available",
                                        style: GoogleFonts.roboto(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    );
                                  }
                                  final limitCollage =
                                      colleges.take(5).toList();

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    itemCount: limitCollage.length,
                                    itemBuilder: (context, index) {
                                      final college = limitCollage[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    CollegeDetailPage(
                                                        college.id!),
                                              ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 15.h),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 18.h, horizontal: 15.w),
                                          decoration: BoxDecoration(
                                            color: themeMode == ThemeMode.light
                                                ? null
                                                : Color(0xFFFFFFFF),
                                            border: Border.all(
                                                color:
                                                    themeMode == ThemeMode.light
                                                        ? Color.fromARGB(
                                                            25, 255, 255, 255)
                                                        : Color.fromARGB(
                                                            25, 88, 86, 113)),
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 56.w,
                                                    height: 56.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xFFF0F0F7),
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        college.image ??
                                                            "https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg",
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return ClipOval(
                                                            child:
                                                                Image.network(
                                                              "https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg",
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        college.collegeName ??
                                                            "N/A",
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: themeMode ==
                                                                    ThemeMode
                                                                        .light
                                                                ? Color(
                                                                    0xFFFFFFFF)
                                                                : Color(
                                                                    0xFF33323F)),
                                                      ),
                                                      Text(
                                                        "${college.city ?? "N/A"} | ${college.totalReviews} Review",
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: themeMode ==
                                                                    ThemeMode
                                                                        .light
                                                                ? Color
                                                                    .fromARGB(
                                                                        178,
                                                                        255,
                                                                        255,
                                                                        255)
                                                                : Color(
                                                                    0xFF666666)),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8.w,
                                                          right: 10.w,
                                                          top: 8.h,
                                                          bottom: 8.h),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          color: Color.fromARGB(
                                                              51,
                                                              217,
                                                              162,
                                                              24)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xFFD9A218),
                                                            size: 18.sp,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            college.avgRating!
                                                                .toStringAsFixed(
                                                                    1),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.inter(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xFFD9A218)),
                                                          )
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xff9088F1)),
                                ),
                                error: (error, stack) => Center(
                                  child: Text(
                                    "Error loading colleges",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Companies",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeMode == ThemeMode.light
                                        ? Color(0xFFC5C3D9)
                                        : Color(0xFF1F1F26)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => FindCompanyPage(),
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "View All",
                                      style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: themeMode == ThemeMode.light
                                              ? Color(0xFF4988C4)
                                              : Color(0xFF1C4D8D)),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: themeMode == ThemeMode.light
                                          ? Color(0xFF4988C4)
                                          : Color(0xFF1C4D8D),
                                      size: 15.sp,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        getHomeStudentData.when(
                          data: (data) {
                            final companies = data.companies ?? [];
                            if (companies.isEmpty) {
                              return Center(
                                child: Text(
                                  "No companies available",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14.sp, color: Colors.white),
                                ),
                              );
                            }
                            final limitCompany = companies.take(5).toList();
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: limitCompany.length,
                              itemBuilder: (context, index) {
                                final company = limitCompany[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              CompanyDetailPage(company.id!),
                                        ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    padding: EdgeInsets.only(
                                        left: 20.w,
                                        right: 20.w,
                                        bottom: 24.h,
                                        top: 20.h),
                                    decoration: BoxDecoration(
                                      color: themeMode == ThemeMode.light
                                          ? null
                                          : Color(0xFFFFFFFF),
                                      border: Border.all(
                                          color: themeMode == ThemeMode.light
                                              ? Color.fromARGB(
                                                  25, 255, 255, 255)
                                              : Color.fromARGB(
                                                  25, 88, 85, 113)),
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 50.w,
                                              height: 50.h,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: themeMode ==
                                                            ThemeMode.light
                                                        ? Color.fromARGB(
                                                            25, 255, 255, 255)
                                                        : Color.fromARGB(
                                                            25, 0, 0, 0),
                                                  )),
                                              child: ClipOval(
                                                child: Image.network(
                                                  company.image ??
                                                      "https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg",
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.network(
                                                      "https://www.howardluksmd.com/wp-content/uploads/2021/10/featured-image-placeholder-728x404.jpg",
                                                      fit: BoxFit.contain,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.topRight,
                                              children: [
                                                Positioned(
                                                  top: -12, // fine-tuned offset
                                                  right: -12,
                                                  child: Image.asset(
                                                    "assets/gridbg.png",
                                                  ),
                                                ),
                                                Container(
                                                  width: 45.w,
                                                  height: 45.h,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: themeMode ==
                                                            ThemeMode.light
                                                        ? Color(0xFF26252E)
                                                        : Color(0xFFF0F0F7),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: themeMode ==
                                                              ThemeMode.light
                                                          ? Color(0xFFFFFFFF)
                                                          : Color(0xFF1F1F26),
                                                      size: 15.sp,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              company.companyName ?? "Unknown",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: themeMode ==
                                                          ThemeMode.light
                                                      ? Color(0xFFFFFFFF)
                                                      : Color(0xFF33323F)),
                                            ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Project Guide |",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: themeMode ==
                                                              ThemeMode.light
                                                          ? Color.fromARGB(178,
                                                              255, 255, 255)
                                                          : Color(0xFF666666)),
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: themeMode ==
                                                          ThemeMode.light
                                                      ? Color.fromARGB(
                                                          178, 255, 255, 255)
                                                      : Color(0xFF666666),
                                                  size: 18.sp,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  "${company.avgRating} Rating",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: themeMode ==
                                                              ThemeMode.light
                                                          ? Color.fromARGB(178,
                                                              255, 255, 255)
                                                          : Color(0xFF666666)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xff9088F1)),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              "Error loading companies",
                              style: GoogleFonts.roboto(
                                  fontSize: 14.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Rest of the code (HomePageBody, UserTabs, Upertabs, MyContainer, NewContainer) remains unchanged

class HomePageBody extends ConsumerStatefulWidget {
  final Function callBack;
  const HomePageBody({super.key, required this.callBack});
  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends ConsumerState<HomePageBody> {
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final getHomeStudentData = ref.watch(getHomeStudentDataProvider);
    final themeMode = ref.watch(themeProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(height: 10.h),

        Container(
          decoration: BoxDecoration(
              color: Color(0xff1C4D8D),
              borderRadius: BorderRadius.circular(20.sp)),
          padding: EdgeInsets.all(20.sp),
          margin: EdgeInsets.all(20.sp),
          // height: 200.h,
          // width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Don’t find the right mentor ?",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Upload your custom request and let the mentors bid on it",
                      style: GoogleFonts.roboto(
                        color: Colors.grey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateListPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.sp),
                    color: Color(0xffD9A218),
                  ),
                  padding: EdgeInsets.all(10.sp),
                  child: Text(
                    "Upload Request",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Top Mentors",
                style: GoogleFonts.roboto(
                    color: themeMode == ThemeMode.light
                        ? Color(0xFFC5C3D9)
                        : Color(0xFF1F1F26),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FindMentorPage(),
                      ));
                },
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: GoogleFonts.roboto(
                        color: themeMode == ThemeMode.light
                            ? Color(0xFF4988C4)
                            : Color(0xFF1C4D8D),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: themeMode == ThemeMode.light
                          ? Color(0xFF4988C4)
                          : Color(0xFF1C4D8D),
                      size: 15.sp,
                    )
                  ],
                ),
              )
              // Row(
              //   children: [
              //     Text(
              //       "Filters",
              //       style: GoogleFonts.roboto(
              //           color: Colors.white,
              //           fontSize: 20.sp,
              //           fontWeight: FontWeight.w600),
              //     ),
              //     SizedBox(width: 4.w),
              //     Image.asset("assets/filter.png"),
              //     SizedBox(width: 4.w),
              //     Image.asset("assets/search.png"),
              //   ],
              // ),
            ],
          ),
        ),

        SizedBox(height: 15.h),
        getHomeStudentData.when(
          data: (data) {
            final categories = data.mentors?.keys.toList() ?? [];
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 20.w),
                SizedBox(
                  height: 35.h,
                  width: MediaQuery.of(context).size.width - 40.w,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Upertabs(
                        title: "All",
                        callBack: () {
                          setState(() {
                            currentTabIndex = 0;
                          });
                          widget.callBack("All");
                        },
                        currentIndex: currentTabIndex,
                        index: 0,
                      ),
                      ...categories.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final category = entry.value;
                        return Upertabs(
                          title: category,
                          callBack: () {
                            setState(() {
                              currentTabIndex = index;
                            });
                            widget.callBack(category);
                          },
                          currentIndex: currentTabIndex,
                          index: index,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xff9088F1)),
          ),
          error: (error, stack) => Center(
            child: Text(
              "Error loading categories",
              style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ),

        SizedBox(height: 10.h),
      ],
    );
  }
}

class UserTabs extends ConsumerStatefulWidget {
  final int id;
  final String fullname;
  final String skill;
  final List<String> servicetype;
  final String image;
  final String otherUserId;
  final String language;
  final String experience;
  final String education;

  const UserTabs({
    super.key,
    required this.id,
    required this.fullname,
    required this.skill,
    required this.servicetype,
    required this.image,
    required this.otherUserId,
    required this.language,
    required this.experience,
    required this.education,
  });

  @override
  ConsumerState<UserTabs> createState() => _UserTabsState();
}

class _UserTabsState extends ConsumerState<UserTabs> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    final themeMode = ref.watch(themeProvider);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding:
          EdgeInsets.only(left: 15.w, top: 15.h, bottom: 20.h, right: 15.w),
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light ? null : Color(0xFFFFFFFF),
        border: Border.all(
            color: themeMode == ThemeMode.light
                ? Color.fromARGB(25, 255, 255, 255)
                : Color.fromARGB(
                    25,
                    88,
                    86,
                    113,
                  )),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56.h,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 40.h,
                        height: 40.h,
                        color: Colors.grey[300],
                        child: CircularProgressIndicator(color: Colors.yellow),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return ClipOval(
                        child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fullname,
                    style: GoogleFonts.roboto(
                      color: themeMode == ThemeMode.light
                          ? Color(0xFFFFFFFF)
                          : Color(0xFF33323F),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${widget.skill} | ${widget.experience} Yrs",
                    style: GoogleFonts.roboto(
                      color: themeMode == ThemeMode.light
                          ? Color.fromARGB(170, 255, 255, 255)
                          : Color(0xFF666666F),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Container(
              //   width: 28.w,
              //   height: 28.h,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color(
              //       0xFFF0F0F7,
              //     ),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       Icons.arrow_forward_ios,
              //       size: 14.sp,
              //       color: Color(0xFF1F1F26),
              //     ),
              //   ),
              // ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  Positioned(
                    top: -12, // fine-tuned offset
                    right: -12,
                    child: Image.asset(
                      "assets/gridbg.png",
                    ),
                  ),
                  Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeMode == ThemeMode.light
                          ? Color(0xFF26252E)
                          : Color(0xFFF0F0F7),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: themeMode == ThemeMode.light
                            ? Color(0xFFFFFFFF)
                            : Color(0xFF1F1F26),
                        size: 15.sp,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            color: themeMode == ThemeMode.light
                ? Color.fromARGB(25, 255, 255, 255)
                : Colors.grey.shade300,
            thickness: 1.w,
          ),
          SizedBox(
            height: 15.h,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.education != null && widget.education.isNotEmpty)
                Text(
                  "Education",
                  style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: themeMode == ThemeMode.light
                          ? Color.fromARGB(170, 255, 255, 255)
                          : Color(0xFF2E2E2E)),
                ),
              if (widget.language != null && widget.language.isNotEmpty)
                Text(
                  "Languages",
                  style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: themeMode == ThemeMode.light
                          ? Color.fromARGB(170, 255, 255, 255)
                          : Color(0xFF2E2E2E)),
                )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.education != null && widget.education.isNotEmpty)
                Text(
                  // "B. Tech (Computer Science)",
                  widget.education,
                  style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: themeMode == ThemeMode.light
                          ? Color.fromARGB(170, 255, 255, 255)
                          : Color(0xFF2E2E2E)),
                ),
              if (widget.language != null && widget.language.isNotEmpty)
                Text(
                  // "English, Mandarin",
                  widget.language,
                  style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: themeMode == ThemeMode.light
                          ? Color.fromARGB(170, 255, 255, 255)
                          : Color(0xFF2E2E2E)),
                )
            ],
          ),

          // SizedBox(
          //   height: 36.h,
          //   width: 155.w,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       log(box.get("userid").toString());
          //       Navigator.push(
          //         context,
          //         CupertinoPageRoute(
          //           builder: (context) => MentorDetailPage(id: widget.id ?? 0),
          //         ),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xff9088F1),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.r),
          //       ),
          //     ),
          //     child: Text(
          //       "Connect",
          //       style: GoogleFonts.roboto(
          //         fontSize: 13.sp,
          //         fontWeight: FontWeight.w500,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          // Stack(
          //   children: [
          //     // ClipRRect(
          //     //   borderRadius: BorderRadius.vertical(
          //     //       top: Radius.circular(20.r), bottom: Radius.circular(20.r)),
          //     //   child: InkWell(
          //     //     onTap: () {},
          //     //     borderRadius: BorderRadius.vertical(
          //     //         top: Radius.circular(20.r),
          //     //         bottom: Radius.circular(20.r)),
          //     //     child: SizedBox(
          //     //       height: 300.h,
          //     //       // height: 150.h, // Ya 180.h jo bhi achha lage - half ya thoda zyada
          //     //       width: double.infinity,
          //     //       child: Image.network(
          //     //         widget.image,
          //     //         fit: BoxFit.cover,
          //     //         loadingBuilder: (context, child, loadingProgress) {
          //     //           if (loadingProgress == null) return child;
          //     //           return Container(color: Colors.grey[300]);
          //     //         },
          //     //         errorBuilder: (context, error, stackTrace) {
          //     //           return Image.network(
          //     //             "https://thumbs.dreamstime.com/b/no-image-vector-symbol-missing-available-icon-gallery-moment-placeholder-246411909.jpg",
          //     //             fit: BoxFit.cover,
          //     //           );
          //     //         },
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //     // Details Section
          //     Positioned(
          //       bottom: 10.h,
          //       child: Padding(
          //         padding: EdgeInsets.all(12.sp),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               widget.fullname,
          //               style: GoogleFonts.roboto(
          //                 color: Colors.white,
          //                 // textColor,
          //                 // themeMode == ThemeMode.dark
          //                 //     ? Color.fromARGB(25, 0, 0, 0)
          //                 //     : Colors.white,
          //                 fontSize: 14.sp,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //             SizedBox(height: 6.h),
          //             Text(
          //               widget.dec,
          //               style: GoogleFonts.roboto(
          //                 color: Colors.white,
          //                 // textColor,
          //                 fontSize: 12.sp,
          //                 fontWeight: FontWeight.w400,
          //               ),
          //               maxLines: 2,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //             SizedBox(height: 12.h),
          //           ],
          //         ),
          //       ),
          //     ),
          //     // Baaki content yahan aayega (name, bio, buttons etc.)
          //     // Expanded( // Yeh important hai - baaki jagah ko fill karega
          //     //   child: Padding(
          //     //     padding: EdgeInsets.all(12.sp),
          //     //     child: Column(
          //     //       mainAxisAlignment: MainAxisAlignment.center,
          //     //       children: [
          //     //         Text(
          //     //           "User Name", // Ya widget.name ya jo bhi ho
          //     //           style: TextStyle(
          //     //             color: textColor,
          //     //             fontSize: 18.sp,
          //     //             fontWeight: FontWeight.bold,
          //     //           ),
          //     //           textAlign: TextAlign.center,
          //     //         ),
          //     //         SizedBox(height: 8.h),
          //     //         Text(
          //     //           "Bio or description here",
          //     //           style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14.sp),
          //     //           textAlign: TextAlign.center,
          //     //           maxLines: 2,
          //     //           overflow: TextOverflow.ellipsis,
          //     //         ),
          //     //         // Yahan buttons ya aur details add kar sakte ho
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class Upertabs extends ConsumerWidget {
  final String title;
  final Function callBack;
  final int currentIndex;
  final int index;

  const Upertabs({
    super.key,
    required this.title,
    required this.callBack,
    required this.currentIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 8.w),
      child: GestureDetector(
        onTap: () => callBack(),
        child: Container(
          height: 30.h,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
              // color: currentIndex == index
              //     ? const Color(0xFF1C4D8D)
              //     : const Color(0xFFF0F0F7),
              color: currentIndex == index
                  ? (themeMode == ThemeMode.light
                      ? Color(0xFF4988C4)
                      : Color(0xFF1C4D8D))
                  : (themeMode == ThemeMode.dark
                      ? Color(0xFFF0F0F7) // ✅ Light mode unselected
                      : const Color.fromARGB(20, 230, 230, 242)),
              borderRadius: BorderRadius.circular(50.r)),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.30,
                // color:
                //     currentIndex == index ? Colors.white : Color(0xFF2E2E2E),
                color: currentIndex == index
                    ? Colors.white
                    : (themeMode == ThemeMode.light
                        ? Color.fromARGB(127, 255, 255, 255)
                        : const Color(0xFF2E2E2E)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyContainer extends ConsumerWidget {
  final String image;
  final String title;
  final String email;
  final String description;

  const MyContainer({
    super.key,
    required this.image,
    required this.title,
    required this.email,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w, bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          //  color: Colors.white,
          color: themeMode == ThemeMode.dark ? Colors.white : Color(0xff9088F1),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Color(0xff9088F1)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1B1B1B),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                image,
                height: 80.h,
                width: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  "https://t4.ftcdn.net/jpg/05/07/58/41/360_F_507584110_KNIfe7d3hUAEpraq10J7MCPmtny8EH7A.jpg",
                  height: 80.h,
                  width: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      // color: Color(0xFF1B1B1B),
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF1B1B1B)
                          : Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14.sp,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          email,
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            // color: Colors.grey[700],
                            color: themeMode == ThemeMode.dark
                                ? Color(0xFF1B1B1B)
                                : Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    description.isNotEmpty
                        ? description
                        : "No Description Available",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      // color: Color(0xFF1B1B1B)87,
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF1B1B1B)
                          : Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetRequestStudentBody extends ConsumerStatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final String email;
  final String phone;
  final Function callBack;

  const GetRequestStudentBody({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.phone,
    required this.callBack,
  });

  @override
  ConsumerState<GetRequestStudentBody> createState() =>
      _GetRequestStudentBodyState();
}

class _GetRequestStudentBodyState extends ConsumerState<GetRequestStudentBody> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding:
          EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          // color: Colors.white,
          color: themeMode == ThemeMode.dark ? Colors.white : Color(0xff9088F1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xff9088F1)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1B1B1B),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                widget.image,
                height: 80.h,
                width: 80.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: themeMode == ThemeMode.dark
                          ? Color(0xFF1B1B1B)
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      //color: Colors.blueGrey,
                      color: themeMode == ThemeMode.dark
                          ? Colors.blueGrey
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 14.sp,
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey
                              : Colors.white),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          widget.email,
                          style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              //color: Colors.grey[700],
                              color: themeMode == ThemeMode.dark
                                  ? Colors.grey[700]
                                  : Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          size: 14.sp,
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey
                              : Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        widget.phone,
                        style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: themeMode == ThemeMode.dark
                                ? Colors.grey[700]
                                : Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: isLoading
                  ? SizedBox(
                      height: 35.h,
                      width: 35.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.green,
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade100,
                        foregroundColor: Color(0xFF1B1B1B),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                      ),
                      onPressed: () async {
                        setState(() => isLoading = true);

                        await widget.callBack();

                        setState(() => isLoading = false);
                      },
                      child: Text(
                        "Accept",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerHomePage extends ConsumerWidget {
  const ShimmerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isLight = themeMode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: isLight ? Colors.white : const Color(0xFF05040F),
      body: Shimmer.fromColors(
        baseColor: isLight ? Colors.grey[300]! : Colors.grey[800]!,
        highlightColor: isLight ? Colors.grey[100]! : Colors.grey[700]!,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                    ),
                  ),
                  Container(
                    width: 130.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 150.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 20),
              // Categories shimmer
              Row(
                children: List.generate(
                  2,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 100,
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 150.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                ),
              ),
              const SizedBox(height: 20),
              // Categories shimmer
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 100,
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Categories shimmer
              Row(
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 25,
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Courses shimmer
              Column(
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 120,
                    decoration: BoxDecoration(
                      color: isLight ? Colors.white : const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
