import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/showReviewDetails.page.dart';
import 'package:educationapp/home/webView.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';
import 'AllReviewPage.dart';
import 'ColloegeUserPage.dart';
import 'MentorDetail.dart';
import 'StudentDetail.dart';

// Enum for tabs
enum CollegeTab { home, posts, jobs, alumni }

class CollegeDetailPage extends ConsumerStatefulWidget {
  final int id;
  const CollegeDetailPage(this.id, {super.key});

  @override
  ConsumerState<CollegeDetailPage> createState() => _CollegeDetailPageState();
}

class _CollegeDetailPageState extends ConsumerState<CollegeDetailPage> {
  CollegeTab _currentTab = CollegeTab.home;

  // ────────────────────────────────────────────────
  // Moved here so it's accessible in the whole class
  static const Color linkedinBlue = Color(0xff9088F1);
  // ────────────────────────────────────────────────

  static const staticBannerUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Andhra_University_Entrance_Gate.jpg/1280px-Andhra_University_Entrance_Gate.jpg";
  static const staticLogoUrl = "https://www.andhrauniversity.edu.in/img/au-logo.png";
  static const staticCentenaryText = "Celebrating 100 years of Excellence...";
  static const staticFollowers = "254K followers";
  static const staticAlumniCount = "214K alumni";
  static const staticIndustry = "Higher Education";
  static const staticHeadquarters = "Andhra Pradesh, IN";

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
      backgroundColor: isDark ?   Colors.white:const Color(0xFF121212),
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

          final bannerUrl = staticBannerUrl;
          final logoUrl = college.image ?? staticLogoUrl;
          final centenaryText = staticCentenaryText;

          return SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner
                Container(
                  height: 260.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(logoUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.w, bottom: 20.h),
                      child: Text(
                        centenaryText,
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: const [
                            Shadow(blurRadius: 6, color: Colors.black54)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Top bar
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

                Padding(
                  padding: EdgeInsets.only(top: 220.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ?   Colors.white:const Color(0xFF121212),
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                    ),
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
                                    color: isDark ?Colors.black87: Colors.white ,
                                  ),
                                ),
                              ),
                              Icon(Icons.verified,
                                  color: linkedinBlue, size: 24.sp),
                            ],
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            "Higher Education • $staticFollowers • $staticAlumniCount",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp, color: Colors.grey[600]),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Follow / Message buttons
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
                                    backgroundColor: linkedinBlue,
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
                                    foregroundColor: linkedinBlue,
                                    side: const BorderSide(
                                        color: linkedinBlue, width: 1.5),
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
                                onPressed: () {},
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
                                    setState(() => _currentTab = CollegeTab.home);
                                  }),
                              _buildTab("About", _currentTab == CollegeTab.posts,
                                  isDark, () {
                                    setState(() => _currentTab = CollegeTab.posts);
                                  }),

                              _buildTab("Alumni",
                                  _currentTab == CollegeTab.alumni, isDark, () {
                                    setState(() => _currentTab = CollegeTab.alumni);
                                  }),
                            ],
                          ),
                        ),

                        const Divider(height: 1, thickness: 0.8),

                        // Tab content
                        _buildTabContent(college, snap, isDark),
                      ],
                    ),
                  ),
                ),

                // Logo
                Positioned(
                  top: 160.h,
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stk) {
          log("$err\n$stk");
          return Center(child: Text("Error: $err"));
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
                color: active ? linkedinBlue : (isDark ? Colors.black54: Colors.white70 ),
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
        return
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Overview",
                      style: GoogleFonts.roboto(
                        color: isDark ?Colors.black87: Colors.white ,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    college.description ?? "No description available.",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: isDark ? Colors.black87: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  // Text("Details",
                  //     style: GoogleFonts.roboto(
                  //       fontSize: 18.sp,
                  //       fontWeight: FontWeight.w700,
                  //       color: isDark ?Colors.black87: Colors.white ,
                  //     )),
                  // SizedBox(height: 12.h),
                  // _buildDetailRow("Website", college.website, null, isDark),
                  // _buildDetailRow("Industry", staticIndustry, null, isDark),
                  // _buildDetailRow("Headquarters", staticHeadquarters, null, isDark),
                  // if (college.city != null || college.pincode != null)
                  //   _buildDetailRow(
                  //     "Location",
                  //     "${college.city ?? ''} ${college.pincode ?? ''}",
                  //     null,
                  //     isDark,
                  //   ),
                  // if (college.phone != null)
                  //   _buildDetailRow("Phone", "+91 ${college.phone}", null, isDark),
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
                      color: isDark ?Colors.black87: Colors.white ,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => AllReviewPage(
                            flag:true,
                            id: college.id ?? 0),
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
                    color: isDark
                        ? Color(0xffF1F2F6)
                        : Color(0xff9088F1),
                    // color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.fullName ?? "Anonymous",
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ?Color(0xff9088F1)
                                      : Color(0xffDEDDEC)
                                ),
                              ),
                              SizedBox(width: 10.w,),
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
                              color:isDark

                                  ? Color(0xFF201F1F)
                              : Color(0xffDEDDEC)
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            review.description ?? "",
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,

                              color:isDark?  Color(0xFF666666)
                                : Color(0xffDEDDEC)

                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: isDark?   Color(0xFF201F1F):
                                   Color(0xffDEDDEC)

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
                margin: EdgeInsets.only(left: 10.w,right: 10.w),
                child: Row(
                  children: [

                    Expanded(
                      child: SizedBox(
                        height: 110.h, // increased height for avatar + name + spacing
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: users.length >= 4 ? 4 : users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 20.w), // good spacing between items
                              child: Expanded(
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            user.userType=="Mentor"?
                                            Navigator.push(context,  MaterialPageRoute(builder: (context)=>MentorDetailPage(id:user.id!))):
                                            Navigator.push(context,  MaterialPageRoute(builder: (context)=>StudenetDetailPage(id:user.id!)));
            },
                                          child: Container(
                                            width: 64.w,
                                            height: 64.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: linkedinBlue.withOpacity(0.5),
                                                width: 2.w,
                                              ),
                                            ),
                                            child: ClipOval(
                                              clipBehavior: Clip.hardEdge, // ensures perfect rounding
                                              child: user.profilePic != null && user.profilePic!.isNotEmpty
                                                  ? Image.network(
                                                user.profilePic!,
                                                width: 64.w,
                                                height: 64.h,
                                                fit: BoxFit.cover, // fills the circle properly
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 32.w,
                                                      height: 32.h,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.w,
                                                        value: loadingProgress.expectedTotalBytes != null
                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                            (loadingProgress.expectedTotalBytes ?? 1)
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) => _defaultAvatar(),
                                              )
                                                  : _defaultAvatar(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        SizedBox(
                                          width: 80.w, // prevent text overflow
                                          child: Text(
                                            user.fullName ?? "Unknown", // ← add fallback if name is null
                                            style: GoogleFonts.roboto(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? Colors.black87 : Colors.white,
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

                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Colloegeuserpage(

                              widget.id,  snap.collage!.name??"")));

                        },
                        child: Icon(Icons.arrow_forward_ios,

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
            SizedBox(height: 60.h),
          ],
        );
      case CollegeTab.posts:
      case CollegeTab.jobs:

      return
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Overview",
                      style: GoogleFonts.roboto(
                        color: isDark ?Colors.black87: Colors.white ,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 10.h),
                  Text(
                    college.description ?? "No description available.",
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: isDark ? Colors.black87: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text("Details",
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ?Colors.black87: Colors.white ,
                      )),
                  SizedBox(height: 12.h),
                  _buildDetailRow("Website", college.website, null, isDark),
                  _buildDetailRow("Industry", staticIndustry, null, isDark),
                  _buildDetailRow("Headquarters", staticHeadquarters, null, isDark),
                  if (college.city != null || college.pincode != null)
                    _buildDetailRow(
                      "Location",
                      "${college.city ?? ''} ${college.pincode ?? ''}",
                      null,
                      isDark,
                    ),
                  if (college.phone != null)
                    _buildDetailRow("Phone", "+91 ${college.phone}", null, isDark),
                ],
              ),
            ),
            // const Divider(),

          ],
        );


    // return _buildStaticContentSection(
        //   isDark: isDark,
        //   title: _currentTab == CollegeTab.posts
        //       ? ""
        //       : "s",
        //   items: _currentTab == CollegeTab.posts
        //       ? [
        //     // "98th Convocation Ceremony held on 15 Jan 2026",
        //     // "New AI & Data Science research center inaugurated",
        //     // "Campus placement 2025-26 – 1200+ offers received",
        //     // "NAAC A++ re-accreditation achieved",
        //   ]
        //       : [
        //     // "Professor – Computer Science (Last date: 28 Feb 2026)",
        //     // "Research Associate – Biotechnology (Contract)",
        //     // "Section Officer – Administration",
        //     // "Guest Faculty – Various Departments",
        //   ],
        // );
    }
  }

  Widget _buildAlumniCard(User user, bool isDark) {
    return Card(
      margin: EdgeInsets.only(bottom: 14.h),
      elevation: isDark ? 2 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      // color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      color: isDark
          ? Color(0xffF1F2F6)
          : Color(0xff9088F1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
         /* ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile view for ${user.fullName ?? 'Alumnus'} – coming soon"),
              duration: const Duration(seconds: 2),
            ),
          );*/

          Navigator.push(context,  MaterialPageRoute(builder: (context)=>StudenetDetailPage(id:user.id!)));
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Profile Picture
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: linkedinBlue.withOpacity(0.4), width: 2.w),
                ),
                child: ClipOval(
                  child: user.profilePic != null && user.profilePic!.isNotEmpty
                      ? Image.network(
                    user.profilePic!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _defaultAvatar(),
                  )
                      : _defaultAvatar(),
                ),
              ),

              SizedBox(width: 16.w),

              // // Name & Info
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         user.fullName ?? "Unknown Alumni",
              //         style: GoogleFonts.roboto(
              //           fontSize: 17.sp,
              //           fontWeight: FontWeight.w600,
              //           color: isDark ?  Colors.black:
              //                Color(0xffDEDDEC)
              //
              //         ),
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       SizedBox(height: 4.h),
              //       Text(
              //         user.userType ?? "Alumnus",
              //         style: GoogleFonts.roboto(
              //           fontSize: 14.sp,
              //           color: isDark?  Color(0xFF201F1F):
              //                Color(0xffDEDDEC)
              //
              //         ),
              //       ),
              //       if (user.email != null && user.email!.isNotEmpty) ...[
              //         SizedBox(height: 4.h),
              //         Text(
              //           user.email!,
              //           style: GoogleFonts.roboto(
              //             fontSize: 13.sp,
              //             color: isDark
              //                   ? Color(0xFF666666)
              //                 : Color(0xffDEDDEC)
              //
              //           ),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ],
              //     ],
              //   ),
              // ),
              //
              // Icon(
              //   Icons.arrow_forward_ios_rounded,
              //   size: 18.sp,
              //   color: Colors.grey[500],
              // ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildStaticContentSection({
    required String title,
    required List<String> items,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ?Colors.black87: Colors.white ,
            ),
          ),
          SizedBox(height: 16.h), 
          ...items.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              "• $item",
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                color: isDark ? Colors.black87: Colors.white70 ,
              ),
            ),
          )),
          SizedBox(height: 20.h),
          Text(
            "(Dynamic content will appear when API provides data)",
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      String label,
      String? dynamicValue,
      String? staticFallback,
      bool isDark,
      ) {
    final value = dynamicValue ?? staticFallback ?? "Not available";
    final isWebsite = label == "Website" && value.contains("http");

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
                if (!url.startsWith('http')) url = 'https://$url';
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => WebViewPage(url: url)),
                );
              }
                  : null,
              child: Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  color: isWebsite ? linkedinBlue : (isDark ? Colors.black87: Colors.white70 ),
                  decoration: isWebsite ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}