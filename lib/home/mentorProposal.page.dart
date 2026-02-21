import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/mentorProposalController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MentorProposalPage extends ConsumerStatefulWidget {
  const MentorProposalPage({super.key});

  @override
  ConsumerState<MentorProposalPage> createState() => _MentorProposalPageState();
}

class _MentorProposalPageState extends ConsumerState<MentorProposalPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final mentorProposalData = ref.watch(mentorProposalController);
    return Scaffold(
        body: mentorProposalData.when(
      data: (snp) {
        return ListView.builder(
          itemCount: snp.data!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final item = snp.data![index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: EdgeInsets.only(
                      left: 15.w, top: 15.h, bottom: 20.h, right: 15.w),
                  decoration: BoxDecoration(
                    color:
                        themeMode == ThemeMode.light ? null : Color(0xFFFFFFFF),
                    border: Border.all(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Color.fromARGB(
                                25,
                                88,
                                86,
                                113,
                              )),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56.h,
                            height: 56.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "item",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 40.h,
                                    height: 40.h,
                                    color: Colors.grey[300],
                                    child: CircularProgressIndicator(
                                        color: Colors.yellow),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return ClipOval(
                                    child: Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.fullName ?? "",
                                style: GoogleFonts.roboto(
                                  color: themeMode == ThemeMode.light
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFF33323F),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${item.title} | {widget.experience} Yrs",
                                style: GoogleFonts.roboto(
                                  color: themeMode == ThemeMode.light
                                      ? Color.fromARGB(170, 255, 255, 255)
                                      : Color(0xFF666666F),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Container(
                          //   width: 28.w,
                          //   height: 28.h,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Color(
                          //       0xFFF0F0F7,
                          //     ),
                          //   ),
                          //   child: Center(
                          //     child: Icon(
                          //       Icons.arrow_forward_ios,
                          //       size: 14.sp,
                          //       color: Color(0xFF1F1F26),
                          //     ),
                          //   ),
                          // ),
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              Positioned(
                                top: -12, // fine-tuned offset
                                right: -12,
                                child: Image.asset(
                                  "assets/gridbg.png",
                                ),
                              ),
                              Container(
                                width: 45.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeMode == ThemeMode.light
                                      ? Color(0xFF26252E)
                                      : Color(0xFFF0F0F7),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: themeMode == ThemeMode.light
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF1F1F26),
                                    size: 15.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Divider(
                        color: themeMode == ThemeMode.light
                            ? Color.fromARGB(25, 255, 255, 255)
                            : Colors.grey.shade300,
                        thickness: 1.w,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  if (widget.education != null && widget.education.isNotEmpty)
                          Text(
                            "Education",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          // if (widget.language != null && widget.language.isNotEmpty)
                          Text(
                            "Languages",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  if (widget.education != null && widget.education.isNotEmpty)
                          Text(
                            "B. Tech (Computer Science)",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          ),
                          //  if (widget.language != null && widget.language.isNotEmpty)
                          Text(
                            "English, Mandarin",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: themeMode == ThemeMode.light
                                    ? Color.fromARGB(170, 255, 255, 255)
                                    : Color(0xFF2E2E2E)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      error: (error, stackTrace) {
        log(stackTrace.toString());
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
