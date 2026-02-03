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
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Model/ReviewGetCompanyModel.dart';
import 'AllReviewPage.dart';
import 'CompanyUsersPage.dart';
import 'MentorDetail.dart';

enum CompanyTab { home, posts, jobs, alumni }

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
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: reviewAsync.when(
        data: (data) {
          final company = data.collage;

          if (company == null) {
            return const Center(child: Text("Company data not found"));
          }

          final logo = company.image ?? fallbackLogo;

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
                      image: NetworkImage(logo),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.45),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                // Top App Bar
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

                Padding(
                  padding: EdgeInsets.only(top: 220.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : const Color(0xFF121212),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32.r)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
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
                                onPressed: () {},
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
                                  _currentTab == CompanyTab.posts, isDark, () {
                                setState(() => _currentTab = CompanyTab.posts);
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

                // Floating Logo
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stk) {
          log("$err");
          return Center(child: Text("Error: $err"));
        },
      ),
    );
  }

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
        return
          Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
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
                  // Text(
                  //   "Details",
                  //   style: GoogleFonts.roboto(
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w700,
                  //     color: isDark ? Colors.black87 : Colors.white,
                  //   ),
                  // ),
                  // SizedBox(height: 12.h),
                  //
                  // _buildDetailRow("Website", company.website, null, isDark),
                  // _buildDetailRow("Location", company.city, null, isDark),
                  // if (company.phone != null)
                  //   _buildDetailRow("Phone", company.phone, null, isDark),

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
        );

      case CompanyTab.posts:
      case CompanyTab.jobs:
        // return _buildStaticContentSection(
        //   isDark: isDark,
        //   title: _currentTab == CompanyTab.posts ? "" : "",
        //   items: _currentTab == CompanyTab.posts
        //       ? [
        //           "",
        //         ]
        //       : [
        //           "",
        //         ],
        // );
      return
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
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

                ],
              ),
            ),

            const Divider(),


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

  Widget _buildUserCard(User user, bool isDark) {
    return Card(
      margin: EdgeInsets.only(bottom: 14.h, left: 20.w, right: 20.w),
      elevation: isDark ? 2 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: isDark ? const Color(0xffF1F2F6) : accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: accentColor.withOpacity(0.4), width: 2.w),
                ),
                child: ClipOval(
                  child: user.profilePic != null && user.profilePic!.isNotEmpty
                      ? Image.network(user.profilePic!, fit: BoxFit.cover)
                      : Icon(Icons.person, color: accentColor, size: 40.sp),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ?? "Unknown",
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.black : const Color(0xffDEDDEC),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      user.userType ?? "Employee",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: isDark
                              ? const Color(0xFF201F1F)
                              : const Color(0xffDEDDEC)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 18.sp, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String? value, String? fallback, bool isDark) {
    final text = value ?? fallback ?? "Not available";
    final isLink = label == "Website" && text.contains("http");

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
                      if (!url.startsWith('http')) url = 'https://$url';
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
              color: isDark ? Colors.black87 : Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(
                  "• $item",
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    color: isDark ? Colors.black87 : Colors.white70,
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
          SizedBox(
            height: 300.h,
          )
        ],
      ),
    );
  }
}
