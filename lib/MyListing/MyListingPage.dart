/*
import 'package:educationapp/MyListing/listingDetails.page.dart';
import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'package:hive/hive.dart';
import '../coreFolder/Controller/myListController.dart';
import '../home/mentorProposal.page.dart';
import 'ListingMyDetail.dart';
import 'mentorProposol.dart';

class MyListing extends ConsumerStatefulWidget {
  const MyListing({super.key});

  @override
  ConsumerState<MyListing> createState() => _MyListingState();
}

class _MyListingState extends ConsumerState<MyListing> {
  int voletId = 0;
  int currentBalance = 0;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(myListingController);
    });
    Future.microtask(() {
      ref.invalidate(myListController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("userdata");
    final type = box.get("userType");
    log("userType listing page : $type");
    final myListingProvider = ref.watch(myListingController);
    final SavedListProvider = ref.watch(myListController);
    final themeMode = ref.watch(themeProvider);
    final isMentorOrProfessional = type == "Mentor" || type == "Professional";

    return Scaffold(
        appBar: AppBar(
*/
/*  leading:

  InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      margin: EdgeInsets.only(left: 10.w,top: 10,bottom: 10),
      width: 3.w,    // ← yeh chhota kiya
      height: 3.h,   // ← yeh chhota kiya
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 6),  // ← thoda kam kiya
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
  ),*//*


          automaticallyImplyLeading:
              false, // ← ये जरूरी है back button hide करने के लिए
          backgroundColor: Color(0xff9088F1),
          centerTitle: true,
          title: Text(
            "My Listing",

            // style: TextStyle(fontSize: 20.sp),

            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: TextField(
                  onChanged: (_) => setState(() {}),
                  controller: searchController,
                  style: GoogleFonts.roboto(
                      color: Color(0xff9088F1), fontSize: 20.sp),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    hintText: "Search ...",
                    hintStyle: GoogleFonts.roboto(
                        color: Color(0xff9088F1), fontSize: 18.sp),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(
                        color: Color(0xff9088F1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide(
                        color: Color(0xff9088F1),
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xff9088F1), size: 20),
                  ),
                ),
              ),
              type != "Student"
                  ?
              myListingProvider.when(
                      data: (listData) {
                        final query = searchController.text.toLowerCase();
                        final filteredList = query.isEmpty
                            ? listData.data!
                            : listData.data!.where((item) {
                                final education =
                                    item.education?.toLowerCase() ?? '';

                                final stName =
                                    item.student!.fullName?.toLowerCase() ?? '';
                                final subjects = item.subjects!
                                    .map((e) => e.toLowerCase() ?? '')
                                    .join(' ');

                                return education.contains(query) ||
                                    stName.contains(query) ||
                                    subjects.contains(query);
                              }).toList();

                        if (filteredList.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "No List Available",
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w300,
                                  color: themeMode == ThemeMode.dark
                                      ? Color(0xFF1B1B1B)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 16.w),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF1B1B1B).withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// STUDENT INFO
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                        child: Image.network(
                                          item.student!.profilePic ??
                                              "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                          height: 60.h,
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.network(
                                              "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                              height: 60.h,
                                              width: 60.w,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.student!.fullName ?? "Student",
                                            style: GoogleFonts.roboto(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1B1B1B),
                                            ),
                                          ),
                                          Text(
                                            "Looking for Mentor",
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              color: Color(0xFF1B1B1B),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 14.h),

                                  /// EDUCATION
                                  Row(
                                    children: [
                                      Icon(Icons.school,
                                          size: 18.sp, color: Colors.blue),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          "Leval : ${item.education ?? ''}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Icon(Icons.timer,
                                          size: 18.sp, color: Colors.red),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          "Duration : ${item.duration ?? ''}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Icon(Icons.wifi,
                                          size: 18.sp,
                                          color: Color(0xFF1B1B1B)),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          "Available : ${item.teachingMode ?? ''}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  /// SUBJECTS
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: item.subjects!
                                        .map(
                                          (subject) => Chip(
                                            label: Text(
                                              subject,
                                              style: GoogleFonts.roboto(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF1B1B1B),
                                              ),
                                            ),
                                            backgroundColor: Color.fromARGB(
                                                225, 222, 221, 236),
                                            side: BorderSide.none,
                                          ),
                                        )
                                        .toList(),
                                  ),

                                  SizedBox(height: 10.h),

                                  /// BUTTON
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff9088F1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) =>
                                                ListingDetailsPage(false, item),
                                          ),
                                        ).then((_) {
                                          ref.invalidate(myListingController);
                                        });
                                      },
                                      child: Text(
                                        "View Details",
                                        style: GoogleFonts.roboto(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        log(stackTrace.toString());

                        // Non-Dio errors
                        return Center(
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  :
              SavedListProvider.when(
                      data: (listData) {
                        final query = searchController.text.toLowerCase();
                        final filteredList = query.isEmpty
                            ? listData.data!
                            : listData.data!.where((item) {
                                final education =
                                    item.education?.toLowerCase() ?? '';

                                final stName =
                                    item.student!.fullName?.toLowerCase() ?? '';
                                final subjects = item.subjects!
                                    .map((e) => e.toLowerCase() ?? '')
                                    .join(' ');

                                return education.contains(query) ||
                                    stName.contains(query) ||
                                    subjects.contains(query);
                              }).toList();

                        if (filteredList.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "No List Available",
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w300,
                                  color: themeMode == ThemeMode.dark
                                      ? Color(0xFF1B1B1B)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 16.w),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.grey[50]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1B1B1B)
                                        .withOpacity(0.08),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. ENHANCED HEADER: Student Profile with Gradient Badge & Subtle Icon
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.w, 20.h, 20.w, 16.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2.r),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xff9088F1),
                                                const Color(0xFF006666),
                                              ],
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 26.r,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              item.student!.profilePic ??
                                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.student!.fullName ??
                                                          "Student",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFF1B1B1B),
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ),
                                                  // Enhanced Status Badge with Icon
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 6.h),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.orange
                                                              .withOpacity(0.2),
                                                          Colors.orange
                                                              .withOpacity(0.1),
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      border: Border.all(
                                                        color: Colors.orange
                                                            .withOpacity(0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          size: 8.sp,
                                                          color: Colors
                                                              .orange[700],
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          "Open",
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors
                                                                .orange[800],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.school,
                                                    size: 14.sp,
                                                    color:
                                                        const Color(0xff9088F1),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Text(
                                                    "Looking for Mentor",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13.sp,
                                                      color: const Color(
                                                          0xFF008080),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Subtle Divider with Gradient
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          const Color(0xff9088F1)
                                              .withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  // 2. ENHANCED BODY: Improved Grid with Icons & Better Spacing
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.w, 20.h, 20.w, 16.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Enhanced Info Grid - Stacked for Better Mobile Readability
                                        _buildInfoTile(
                                          Icons.auto_stories_outlined,
                                          "Subject Level",
                                          item.education ?? 'N/A',
                                          const Color(0xff9088F1),
                                        ),
                                        SizedBox(height: 12.h),
                                        _buildInfoTile(
                                          Icons.schedule_outlined,
                                          "Duration",
                                          item.duration ?? 'N/A',
                                          const Color(0xFFFF6B6B),
                                        ),
                                        SizedBox(height: 20.h),

                                        // Teaching Mode with Enhanced Icon & Subtle Background
                                        Container(
                                          padding: EdgeInsets.all(16.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50]
                                                ?.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                item.teachingMode!
                                                        .toLowerCase()
                                                        .contains('online')
                                                    ? Icons.video_call_outlined
                                                    : Icons
                                                        .location_on_outlined,
                                                size: 20.sp,
                                                color: const Color(0xff9088F1),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: Text(
                                                  "Mode: ${item.teachingMode ?? 'Not Specified'}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 15.sp,
                                                    color:
                                                        const Color(0xFF1B1B1B),
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        // 3. SUBJECTS: Chip-style with Subtle Shadows & Colors
                                        if (item.subjects != null &&
                                            item.subjects!.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Subjects",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF1B1B1B),
                                                ),
                                              ),
                                              SizedBox(height: 12.h),
                                              Wrap(
                                                spacing: 8.w,
                                                runSpacing: 8.h,
                                                children: item.subjects!
                                                    .map((subject) => Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      14.w,
                                                                  vertical:
                                                                      8.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                const Color(
                                                                        0xFF008080)
                                                                    .withOpacity(
                                                                        0.1),
                                                                Colors
                                                                    .transparent,
                                                              ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                            border: Border.all(
                                                              color: const Color(
                                                                      0xFF008080)
                                                                  .withOpacity(
                                                                      0.2),
                                                              width: 1,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.05),
                                                                blurRadius: 4,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            subject,
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: const Color(
                                                                  0xFF008080),
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            ],
                                          ),

                                        // Add some breathing room if no subjects
                                        if (item.subjects == null ||
                                            item.subjects!.isEmpty)
                                          SizedBox(height: 12.h),
                                      ],
                                    ),
                                  ),
SizedBox(height: 20.h,), 

                                  Padding(
                                    padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      Row(
                                        children: [
                                          Text("Mentor Request",
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(width: 10.w,),
                                          Container(
                                            width: 20,           // adjust size as needed
                                            height: 20,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              // color: Color(0xff9088F1),
                                              shape: BoxShape.circle,           // perfect circle
                                              // OR use borderRadius if you want slightly rounded rect instead:
                                              // borderRadius: BorderRadius.circular(30),
                                            ),
                                            alignment: Alignment.center,        // centers the text inside
                                            child: Text(
                                              item.mentorCount.toString(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                                color: Colors.black,            // ← very important! (white looks best)
                                              ),
                                            ),
                                          ),
                                         */
/* Text(
                                            item.mentorCount.toString(),
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                              color: Colors.black,            // ← very important! (white looks best)
                                            ),
                                          ),*//*

                                        ],
                                      ),



                                        GestureDetector(
                                          onTap:(){
                                           Navigator.push(context, MaterialPageRoute(builder: (context)=>MentorProposalPageNew( item: item,))).then((_) =>
                                               ref.invalidate(myListController));
                            },
                                          child: Container(
                                            width: 30,           // adjust size as needed
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Color(0xff9088F1),
                                              shape: BoxShape.circle,           // perfect circle
                                              // OR use borderRadius if you want slightly rounded rect instead:
                                              // borderRadius: BorderRadius.circular(30),
                                            ),
                                            alignment: Alignment.center,        // centers the text inside
                                            child: Icon(Icons.arrow_forward_ios,size: 20.sp,)
                                          ),
                                        ),
                                   */
/*   Container(


                                        child: Text(item.mentorCount.toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
*//*


                                    ],),
                                  ),

                                  SizedBox(height: 20.h,),
                                  // 4. ENHANCED FOOTER: Button with Hover-like Effect & Icon
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.w, 0, 20.w, 20.h),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 52.h,
                                      child: ElevatedButton.icon(
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16.sp,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "View Full Request",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff9088F1),
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shadowColor: const Color(0xff9088F1)
                                              .withOpacity(0.3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14.h),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  ListingDetailsPageMyDetail(
                                                      true, item),
                                            ),
                                          ).then((_) =>
                                              ref.invalidate(myListController));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        log(stackTrace.toString());

                        // Non-Dio errors
                        return Center(
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
            ],
          ),
        ));
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
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
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






*/


import 'package:educationapp/MyListing/listingDetails.page.dart';
import 'package:educationapp/coreFolder/Controller/myListingController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer';
import 'package:hive/hive.dart';
import '../coreFolder/Controller/myListController.dart';
import 'ListingMyDetail.dart';
import 'mentorProposol.dart';

class MyListing extends ConsumerStatefulWidget {
  const MyListing({super.key});
  @override
  ConsumerState<MyListing> createState() => _MyListingState();
}

class _MyListingState extends ConsumerState<MyListing> {
  int voletId = 0;
  int currentBalance = 0;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(myListingController);
    });
    Future.microtask(() {
      ref.invalidate(myListController);
    });
  }

  // Refresh function → both providers/API will be called again
  Future<void> _onRefresh() async {
    ref.invalidate(myListingController);
    ref.invalidate(myListController);
    // Optional: you can add small delay if you want
    // await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("userdata");
    final type = box.get("userType");
    log("userType listing page : $type");

    final myListingAsync = ref.watch(myListingController);
    final savedListAsync = ref.watch(myListController);
    final themeMode = ref.watch(themeProvider);
    final isMentorOrProfessional = type == "Mentor" || type == "Professional";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff9088F1),
        centerTitle: true,
        title: Text(
          "My Listing",
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
      ),

      backgroundColor:
      themeMode == ThemeMode.dark ? Colors.white : const Color(0xFF1B1B1B),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xff9088F1),
        backgroundColor: Colors.white,
        displacement: 40.h,
        strokeWidth: 3,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: TextField(
                  onChanged: (_) => setState(() {}),
                  controller: searchController,
                  style: GoogleFonts.roboto(
                      color: const Color(0xff9088F1), fontSize: 20.sp),
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                    hintText: "Search ...",
                    hintStyle: GoogleFonts.roboto(
                        color: const Color(0xff9088F1), fontSize: 18.sp),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: const BorderSide(color: Color(0xff9088F1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: const BorderSide(color: Color(0xff9088F1)),
                    ),
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xff9088F1), size: 20),
                  ),
                ),
              ),

              // ────────────────────────────────────────────────
              // Mentor / Professional view
              if (type != "Student")
                myListingAsync.when(
                  data: (listData) {
                    final query = searchController.text.toLowerCase();
                    final filteredList = query.isEmpty
                        ? listData.data!
                        : listData.data!.where((item) {
                      final education =
                          item.education?.toLowerCase() ?? '';
                      final stName =
                          item.student!.fullName?.toLowerCase() ?? '';
                      final subjects = item.subjects!
                          .map((e) => e.toLowerCase() ?? '')
                          .join(' ');

                      return education.contains(query) ||
                          stName.contains(query) ||
                          subjects.contains(query);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "No List Available",
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300,
                              color: themeMode == ThemeMode.dark
                                  ? const Color(0xFF1B1B1B)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B1B1B).withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40.r),
                                    child: Image.network(
                                      item.student!.profilePic ??
                                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                      height: 60.h,
                                      width: 60.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                          height: 60.h,
                                          width: 60.w,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.student!.fullName ?? "Student",
                                        style: GoogleFonts.roboto(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1B1B1B),
                                        ),
                                      ),
                                      Text(
                                        "Looking for Mentor",
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          color: const Color(0xFF1B1B1B),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              SizedBox(height: 14.h),

                              Row(
                                children: [
                                  Icon(Icons.school,
                                      size: 18.sp, color: Colors.blue),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "Leval : ${item.education ?? ''}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(Icons.timer,
                                      size: 18.sp, color: Colors.red),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "Duration : ${item.duration ?? ''}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(Icons.wifi,
                                      size: 18.sp, color: Color(0xFF1B1B1B)),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "Available : ${item.teachingMode ?? ''}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: item.subjects!
                                    .map(
                                      (subject) => Chip(
                                    label: Text(
                                      subject,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                    ),
                                    backgroundColor: Color.fromARGB(
                                        225, 222, 221, 236),
                                    side: BorderSide.none,
                                  ),
                                )
                                    .toList(),
                              ),

                              SizedBox(height: 10.h),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff9088F1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  onPressed: () {

                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) =>
                                            ListingDetailsPage(requirementId: item.id!),
                                      ),
                                    ).then((_) {
                                      ref.invalidate(myListingController);
                                    });

                                    },
                                  child: Text(
                                    "View Details",
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    log(stackTrace.toString());
                    return Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                )

              // ────────────────────────────────────────────────
              // Student saved list view
              else
                savedListAsync.when(
                  data: (listData) {
                    final query = searchController.text.toLowerCase();
                    final filteredList = query.isEmpty
                        ? listData.data!
                        : listData.data!.where((item) {
                      final education =
                          item.education?.toLowerCase() ?? '';
                      final stName =
                          item.student!.fullName?.toLowerCase() ?? '';
                      final subjects = item.subjects!
                          .map((e) => e.toLowerCase() ?? '')
                          .join(' ');

                      return education.contains(query) ||
                          stName.contains(query) ||
                          subjects.contains(query);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "No List Available",
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300,
                              color: themeMode == ThemeMode.dark
                                  ? const Color(0xFF1B1B1B)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Colors.grey[50]!],
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1B1B1B).withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.w, 20.h, 20.w, 16.h),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2.r),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xff9088F1),
                                            const Color(0xFF006666),
                                          ],
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 26.r,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          item.student!.profilePic ??
                                              "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.student!.fullName ??
                                                      "Student",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                        0xFF1B1B1B),
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 6.h),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.orange
                                                          .withOpacity(0.2),
                                                      Colors.orange
                                                          .withOpacity(0.1),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20.r),
                                                  border: Border.all(
                                                    color: Colors.orange
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 8.sp,
                                                      color:
                                                      Colors.orange[700],
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      "Open",
                                                      style:
                                                      GoogleFonts.inter(
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: Colors
                                                            .orange[800],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.school,
                                                size: 14.sp,
                                                color: const Color(0xff9088F1),
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                "Looking for Mentor",
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.sp,
                                                  color: const Color(0xFF008080),
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 20.w),
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xff9088F1)
                                          .withOpacity(0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.w, 20.h, 20.w, 16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoTile(
                                      Icons.auto_stories_outlined,
                                      "Subject Level",
                                      item.education ?? 'N/A',
                                      const Color(0xff9088F1),
                                    ),
                                    SizedBox(height: 12.h),
                                    _buildInfoTile(
                                      Icons.schedule_outlined,
                                      "Duration",
                                      item.duration ?? 'N/A',
                                      const Color(0xFFFF6B6B),
                                    ),
                                    SizedBox(height: 20.h),

                                    Container(
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50]?.withOpacity(0.5),
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            item.teachingMode!
                                                .toLowerCase()
                                                .contains('online')
                                                ? Icons.video_call_outlined
                                                : Icons.location_on_outlined,
                                            size: 20.sp,
                                            color: const Color(0xff9088F1),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Text(
                                              "Mode: ${item.teachingMode ?? 'Not Specified'}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 15.sp,
                                                color: const Color(0xFF1B1B1B),
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),

                                    if (item.subjects != null &&
                                        item.subjects!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Subjects",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF1B1B1B),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Wrap(
                                            spacing: 8.w,
                                            runSpacing: 8.h,
                                            children: item.subjects!
                                                .map((subject) => Container(
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 14.w,
                                                  vertical: 8.h),
                                              decoration: BoxDecoration(
                                                gradient:
                                                LinearGradient(
                                                  colors: [
                                                    const Color(
                                                        0xFF008080)
                                                        .withOpacity(
                                                        0.1),
                                                    Colors.transparent,
                                                  ],
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20.r),
                                                border: Border.all(
                                                  color: const Color(
                                                      0xFF008080)
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                        0.05),
                                                    blurRadius: 4,
                                                    offset: const Offset(
                                                        0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                subject,
                                                style:
                                                GoogleFonts.inter(
                                                  fontSize: 13.sp,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: const Color(
                                                      0xFF008080),
                                                ),
                                              ),
                                            ))
                                                .toList(),
                                          ),
                                        ],
                                      ),

                                    if (item.subjects == null ||
                                        item.subjects!.isEmpty)
                                      SizedBox(height: 12.h),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20.h),

                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20.w, right: 20.w),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Mentor Request",
                                          style: GoogleFonts.roboto(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Container(

                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              item.mentorCount.toString(),
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MentorProposalPageNew(proposalId: item.id!),
                                          ),
                                        ).then((_) =>
                                            ref.invalidate(myListController));
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff9088F1),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20.h),

                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.w, 0, 20.w, 20.h),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 52.h,
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "View Full Request",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff9088F1),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor:
                                      const Color(0xff9088F1).withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16.r),
                                      ),
                                      padding:
                                      EdgeInsets.symmetric(vertical: 14.h),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (_) =>
                                              ListingDetailsPageMyDetail(
                                                  true, item),
                                        ),
                                      ).then((_) =>
                                          ref.invalidate(myListController));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    log(stackTrace.toString());
                    return Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      IconData icon,
      String label,
      String value,
      Color color,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
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
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}