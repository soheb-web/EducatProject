import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/Model/getCreateListModel.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../coreFolder/Model/MyListModel.dart';

class ListingDetailsPageMyDetail extends ConsumerStatefulWidget {
  bool data;
  final DatumMyList item;
  ListingDetailsPageMyDetail(this.data, this.item, {super.key});
  @override
  ConsumerState<ListingDetailsPageMyDetail> createState() =>
      _ListingDetailsPageMyDetailState();
}

class _ListingDetailsPageMyDetailState
    extends ConsumerState<ListingDetailsPageMyDetail> {
  // bool hasApplied = false;
  bool isAccept = false;
  late int status;

  @override
  void initState() {
    super.initState();
    status = widget.item.status ?? 0;
  }

  double _getAmountInRupees(int coins) {
    return (coins * 0.1);
  }

  // Function: Rupees se Coins mein convert karega
  int _getCoinsFromRupees(double rupees) {
    // ₹1 = 10 coins → isliye rupees * 10
    return (rupees * 10)
        .toInt(); // .toInt() se decimal hat jayega (safe rounding down)
  }

  String timeAgoFromTime(String timeString) {
    try {
      DateTime now = DateTime.now();

      // "7:00 PM" parse karo
      DateTime parsedTime = DateFormat("h:mm a").parse(timeString);

      // Aaj ki date ke saath time set karo
      DateTime postDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      Duration difference = now.difference(postDateTime);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hour ago";
      } else {
        return "${difference.inDays} day ago";
      }
    } catch (e) {
      return timeString; // fallback
    }
  }

  String timeAgo(String dateTimeString) {
    DateTime postTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();

    Duration diff = now.difference(postTime);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} day ago";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()} week ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month ago";
    } else {
      return "${(diff.inDays / 365).floor()} year ago";
    }
  }

  String createAtago(String dateTimeString) {
    DateTime postTime = DateTime.parse(dateTimeString); // ISO string parse
    DateTime now = DateTime.now();

    Duration diff = now.difference(postTime);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} day ago";
    } else if (diff.inDays < 30) {
      return "${(diff.inDays / 7).floor()} week ago";
    } else if (diff.inDays < 365) {
      return "${(diff.inDays / 30).floor()} month ago";
    } else {
      return "${(diff.inDays / 365).floor()} year ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    /* final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final bgColor = isDark ? Colors.white : const Color(0xFF1B1B1B);*/

    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final cardColor =
        // isDark ? const Color(0xFF2A2A2A) : Colors.white;
        // isDark ? const Color(0xFF2A2A2A) :
        Colors.white;
    // final textColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final textColor = const Color(0xFF1B1B1B);
    final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    // final bgColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final bgColor = const Color(0xFF1B1B1B);
    return Scaffold(
      backgroundColor: isDark ? Colors.white : const Color(0xFF1B1B1B),
      //  backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 6), // ← thoda kam kiya
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        // IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.arrow_back,
        //         color:
        //             // themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) :
        //             Colors.white)),
        backgroundColor: const Color(0xff9088F1),
        elevation: 0,
        title: Text(
          "Student Requirements",
          style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor,
                    cardColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: textColor.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff9088F1),
                          Color(0xFF006666),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.network(
                        widget.item.student!.profilePic ??
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: 80.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff9088F1).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40.sp,
                              color: const Color(0xff9088F1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.student!.fullName ?? "Student",
                          style: GoogleFonts.roboto(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                              height: 1.2),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xff9088F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            widget.item.education ?? "",
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: const Color(0xff9088F1),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.2),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            size: 8.sp, color: Colors.orange[700]),
                        SizedBox(width: 4.w),
                        Text(
                          "Open",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            /// REQUIREMENT CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor,
                    cardColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: textColor.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subjects Required",
                    style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: widget.item.subjects!
                        .map<Widget>(
                          (s) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff9088F1).withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: const Color(0xff9088F1).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              s,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20.h),
                  _buildInfoSection(
                    context,
                    title: "Basic Details",
                    children: [
                      _buildInfoRow(
                        icon: Icons.location_on,
                        color: Colors.red,
                        label: "Location",
                        value:
                            "${widget.item.localAddress ?? ''} ${widget.item.state} India ${widget.item.pincode}",
                      ),
                      _buildInfoRow(
                        icon: Icons.date_range_outlined,
                        color: Colors.grey,
                        label: "Posted",
                        value: timeAgo(widget.item.createdAt.toString()),
                      ),
                      _buildInfoRow(
                        icon: Icons.school,
                        color: const Color(0xff9088F1),
                        label: "Level",
                        value: widget.item.education ?? "N/A",
                      ),
                      _buildInfoRow(
                        icon: Icons.schedule,
                        color: Colors.green,
                        label: "Requires",
                        value: widget.item.requires ?? "N/A",
                      ),
                      _buildInfoRow(
                        icon: Icons.person_2_outlined,
                        color: Colors.deepPurple,
                        label: "Posted By",
                        value:
                            "${widget.item.student!.fullName ?? "N/A"} (Student)",
                      ),
                      _buildInfoRow(
                        icon: Icons.people_outline_outlined,
                        color: textColor,
                        label: "Gender Preference",
                        value: widget.item.gender ?? "None",
                      ),
                      _buildInfoRow(
                        icon: Icons.monetization_on,
                        color: Colors.amber,
                        label: "Coins",
                        value:
                            "${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()}",
                      ),
                    ],
                  ),
                  if (widget.item.teachingMode != null)
                    _buildInfoRow(
                      icon: Icons.person,
                      color: Colors.brown,
                      label: "Available",
                      value: widget.item.teachingMode ?? "None",
                    ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                    icon: Icons.timer,
                    color: Colors.orange,
                    label: "Duration",
                    value: widget.item.duration ?? "N/A",
                  ),
                  if (widget.item.mobileNumber != null)
                    _buildInfoRow(
                      icon: Icons.phone_android,
                      color: const Color(0xff9088F1),
                      label: "Phone",
                      value: widget.item.mobileNumber ?? "",
                    ),
                  if (widget.item.communicate != null)
                    _buildInfoRow(
                      icon: Icons.message,
                      color: Colors.deepOrange,
                      label: "Can Communicate in",
                      value: widget.item.communicate ?? "",
                    ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff9088F1).withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                          color: const Color(0xff9088F1).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.currency_rupee,
                            color: Colors.green, size: 20.sp),
                        SizedBox(width: 12.w),
                        Text(
                          "Budget : ₹${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()}",
                          style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// CONTACT SECTION (Mobile Number)
            // hasApplied

            !widget.data
                ? status == 1
                    ? Column(
                        children: [
                          _buildActionButton(
                            icon: Icons.email_outlined,
                            label: "Message",
                            onTap: status == 0
                                ? null
                                : () {
                                    log("id : -  ${widget.item.id.toString()}");
                                    log("Student id : -  ${widget.item.studentId.toString()}");
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ChatingPage(
                                              name: widget
                                                      .item.student!.fullName ??
                                                  "N/A",
                                              id: widget.item.id.toString(),
                                              otherUesrid: widget.item.studentId
                                                  .toString()),
                                        ));
                                  },
                          ),
                          SizedBox(height: 12.h),
                          _buildActionButton(
                            icon: Icons.phone_outlined,
                            label:
                                "Phone number ${widget.item.student!.phoneNumber ?? ""}",
                            onTap: () {
                              String? phone = widget.item.student!.phoneNumber;

                              if (phone == null || phone.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Phone number not available")),
                                );
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text("Call Student"),
                                    content:
                                        Text("Do you want to call ${phone}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext)
                                              .pop(); // Dialog close
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(dialogContext)
                                              .pop(); // Dialog close

                                          // Actual phone call
                                          final Uri launchUri = Uri(
                                            scheme: 'tel',
                                            path: phone,
                                          );
                                          if (await canLaunchUrl(launchUri)) {
                                            await launchUrl(launchUri);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Could not launch dialer")),
                                            );
                                          }

                                          // Agar call karne ke baad koi new screen navigate karna hai toh yeh karo
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => YourNewScreen(student: widget.item.student!),
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          "Call",
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActionButton(
                            icon: Icons.email_outlined,
                            label:
                                "Message & view phone number (${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()} coins)",
                            onTap: () {}, // Placeholder, as per original
                          ),
                          SizedBox(height: 12.h),
                          _buildActionButton(
                            icon: Icons.phone_outlined,
                            label:
                                "view phone number (${(double.tryParse(widget.item.budget ?? '0') ?? 0).toInt()} coins)",
                            onTap: () {}, // Placeholder, as per original
                          ),
                        ],
                      )
                : SizedBox(),

            SizedBox(height: 24.h),

            /// ACTION BUTTONS (Mentor Side)
            ///
            ///

            // !widget.data
            //     ?
            //
            // Row(
            //   children: [
            //     widget.item.notificationStatus==null
            //     // status == 1
            //
            //         ? SizedBox()
            //         : Expanded(
            //       child: ElevatedButton.icon(
            //
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: const Color(0xff9088F1),
            //           foregroundColor: Colors.white,
            //           elevation: 4,
            //           shadowColor:
            //           const Color(0xff9088F1).withOpacity(0.3),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(20.r),
            //           ),
            //           padding: EdgeInsets.symmetric(vertical: 16.h),
            //         ),
            //
            //         onPressed: () async {
            //           final profile =
            //           ref.read(userProfileController);
            //
            //           // Safety check
            //           if (profile.value == null ||
            //               profile.value!.data == null) {
            //             Fluttertoast.showToast(
            //                 msg: "Profile not loaded");
            //             return;
            //           }
            //
            //           // User ke paas kitne coins hain (String se double mein convert)
            //           final String? userCoinsStr =
            //               profile.value!.data!.coins;
            //           final double userCoins =
            //               double.tryParse(userCoinsStr ?? "0") ??
            //                   0.0;
            //
            //           // Mentor apply ke liye kitni fee hai (rupees mein)
            //           final double feeInRupees = double.tryParse(
            //               widget.item.budget ?? "0") ??
            //               0.0;
            //
            //           // Kitne coins chahiye is fee ke liye? (₹0.1 = 1 coin → ₹1 = 10 coins)
            //           // final int requiredCoins = (feeInRupees * 10)
            //           //     .toInt(); // Ya function use karo niche diya hua
            //
            //           // Check karo: User ke paas kaafi coins hain ya nahi?
            //           if (userCoins < feeInRupees) {
            //             Fluttertoast.showToast(
            //               msg:
            //               "Insufficient coins! You need $feeInRupees coins (₹$feeInRupees)",
            //               toastLength: Toast.LENGTH_LONG,
            //               backgroundColor: Colors.red,
            //               textColor: Colors.white,
            //             );
            //             return;
            //           }
            //
            //           // Agar coins kaafi hain toh apply karo
            //           final body = ApplybodyModel(
            //             body:
            //             "A mentor has applied to your request. Check details now!",
            //             title: "Mentor Application",
            //             userId: widget.item.studentId,
            //             studentIistsId: widget.item.id,
            //           );
            //
            //           try {
            //             setState(() {
            //               isAccept = true;
            //             });
            //
            //             final service =
            //             APIStateNetwork(createDio());
            //             final response = await service
            //                 .applyOrSendNotification(body);
            //
            //             if (response.response.data['success'] ==
            //                 true) {
            //               Fluttertoast.showToast(
            //                 msg: "Applied successfully!",
            //                 backgroundColor: Colors.green,
            //               );
            //               setState(() {
            //                 status =
            //                 1; // 🔥 UI instantly refresh ho jayega
            //               });
            //
            //               ref.invalidate(myListingController);
            //             } else {
            //               Fluttertoast.showToast(
            //                 msg:
            //                 response.response.data['message'] ??
            //                     "Application failed",
            //               );
            //             }
            //           } catch (e, st) {
            //             log("Apply Error: $e\nStackTrace: $st");
            //             Fluttertoast.showToast(
            //                 msg:
            //                 "Something went wrong. Try again.");
            //           } finally {
            //             setState(() {
            //               isAccept = false;
            //             });
            //           }
            //         },
            //         icon: isAccept
            //             ?
            //         SizedBox(
            //           width: 20.w,
            //           height: 20.h,
            //           child: CircularProgressIndicator(
            //             color: Colors.white,
            //             strokeWidth: 2,
            //           ),
            //         )
            //             : Icon(Icons.apple_outlined, size: 20),
            //         label: isAccept
            //             ? const Text("")
            //             : Text(
            //           "Apply Now",
            //           style: GoogleFonts.inter(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
            //
            //     : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1B1B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        ...children.map((child) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: child,
            )),
        SizedBox(height: 8.h),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    // final textColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final textColor = const Color(0xFF1B1B1B);
    // final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final secondaryTextColor = Colors.grey[600]!;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff9088F1),
              const Color(0xFF006666),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff9088F1).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
