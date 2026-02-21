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

class AddReviewPage extends ConsumerStatefulWidget {
  final String id;

  const AddReviewPage({
    super.key,
    required this.id,

  });

  @override
  ConsumerState<AddReviewPage> createState() =>
      _AddReviewPageState();
}

class _AddReviewPageState extends ConsumerState<AddReviewPage> {
  int selectedRating = 0;
  final descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var userId = box.get("userid");
    // final getMentorReviewProvider =
    //     ref.watch(getMentorReviewController(widget.id.toString()));
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
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
                      controller: descriptionController,
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
                      onPressed: selectedRating == 0 || _isLoading
                          ? null
                          : () async {
                        log(widget.id);

                        setState(() {
                          _isLoading = true;
                        });

                        final body = MentorReviewBodyModel(
                          mentorId: widget.id,
                          description: descriptionController.text.trim(),
                          rating: selectedRating,
                        );

                        try {
                          final service = APIStateNetwork(createDio());
                          final response =
                          await service.mentorReview(body);

                          if (response.status == true) {
                            Navigator.pop(context);
                            ref.invalidate(getMentorReviewController(
                                widget.id.toString()));
                            Fluttertoast.showToast(
                                msg: response.message.toString());

                            // Reset only after success
                            setState(() {
                              selectedRating = 0;
                              descriptionController.clear();
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Something went wrong");
                          }
                        } catch (e, st) {
                          log("${e.toString()} /n ${st.toString()}");
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