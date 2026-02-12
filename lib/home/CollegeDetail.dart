/*
import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/switchBodyMentor.dart';
import 'package:educationapp/home/showReviewDetails.page.dart';
import 'package:educationapp/home/webView.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import 'AllReviewPage.dart';
import 'ColloegeUserPage.dart';
import 'MentorDetail.dart';
import 'StudentDetail.dart';

enum CollegeTab { home, about,  alumni }

class CollegeDetailPage extends ConsumerStatefulWidget {
  final int id;

  const CollegeDetailPage(this.id, {super.key});

  @override
  ConsumerState<CollegeDetailPage> createState() => _CollegeDetailPageState();
}

class _CollegeDetailPageState extends ConsumerState<CollegeDetailPage> {
  CollegeTab _currentTab = CollegeTab.home;
  static const Color linkedinBlue = Color(0xff9088F1);
  static const staticBannerUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Andhra_University_Entrance_Gate.jpg/1280px-Andhra_University_Entrance_Gate.jpg";
  static const staticLogoUrl =
      "https://www.andhrauniversity.edu.in/img/au-logo.png";
  static const staticCentenaryText = "Celebrating 100 years of Excellence...";
  static const staticFollowers = "254K followers";
  static const staticAlumniCount = "214K alumni";
  static const staticIndustry = "Higher Education";
  static const staticHeadquarters = "Andhra Pradesh, IN";
  bool isLoadingFollow = false;
  bool isFollowing = false; // optional - अगर backend से follow status आता है तो use करो
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  String formatCount(int? count) {
    if (count == null || count == 0) return "0";
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewCollegeProvider(widget.id));
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.white : const Color(0xFF121212),
      body: reviewAsync.when(
        data: (snap) {
          final college = snap.collage;

          if (college == null) {
            return const Center(
              child: Text(
                "No college information available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

// Follow status sync from backend
          isFollowing = college.isFollowed == "follow" || college.isFollowed == true;

          final bannerUrl = college.image ?? staticBannerUrl;
          final logoUrl = college.image ?? staticLogoUrl;

          final String industry = college.type ?? "Higher Education";
          final String followersText = "${formatCount(college.totalFollowers)} followers";
          // Alumni field backend में नहीं है → static fallback या N/A
          final String alumniText =college.totalUsers.toString()??"";


            Stack(

              children:[

                Column(
                children: [

                  Container(
                    height: 260.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(logoUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.45),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 260.h,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: NetworkImage(logoUrl),
                  //       fit: BoxFit.cover,
                  //       colorFilter: ColorFilter.mode(
                  //         Colors.black.withOpacity(0.4),
                  //         BlendMode.darken,
                  //       ),
                  //     ),
                  //   ),
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: Padding(
                  //       padding: EdgeInsets.only(right: 20.w, bottom: 20.h),
                  //       child: Text(
                  //         centenaryText,
                  //         style: GoogleFonts.roboto(
                  //           fontSize: 17.sp,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.white,
                  //           shadows: const [
                  //             Shadow(blurRadius: 6, color: Colors.black54)
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                 Expanded(
                   child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : const Color(0xFF121212),
                          // borderRadius:
                          // BorderRadius.vertical(top: Radius.circular(32.r)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 60.h),

                              // College name + verified
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        college.name ?? "College Name",
                                        style: GoogleFonts.roboto(
                                          fontSize: 26.sp,
                                          fontWeight: FontWeight.w700,
                                          color:
                                          isDark ? Colors.black87 : Colors.white,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.verified,
                                        color: linkedinBlue, size: 24.sp),
                                  ],
                                ),
                              ),

                              SizedBox(height: 6.h),

                            */
/*  Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Text(
                                  "Higher Education • $staticFollowers • $staticAlumniCount",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp, color: Colors.grey[600]),
                                ),
                              ),*/ /*



                              // Dynamic Info Line
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Text(
                                  "$industry • $followersText • $alumniText",
                                  style: GoogleFonts.roboto(
                                    fontSize: 15.sp,
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ),



                              SizedBox(height: 24.h),

                              // Follow / Message buttons
          //                     Padding(
          //                       padding: EdgeInsets.symmetric(horizontal: 24.w),
          //                       child: Row(
          //                         children: [
          // //                           Expanded(
          // //                             child: ElevatedButton.icon(
          // //                               icon: const Icon(Icons.add, size: 18),
          // //                               label: const Text("Follow"),
          // //                               onPressed: () {
          // //
          // //
          // // try {
          // //
          // // final body = FollowUnfollowModel(college_id: college.id!);
          // // final service = APIStateNetwork(createDio());
          // // final response = await service.followUnfollow(body);
          // //
          // // if (response.success == true) {
          // // Fluttertoast.showToast(msg: response.message ?? "Switched to Mentor successfully");
          // // ref.invalidate(reviewCollegeProvider(widget.id));
          // // } else {
          // // Fluttertoast.showToast(
          // // msg: response.message ?? "Failed to switch",
          // // toastLength: Toast.LENGTH_LONG,
          // // );
          // //
          // // if (response.message?.toLowerCase().contains("already mentor") ?? false) {
          // // ref.invalidate(reviewCollegeProvider(widget.id));
          // // }
          // // }
          // // } catch (e) {
          // // Fluttertoast.showToast(msg: "Error: ${e.toString()}");
          // // }
          // // } else {
          // //
          // //
          // //                               },
          // //                               style: ElevatedButton.styleFrom(
          // //                                 backgroundColor: linkedinBlue,
          // //                                 foregroundColor: Colors.white,
          // //                                 shape: RoundedRectangleBorder(
          // //                                     borderRadius:
          // //                                     BorderRadius.circular(30.r)),
          // //                                 padding:
          // //                                 EdgeInsets.symmetric(vertical: 12.h),
          // //                               ),
          // //                             ),
          // //                           ),
          //
          //                           Expanded(
          //                             child: ElevatedButton.icon(
          //                               icon: const Icon(Icons.add, size: 18),
          //                               label: Text(isFollowing ? "Following" : "Follow"), // dynamic text (optional improvement)
          //                               onPressed: isLoadingFollow // loading state check (define isLoadingFollow bool in state)
          //                                   ? null
          //                                   : () async {
          //                                 setState(() {
          //                                   isLoadingFollow = true;
          //                                 });
          //
          //                                 try {
          //                                   final body = FollowUnfollowModel(college_id: college.id!);
          //                                   final service = APIStateNetwork(createDio());
          //                                   final response = await service.followUnfollow(body);
          //
          //                                   if (response.status == true) {
          //                                     Fluttertoast.showToast(
          //                                       msg: response.action ?? "Followed successfully",
          //                                       backgroundColor: Colors.green,
          //                                       textColor: Colors.white,
          //                                     );
          //
          //                                     // Refresh the college review/provider
          //                                     ref.invalidate(reviewCollegeProvider(widget.id));
          //
          //                                   } else {
          //                                     Fluttertoast.showToast(
          //                                       msg: response.action ?? "Failed to follow",
          //                                       toastLength: Toast.LENGTH_LONG,
          //                                       backgroundColor: Colors.red,
          //                                       textColor: Colors.white,
          //                                     );
          //
          //                                     // अगर "already following" जैसा message हो तो भी refresh
          //                                     if (response.action?.toLowerCase().contains("already") ?? false) {
          //                                       ref.invalidate(reviewCollegeProvider(widget.id));
          //                                     }
          //                                   }
          //                                 } catch (e, stack) {
          //                                   log("Follow Error: $e\nStack: $stack");
          //                                   Fluttertoast.showToast(
          //                                     msg: "Something went wrong. Please try again.",
          //                                     backgroundColor: Colors.red,
          //                                   );
          //                                 } finally {
          //                                   if (mounted) {
          //                                     setState(() {
          //                                       isLoadingFollow = false;
          //                                     });
          //                                   }
          //                                 }
          //                               },
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: isFollowing ? Colors.grey[700] : linkedinBlue,
          //                                 foregroundColor: Colors.white,
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius: BorderRadius.circular(30.r),
          //                                 ),
          //                                 padding: EdgeInsets.symmetric(vertical: 12.h),
          //                                 elevation: 0,
          //                                 minimumSize: Size(double.infinity, 48.h), // full width button
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(width: 12.w),
          //                           Expanded(
          //                             child: OutlinedButton.icon(
          //                               icon: const Icon(Icons.send, size: 18),
          //                               label: const Text("Message"),
          //                               onPressed: () {},
          //                               style: OutlinedButton.styleFrom(
          //                                 foregroundColor: linkedinBlue,
          //                                 side: const BorderSide(
          //                                     color: linkedinBlue, width: 1.5),
          //                                 shape: RoundedRectangleBorder(
          //                                     borderRadius:
          //                                     BorderRadius.circular(30.r)),
          //                                 padding:
          //                                 EdgeInsets.symmetric(vertical: 12.h),
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(width: 8.w),
          //                           IconButton(
          //                             icon: Icon(Icons.more_horiz,
          //                                 color: Colors.grey[700], size: 28.sp),
          //                             // onPressed: () {},
          //                             onPressed: () {
          //                               showModalBottomSheet(
          //                                 context: context,
          //                                 backgroundColor: isDark
          //                                     ? Color(0xffF1F2F6)
          //                                     : Color(0xff9088F1),
          //                                 // important for custom rounded container
          //                                 isScrollControlled: true,
          //                                 // allows better height control
          //                                 shape: const RoundedRectangleBorder(
          //                                   borderRadius: BorderRadius.vertical(
          //                                       top: Radius.circular(24)),
          //                                 ),
          //                                 builder: (BuildContext sheetContext) {
          //                                   return _buildMoreOptionsSheet(college);
          //                                 },
          //                               );
          //                             },
          //                           ),
          //                         ],
          //                       ),
          //                     ),


                              // Follow / Message buttons
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.add, size: 18),
                                        label: Text(isFollowing ? "Following" : "Follow"),
                                        onPressed: isLoadingFollow
                                            ? null
                                            : () async {
                                          setState(() => isLoadingFollow = true);

                                          try {
                                            final body = FollowUnfollowModel(college_id: college.id!);
                                            final service = APIStateNetwork(createDio());
                                            final response = await service.followUnfollow(body);

                                            if (response.status == true) {
                                              Fluttertoast.showToast(
                                                msg: response.action ?? "Followed successfully",
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                              );
                                              ref.invalidate(reviewCollegeProvider(widget.id));
                                              setState(() => isFollowing = true);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: response.action ?? "Failed to follow",
                                                toastLength: Toast.LENGTH_LONG,
                                                backgroundColor: Colors.red,
                                              );

                                              if (response.action?.toLowerCase().contains("already") ?? false) {
                                                ref.invalidate(reviewCollegeProvider(widget.id));
                                                setState(() => isFollowing = true);
                                              }
                                            }
                                          } catch (e, stack) {
                                            log("Follow Error: $e\n$stack");
                                            Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                              backgroundColor: Colors.red,
                                            );
                                          } finally {
                                            if (mounted) setState(() => isLoadingFollow = false);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isFollowing ? Colors.grey[700] : linkedinBlue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                          padding: EdgeInsets.symmetric(vertical: 12.h),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        icon: const Icon(Icons.send, size: 18),
                                        label: const Text("Message"),
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: linkedinBlue,
                                          side: const BorderSide(color: linkedinBlue, width: 1.5),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                          padding: EdgeInsets.symmetric(vertical: 12.h),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // TABS
                              SizedBox(
                                height: 52.h,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  children: [
                                    _buildTab("Home", _currentTab == CollegeTab.home,
                                        isDark, () {
                                          setState(() =>
                                          _currentTab = CollegeTab.home);
                                        }),
                                    _buildTab("About",
                                        _currentTab == CollegeTab.about, isDark, () {
                                          setState(() =>
                                          _currentTab = CollegeTab.about);
                                        }),
                                    _buildTab("Alumni",
                                        _currentTab == CollegeTab.alumni, isDark, () {
                                          setState(() =>
                                          _currentTab = CollegeTab.alumni);
                                        }),
                                  ],
                                ),
                              ),

                              const Divider(height: 1, thickness: 0.8),

                              _buildTabContent(college, snap, isDark),


                            ],
                          ),
                        ),
                      ),
                 ),


                ],
              ),

                SafeArea(
                child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Row(
                children: [
                GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.white.withOpacity(0.92),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black87, size: 22.sp),
                ),
                ),
                SizedBox(width: 16.w),
                Text(
                "College Review",
                style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                ),
                ),
                ],
                ),
                ),
                ),


                Positioned(
                top: 200.h,
                left: 24.w,
                child: Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
                boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 6)),
                ],
                ),
                child: ClipOval(
                child: Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                color: linkedinBlue,
                child: const Icon(Icons.school,
                color: Colors.white, size: 50),
                ),
                ),
                ),
                ),
                )

           ] );


        }, error: (Object error, StackTrace stackTrace) {  }, loading: () {  }));
  }
*/

import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/switchBodyMentor.dart';
import 'package:educationapp/home/followCollagePage.dart';
import 'package:educationapp/home/showReviewDetails.page.dart';
import 'package:educationapp/home/webView.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import 'AllReviewPage.dart';
import 'ColloegeUserPage.dart';
import 'MentorDetail.dart';
import 'StudentDetail.dart';

enum CollegeTab { home, about, alumni }

class CollegeDetailPage extends ConsumerStatefulWidget {
  final int id;

  const CollegeDetailPage(this.id, {super.key});

  @override
  ConsumerState<CollegeDetailPage> createState() => _CollegeDetailPageState();
}

class _CollegeDetailPageState extends ConsumerState<CollegeDetailPage> {
  CollegeTab _currentTab = CollegeTab.home;
  static const Color linkedinBlue = Color(0xff9088F1);
  static const String staticBannerUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Andhra_University_Entrance_Gate.jpg/1280px-Andhra_University_Entrance_Gate.jpg";
  static const String staticLogoUrl =
      "https://www.andhrauniversity.edu.in/img/au-logo.png";
  static const String staticCentenaryText =
      "Celebrating 100 years of Excellence...";

  bool isLoadingFollow = false;
  bool isAnimating = false;
  bool isFollowing = false;

  static const staticIndustry = "Higher Education";
  static const staticHeadquarters = "Andhra Pradesh, IN";
  String formatCount(int? count) {
    if (count == null || count == 0) return "0";
    if (count >= 1000000) return "${(count / 1000000).toStringAsFixed(1)}M";
    if (count >= 1000) return "${(count / 1000).toStringAsFixed(1)}K";
    return count.toString();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewCollegeProvider(widget.id));
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: reviewAsync.when(
        data: (snap) {
          final college = snap.collage;

          if (college == null) {
            return const Center(
              child: Text(
                "No college information available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Follow status sync from backend
          isFollowing =
              college.isFollowed == "follow" || college.isFollowed == true;

          final bannerUrl = college.image ?? staticBannerUrl;
          final logoUrl = college.image ?? staticLogoUrl;

          final String industry = college.type ?? "Higher Education";
          final String followersText =
              "${formatCount(college.totalFollowers)} followers";
          // Alumni field backend में नहीं है → static fallback या N/A
          // final String alumniText = "214K alumni";
          final String alumniText =
              "${formatCount(college.users!.length ?? 0)} alumni";

          return Stack(
            children: [
              // Banner Background
              Container(
                height: 260.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bannerUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.45),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),

              // Main Content
              Column(
                children: [
                  SizedBox(height: 260.h),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : const Color(0xFF121212),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80.h), // space for profile pic

                            // College name + verified
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      college.name ?? "College Name",
                                      style: GoogleFonts.roboto(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.black87
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.verified,
                                      color: linkedinBlue, size: 24.sp),
                                ],
                              ),
                            ),

                            SizedBox(height: 6.h),

                            // Dynamic Info Line
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                children: [
                                  Text(
                                    "$industry  •",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.blueGrey
                                          : Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final CollageName = college.name ?? "";
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FollowCollagePage(
                                                    widget.id, CollageName),
                                          ));
                                    },
                                    child: Text(
                                      "$followersText • ",
                                      style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          // color: isDark
                                          //     ? Colors.grey[400]
                                          //     : Colors.grey[600],
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final CollageName = college.name ?? "";
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Colloegeuserpage(
                                            widget.id,
                                            CollageName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "$alumniText",
                                      style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.blueGrey
                                              : Colors.blueGrey),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Follow / Message buttons
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                children: [
                                  // Expanded(
                                  //   child: ElevatedButton.icon(
                                  //     icon: const Icon(Icons.add, size: 18),
                                  //     label: Text(
                                  //         isFollowing ? "Following" : "Follow"),
                                  //     onPressed: isLoadingFollow
                                  //         ? null
                                  //         : () async {
                                  //             setState(
                                  //                 () => isLoadingFollow = true);

                                  //             try {
                                  //               final body =
                                  //                   FollowUnfollowModel(
                                  //                       college_id:
                                  //                           college.id!);
                                  //               final service = APIStateNetwork(
                                  //                   createDio());
                                  //               final response = await service
                                  //                   .followUnfollow(body);

                                  //               if (response.status == true) {
                                  //                 Fluttertoast.showToast(
                                  //                   msg: response.action ??
                                  //                       "Followed successfully",
                                  //                   backgroundColor:
                                  //                       Colors.green,
                                  //                   textColor: Colors.white,
                                  //                 );
                                  //                 ref.invalidate(
                                  //                     reviewCollegeProvider(
                                  //                         widget.id));
                                  //                 setState(
                                  //                     () => isFollowing = true);
                                  //               } else {
                                  //                 Fluttertoast.showToast(
                                  //                   msg: response.action ??
                                  //                       "Failed to follow",
                                  //                   toastLength:
                                  //                       Toast.LENGTH_LONG,
                                  //                   backgroundColor: Colors.red,
                                  //                 );

                                  //                 if (response.action
                                  //                         ?.toLowerCase()
                                  //                         .contains(
                                  //                             "already") ??
                                  //                     false) {
                                  //                   ref.invalidate(
                                  //                       reviewCollegeProvider(
                                  //                           widget.id));
                                  //                   setState(() =>
                                  //                       isFollowing = true);
                                  //                 }
                                  //               }
                                  //             } catch (e, stack) {
                                  //               log("Follow Error: $e\n$stack");
                                  //               Fluttertoast.showToast(
                                  //                 msg: "Something went wrong",
                                  //                 backgroundColor: Colors.red,
                                  //               );
                                  //             } finally {
                                  //               if (mounted)
                                  //                 setState(() =>
                                  //                     isLoadingFollow = false);
                                  //             }
                                  //           },
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: isFollowing
                                  //           ? Colors.grey[700]
                                  //           : linkedinBlue,
                                  //       foregroundColor: Colors.white,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(30.r)),
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 12.h),
                                  //       elevation: 0,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   child: ElevatedButton.icon(
                                  //     // Loading ke waqt hum icon ko checkmark ya add hi rehne denge
                                  //     icon: Icon(
                                  //       isFollowing ? Icons.check : Icons.add,
                                  //       size: 18,
                                  //       color: isLoadingFollow
                                  //           ? Colors.white70
                                  //           : Colors.white,
                                  //     ),
                                  //     label: Text(
                                  //       // Loading ke waqt text change nahi hoga, bas thoda fade dikhega
                                  //       isFollowing ? "Following" : "Follow",
                                  //       style: TextStyle(
                                  //         color: isLoadingFollow
                                  //             ? Colors.white70
                                  //             : Colors.white,
                                  //       ),
                                  //     ),
                                  //     onPressed: isLoadingFollow
                                  //         ? null
                                  //         : () async {
                                  //             // 1. Pehle hi state change kar do (Optimistic Update)
                                  //             final previousState = isFollowing;
                                  //             setState(() {
                                  //               isLoadingFollow = true;
                                  //               isFollowing =
                                  //                   !isFollowing; // Turant change dikhega
                                  //             });

                                  //             try {
                                  //               final body =
                                  //                   FollowUnfollowModel(
                                  //                       college_id:
                                  //                           college.id!);
                                  //               final service = APIStateNetwork(
                                  //                   createDio());
                                  //               final response = await service
                                  //                   .followUnfollow(body);

                                  //               if (response.status == true) {
                                  //                 Fluttertoast.showToast(
                                  //                   msg: response.action ??
                                  //                       "Success",
                                  //                   backgroundColor:
                                  //                       Colors.green,
                                  //                 );
                                  //                 // Background mein data refresh hone do
                                  //                 ref.invalidate(
                                  //                     reviewCollegeProvider(
                                  //                         widget.id));
                                  //               } else {
                                  //                 // Agar API mana kar de, toh wapas purane state pe jao
                                  //                 setState(() => isFollowing =
                                  //                     previousState);
                                  //                 Fluttertoast.showToast(
                                  //                   msg: response.action ??
                                  //                       "Failed",
                                  //                   backgroundColor: Colors.red,
                                  //                 );
                                  //               }
                                  //             } catch (e) {
                                  //               // Error ki surat mein bhi wapas purane state pe jao
                                  //               setState(() => isFollowing =
                                  //                   previousState);
                                  //               Fluttertoast.showToast(
                                  //                 msg: "Something went wrong",
                                  //                 backgroundColor: Colors.red,
                                  //               );
                                  //             } finally {
                                  //               if (mounted) {
                                  //                 setState(() =>
                                  //                     isLoadingFollow = false);
                                  //               }
                                  //             }
                                  //           },
                                  //     style: ElevatedButton.styleFrom(
                                  //       // Background color bhi turant change hoga
                                  //       backgroundColor: isFollowing
                                  //           ? Colors.grey[700]
                                  //           : linkedinBlue,
                                  //       disabledBackgroundColor: isFollowing
                                  //           ? Colors.grey[600]
                                  //           : linkedinBlue.withOpacity(0.8),
                                  //       foregroundColor: Colors.white,
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(30.r)),
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 12.h),
                                  //       elevation: 0,
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: isLoadingFollow
                                          ? null
                                          : () async {
                                              final previousState = isFollowing;

                                              setState(() {
                                                isLoadingFollow = true;
                                                isFollowing =
                                                    !isFollowing; // optimistic update
                                                isAnimating = true;
                                              });

                                              try {
                                                final body =
                                                    FollowUnfollowModel(
                                                        college_id:
                                                            college.id!);
                                                final service = APIStateNetwork(
                                                    createDio());
                                                final response = await service
                                                    .followUnfollow(body);

                                                if (response.status == true) {
                                                  // Fluttertoast.showToast(
                                                  //   msg: response.action ??
                                                  //       "Success",
                                                  //   backgroundColor:
                                                  //       Colors.green,
                                                  // );

                                                  ref.invalidate(
                                                      reviewCollegeProvider(
                                                          widget.id));
                                                } else {
                                                  setState(() => isFollowing =
                                                      previousState);

                                                  Fluttertoast.showToast(
                                                    msg: response.action ??
                                                        "Failed",
                                                    backgroundColor: Colors.red,
                                                  );
                                                }
                                              } catch (e) {
                                                setState(() => isFollowing =
                                                    previousState);

                                                Fluttertoast.showToast(
                                                  msg: "Something went wrong",
                                                  backgroundColor: Colors.red,
                                                );
                                              } finally {
                                                if (mounted) {
                                                  setState(() {
                                                    isLoadingFollow = false;
                                                    isAnimating = false;
                                                  });
                                                }
                                              }
                                            },
                                      child: AnimatedScale(
                                        scale: isAnimating ? 0.96 : 1,
                                        duration:
                                            const Duration(milliseconds: 120),
                                        child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          opacity: isLoadingFollow ? 0.7 : 1,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 250),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.h),
                                            decoration: BoxDecoration(
                                              color: isFollowing
                                                  ? Colors.grey[700]
                                                  : linkedinBlue,
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AnimatedRotation(
                                                  turns:
                                                      isLoadingFollow ? 0.1 : 0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  child: Icon(
                                                    isFollowing
                                                        ? Icons.check
                                                        : Icons.add,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  isFollowing
                                                      ? "Following"
                                                      : "Follow",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.send, size: 18),
                                      label: const Text("Contact"),
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: linkedinBlue,
                                        side: const BorderSide(
                                            color: linkedinBlue, width: 1.5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.r)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  IconButton(
                                    icon: Icon(Icons.more_horiz,
                                        color: Colors.grey[700], size: 28.sp),
                                    // onPressed: () {},
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: isDark
                                            ? Color(0xffF1F2F6)
                                            : Color(0xff9088F1),
                                        // important for custom rounded container
                                        isScrollControlled: true,
                                        // allows better height control
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24)),
                                        ),
                                        builder: (BuildContext sheetContext) {
                                          return _buildMoreOptionsSheet(
                                              college);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Tabs
                            SizedBox(
                              height: 52.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                children: [
                                  _buildTab(
                                      "Home",
                                      _currentTab == CollegeTab.home,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CollegeTab.home);
                                  }),
                                  _buildTab(
                                      "About",
                                      _currentTab == CollegeTab.about,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CollegeTab.about);
                                  }),
                                  _buildTab(
                                      "Alumni",
                                      _currentTab == CollegeTab.alumni,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CollegeTab.alumni);
                                  }),
                                ],
                              ),
                            ),

                            const Divider(height: 1, thickness: 0.8),

                            // Tab Content (तुम्हारा पुराना logic वही रहेगा)
                            _buildTabContent(college, snap, isDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Top Bar
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: Colors.white.withOpacity(0.92),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.black87, size: 22),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "College Review",
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Profile Picture Overlap
              Positioned(
                top: 220.h,
                left: 24.w,
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4.w),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6)),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: linkedinBlue,
                        child: const Icon(Icons.school,
                            color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log("College Detail Error: $error\n$stack");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error loading college: $error"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(reviewCollegeProvider(widget.id)),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(
    String text,
    bool active,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: active
                    ? linkedinBlue
                    : (isDark ? Colors.black54 : Colors.white70),
              ),
            ),
            if (active)
              Container(
                margin: EdgeInsets.only(top: 6.h),
                height: 3.h,
                width: 36.w,
                color: linkedinBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    Collage college,
    ReviewGetModel snap,
    bool isDark,
  ) {
    switch (_currentTab) {
      case CollegeTab.home:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Overview",
                      style: GoogleFonts.roboto(
                        color: isDark ? Colors.black87 : Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    college.description ?? "No description available.",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: isDark ? Colors.black87 : Colors.white70,
                    ),
                  ),
                  SizedBox(height: 28.h),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews & Testimonials",
                    style: GoogleFonts.roboto(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            AllReviewPage(flag: true, id: college.id ?? 0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "View All",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: linkedinBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16.sp, color: linkedinBlue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: snap.reviews?.length ?? 0,
              itemBuilder: (context, index) {
                final review = snap.reviews![index];
                final rating = (review.rating ?? 0).clamp(0, 5);

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ShowReviewDetailsPage(
                        review: review,
                        isViewOnly: true,
                      ),
                    ),
                  ),
                  child: Card(
                    elevation: isDark ? 2 : 1,
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                    color: isDark ? Color(0xffF1F2F6) : Color(0xff9088F1),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review.fullName ?? "Anonymous",
                                style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Color(0xff9088F1)
                                        : Color(0xffDEDDEC)),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            review.title ?? "",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Color(0xFF201F1F)
                                    : Color(0xffDEDDEC)),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            review.description ?? "",
                            style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: isDark
                                    ? Color(0xFF666666)
                                    : Color(0xffDEDDEC)),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: isDark
                                    ? Color(0xFF201F1F)
                                    : Color(0xffDEDDEC)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50.h),
          ],
        );

      // case CollegeTab.alumni:
      //   final users = snap.collage?.users ?? [];
      //   return Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               "Alumni Network",
      //               style: GoogleFonts.roboto(
      //                 fontSize: 20.sp,
      //                 fontWeight: FontWeight.w700,
      //                 color: isDark ? Colors.black87 : Colors.white,
      //               ),
      //             ),
      //             Text(
      //               "${users.length} ${users.length == 1 ? 'Alumnus' : 'Alumni'}",
      //               style: GoogleFonts.roboto(
      //                 fontSize: 15.sp,
      //                 color: Colors.grey[600],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       if (users.isEmpty)
      //         Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      //           child: Center(
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Icon(
      //                   Icons.people_outline_rounded,
      //                   size: 64.sp,
      //                   color: Colors.grey[400],
      //                 ),
      //                 SizedBox(height: 16.h),
      //                 Text(
      //                   "No alumni connected yet",
      //                   style: GoogleFonts.roboto(
      //                     fontSize: 17.sp,
      //                     color: Colors.grey[600],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         )
      //       else
      //         Container(
      //           margin: EdgeInsets.only(left: 10.w, right: 10.w),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: SizedBox(
      //                   height: 110.h,
      //                   // increased height for avatar + name + spacing
      //                   child: ListView.builder(
      //                     scrollDirection: Axis.horizontal,
      //                     physics: const BouncingScrollPhysics(),
      //                     padding: EdgeInsets.symmetric(horizontal: 24.w),
      //                     itemCount: users.length >= 4 ? 4 : users.length,
      //                     itemBuilder: (context, index) {
      //                       final user = users[index];
      //                       return Padding(
      //                         padding: EdgeInsets.only(right: 20.w),
      //                         // good spacing between items
      //                         child: Expanded(
      //                           child: Row(
      //                             children: [
      //                               Column(
      //                                 children: [
      //                                   GestureDetector(
      //                                     onTap: () {
      //                                       user.userType == "Mentor"
      //                                           ? Navigator.push(
      //                                               context,
      //                                               MaterialPageRoute(
      //                                                   builder: (context) =>
      //                                                       MentorDetailPage(
      //                                                           id: user.id!)))
      //                                           : Navigator.push(
      //                                               context,
      //                                               MaterialPageRoute(
      //                                                   builder: (context) =>
      //                                                       StudenetDetailPage(
      //                                                           id: user.id!)));
      //                                     },
      //                                     child: Container(
      //                                       width: 64.w,
      //                                       height: 64.h,
      //                                       decoration: BoxDecoration(
      //                                         shape: BoxShape.circle,
      //                                         border: Border.all(
      //                                           color: linkedinBlue
      //                                               .withOpacity(0.5),
      //                                           width: 2.w,
      //                                         ),
      //                                       ),
      //                                       child: ClipOval(
      //                                         clipBehavior: Clip.hardEdge,
      //                                         // ensures perfect rounding
      //                                         child: user.profilePic != null &&
      //                                                 user.profilePic!
      //                                                     .isNotEmpty
      //                                             ? Image.network(
      //                                                 user.profilePic!,
      //                                                 width: 64.w,
      //                                                 height: 64.h,
      //                                                 fit: BoxFit.cover,
      //                                                 // fills the circle properly
      //                                                 loadingBuilder: (context,
      //                                                     child,
      //                                                     loadingProgress) {
      //                                                   if (loadingProgress ==
      //                                                       null) return child;
      //                                                   return Center(
      //                                                     child: SizedBox(
      //                                                       width: 32.w,
      //                                                       height: 32.h,
      //                                                       child:
      //                                                           CircularProgressIndicator(
      //                                                         strokeWidth: 2.w,
      //                                                         value: loadingProgress
      //                                                                     .expectedTotalBytes !=
      //                                                                 null
      //                                                             ? loadingProgress
      //                                                                     .cumulativeBytesLoaded /
      //                                                                 (loadingProgress
      //                                                                         .expectedTotalBytes ??
      //                                                                     1)
      //                                                             : null,
      //                                                       ),
      //                                                     ),
      //                                                   );
      //                                                 },
      //                                                 errorBuilder: (context,
      //                                                         error,
      //                                                         stackTrace) =>
      //                                                     _defaultAvatar(),
      //                                               )
      //                                             : _defaultAvatar(),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   SizedBox(height: 8.h),
      //                                   SizedBox(
      //                                     width: 80.w, // prevent text overflow
      //                                     child: Text(
      //                                       user.fullName ?? "Unknown",
      //                                       // ← add fallback if name is null
      //                                       style: GoogleFonts.roboto(
      //                                         fontSize: 13.sp,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: isDark
      //                                             ? Colors.black87
      //                                             : Colors.white,
      //                                       ),
      //                                       textAlign: TextAlign.center,
      //                                       maxLines: 1,
      //                                       overflow: TextOverflow.ellipsis,
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ),
      //               GestureDetector(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => Colloegeuserpage(
      //                                 widget.id, snap.collage!.name ?? "")));
      //                   },
      //                   child: Icon(
      //                     Icons.arrow_forward_ios,
      //                     color: isDark ? Colors.black87 : Colors.white,
      //                   )),
      //             ],
      //           ),
      //         ),
      //       SizedBox(height: 32.h),
      //       Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 24.w),
      //         child: Text(
      //           "(Connect & message features coming soon)",
      //           style: GoogleFonts.roboto(
      //             fontSize: 13.sp,
      //             color: Colors.grey[500],
      //             fontStyle: FontStyle.italic,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //       ),
      //       SizedBox(height: 60.h),
      //     ],
      //   );

      case CollegeTab.alumni:
        final users = snap.collage?.users ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alumni Network",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                  Text(
                    "${users.length} ${users.length == 1 ? 'Alumnus' : 'Alumni'}",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            if (users.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 64.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No alumni connected yet",
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: users.length >= 4 ? 4 : users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];

                            // Safe handling of potentially null fields
                            final profilePic = user.profilePic;
                            final fullName = user.fullName ?? "Unknown";
                            final userId = user.id;

                            // Force HTTPS if needed (common release issue)
                            String displayPic = profilePic ?? '';
                            if (displayPic.startsWith('http://')) {
                              displayPic = displayPic.replaceFirst(
                                  'http://', 'https://');
                            }

                            return Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: userId != null
                                        ? () {
                                            if (user.userType == "Mentor") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MentorDetailPage(
                                                          id: userId),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudenetDetailPage(
                                                          id: userId),
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      width: 64.w,
                                      height: 64.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          // color: accentColor.withOpacity(0.5),
                                          width: 2.w,
                                        ),
                                      ),
                                      child: ClipOval(
                                        clipBehavior: Clip.hardEdge,
                                        child: (displayPic.isNotEmpty)
                                            ? Image.network(
                                                displayPic,
                                                width: 64.w,
                                                height: 64.h,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 32.w,
                                                      height: 32.h,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.w,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                        .expectedTotalBytes ??
                                                                    1)
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  // Optional: log for debugging
                                                  debugPrint(
                                                      "Image failed for ${fullName}: $error");
                                                  return _defaultAvatar();
                                                },
                                              )
                                            : _defaultAvatar(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  SizedBox(
                                    width: 80.w,
                                    child: Text(
                                      fullName,
                                      style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.black87
                                            : Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final companyName = snap.collage?.name ?? "";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Colloegeuserpage(
                              widget.id,
                              companyName,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.black87 : Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                "(Connect & message features coming soon)",
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 200.h), // keep your bottom spacing
          ],
        );

      case CollegeTab.about:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Overview",
                      style: GoogleFonts.roboto(
                        color: isDark ? Colors.black87 : Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    college.description ?? "No description available.",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: isDark ? Colors.black87 : Colors.white70,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text("Details",
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.black87 : Colors.white,
                      )),
                  SizedBox(height: 12.h),
                  _buildDetailRow("Website", college.website, null, isDark),
                  _buildDetailRow("Industry", staticIndustry, null, isDark),
                  _buildDetailRow(
                      "Headquarters", staticHeadquarters, null, isDark),
                  if (college.city != null || college.pincode != null)
                    _buildDetailRow(
                      "Location",
                      "${college.city ?? ''} ${college.pincode ?? ''}",
                      null,
                      isDark,
                    ),
                  if (college.phone != null)
                    _buildDetailRow(
                        "Phone", "+91 ${college.phone}", null, isDark),
                  if (college.email != null)
                    _buildDetailRow("Email", college.email, null, isDark),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      backgroundColor: linkedinBlue.withOpacity(0.15),
      child: Icon(
        Icons.person,
        color: linkedinBlue,
        size: 32.sp,
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String? dynamicValue,
    String? staticFallback,
    bool isDark,
  ) {
    final value = dynamicValue ?? "Not available";
    final isWebsite =
        label == "Website" && value.contains("http") || value.contains("https");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isWebsite
                  ? () {
                      var url = value.trim();
                      // if (!url.startsWith('http')) url = 'https://$url';
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => WebViewPage(url: url)),
                      );
                    }
                  : null,
              child: Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  color: isWebsite
                      ? linkedinBlue
                      : (isDark ? Colors.black87 : Colors.white70),
                  decoration: isWebsite ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsSheet(Collage college) {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xffF1F2F6) : Color(0xff9088F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 42.w,
            height: 5.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[600] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Page Options",
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Color(0xff9088F1) : Color(0xffDEDDEC),
                  ),
                ),
              ],
            ),
          ),
          // your menu items here...
          _buildSheetItem(
              icon: Icons.open_in_browser,
              title: "Visit website",
              onTap: () {
                var url = college.website!.trim();
                if (!url.startsWith('http')) url = 'https://$url';
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => WebViewPage(url: url)),
                );
              }),
          _buildSheetItem(
              icon: Icons.share_rounded,
              title: "Share this page",
              onTap: () {
                Navigator.pop(context); // close bottom sheet
                _shareToWhatsApp(college); // call the function
              }),
          // _buildSheetItem(
          //     icon: Icons.send,
          //     title: "Send Message",
          //     onTap: () {},
          //     isDestructive: true),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Future<void> _shareToWhatsApp(Collage college) async {
    final String collegeName = college.name ?? "this college";
    final int collegeId = college.id ?? widget.id;


    final String pageLink = "https://yourapp.com/college/$collegeId";
    // Alternative example: "https://play.google.com/store/apps/details?id=com.your.educationapp";

    final String message = "Check out $collegeName!\n"
        "Reviews, alumni network, details & more.\n\n"
        "$pageLink\n\n"
        "Shared from Education App";

    final String encodedMessage = Uri.encodeComponent(message);

    final Uri waUri = Uri.parse("https://wa.me/?text=$encodedMessage");

    try {
      if (await canLaunchUrl(waUri)) {
        await launchUrl(
          waUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("WhatsApp not installed or cannot open")),
          );
        }
      }
    } catch (e) {
      debugPrint("WhatsApp launch error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening WhatsApp: $e")),
        );
      }
    }
  }

  Widget _buildSheetItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    IconData? trailingIcon,
    String? subtitle,
    bool isDestructive = false,
    bool isDisabled = false,
    Color? customColor,
  }) {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;

    final baseColor = customColor ??
        (isDestructive
            ? Colors.red[700]!
            : (isDark ? Colors.white : Colors.black87));

    final disabledColor = isDark ? Colors.grey[600] : Colors.grey[400];

    final color = isDisabled ? disabledColor : baseColor;

    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? Color(0xff9088F1) : Color(0xffDEDDEC),
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Color(0xff9088F1) : Color(0xffDEDDEC),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: isDark ? Color(0xff9088F1) : Color(0xffDEDDEC),
              ),
            )
          : null,
      trailing: trailingIcon != null
          ? Icon(
              trailingIcon,
              color: color!.withOpacity(0.7),
              size: 22.sp,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      minLeadingWidth: 40.w,
      horizontalTitleGap: 16.w,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: isDisabled
          ? null
          : () {
              // Optional: close bottom sheet automatically
              if (onTap != null) {
                onTap();
                // Navigator.pop(context);   ← uncomment if you want auto-close
              }
            },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }
}
