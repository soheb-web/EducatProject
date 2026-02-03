/*

*/



import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/getMentorReveiwController.dart';
import 'package:educationapp/coreFolder/Controller/saveReviewController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/getMentorReviewModel.dart';
import 'package:educationapp/coreFolder/Model/mentorReviewResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class MentoraddReviewPage extends ConsumerStatefulWidget {
  final String id;
  final Review? getmentorReviewModel; // ← existing review (nullable)

  const MentoraddReviewPage({
    super.key,
    required this.id,
    this.getmentorReviewModel,
  });

  @override
  ConsumerState<MentoraddReviewPage> createState() => _MentoraddReviewPageState();
}

class _MentoraddReviewPageState extends ConsumerState<MentoraddReviewPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final hasReview = widget.getmentorReviewModel != null;
    final rating = widget.getmentorReviewModel?.rating ?? 0;
    final description = widget.getmentorReviewModel?.description ?? "";

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.dark ? Color(0xff1B1B1B) : Color(0xff9088F1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 50.w),
                Text(
                  hasReview ? "Your Review" : "Add Review",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark ? Colors.white : Color(0xff1B1B1B),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review Details",
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: themeMode == ThemeMode.dark ? Color(0xff1B1B1B) : Colors.white,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ★★★★★ Stars – read only
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
                          child: Icon(
                            starIndex <= rating ? Icons.star : Icons.star_border,
                            color: const Color(0xff9088F1),
                            size: 36.sp,
                          ),
                        );
                      }),
                    ),

                    if (rating > 0) ...[
                      SizedBox(height: 8.h),
                      Text(
                        "$rating / 5",
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],

                    SizedBox(height: 32.h),

                    Text(
                      "Your Comment",
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Read-only description
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(20.r),
                        // color: themeMode == ThemeMode.dark
                        //     ? Colors.grey.shade900.withOpacity(0.4)
                        //     : Colors.grey.shade100.withOpacity(0.5),
                      ),
                      child: Text(
                        description.isNotEmpty ? description : "No comment provided.",
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.5,
                          color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white70,
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    if (!hasReview) ...[
                      Text(
                        "You haven't submitted a review yet.",
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Optional: button to go to add review screen
                    ] else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}