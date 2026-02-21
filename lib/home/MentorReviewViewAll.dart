import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../coreFolder/Controller/getMentorReveiwController.dart';
import '../coreFolder/Controller/themeController.dart';
import 'mentorAddReview.page.dart';


  class Mentorreviewviewall extends ConsumerStatefulWidget {
   String id;
  Mentorreviewviewall({super.key, required this.id});

  @override
  ConsumerState<Mentorreviewviewall> createState() => _MentorreviewviewallState();
  }

  class _MentorreviewviewallState extends ConsumerState<Mentorreviewviewall> {

  @override
  Widget build(BuildContext context) {
    final getMentorReviewProvider =
    ref.watch(getMentorReviewController(widget.id.toString()));
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor:
      themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B),
      appBar:

      AppBar(
        leading:
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10.w, top: 10, bottom: 10),
            width: 3.w, // ← yeh chhota kiya
            height: 3.h, // ← yeh chhota kiya
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 6), // ← thoda kam kiya
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color:
                  themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : null,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xff9088F1),
        centerTitle: true,
        title: Text(
          "Review",
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(height: 20.h,),
          getMentorReviewProvider.when(
            data: (snp) {
              if (snp.reviews!.isEmpty) {
                return Center(
                  child: Text(
                    "No Review yet.",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: themeMode ==
                          ThemeMode.dark
                          ? const Color(0xFF1B1B1B)
                          : Colors.white,
                    ),
                  ),
                );
              }
              // 👇 Take only top 5
              final limitedReviews =
              snp.reviews!.take(5).toList();

              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics:
                NeverScrollableScrollPhysics(),
                itemCount: limitedReviews.length,
                itemBuilder: (context, index) {
                  final review =
                  limitedReviews[index];

                  final double avg =
                      double.tryParse(review.rating
                          .toString() ??
                          "") ??
                          0.0;
                  final int rating =
                  avg.clamp(0, 5).toInt();

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                MentoraddReviewPage(
                                    getmentorReviewModel:
                                    review,
                                    id: widget.id
                                        .toString()),
                          ));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 16.h,
                          bottom: 16.h),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            20.r),
                        // color: Color(0xFFF1F2F6),
                        color: themeMode ==
                            ThemeMode.dark
                            ? Color(0xffF1F2F6)
                            : Color(0xff9088F1),
                      ),
                      margin: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            review.userName ??
                                "N/A",
                            style:
                            GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              color: themeMode ==
                                  ThemeMode
                                      .light
                                  ? Color(
                                  0xffDEDDEC)
                                  : Color(
                                  0xff9088F1),
                            ),
                          ),
                          SizedBox(height: 5.h,),

                          Row(
                            mainAxisSize: MainAxisSize.min, // important

                            children: [
                              ...List.generate(
                                rating,
                                    (indiex) => Icon(
                                  Icons.star,
                                  color:
                                  Colors.amber,
                                  size: 20.0,
                                ),
                              ),
                              ...List.generate(
                                5 - rating, // Remaining stars (5 - filled stars)
                                    (i) => const Icon(
                                  Icons
                                      .star_border, // Outlined star icon
                                  color: Colors
                                      .amber, // Use the same color for visual consistency
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            review.description ??
                                '',
                            style:
                            GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: themeMode ==
                                  ThemeMode
                                      .light
                                  ? Color(
                                  0xffDEDDEC)
                                  : Color(
                                  0xFF666666),
                            ),
                          ),

                          // SizedBox(
                          //   height: 10.h,
                          // )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              log(stackTrace.toString());
              log(error.toString());
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          ),


        ],),
      ),
    );
  }
}
