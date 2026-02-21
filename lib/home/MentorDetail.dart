import 'dart:developer';
import 'package:educationapp/apiService.dart';
import 'package:educationapp/coreFolder/Controller/getMentorReveiwController.dart';
import 'package:educationapp/coreFolder/Controller/getRequestStudentController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/sendRequestBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:educationapp/home/mentorAddReview.page.dart';
import 'package:educationapp/notificationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import '../coreFolder/Controller/profileController.dart';
import 'AddReviewPage.dart';
import 'MentorReviewViewAll.dart';

class MentorDetailPage extends ConsumerStatefulWidget {
  final int id;
  MentorDetailPage({super.key, required this.id});

  @override
  ConsumerState<MentorDetailPage> createState() => _MentorDetailPageState();
}

class _MentorDetailPageState extends ConsumerState<MentorDetailPage> {
  bool isLoading = false;
  final api = ApiService();
  Future<void> sendConnectRequest() async {
    setState(() {
      isLoading = true;
    });
    try {
      final body = SendRequestBodyModel(mentorId: widget.id);
      final service = APIStateNetwork(createDio());
      final response = await service.studentSendRequest(body);

      if (response.status == true) {
        api.sendNotification(
            mentorId: widget.id.toString(),
            title: 'New Mentorship Request',
            b: 'You have received a new mentorship request');
        Fluttertoast.showToast(msg: response.message);
        ref.invalidate(getRequestStudentController); // keep this
        ref.read(requestRefreshTrigger.notifier).state =
            !ref.read(requestRefreshTrigger); // toggle to trigger rebuild
        ref.invalidate(profileProvider(widget.id));
        // Do not add to connectedMentors or set isConnected here - wait for API refresh to confirm status
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (e, st) {
      log("${e.toString()} \n $st");
      Fluttertoast.showToast(msg: "No Request sent");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? token;
  @override
  void initState() {
    super.initState();
    NotificationService.init();
    _loadToken();
  }

  Future<void> _loadToken() async {
    token = await NotificationService.getToken();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(widget.id));
    final getMentorReviewProvider =
        ref.watch(getMentorReviewController(widget.id.toString()));
    final themeMode = ref.watch(themeProvider);
    var box = Hive.box('userdata');

    return Scaffold(
      backgroundColor: Colors.white,
      body: profileAsync.when(
        data: (profile) {
          final mentorRequestsList = profile.mentorRequests;

          final String? status = (mentorRequestsList != null)
              ? mentorRequestsList.status
              : null; // यदि लिस्ट खाली है तो null

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(profileProvider(widget.id));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // IMPORTANT
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 20.w),
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Color(0xFF1B1B1B),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "Mentor Details",
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            height: 170.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (profile.backgroundImage != null &&
                                        profile.backgroundImage!.isNotEmpty)
                                    ? NetworkImage(profile.backgroundImage!)
                                    : const AssetImage(
                                        'assets/images/student_cover.png',
                                      ) as ImageProvider,
                              ),
                            ),
                            child: profile.backgroundImage == null ||
                                    profile.backgroundImage!.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.school,
                                          size: 40.sp,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "No Cover Photo",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),
                          Container(
                            //   color: Colors.white,
                            color: themeMode == ThemeMode.light
                                ? Color(0xFF1B1B1B)
                                : Colors.white,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  top: 100.h, left: 20.w, right: 20.w),
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile.fullName!,
                                        style: GoogleFonts.roboto(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                          //color: Color(0xFF1B1B1B),
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      if (profile.jobRole != null &&
                                          profile.jobRole!.isNotEmpty)
                                        Text(
                                          profile.jobRole ?? "No Job",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      if (profile.jobCompanyName != null &&
                                          profile.jobCompanyName!.isNotEmpty)
                                        Text(
                                          "${profile.jobCompanyName ?? "No company"} * ${profile.jobLocation}",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),

                                      // if (profile.skills != null)
                                      //   if (profile.skills is List &&
                                      //       profile.skills!.isNotEmpty)
                                      //     Wrap(
                                      //       spacing: 10.w,
                                      //       runSpacing: 10.h,
                                      //       children: (profile.skills as List)
                                      //           .map<Widget>(
                                      //             (skill) => Text(
                                      //               skill.toString(),
                                      //               style: GoogleFonts.roboto(
                                      //                 fontSize: 20.sp,
                                      //                 fontWeight:
                                      //                     FontWeight.w600,
                                      //                 color: Color(0xFF1B1B1B),
                                      //               ),
                                      //             ),
                                      //           )
                                      //           .toList(),
                                      //     )
                                      //   else
                                      //     Text(
                                      //       profile.skills.toString(),
                                      //       style: GoogleFonts.roboto(
                                      //         fontSize: 16.sp,
                                      //         fontWeight: FontWeight.w600,
                                      //         color: themeMode == ThemeMode.dark
                                      //             ? Color(0xFF1B1B1B)
                                      //             : Colors.white,
                                      //       ),
                                      //     )
                                      // else
                                      //   Text(
                                      //     'No skills',
                                      //     style: GoogleFonts.roboto(
                                      //       fontSize: 12.sp,
                                      //       fontWeight: FontWeight.w600,
                                      //       color: themeMode == ThemeMode.dark
                                      //           ? Color(0xFF1B1B1B)
                                      //           : Colors.white,
                                      //     ),
                                      //   ),
                                      // Text(
                                      //   "Total Exprience ${profile.totalExperience ?? 'No experience'}",
                                      //   style: GoogleFonts.roboto(
                                      //     fontSize: 15.sp,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: themeMode == ThemeMode.dark
                                      //         ? Color(0xFF1B1B1B)
                                      //         : Colors.white,
                                      //   ),
                                      // ),
                                      // Text(
                                      //   '${profile.companiesWorked ?? 'N/A'}',
                                      //   style: GoogleFonts.roboto(
                                      //     fontSize: 16.sp,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: themeMode == ThemeMode.dark
                                      //         ? Color(0xFF1B1B1B)
                                      //         : Colors.white,
                                      //   ),
                                      // ),

                                      SizedBox(height: 15.w),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10.w, top: 10.h, right: 10.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: isLoading
                                                  ? null
                                                  : () async {
                                                      if (status == null ||
                                                          status.toLowerCase() ==
                                                              "connected") {
                                                        await sendConnectRequest();
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Request already: $status");
                                                      }
                                                    },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                height: 50.h,
                                                width: 160.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: status == "connected"
                                                      ? Color(0xff9088F1)
                                                      : status == "pending"
                                                          ? Colors.red
                                                          : status == "accepted"
                                                              ? Colors.green
                                                              : Colors.grey,
                                                ),
                                                child: Center(
                                                  child: isLoading
                                                      ? SizedBox(
                                                          width: 30.w,
                                                          height: 30.h,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 2.w,
                                                          ),
                                                        )
                                                      : Text(
                                                          status == "connected"
                                                              ? "Send Request"
                                                              : status ==
                                                                      "pending"
                                                                  ? "Pending"
                                                                  : status ==
                                                                          "accepted"
                                                                      ? "Accepted"
                                                                      : "Send Request",
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            if (status == "accepted") ...[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            ChatingPage(
                                                                otherUesrid:
                                                                    profile
                                                                        .id
                                                                        .toString(),
                                                                id: box
                                                                    .get(
                                                                        "userid")
                                                                    .toString(),
                                                                name: profile
                                                                    .fullName
                                                                    .toString()),
                                                      ));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w, right: 10.w),
                                                  height: 50.h,
                                                  width: 160.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff008080)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Message",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff008080),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              InkWell(
                                                onTap: () {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Request not accepted yet!");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w, right: 10.w),
                                                  height: 50.h,
                                                  width: 140.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff008080)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Message",
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff008080),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 10.h,
                                            left: 10.w,
                                            right: 10.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color(0xff9088F1))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "About ${profile.fullName}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF1B1B1B)
                                                        : Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 3.h),
                                            if (profile.totalExperience !=
                                                    null &&
                                                profile.totalExperience!
                                                    .isNotEmpty)
                                              Text(
                                                "${profile.totalExperience} Yrs Exprience of ${profile.jobRole}.",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                            SizedBox(height: 3.h),
                                            if (profile.description != null &&
                                                profile.description!.isNotEmpty)
                                              Text(
                                                profile.description ??
                                                    "No description",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),

                                      Container(
                                          margin: EdgeInsets.only(top: 10.h),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(
                                              top: 10.h,
                                              bottom: 10.h,
                                              left: 10.w,
                                              right: 10.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              border: Border.all(
                                                  color: Color(0xff9088F1))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Educations",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xFF1B1B1B)
                                                      : Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              if (profile.highestQualification !=
                                                      null &&
                                                  profile.highestQualification!
                                                      .isNotEmpty)
                                                Text(
                                                  profile.highestQualification ??
                                                      "No qualification",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: themeMode ==
                                                            ThemeMode.dark
                                                        ? Color(0xff666666)
                                                        : Colors.white,
                                                  ),
                                                ),
                                            ],
                                          )),
                                      SizedBox(height: 15.h),

                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 10.h,
                                            left: 10.w,
                                            right: 10.w),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: Color(0xff9088F1))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Experience",
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF1B1B1B)
                                                        : Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            if (profile.totalExperience !=
                                                    null &&
                                                profile.totalExperience!
                                                    .isNotEmpty)
                                              Text(
                                                "${profile.totalExperience ?? "No"} Year Exprience",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                            if (profile.jobRole != null &&
                                                profile.jobRole!.isNotEmpty)
                                              Text(
                                                "${profile.jobRole ?? "No"}",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                            if (profile.jobCompanyName !=
                                                    null &&
                                                profile
                                                    .jobCompanyName!.isNotEmpty)
                                              Text(
                                                "${profile.jobCompanyName ?? "No"}",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                            SizedBox(height: 5.h),
                                            if (profile.collegeOrInstituteName !=
                                                    null &&
                                                profile.collegeOrInstituteName!
                                                    .isNotEmpty)
                                              Text(
                                                profile.collegeOrInstituteName ??
                                                    "No",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Color(0xff666666)
                                                      : Colors.white,
                                                ),
                                              ),
                                            SizedBox(height: 5.h),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15.h),

                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Skills",
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF1B1B1B)
                                                        : Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            if (profile.skills != null)
                                              if (profile.skills is List &&
                                                  profile.skills!.isNotEmpty)
                                                Wrap(
                                                  spacing: 10.w,
                                                  runSpacing: 10.h,
                                                  children: (profile.skills
                                                          as List)
                                                      .map<Widget>(
                                                        (skill) => Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.r),
                                                            color: const Color(
                                                                0xffDEDDEC),
                                                          ),
                                                          child: Text(
                                                            skill.toString(),
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF1B1B1B),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                )
                                              else
                                                Text(
                                                  'No skills listed',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xff666666),
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15.h),
                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),
                                      // Language
                                      _buildLanguageSection(
                                        title: "Languages",
                                        languageString: profile.languageKnown,
                                        themeMode: themeMode,
                                      ),
                                      SizedBox(height: 15.h),
                                      Divider(
                                        color: Colors.grey.shade400,
                                        thickness: 1.w,
                                      ),





                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    AddReviewPage(
                                                      id:  widget.id
                                                          .toString(),),
                                              ));

                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4.sp),
                                          height: 40.h,
                                          width: 110.w,
                                          decoration: BoxDecoration(
                                            color:
          Color(0xff9088F1),
border: Border.all(color: Color(0xff9088F1),),
                                            borderRadius: BorderRadius.circular(10),

                                          ),
                                          margin: EdgeInsets.only(top: 15.h),
                                          child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Add Review",
                                                style: GoogleFonts.roboto(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                     Colors.white
                                                ),
                                              ),


                                              SizedBox(width: 5.w,),


                                             Container(

                                               decoration: BoxDecoration(
                                                 color: Color(0xff9088F1),

                                                 borderRadius: BorderRadius.circular(30),


                                               ),

                                               child:
                                              Icon(Icons.arrow_forward_ios,size: 16.sp,)
                                             )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Reviews & Testimonials",
                                              style: GoogleFonts.roboto(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.light
                                                        ? Color(0xffDEDDEC)
                                                        : Color(0xff9088F1),
                                              ),
                                            ),


                                            GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     CupertinoPageRoute(
                                                //       builder: (context) =>
                                                //           MentoraddReviewPage(
                                                //               id: widget.id
                                                //                   .toString()),
                                                //     ));
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          Mentorreviewviewall(
                                                               id:  widget.id
                                                                   .toString(),),
                                                    ));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "View All",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: themeMode ==
                                                              ThemeMode.light
                                                          ? Color(0xffDEDDEC)
                                                          : Color(0xff9088F1),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 20.sp,
                                                    color: themeMode ==
                                                            ThemeMode.light
                                                        ? Color(0xffDEDDEC)
                                                        : Color(0xff9088F1),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),

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
                                              snp.reviews!.take(2).toList();

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
                                                      SizedBox(height: 10.h),



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

                                                      SizedBox(
                                                        height: 10.h,
                                                      ),

                                                      Text(
                                                        "Posted on ${review.createdAt?.toString().split(' ')[0] ?? ''}",
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          color:
                                                          themeMode == ThemeMode.light
                                                              ? Color(0xffDEDDEC)
                                                              : Color(0xFF201F1F),
                                                        ),
                                                      ),
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

                                      SizedBox(
                                        height: 10.h,
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 20.w,
                        right: 0,
                        top: 100.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 1.2)),
                              child: ClipOval(
                                child: profile.profilePic != null
                                    ? Image.network(
                                        profile.profilePic!,
                                        height: 141.w,
                                        width: 141.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.network(
                                          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                          height: 141.w,
                                          width: 141.w,
                                          fit: BoxFit.cover,
                                        ),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return SizedBox(
                                            height: 141.w,
                                            width: 141.w,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.amber,
                                                strokeWidth: 1,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        height: 141.w,
                                        width: 141.w,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log(stack.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () => ref.invalidate(profileProvider(widget.id)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageSection({
    required String title,
    required String? languageString,
    required ThemeMode themeMode,
  }) {
    final languages = languageString != null && languageString.isNotEmpty
        ? languageString.split(',').map((e) => e.trim()).toList()
        : [];

    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF1B1B1B)
                  : Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          languages.isNotEmpty
              ? Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: languages.map((lang) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: const Color(0xffDEDDEC),
                      ),
                      child: Text(
                        lang,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xff666666)
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  "No language specified",
                  style:
                      GoogleFonts.roboto(fontSize: 14.sp, color: Colors.black),
                ),
        ],
      ),
    );
  }
}
