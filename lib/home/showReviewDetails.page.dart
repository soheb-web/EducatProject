import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../coreFolder/Model/ReviewGetModel.dart';

class ShowReviewDetailsPage extends ConsumerStatefulWidget {
  final Review review;
  final bool isViewOnly;

  const ShowReviewDetailsPage({
    super.key,
    required this.review,
    this.isViewOnly = false,
  });
  @override
  ConsumerState<ShowReviewDetailsPage> createState() =>
      _ShowReviewDetailsPageState();
}

class _ShowReviewDetailsPageState extends ConsumerState<ShowReviewDetailsPage> {
  int selectedRating = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  /// Feature wise ratings
  Map<String, int> featureRatings = {};

  @override
  void initState() {
    super.initState();

    /// ⭐ overall rating
    selectedRating = widget.review.rating ?? 0;

    /// title & description
    _titleController.text = widget.review.title ?? "";
    _descriptionController.text = widget.review.description ?? "";

    /// Feature wise rating (name_wise_rating)
    final nameWise = widget.review.nameWiseRating;

    if (nameWise != null && nameWise.reviewers != null) {
      for (final reviewer in nameWise.reviewers!) {
        if (reviewer != null &&
            reviewer.reviewerName != null &&
            reviewer.reviewerCount != null) {
          featureRatings[reviewer.reviewerName!] = reviewer.reviewerCount!;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      ///backgroundColor: Color(0xff1B1B1B),
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xff1B1B1B) : Color(0xff9088F1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.w,
                ),
                Text(
                  "Review Details",
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20.w,
                top: 20.h,
                bottom: 20.h,
                right: 20.w,
              ),
              decoration: BoxDecoration(
                //  color: Colors.white,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xff1B1B1B),
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
                      "Fill out the details",
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xff1B1B1B)
                            : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Icon(
                            starIndex <= selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xff9088F1),
                            size: 30.sp,
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Review Title",
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      controller: _titleController,
                      readOnly: widget.isViewOnly,
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF4D4D4D)
                            : Colors.white,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                color: themeMode == ThemeMode.dark
                                    ? Color(0xFF4D4D4D)
                                    : Colors.white,
                              ))),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Description",
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      maxLines: 4,
                      controller: _descriptionController,
                      readOnly: widget.isViewOnly,
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF4D4D4D)
                            : Colors.white,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide(
                                color: themeMode == ThemeMode.dark
                                    ? Color(0xFF4D4D4D)
                                    : Colors.white,
                              ))),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Rating Criteria",
                      style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF1B1B1B)
                              : Colors.white,
                          letterSpacing: -1),
                    ),
                    SizedBox(height: 10.h),
                    Column(
                      children: featureRatings.entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key.toUpperCase(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: themeMode == ThemeMode.dark
                                            ? const Color(0xFF1B1B1B)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (index) {
                                      final starIndex = index + 1;
                                      return Padding(
                                        padding: EdgeInsets.only(left: 4.w),
                                        child: Icon(
                                          starIndex <= entry.value
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: const Color(0xff9088F1),
                                          size: 24.sp,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Divider(
                                height: 10,
                                thickness: 0.6,
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
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
