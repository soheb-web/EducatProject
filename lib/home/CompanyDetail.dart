/*
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/ShowReviewCompanyDetailsPage.dart';
import 'package:educationapp/home/StudentDetail.dart';
import 'package:educationapp/home/webView.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetCompanyModel.dart';
import 'AllReviewPage.dart';
import 'CompanyUsersPage.dart';
import 'MentorDetail.dart';

enum CompanyTab { home, about, alumni }

class CompanyDetailPage extends ConsumerStatefulWidget {
  final int id;

  const CompanyDetailPage(this.id, {super.key});

  @override
  ConsumerState<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends ConsumerState<CompanyDetailPage> {
  CompanyTab _currentTab = CompanyTab.home;
  static const Color accentColor = Color(0xff9088F1);
  static const String staticBanner =
      "https://images.unsplash.com/photo-1486406146926-c627a92c91f9?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80";
  static const String fallbackLogo =
      "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg";

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
    final reviewAsync = ref.watch(reviewCompanyProvider(widget.id));
    final theme = ref.watch(themeProvider);
    final isDark = theme == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.white : const Color(0xFF121212),
      body: reviewAsync.when(
        data: (data) {
          final company = data.collage;

          if (company == null) {
            return const Center(child: Text("Company data not found"));
          }

          final logo = company.image ?? fallbackLogo;

          return

              Stack(
                children:[
                  Column(
                            children: [
                Container(
                  height: 260.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(logo),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.45),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : const Color(0xFF121212),
                      // borderRadius:
                      //     BorderRadius.vertical(top: Radius.circular(32.r)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 60.h),

                          // Name + Verified
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    company.name ?? "Company Name",
                                    style: GoogleFonts.roboto(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isDark ? Colors.black87 : Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(Icons.verified,
                                    color: accentColor, size: 24.sp),
                              ],
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              "${company.type ?? 'Company'} • ${company.city ?? ''} • ${company.totalReviews ?? 0} reviews",
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text("Follow"),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.r)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
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
                                      foregroundColor: accentColor,
                                      side: const BorderSide(
                                          color: accentColor, width: 1.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.r)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                IconButton(
                                  icon: Icon(Icons.more_horiz,
                                      color: Colors.grey[700], size: 28.sp),
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
                                        return _buildMoreOptionsSheet(company);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Tabs
                          SizedBox(
                            height: 52.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              children: [
                                _buildTab("Home", _currentTab == CompanyTab.home,
                                    isDark, () {
                                  setState(() => _currentTab = CompanyTab.home);
                                }),
                                _buildTab("About",
                                    _currentTab == CompanyTab.about, isDark, () {
                                  setState(() => _currentTab = CompanyTab.about);
                                }),
                                _buildTab("Alumni",
                                    _currentTab == CompanyTab.alumni, isDark, () {
                                  setState(() => _currentTab = CompanyTab.alumni);
                                }),
                              ],
                            ),
                          ),

                          const Divider(height: 1, thickness: 0.8),

                          // Content
                          _buildTabContent(company, data, isDark),

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
                            "Company Review",
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
                          logo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: accentColor,
                            child: const Icon(Icons.business,
                                color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),

             ] );


        },
        error: (Object error, StackTrace stackTrace) {},
        loading: () {},
      ),
    );
  }
*/

import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/ShowReviewCompanyDetailsPage.dart';
import 'package:educationapp/home/StudentDetail.dart';
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
import '../coreFolder/Model/ReviewGetCompanyModel.dart';
import '../coreFolder/Model/switchBodyMentor.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';
import 'AllReviewPage.dart';
import 'CompanyUsersPage.dart';
import 'MentorDetail.dart';
import 'followCompanyList.dart';

enum CompanyTab { home, about, alumni }

class CompanyDetailPage extends ConsumerStatefulWidget {
  final int id;

  const CompanyDetailPage(this.id, {super.key});

  @override
  ConsumerState<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends ConsumerState<CompanyDetailPage> {
  CompanyTab _currentTab = CompanyTab.home;
  static const Color accentColor = Color(0xff9088F1);
  static const String staticBanner =
      "https://images.unsplash.com/photo-1486406146926-c627a92c91f9?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80";
  static const String fallbackLogo =
      "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg";

  bool isLoadingFollow = false;
  bool isFollowing = false;
  bool isAnimating = false;

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
    final reviewAsync = ref.watch(reviewCompanyProvider(widget.id));
    final theme = ref.watch(themeProvider);
    final isDark = theme == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: reviewAsync.when(
        data: (data) {
          final company = data.collage;

          if (company == null) {
            return const Center(child: Text("Company data not found"));
          }

          // Follow status sync from backend
          isFollowing =
              company.isFollowed == "follow" || company.isFollowed == true;

          final logo = company.image ?? fallbackLogo;

          final String industry = company.type ?? "Company";
          final String followersText =
              "${formatCount(company.totalFollowers)} followers";

          // final String alumniText =  "214K alumni";
          final String alumniText =
              "${formatCount(company.users!.length ?? 0)} alumni";

          return Stack(
            children: [
              // Banner Background
              Container(
                height: 260.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(logo),
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
                            SizedBox(height: 60.h),

                            // Name + Verified
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      company.name ?? "Company Name",
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
                                      color: accentColor, size: 24.sp),
                                ],
                              ),
                            ),

                            SizedBox(height: 6.h),

                            // Dynamic Info Line
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "$industry • ",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.blueGrey[400]
                                          : Colors.blueGrey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final companyName = company.name ?? "";
                                      /*  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context)

                                          {
                                            FollowCompanyPage()
                                          }

                                          ),
                                        );*/

                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) => FollowCompanyPage(
                                            widget.id,
                                            companyName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Text(
                                        "$followersText • ",
                                        style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.blueGrey[400]
                                              : Colors.blueGrey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final companyName = company.name ?? "";
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComapnyUsersPage(
                                                    widget.id, companyName),
                                          ));
                                    },
                                    child: Text(
                                      "$alumniText",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? Colors.blueGrey[400]
                                            : Colors.blueGrey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Follow / Message Buttons
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
                                  //                   FollowUnfollowCompanyModel(
                                  //                       company_id: company
                                  //                           .id!); // Assuming model accepts college_id
                                  //               final service = APIStateNetwork(
                                  //                   createDio());
                                  //               final response = await service
                                  //                   .followUnfollowCompany(
                                  //                       body);
                                  //               if (response.status == true) {
                                  //                 Fluttertoast.showToast(
                                  //                   msg: response.action ??
                                  //                       "Followed successfully",
                                  //                   backgroundColor:
                                  //                       Colors.green,
                                  //                   textColor: Colors.white,
                                  //                 );
                                  //                 ref.invalidate(
                                  //                     reviewCompanyProvider(
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
                                  //                       reviewCompanyProvider(
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
                                  //           : accentColor,
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
                                              setState(() {
                                                isLoadingFollow = true;
                                                isAnimating = true;
                                              });

                                              try {
                                                final body =
                                                    FollowUnfollowCompanyModel(
                                                        company_id:
                                                            company.id!);
                                                final service = APIStateNetwork(
                                                    createDio());
                                                final response = await service
                                                    .followUnfollowCompany(
                                                        body);

                                                if (response.status == true) {
                                                  // Fluttertoast.showToast(
                                                  //   msg: response.action ??
                                                  //       "Followed successfully",
                                                  //   backgroundColor:
                                                  //       Colors.green,
                                                  //   textColor: Colors.white,
                                                  // );
                                                  ref.invalidate(
                                                      reviewCompanyProvider(
                                                          widget.id));
                                                  setState(
                                                      () => isFollowing = true);
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg: response.action ??
                                                        "Failed to follow",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor: Colors.red,
                                                  );

                                                  if (response.action
                                                          ?.toLowerCase()
                                                          .contains(
                                                              "already") ??
                                                      false) {
                                                    ref.invalidate(
                                                        reviewCompanyProvider(
                                                            widget.id));
                                                    setState(() =>
                                                        isFollowing = true);
                                                  }
                                                }
                                              } catch (e, stack) {
                                                log("Follow Error: $e\n$stack");
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
                                                  : accentColor,
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
                                        foregroundColor: accentColor,
                                        side: const BorderSide(
                                            color: accentColor, width: 1.5),
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
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: isDark
                                            ? Color(0xffF1F2F6)
                                            : Color(0xff9088F1),
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24)),
                                        ),
                                        builder: (BuildContext sheetContext) {
                                          return _buildMoreOptionsSheet(
                                              company);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Tabs
                            SizedBox(
                              height: 52.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                children: [
                                  _buildTab(
                                      "Home",
                                      _currentTab == CompanyTab.home,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CompanyTab.home);
                                  }),
                                  _buildTab(
                                      "About",
                                      _currentTab == CompanyTab.about,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CompanyTab.about);
                                  }),
                                  _buildTab(
                                      "Alumni",
                                      _currentTab == CompanyTab.alumni,
                                      isDark, () {
                                    setState(
                                        () => _currentTab = CompanyTab.alumni);
                                  }),
                                ],
                              ),
                            ),

                            const Divider(height: 1, thickness: 0.8),

                            // Tab Content
                            _buildTabContent(company, data, isDark),
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
                        "Company Review",
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

              // Overlapping Logo/Profile Pic
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
                      logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: accentColor,
                        child: const Icon(Icons.business,
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
          log("Company Detail Error: $error\n$stack");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error loading company: $error"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(reviewCompanyProvider(widget.id)),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// बाकी सारे helper functions (_buildTab, _buildTabContent, _defaultAvatar, _buildDetailRow, _buildMoreOptionsSheet, _shareToWhatsApp, _buildSheetItem)
// वही रहेंगे जो तुम्हारे पास थे — कोई बदलाव नहीं किया उनमें

  Widget _buildTab(String text, bool active, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: active
                    ? accentColor
                    : (isDark ? Colors.black54 : Colors.white70),
              ),
            ),
            if (active)
              Container(
                margin: EdgeInsets.only(top: 6.h),
                height: 3.h,
                width: 36.w,
                color: accentColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
      Collage company, ReviewGetCompanyModel snap, bool isDark) {
    switch (_currentTab) {
      case CompanyTab.home:
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    company.description ?? "No description available.",
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

            // Reviews Section
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
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) =>
                              AllReviewPage(flag: false, id: company.id ?? 0),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "View All",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16.sp, color: accentColor),
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
              itemBuilder: (context, i) {
                final review = snap.reviews![i];
                final rating = (review.rating ?? 0).clamp(0, 5);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ShowReviewCompanyDetailsPage(
                          review: review,
                          isViewOnly: true,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: isDark ? 2 : 1,
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                    color: isDark ? const Color(0xffF1F2F6) : accentColor,
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
                                      ? accentColor
                                      : const Color(0xffDEDDEC),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18.sp,
                                  );
                                }),
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
                                  ? const Color(0xFF201F1F)
                                  : const Color(0xffDEDDEC),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            review.description ?? "",
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: isDark
                                  ? const Color(0xFF666666)
                                  : const Color(0xffDEDDEC),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: isDark
                                  ? const Color(0xFF201F1F)
                                  : const Color(0xffDEDDEC),
                            ),
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

/*      case CompanyTab.alumni:
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
                            return Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Expanded(
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            user.userType == "Mentor"
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MentorDetailPage(
                                                                id: user.id!)))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudenetDetailPage(
                                                                id: user.id!)));
                                          },
                                          child: Container(
                                            width: 64.w,
                                            height: 64.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 2.w,
                                              ),
                                            ),
                                            child: ClipOval(
                                              clipBehavior: Clip.hardEdge,
                                              child: user.profilePic != null &&
                                                      user.profilePic!
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      user.profilePic!,
                                                      width: 64.w,
                                                      height: 64.h,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
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
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          _defaultAvatar(),
                                                    )
                                                  : _defaultAvatar(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        SizedBox(
                                          width: 80.w, // prevent text overflow
                                          child: Text(
                                            user.fullName ?? "Unknown",
                                            // ← add fallback if name is null
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
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComapnyUsersPage(
                                      widget.id, snap.collage!.name ?? "")));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: isDark ? Colors.black87 : Colors.white,
                        )),
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
            SizedBox(height: 200.h),
          ],
        );*/

      case CompanyTab.alumni:
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
                                          color: accentColor.withOpacity(0.5),
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
                            builder: (context) => ComapnyUsersPage(
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

      case CompanyTab.about:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    company.description ?? "No description available.",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: isDark ? Colors.black87 : Colors.white70,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    "Details",
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildDetailRow("Website", company.website, null, isDark),
                  _buildDetailRow("Location", company.city, null, isDark),
                  if (company.phone != null)
                    _buildDetailRow("Phone", company.phone, null, isDark),
                  if (company.email != null)
                    _buildDetailRow("Email", company.email, null, isDark),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      child: Icon(
        Icons.person,
        size: 32.sp,
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String? value, String? fallback, bool isDark) {
    final text = value ?? "Not available";
    // final isLink = label == "Website" && text.contains("http");

    final isLink =
        label == "Website" && text.contains("http") || text.contains("https");
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
                  color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isLink
                  ? () {
                      var url = text.trim();
                      // if (!url.startsWith('http')) url = 'https://$url';
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => WebViewPage(url: url)));
                    }
                  : null,
              child: Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  color: isLink
                      ? accentColor
                      : (isDark ? Colors.black87 : Colors.white70),
                  decoration: isLink ? TextDecoration.underline : null,
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
                // if (!url.startsWith('http')) url = 'https://$url';
                print(url);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => WebViewPage(url: college.website ?? "")),
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

    // Change this to your real app link / deep link / web page
    // Example: Play Store link or your website
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
