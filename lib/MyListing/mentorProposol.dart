/*
import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/MyListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MentorProposalPageNew extends ConsumerStatefulWidget {

  const MentorProposalPageNew(DatumMyList item, {super.key});

  @override
  ConsumerState<MentorProposalPageNew> createState() => _MentorProposalPageNewState();
}

class _MentorProposalPageNewState extends ConsumerState<MentorProposalPageNew> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Mentor Proposals",
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F26),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: 5,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.only(
                        left: 15.w, top: 15.h, bottom: 20.h, right: 15.w),
                    decoration: BoxDecoration(
                      color: themeMode == ThemeMode.light
                          ? null
                          : Color(0xFFFFFFFF),
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
                                  "item",
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 40.h,
                                      height: 40.h,
                                      color: Colors.grey[300],
                                      child: CircularProgressIndicator(
                                          color: Colors.yellow),
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
                                  "Savjivddin Ansari",
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
                                  "Flutter Developer * 1 Yrs",
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
                            //  if (widget.education != null && widget.education.isNotEmpty)
                            Text(
                              "Proposed Fee",
                              style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF2E2E2E)),
                            ),
                            // if (widget.language != null && widget.language.isNotEmpty)
                            Text(
                              "Rating",
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
                            //  if (widget.education != null && widget.education.isNotEmpty)
                            Text(
                              "₹2,200",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF2E2E2E)),
                            ),
                            //  if (widget.language != null && widget.language.isNotEmpty)
                            Text(
                              "⭐ 4.6 (88 reviews)",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF2E2E2E)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  minimumSize: Size(175.w, 45.h),
                                  backgroundColor: Color(0xff9088F1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ).copyWith(overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.white
                                          .withOpacity(0.25); // ripple
                                    }
                                    return null;
                                  },
                                )),
                                onPressed: () {},
                                child: Text(
                                  "Accept Request",
                                  style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  minimumSize: Size(175.w, 45.h),
                                  backgroundColor: Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      side: BorderSide(
                                          color: Color(0xFFFF0000),
                                          width: 1.w)),
                                ).copyWith(overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return const Color(0xFFFF0000)
                                          .withOpacity(0.15);
                                    }
                                    return null;
                                  },
                                )),
                                onPressed: () {},
                                child: Text("Accept Request",
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFF0000),
                                    ))),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}*/
/*

import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/MyListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/MentorSendBody.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class MentorProposalPageNew extends ConsumerWidget {
  final DatumMyList item;

  const MentorProposalPageNew({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    // Agar mentors nahi hain to empty state
    if (item.mentors == null || item.mentors!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Mentor Proposals",
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F26),
            ),
          ),
        ),
        body: Center(
          child: Text(
            "No mentor proposals yet...",
            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mentor Proposals",
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F1F26),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: item.mentors!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final mentor = item.mentors![index];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: EdgeInsets.only(
                      left: 15.w, top: 15.h, bottom: 20.h, right: 15.w),
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.light
                        ? null
                        : Color(0xFFFFFFFF),
                    border: Border.all(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Color.fromARGB(25, 88, 86, 113)),
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
                                // Agar Mentor model mein profile pic add kar diya hai to yahan use karo
                                // mentor.profilePic ??
                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 40.h,
                                    height: 40.h,
                                    color: Colors.grey[300],
                                    child: CircularProgressIndicator(
                                        color: Colors.yellow),
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
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentor.name ?? "Mentor Name",
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
                                "Flutter Developer • 1 Yrs", // ← yahan future mein real experience daal sakte ho
                                style: GoogleFonts.roboto(
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF666666),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              Positioned(
                                top: -12,
                                right: -12,
                                child: Image.asset("assets/gridbg.png"),
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
                      SizedBox(height: 10.h),
                      Divider(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Colors.grey.shade300,
                        thickness: 1.w,
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Proposed Fee",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          Text(
                            "Rating",
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
                          Text(
                            "₹${item.budget ?? '2,200'}", // ← real budget use kiya
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          Text(
                            "⭐ 4.6 (88 reviews)", // ← yahan real rating add kar sakte ho future mein
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          )
                        ],
                      ),
                      SizedBox(height: 16.h),
                     */
/* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              minimumSize: Size(175.w, 45.h),
                              backgroundColor: Color(0xff9088F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white.withOpacity(0.25);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // onPressed: () {

                              onPressed: () async {
                                final profile =
                                ref.read(userProfileController);

                                // Safety check
                                if (profile.value == null ||
                                    profile.value!.data == null) {
                                  Fluttertoast.showToast(
                                      msg: "Profile not loaded");
                                  return;
                                }

                                // User ke paas kitne coins hain (String se double mein convert)
                                final String? userCoinsStr =
                                    profile.value!.data!.coins;
                                final double userCoins =
                                    double.tryParse(userCoinsStr ?? "0") ??
                                        0.0;

                                // Mentor apply ke liye kitni fee hai (rupees mein)
                                final double feeInRupees = double.tryParse(
                                    widget.item.budget ?? "0") ??
                                    0.0;

                                // Kitne coins chahiye is fee ke liye? (₹0.1 = 1 coin → ₹1 = 10 coins)
                                // final int requiredCoins = (feeInRupees * 10)
                                //     .toInt(); // Ya function use karo niche diya hua

                                // Check karo: User ke paas kaafi coins hain ya nahi?
                                if (userCoins < feeInRupees) {
                                  Fluttertoast.showToast(
                                    msg:
                                    "Insufficient coins! You need $feeInRupees coins (₹$feeInRupees)",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }

                                // Agar coins kaafi hain toh apply karo

                                final body = MentorrequestApplyBody(

                                 mentorId:mentor.id,
                                 title:"Accept Request",
           body:"Accept Request Notification",
           data:"Accept Request Notification",
           mentorStatus:"Accept"
                                *//*
*/
/*  body:
                                  "A mentor has applied to your request. Check details now!",
                                  title: "Mentor Application",
                                  userId: widget.item.studentId,
                                  studentIistsId: widget.item.id,*//*
*/
/*
                                );

                                try {
                                  setState(() {
                                    isAccept = true;
                                  });

                                  final service =
                                  APIStateNetwork(createDio());
                                  final response = await service
                                      .mentorSend(body);

                                  if (response.response.data['success'] ==
                                      true) {
                                    Fluttertoast.showToast(
                                      msg: "Applied successfully!",
                                      backgroundColor: Colors.green,
                                    );
                                    setState(() {
                                      status =
                                      1; // 🔥 UI instantly refresh ho jayega
                                    });

                                    ref.invalidate(myListingController);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg:
                                      response.response.data['message'] ??
                                          "Application failed",
                                    );
                                  }
                                } catch (e, st) {
                                  log("Apply Error: $e\nStackTrace: $st");
                                  Fluttertoast.showToast(
                                      msg:
                                      "Something went wrong. Try again.");
                                } finally {
                                  setState(() {
                                    isAccept = false;
                                  });
                                }
                              },
                              // Accept logic yahan daal do
                              print("Accepted mentor: ${mentor.name}");
                            },
                            child: Text(
                              "Accept Request",
                              style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              minimumSize: Size(175.w, 45.h),
                              backgroundColor: Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                side: BorderSide(color: Color(0xFFFF0000), width: 1.w),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xFFFF0000).withOpacity(0.15);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: () {
                              // Reject logic yahan daal do
                              print("Rejected mentor: ${mentor.name}");
                            },
                            child: Text(
                              "Reject Request",
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ),
                        ],
                      )*//*


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Accept Button
                          ElevatedButton(
                            onPressed: isAccepting || isRejecting
                                ? null // disable both buttons while any operation is running
                                : () async {
                              setState(() => isAccepting = true);

                              try {
                                final profile = ref.read(userProfileController);

                                if (profile.value == null || profile.value!.data == null) {
                                  Fluttertoast.showToast(msg: "Profile not loaded");
                                  return;
                                }

                                final String? userCoinsStr = profile.value!.data!.coins;
                                final double userCoins = double.tryParse(userCoinsStr ?? "0") ?? 0.0;

                                final double feeInRupees = double.tryParse(widget.item.budget ?? "0") ?? 0.0;

                                // Assuming 1 rupee = 10 coins (change multiplier if different)
                                final double requiredCoins = feeInRupees * 10;

                                if (userCoins < requiredCoins) {
                                  Fluttertoast.showToast(
                                    msg: "Insufficient coins! Need ${requiredCoins.toStringAsFixed(0)} coins (₹${feeInRupees.toStringAsFixed(0)})",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }

                                // Prepare request body for ACCEPT
                                final body = MentorrequestApplyBody(
                                  mentorId: mentor.id,
                                  title: "Accept Request",
                                  body: "Accept Request Notification",
                                  data: "Accept Request Notification",
                                  mentorStatus: "Accept", // or "accepted" — match your backend
                                );

                                final service = APIStateNetwork(createDio());
                                final response = await service.mentorSend(body);

                                if (response.response.data['success'] == true) {
                                  Fluttertoast.showToast(
                                    msg: "Request accepted successfully!",
                                    backgroundColor: Colors.green,
                                  );

                                  setState(() {
                                    status = 1; // or whatever value means accepted in your UI
                                  });

                                  ref.invalidate(myListingController);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: response.response.data['message'] ?? "Failed to accept",
                                  );
                                }
                              } catch (e, st) {
                                log("Accept Error: $e\n$st");
                                Fluttertoast.showToast(msg: "Something went wrong. Try again.");
                              } finally {
                                setState(() => isAccepting = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              minimumSize: Size(175.w, 45.h),
                              backgroundColor: Color(0xff9088F1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white.withOpacity(0.25);
                                }
                                return null;
                              }),
                            ),
                            child: isAccepting
                                ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : Text(
                              "Accept Request",
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Reject Button
                          ElevatedButton(
                            onPressed: isAccepting || isRejecting
                                ? null
                                : () async {
                              setState(() => isRejecting = true);

                              try {
                                // Prepare request body for REJECT
                                final body = MentorrequestApplyBody(
                                  mentorId: mentor.id,
                                  title: "Reject Request",
                                  body: "Reject Request Notification",
                                  data: "Reject Request Notification",
                                  mentorStatus: "Reject", // or "rejected" — match your backend
                                );

                                final service = APIStateNetwork(createDio());
                                final response = await service.mentorSend(body);

                                if (response.response.data['success'] == true) {
                                  Fluttertoast.showToast(
                                    msg: "Request rejected",
                                    backgroundColor: Colors.orange,
                                  );

                                  setState(() {
                                    status = 2; // or whatever value means rejected in your UI
                                  });

                                  ref.invalidate(myListingController);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: response.response.data['message'] ?? "Failed to reject",
                                  );
                                }
                              } catch (e, st) {
                                log("Reject Error: $e\n$st");
                                Fluttertoast.showToast(msg: "Something went wrong. Try again.");
                              } finally {
                                setState(() => isRejecting = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              minimumSize: Size(175.w, 45.h),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                side: BorderSide(color: Color(0xFFFF0000), width: 1.w),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color(0xFFFF0000).withOpacity(0.15);
                                }
                                return null;
                              }),
                            ),
                            child: isRejecting
                                ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Color(0xFFFF0000),
                                strokeWidth: 2.5,
                              ),
                            )
                                : Text(
                              "Reject Request",
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF0000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/
/*


import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/MyListModel.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Profile/profileScreen.dart';
import '../coreFolder/Controller/myListController.dart';
import '../coreFolder/Controller/myListingController.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/MentorSendBody.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import '../home/chating.page.dart';

class MentorProposalPageNew extends ConsumerStatefulWidget {
  final int id;

  const MentorProposalPageNew({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<MentorProposalPageNew> createState() => _MentorProposalPageNewState();
}

class _MentorProposalPageNewState extends ConsumerState<MentorProposalPageNew> {
  bool isAccepting = false;
  bool isRejecting = false;

  // Har mentor ka alag status (0 = pending, 1 = accepted, 2 = rejected)
  final Map<int, int> mentorStatusMap = {};

  @override
  void initState() {
    super.initState();



    // Sab mentors ko shuru mein pending (0) set kar do
    for (var mentor in widget.item.mentors ?? []) {
      if (mentor.id != null) {
        mentorStatusMap[mentor.id!] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
 */
/*   final themeMode = ref.watch(themeProvider);*//*

    final savedListAsync = ref.watch(myListController);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final cardColor =
    // isDark ? const Color(0xFF2A2A2A) : Colors.white;
    // isDark ? const Color(0xFF2A2A2A) :
    Colors.white;
    // final textColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final textColor =  const Color(0xFF1B1B1B);
    final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    // final bgColor = isDark ? Colors.white : const Color(0xFF1B1B1B);
    final bgColor =
    const Color(0xFF1B1B1B);
    // Agar mentors nahi hain to empty state
    if (widget.item.mentors == null || widget.item.mentors!.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Mentor Proposals",
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F1F26),
            ),
          ),
        ),
        body: Center(
          child: Text(
            "No mentor proposals yet...",
            style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:  isDark ? Colors.white : const Color(0xFF1B1B1B),
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff9088F1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mentor Proposals",
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color:Colors.white
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.item.mentors!.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final mentor = widget.item.mentors![index];
          final mentorId = mentor.id ?? 0;
          final currentStatus = mentorStatusMap[mentorId] ?? 0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: EdgeInsets.only(
                      left: 15.w, top: 15.h, bottom: 20.h, right: 15.w),
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.light
                        ? null
                        : Color(0xFFFFFFFF),
                    border: Border.all(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Color.fromARGB(25, 88, 86, 113)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... (yeh pura mentor header, image, name, experience wala part same rakha)

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
                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 40.h,
                                    height: 40.h,
                                    color: Colors.grey[300],
                                    child: CircularProgressIndicator(
                                        color: Colors.yellow),
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
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentor.name ?? "Mentor Name",
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
                                "Flutter Developer • 1 Yrs",
                                style: GoogleFonts.roboto(
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF666666),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              Positioned(
                                top: -12,
                                right: -12,
                                child: Image.asset("assets/gridbg.png"),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MentorDetailPage(id: mentor.id!.toInt())));
                                },
                                child: Container(
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
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Divider(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Colors.grey.shade300,
                        thickness: 1.w,
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Proposed Fee",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          Text(
                            "Rating",
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
                          Text(
                            "₹${widget.item.budget ?? '2,200'}",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          Text(
                            "⭐ 4.6 (88 reviews)",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          )
                        ],
                      ),
                      SizedBox(height: 16.h),


                      if (mentor.mentor_status==null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                minimumSize: Size(175.w, 45.h),
                                backgroundColor: Color(0xff9088F1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ).copyWith(
                                overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.white.withOpacity(0.25);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: (isAccepting || isRejecting)
                                  ? null
                                  : () async {
                                setState(() => isAccepting = true);

                                try {
                                  final profile =
                                  ref.read(userProfileController);

                                  if (profile.value == null ||
                                      profile.value!.data == null) {
                                    Fluttertoast.showToast(
                                        msg: "Profile not loaded");
                                    return;
                                  }

                                  final String? userCoinsStr =
                                      profile.value!.data!.coins;
                                  final double userCoins =
                                      double.tryParse(
                                          userCoinsStr ?? "0") ??
                                          0.0;

                                  final double feeInRupees =
                                      double.tryParse(
                                          widget.item.budget ?? "0") ??
                                          0.0;



                                  final body = MentorrequestApplyBody(
                                    mentorId: mentor.id,
                                    title: "Accept Request",
                                    body: "Accept Request Notification",
                                    student_lists_id:widget.item.id,
                                    mentorStatus: "Accept",                  // or "accepted" — ask backend
                                  );



                                  final service =
                                  APIStateNetwork(createDio());
                                  final response =
                                  await service.mentorSend(body);

                                  if (response.response.data['success'] ==
                                      true) {
                                    Fluttertoast.showToast(
                                      msg: "Request accepted successfully!",
                                      backgroundColor: Colors.green,
                                    );



                                      ref.invalidate(myListingController);
                                      ref.invalidate(myListController);



                                    setState(() {
                                      mentorStatusMap[mentorId] = 1;
                                    });


                                  } else {
                                    Fluttertoast.showToast(
                                      msg: response.response.data[
                                      'message'] ??
                                          "Failed to accept",
                                    );
                                  }
                                } catch (e, st) {
                                  log("Accept Error: $e\n$st");
                                  Fluttertoast.showToast(
                                      msg:
                                      "Something went wrong. Try again.");
                                } finally {
                                  setState(() => isAccepting = false);
                                }
                              },
                              child: isAccepting
                                  ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : Text(
                                "Accept Request",
                                style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                minimumSize: Size(175.w, 45.h),
                                backgroundColor: Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  side: BorderSide(
                                      color: Color(0xFFFF0000), width: 1.w),
                                ),
                              ).copyWith(
                                overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return const Color(0xFFFF0000)
                                          .withOpacity(0.15);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: (isAccepting || isRejecting)
                                  ? null
                                  : () async {
                                setState(() => isRejecting = true);

                                try {
                                  final profile =
                                  ref.read(userProfileController);
                                  // For Reject button
                                  final body = MentorrequestApplyBody(
                                    mentorId: mentor.id,
                                    title: "Reject Request",
                                    body: "Reject Request Notification",
                                    student_lists_id:widget.item.id,
                                    mentorStatus: "Reject",                  // or "rejected"
                                  );

                                  final service =
                                  APIStateNetwork(createDio());
                                  final response =
                                  await service.mentorSend(body);

                                  if (response.response.data['success'] ==
                                      true) {
                                    Fluttertoast.showToast(
                                      msg: "Request rejected",
                                      backgroundColor: Colors.orange,
                                    );

                                    setState(() {
                                      mentorStatusMap[mentorId] = 2;
                                    });

                                    // ref.invalidate(myListingController);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: response.response.data[
                                      'message'] ??
                                          "Failed to reject",
                                    );
                                  }
                                } catch (e, st) {
                                  log("Reject Error: $e\n$st");
                                  Fluttertoast.showToast(
                                      msg:
                                      "Something went wrong. Try again.");
                                } finally {
                                  setState(() => isRejecting = false);
                                }
                              },
                              child: isRejecting
                                  ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: Color(0xFFFF0000),
                                  strokeWidth: 2.5,
                                ),
                              )
                                  : Text(
                                "Reject Request",
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFF0000),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
          mentor.mentor_status??"",

                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: currentStatus == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),



                      if (mentor.mentor_status!=null&&mentor.mentor_status=="Accept")

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                minimumSize: Size(175.w, 45.h),
                                backgroundColor: Color(0xff9088F1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ).copyWith(
                                overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.white.withOpacity(0.25);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: (){

                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text("Call Student"),
                                      content:
                                      Text("Do you want to call ${mentor.phone_number}?"),
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
                                              path: mentor.phone_number,
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

                                  child:  Text(
                                      mentor.phone_number??"",
                                style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                minimumSize: Size(175.w, 45.h),
                                backgroundColor: Color(0xff9088F1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ).copyWith(
                                overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                      (states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.white.withOpacity(0.25);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: (){

                                final profile =
                                ref.read(userProfileController);

                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ChatingPage(
                                          name: mentor.name??
                                              "N/A",
                                          id: profile.value!.data!.id.toString(),
                                          otherUesrid:mentor.id.toString()

                                      ),
                                    ));

                              },

                              child:  Text(
                                "Message",
                                style: GoogleFonts.roboto(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),

                          ],
                        ),

                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/
/*

import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/MyListModel.dart'; // ← your GetMyListModel
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../coreFolder/Controller/myListController.dart';
import '../coreFolder/Controller/myListingController.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/MentorSendBody.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import '../home/chating.page.dart';

class MentorProposalPageNew extends ConsumerStatefulWidget {
  final int proposalId; // ← renamed for clarity

  const MentorProposalPageNew({
    super.key,
    required this.proposalId,
  });

  @override
  ConsumerState<MentorProposalPageNew> createState() => _MentorProposalPageNewState();
}

class _MentorProposalPageNewState extends ConsumerState<MentorProposalPageNew> {
  bool isAccepting = false;
  bool isRejecting = false;

  // We'll store the matched proposal here after filtering
  DatumMyList? _selectedProposal;

  @override
  void initState() {
    super.initState();
    // Optional: you can listen in build or use ref.watch → see below
  }

  @override
  Widget build(BuildContext context) {
    final myListAsync = ref.watch(myListController); // List of all proposals
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final bgColor = isDark ? const Color(0xFF1B1B1B) : Colors.white;
    final cardBg = isDark ? Colors.white : const Color(0xFF2A2A2A);
    final textColor = isDark ? const Color(0xFF1B1B1B) : Colors.white;
    final secondaryText = isDark ? Colors.grey[600]! : Colors.grey[400]!;

    return Scaffold(
      backgroundColor:
      themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),

      appBar: AppBar(
        backgroundColor: const Color(0xff9088F1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mentor Proposals",
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: myListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (GetMyListModel model) {
          // Find the proposal that matches widget.proposalId
          final proposal = model.data?.firstWhere(
                (p) => p.id == widget.proposalId,
            orElse: () => DatumMyList(), // empty fallback
          );

          if (proposal == null || proposal.id == null) {
            return Center(
              child: Text(
                "Proposal not found",
                style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }

          _selectedProposal = proposal; // store for later use if needed

          final mentors = proposal.mentors ?? [];

          if (mentors.isEmpty) {
            return Center(
              child: Text(
                "No mentor proposals yet...",
                style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              final mentorId = mentor.id ?? 0;

              final status = mentor.mentor_status; // "Accept", "Reject", null

              return Container(
                margin: EdgeInsets.only(bottom: 20.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mentor header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundImage: const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentor.name ?? "Mentor Name",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Flutter Developer • 1 Yrs",
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MentorDetailPage(id: mentorId),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 22.r,
                            backgroundColor:
                            isDark ? const Color(0xFFF0F0F7) : const Color(0xFF26252E),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: isDark ? const Color(0xFF1F1F26) : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    Divider(color: Colors.grey.withOpacity(0.3)),

                    SizedBox(height: 12.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Proposed Fee", style: _labelStyle(secondaryText)),
                        Text("Rating", style: _labelStyle(secondaryText)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${proposal.budget ?? '—'}",
                          style: _valueStyle(textColor),
                        ),
                        Text(
                          "⭐ 4.6 (88 reviews)",
                          style: _valueStyle(textColor),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ────────────────────────────────────────────────
                    //     Main Action Area – depends on mentor_status
                    // ────────────────────────────────────────────────
                    if (status == null) ...[

                      _buildPendingButtons(context, mentor, proposal.id!),

                    ] else ...[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            status == "Accept" ? "Accepted" : "Rejected",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: status == "Accept" ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),

                      if (status == "Accept") ...[
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(
                              label: mentor.phone_number ?? "—",
                              onPressed: () => _callNumber(mentor.phone_number),
                              color: const Color(0xff9088F1),
                              textColor: Colors.white,
                            ),
                            SizedBox(width: 20.w,),
                            _buildActionButton(
                              textColor: Colors.white,
                              label: "Message",
                              onPressed: () {
                                final myProfile = ref.read(userProfileController).value;
                                if (myProfile?.data == null) return;

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => ChatingPage(
                                      name: mentor.name ?? "N/A",
                                      id: myProfile!.data!.id.toString(),
                                      otherUesrid: mentor.id.toString(),
                                    ),
                                  ),
                                );
                              },
                              color: const Color(0xff9088F1),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPendingButtons(BuildContext context, Mentor mentor, int proposalId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          label: "Accept Request",
          isLoading: isAccepting,
          color: const Color(0xff9088F1),
          textColor: Colors.white,
          onPressed: () => _handleAccept(mentor, proposalId),
        ),
        SizedBox(width: 20.w,),
        _buildActionButton(
          label: "Reject Request",
          isLoading: isRejecting,
          color: Colors.white,
          borderColor: Colors.red,
          textColor: Colors.red,
          onPressed: () => _handleReject(mentor, proposalId),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    bool isLoading = false,
    required Color color,
    Color? borderColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 1,
          minimumSize: Size(double.infinity, 46.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 24.w,
          height: 24.h,
          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
        )
            : Text(
          label,
          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _handleAccept(Mentor mentor, int proposalId) async {
    setState(() => isAccepting = true);
    try {
      final body = MentorrequestApplyBody(
        mentorId: mentor.id,
        title: "Accept Request",
        body: "Accept Request Notification",
        student_lists_id: proposalId,
        mentorStatus: "Accept",
      );

      final service = APIStateNetwork(createDio());
      final res = await service.mentorSend(body);

      if (res.response.data['success'] == true) {
        Fluttertoast.showToast(msg: "Accepted!", backgroundColor: Colors.green);
        ref.invalidate(myListController);
        ref.invalidate(myListingController);
      } else {
        Fluttertoast.showToast(msg: res.response.data['message'] ?? "Failed");
      }
    } catch (e) {
      log("Accept failed: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() => isAccepting = false);
    }
  }

  Future<void> _handleReject(Mentor mentor, int proposalId) async {
    setState(() => isRejecting = true);
    try {
      final body = MentorrequestApplyBody(
        mentorId: mentor.id,
        title: "Reject Request",
        body: "Reject Request Notification",
        student_lists_id: proposalId,
        mentorStatus: "Reject",
      );

      final service = APIStateNetwork(createDio());
      final res = await service.mentorSend(body);

      if (res.response.data['success'] == true) {
        Fluttertoast.showToast(msg: "Rejected", backgroundColor: Colors.orange);
        ref.invalidate(myListController);
      } else {
        Fluttertoast.showToast(msg: res.response.data['message'] ?? "Failed");
      }
    } catch (e) {
      log("Reject failed: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() => isRejecting = false);
    }
  }

  Future<void> _callNumber(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open dialer")),
      );
    }
  }

  TextStyle _labelStyle(Color color) => GoogleFonts.roboto(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );

  TextStyle _valueStyle(Color color) => GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: color,
  );
}*/



import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/MyListModel.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../coreFolder/Controller/myListController.dart';
import '../coreFolder/Controller/myListingController.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/MentorSendBody.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import '../home/chating.page.dart';

class MentorProposalPageNew extends ConsumerStatefulWidget {
  final int proposalId;

  const MentorProposalPageNew({
    super.key,
    required this.proposalId,
  });

  @override
  ConsumerState<MentorProposalPageNew> createState() => _MentorProposalPageNewState();
}

class _MentorProposalPageNewState extends ConsumerState<MentorProposalPageNew> {
  // Instead of global isAccepting/isRejecting → we track per mentor
  int? _processingMentorId;
  String? _processingType; // "accept" or "reject"

  bool isProcessingMentor(int mentorId) => _processingMentorId == mentorId;

  @override
  Widget build(BuildContext context) {
    final myListAsync = ref.watch(myListController);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final bgColor = isDark ? const Color(0xFF1B1B1B) : Colors.white;
    final cardBg = isDark ? Colors.white : const Color(0xFF2A2A2A);
    final textColor = isDark ? const Color(0xFF1B1B1B) : Colors.white;
    final secondaryText = isDark ? Colors.grey[600]! : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),
      appBar: AppBar(
        backgroundColor: const Color(0xff9088F1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mentor Proposals",
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: myListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (GetMyListModel model) {
          final proposal = model.data?.firstWhere(
                (p) => p.id == widget.proposalId,
            orElse: () => DatumMyList(),
          );

          if (proposal == null || proposal.id == null) {
            return Center(
              child: Text(
                "Proposal not found",
                style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }

          final mentors = proposal.mentors ?? [];

          if (mentors.isEmpty) {
            return Center(
              child: Text(
                "No mentor proposals yet...",
                style: GoogleFonts.roboto(fontSize: 16.sp, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              final mentorId = mentor.id ?? 0;
              final status = mentor.mentor_status;

              final isThisProcessing = isProcessingMentor(mentorId);

              return Container(
                margin: EdgeInsets.only(bottom: 20.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mentor header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundImage: const NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentor.name ?? "Mentor Name",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Flutter Developer • 1 Yrs",
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MentorDetailPage(id: mentorId),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 22.r,
                            backgroundColor:
                            isDark ? const Color(0xFFF0F0F7) : const Color(0xFF26252E),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.sp,
                              color: isDark ? const Color(0xFF1F1F26) : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    Divider(color: Colors.grey.withOpacity(0.3)),
                    SizedBox(height: 12.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Proposed Fee", style: _labelStyle(secondaryText)),
                        Text("Rating", style: _labelStyle(secondaryText)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${proposal.budget ?? '—'}",
                          style: _valueStyle(textColor),
                        ),
                        Text(
                          "⭐ 4.6 (88 reviews)",
                          style: _valueStyle(textColor),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    if (status == null) ...[
                      _buildPendingButtons(context, mentor, proposal.id!, isThisProcessing),
                    ] else ...[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            status == "Accept" ? "Accepted" : "Rejected",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: status == "Accept" ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      if (status == "Accept") ...[
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(
                              label: mentor.phone_number ?? "—",
                              onPressed: () => _callNumber(mentor.phone_number),
                              color: const Color(0xff9088F1),
                              textColor: Colors.white,
                            ),
                            SizedBox(width: 20.w),
                            _buildActionButton(
                              label: "Message",
                              onPressed: () {
                                final myProfile = ref.read(userProfileController).value;
                                if (myProfile?.data == null) return;

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => ChatingPage(
                                      name: mentor.name ?? "N/A",
                                      id: myProfile!.data!.id.toString(),
                                      otherUesrid: mentor.id.toString(),
                                    ),
                                  ),
                                );
                              },
                              color: const Color(0xff9088F1),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPendingButtons(
      BuildContext context,
      Mentor mentor,
      int proposalId,
      bool isThisProcessing,
      ) {
    final bool isAcceptLoading = isThisProcessing && _processingType == "accept";
    final bool isRejectLoading = isThisProcessing && _processingType == "reject";

    // Optional: disable both buttons while any action is processing on this mentor
    final bool disableButtons = isThisProcessing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          label: "Accept Request",
          isLoading: isAcceptLoading,
          color: const Color(0xff9088F1),
          textColor: Colors.white,
          onPressed: disableButtons ? null : () => _handleAccept(mentor, proposalId),
        ),
        SizedBox(width: 20.w),
        _buildActionButton(
          label: "Reject Request",
          isLoading: isRejectLoading,
          color: Colors.white,
          borderColor: Colors.red,
          textColor: Colors.red,
          onPressed: disableButtons ? null : () => _handleReject(mentor, proposalId),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    bool isLoading = false,
    required Color color,
    Color? borderColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 1,
          minimumSize: Size(double.infinity, 46.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 24.w,
          height: 24.h,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : Text(
          label,
          style: GoogleFonts.roboto(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _handleAccept(Mentor mentor, int proposalId) async {
    setState(() {
      _processingMentorId = mentor.id;
      _processingType = "accept";
    });

    try {
      final body = MentorrequestApplyBody(
        mentorId: mentor.id,
        title: "Accept Request",
        body: "Accept Request Notification",
        student_lists_id: proposalId,
        mentorStatus: "Accept",
      );

      final service = APIStateNetwork(createDio());
      final res = await service.mentorSend(body);

      if (res.response.data['success'] == true) {
        Fluttertoast.showToast(msg: "Accepted!", backgroundColor: Colors.green);
        ref.invalidate(myListController);
        ref.invalidate(myListingController);
      } else {
        Fluttertoast.showToast(msg: res.response.data['message'] ?? "Failed");
      }
    } catch (e) {
      log("Accept failed: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      if (mounted) {
        setState(() {
          _processingMentorId = null;
          _processingType = null;
        });
      }
    }
  }

  Future<void> _handleReject(Mentor mentor, int proposalId) async {
    setState(() {
      _processingMentorId = mentor.id;
      _processingType = "reject";
    });

    try {
      final body = MentorrequestApplyBody(
        mentorId: mentor.id,
        title: "Reject Request",
        body: "Reject Request Notification",
        student_lists_id: proposalId,
        mentorStatus: "Reject",
      );

      final service = APIStateNetwork(createDio());
      final res = await service.mentorSend(body);

      if (res.response.data['success'] == true) {
        Fluttertoast.showToast(msg: "Rejected", backgroundColor: Colors.orange);
        ref.invalidate(myListController);
      } else {
        Fluttertoast.showToast(msg: res.response.data['message'] ?? "Failed");
      }
    } catch (e) {
      log("Reject failed: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      if (mounted) {
        setState(() {
          _processingMentorId = null;
          _processingType = null;
        });
      }
    }
  }

  Future<void> _callNumber(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open dialer")),
      );
    }
  }

  TextStyle _labelStyle(Color color) => GoogleFonts.roboto(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );

  TextStyle _valueStyle(Color color) => GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: color,
  );
}