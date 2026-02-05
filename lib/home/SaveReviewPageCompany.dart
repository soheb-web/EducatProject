import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/reviewCategoryController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import '../coreFolder/Controller/reviewController.dart';
import '../coreFolder/Controller/saveReviewController.dart';
import '../coreFolder/Model/ReviewGetModel.dart';

class SaveReviewPageCompany extends ConsumerStatefulWidget {
  int? id;
  final Review? review;
  final bool isViewOnly;

  SaveReviewPageCompany( {
    super.key,
    this.id,
    this.review,
    this.isViewOnly = false,

  });

  @override
  ConsumerState<SaveReviewPageCompany> createState() => _SaveReviewPageCompanyState();
}

class _SaveReviewPageCompanyState extends ConsumerState<SaveReviewPageCompany> {
  int selectedRating = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  bool flag=false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Map<String, int> featureRatings = {
    "Work Culture": 0,
    "Work Environment": 0,
    "Work-Life Balance": 0,
    "Office Facilities": 0,
    "Career Growth": 0,
    "Salary & Hikes": 0,
    "Ethics & Values": 0,
    "Company Policies": 0,
    "Working Hours": 0,
    "Perks & Benefits": 0,
  };

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");

    // final reviewAsync = ref.watch(reviewProvider(widget.id));

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
                  "Add Review",
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
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedRating = starIndex),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Icon(
                              starIndex <= selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xff9088F1),
                              size: 30.sp,
                            ),
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
                      children: featureRatings.keys.map((feature) {
                        final rating = featureRatings[feature]!;

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.h),
                              child: Row(
                                children: [
                                  /// Feature name (left)
                                  Expanded(
                                    child: Text(
                                      feature.toUpperCase(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: themeMode == ThemeMode.dark
                                            ? const Color(0xFF1B1B1B)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),

                                  /// Stars (right)
                                  Row(
                                    children: List.generate(5, (index) {
                                      final starIndex = index + 1;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            featureRatings[feature] = starIndex;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.w),
                                          child: Icon(
                                            starIndex <= rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: const Color(0xff9088F1),
                                            size: 24.sp,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),

                            /// Divider (full width, proper spacing)
                            Divider(
                              height: 1,
                              thickness: 0.6,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            SizedBox(
                              height: 15.h,
                            )
                          ],
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: 20.h,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 60.h)),
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            // When button is disabled
                            if (states.contains(MaterialState.disabled)) {
                              return themeMode == ThemeMode.dark
                                  ? const Color(0xFFDCF881).withOpacity(0.4)
                                  : Colors.white.withOpacity(0.4);
                            }

                            // When button is enabled
                            return themeMode == ThemeMode.dark
                                ? const Color(0xFFDCF881)
                                : Colors.white;
                          },
                        ),
                      ),
                      // onPressed: selectedRating == 0 || _isLoading
                      //     ? null
                      //     : () async {
                      //         final selectedRatings = featureRatings.entries
                      //             .where((e) => e.value > 0)
                      //             .toList();
                      //         if (selectedRatings.isEmpty) {
                      //           Fluttertoast.showToast(
                      //             msg: "Please rate at least one feature",
                      //             backgroundColor: Colors.orange,
                      //             textColor: Colors.white,
                      //           );
                      //           return;
                      //         }
                      //         final Map<String, dynamic> reviewPayload = {
                      //           "user_id": userId,
                      //           "collage_id": widget.id,
                      //           "count": selectedRating.toString(),
                      //           "description":
                      //               _descriptionController.text.trim(),
                      //           "name": featureRatings,
                      //           "title" :_titleController.text.trim(),
                      //         };
                      //         if (reviewPayload["description"]!.isEmpty) {
                      //           Fluttertoast.showToast(
                      //             msg: "Please add a description",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.TOP,
                      //             backgroundColor: Colors.orange,
                      //             textColor: Colors.white,
                      //             fontSize: 12.0,
                      //           );
                      //           return;
                      //         }
                      //         setState(() => _isLoading = true);
                      //         try {
                      //           await ref.read(
                      //               saveReviewProvider(reviewPayload).future);
                      //           // Refresh the reviews list
                      //           //  ref.invalidate(reviewProvider(widget.id));
                      //           // Reset form
                      //           setState(() => selectedRating = 0);
                      //           _descriptionController.clear();
                      //         } catch (e) {
                      //           Fluttertoast.showToast(
                      //             msg: "Failed to save review: $e",
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.TOP,
                      //             backgroundColor: Colors.red,
                      //             textColor: Colors.white,
                      //             fontSize: 12.0,
                      //           );
                      //         } finally {
                      //           setState(() => _isLoading = false);
                      //         }
                      //       },
                      onPressed: _isLoading
                          ? null
                          : () async {
                        final reviewers = featureRatings.entries
                            .where((e) => e.value > 0)
                            .map((e) => {
                          "reviewer_name": e.key,
                          "reviewer_count": e.value,
                        })
                            .toList();

                        if (reviewers.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please rate at least one feature",
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        if (_titleController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please enter review title",
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        if (_descriptionController.text.trim().isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please add a description",
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        final Map<String, dynamic> reviewPayload = {
                          // "name":
                          //     "sdfsdfs", // ya backend ka required field
                          "user_id": userId,
                          "collage_id": widget.id,
                          "count": selectedRating, // overall rating
                          "title": _titleController.text.trim(),
                          "description":
                          _descriptionController.text.trim(),
                          "reviewers": reviewers, // 🔥 IMPORTANT
                        };

                        setState(() => _isLoading = true);

                        try {
                          await ref.read(
                              saveReviewProvider(reviewPayload).future);
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Review submitted successfully",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );

                          // Reset
                          setState(() {
                            selectedRating = 0;
                            featureRatings.updateAll((key, value) => 0);
                          });
                          _titleController.clear();
                          _descriptionController.clear();
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Failed to save review",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },

                      child: _isLoading
                          ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF1B1B1B)
                              : Colors.white,
                        ),
                      )
                          : Text(
                        "Submit Review",
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF1B1B1B)
                              : Color(0xFF1B1B1B),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Text(
                    //   "Rating criteria",
                    //   style: GoogleFonts.roboto(
                    //       fontSize: 20.sp,
                    //       fontWeight: FontWeight.w600,
                    //       color: themeMode == ThemeMode.dark
                    //           ? Color(0xFF1B1B1B)
                    //           : Colors.white,
                    //       letterSpacing: -1),
                    // ),
                    // reviewAsync.when(
                    //   data: (data) {
                    //     if (data.collage!.nameWiseRating!.isEmpty) {
                    //       return Center(
                    //         child: Text(
                    //           "No reviews yet",
                    //           style: GoogleFonts.roboto(
                    //             fontSize: 14.sp,
                    //             color: themeMode == ThemeMode.dark
                    //                 ? Color(0xFF1B1B1B)
                    //                 : Colors.white,
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //     return ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: NeverScrollableScrollPhysics(),
                    //       padding: EdgeInsets.only(top: 10.h),
                    //       itemCount: data.collage!.nameWiseRating!.length,
                    //       itemBuilder: (context, index) {
                    //         final list = data.collage?.nameWiseRating;
                    //         final inde = list![index];
                    //         // FIX: average rating null-safe
                    //         final double avg = double.tryParse(
                    //                 inde.averageRating?.toString() ?? "0") ??
                    //             0.0;
                    //         final int rating = avg.clamp(0, 5).toInt();

                    //         return Padding(
                    //           padding: EdgeInsets.only(
                    //             bottom: 10.h,
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Text(
                    //                 inde.name ?? "N/A",
                    //                 style: GoogleFonts.inter(
                    //                     fontSize: 16.sp,
                    //                     fontWeight: FontWeight.w500,
                    //                     color: themeMode == ThemeMode.dark
                    //                         ? Color(0xFF1B1B1B)
                    //                         : Colors.white,
                    //                     letterSpacing: -0.55),
                    //               ),
                    //               Spacer(),

                    //               // 3. Filled Stars (Full Icons)
                    //               ...List.generate(
                    //                 rating, // Number of filled stars
                    //                 (i) => const Icon(
                    //                   Icons.star, // Filled star icon
                    //                   color: Colors.amber,
                    //                   size: 20.0,
                    //                 ),
                    //               ),
                    //               // 4. Outlined Stars (Empty Icons)
                    //               ...List.generate(
                    //                 5 - rating, // Remaining stars (5 - filled stars)
                    //                 (i) => const Icon(
                    //                   Icons.star_border, // Outlined star icon
                    //                   color: Colors
                    //                       .amber, // Use the same color for visual consistency
                    //                   size: 20.0,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    //   error: (error, stackTrace) {
                    //     log("${error.toString()} /n ${stackTrace.toString()}");
                    //     return Center(
                    //       child: Text(error.toString()),
                    //     );
                    //   },
                    //   loading: () => Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // ),
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
