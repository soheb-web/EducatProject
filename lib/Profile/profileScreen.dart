import 'dart:developer';
import 'dart:io';
import 'package:educationapp/complete/complete.page.dart';
import 'package:educationapp/coreFolder/Controller/getMentorReveiwController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../coreFolder/Model/switchBodyMentor.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({
    super.key,
  });
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? selectbgImage;
  final ImagePicker _picker = ImagePicker();
  bool isSwitched = false; // ← ये state को कंट्रोल करता है
  Future<void> pickAndUploadImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        selectbgImage = file;
      });

      await uploadImageBackground(file);
    }
  }

  bool isLoadingSwitch = false;
  bool isMentor = false; // local state

  void showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickAndUploadImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImageBackground(File imageFile) async {
    final dio = createDio();
    final api = APIStateNetwork(dio);

    try {
      final response = await api.uploadBackgroundImage(imageFile);
      if (response.response.data['status'] == true) {
        log("Upload Success: $response");
        Fluttertoast.showToast(msg: response.response.data['message']);
        ref.invalidate(userProfileController);
      } else {
        Fluttertoast.showToast(msg: "Upload Error");
      }
    } catch (e) {
      log("Upload Error: $e");
    }
  }

  // Future<void> sendConnectRequest( {required String userType}) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final body = SwitchBodyMentor(user_type:userType );
  //     final service = APIStateNetwork(createDio());
  //     final response = await service.swichMentor(body);
  //
  //     if (response.status == true) {
  //
  //       Fluttertoast.showToast(msg: response.message);
  //
  //     } else {
  //       Fluttertoast.showToast(msg: response.message);
  //     }
  //   } catch (e, st) {
  //     log("${e.toString()} \n $st");
  //     Fluttertoast.showToast(msg: "No Request sent");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    var mentorId = box.get("userid");
    final userType = box.get("userType");
    final userProfileAsync = ref.watch(userProfileController);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: userProfileAsync.when(
        data: (userProfile) {
          // Safely extract profile data
          final profileData = userProfile.data;

          if (profileData == null) {
            return const Center(
              child: Text(
                'No profile data available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          isMentor = profileData.userType == "Mentor";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 15.h),
                  child: Text(
                    "Profile",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 170.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                // image: selectbgImage != null
                                //     ? DecorationImage(
                                //         image: FileImage(selectbgImage!),
                                //         fit: BoxFit.cover,
                                //       )
                                //     : const DecorationImage(
                                //         image: AssetImage(
                                //             'assets/images/student_cover.png'),
                                //         fit: BoxFit.cover,
                                //       ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: selectbgImage != null
                                      ? FileImage(selectbgImage!)
                                      : (profileData.backgroundImage != null &&
                                              profileData
                                                  .backgroundImage!.isNotEmpty)
                                          ? NetworkImage(profileData
                                              .backgroundImage
                                              .toString())
                                          : const AssetImage(
                                              'assets/images/student_cover.png',
                                            ) as ImageProvider,
                                ),
                              ),

                              /// 👇 TEXT SIRF TAB DIKHE JAB DONO IMAGE NA HO
                              child: (selectbgImage == null &&
                                      (profileData.backgroundImage == null ||
                                          profileData.backgroundImage!.isEmpty))
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
                                            "Add Cover Photo",
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

                            /// ✏️ Edit Button
                            Positioned(
                              right: 20,
                              top: 20,
                              child: InkWell(
                                onTap: () {
                                  showImagePicker();
                                },
                                child: Container(
                                  width: 36.w,
                                  height: 36.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      color: Color(0xff9088F1),
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: themeMode == ThemeMode.light
                              ? Color(0xFF1B1B1B)
                              : Colors.white,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: 100.h, left: 20.w, right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Expanded(
                                //       child: Text(
                                //         profileData.fullName ?? "No Name",
                                //         style: GoogleFonts.roboto(
                                //           fontSize: 24.sp,
                                //           fontWeight: FontWeight.w600,
                                //           color: themeMode == ThemeMode.dark
                                //               ? Color(0xFF1B1B1B)
                                //               : Colors.white,
                                //         ),
                                //       ),
                                //     ),
                                //
                                //     if (userType != "Student") ...[
                                //       if (userType == "Professional" || userType == "Mentor") ...[
                                //
                                //
                                //
                                //         Row(
                                //           children: [
                                //             Switch(
                                //               value: profileData.userType == "Mentor",  // provider से live value
                                //               onChanged: isLoadingSwitch
                                //                   ? null
                                //                   : (bool wantToEnableMentor) async {
                                //                 setState(() => isLoadingSwitch = true);
                                //
                                //                 // अगर switch को ON करना चाहते हैं (Professional → Mentor)
                                //                 if (wantToEnableMentor) {
                                //                   // पहले चेक: अगर पहले से Mentor है तो toast + return
                                //                   if (profileData.userType == "Mentor") {
                                //                     Fluttertoast.showToast(msg: "You are already a Mentor");
                                //                     setState(() => isLoadingSwitch = false);
                                //                     return;
                                //                   }
                                //
                                //                   // Professional है → API call करो
                                //                   try {
                                //                     final newUserType = "Mentor";
                                //                     final body = SwitchBodyMentor(user_type: newUserType);
                                //                     final service = APIStateNetwork(createDio());
                                //                     final response = await service.swichMentor(body);
                                //
                                //                     if (response.success == true) {
                                //                       Fluttertoast.showToast(msg: response.message ?? "Switched to Mentor successfully");
                                //                       ref.invalidate(userProfileController); // refresh → value update
                                //                     } else {
                                //                       Fluttertoast.showToast(
                                //                         msg: response.message ?? "Failed to switch",
                                //                         toastLength: Toast.LENGTH_LONG,
                                //                       );
                                //
                                //                       // अगर backend "already Mentor" कहे (edge case)
                                //                       if (response.message?.toLowerCase().contains("already mentor") ?? false) {
                                //                         ref.invalidate(userProfileController);
                                //                       }
                                //                     }
                                //                   } catch (e) {
                                //                     Fluttertoast.showToast(msg: "Error: ${e.toString()}");
                                //                   }
                                //                 }
                                //
                                //                 // अगर switch को OFF करना चाहते हैं (Mentor → Professional)
                                //                 else {
                                //                   // हमेशा block करो (API call मत करो)
                                //                   Fluttertoast.showToast(
                                //                     msg: "You are already a Mentor. Cannot switch back to Professional.",
                                //                     toastLength: Toast.LENGTH_LONG,
                                //                   );
                                //                   // switch को forcefully on रखो (क्योंकि value provider से आ रहा है)
                                //                   // कोई setState की जरूरत नहीं, क्योंकि value provider पर depend है
                                //                 }
                                //
                                //                 setState(() => isLoadingSwitch = false);
                                //               },
                                //               activeColor: const Color(0xFF16A34A),
                                //               activeTrackColor: const Color(0xFF16A34A).withOpacity(0.4),
                                //               inactiveThumbColor: Colors.grey[400],
                                //               inactiveTrackColor: Colors.grey[300],
                                //             ),
                                //
                                //             Text("Switch To Mentor",style: TextStyle(
                                //               color: Colors.black
                                //             ),)
                                //           ],
                                //         ),
                                //
                                //
                                //       ],
                                //     ],
                                //
                                //
                                //   ],
                                // ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Left: Name (Expanded ताकि लंबा नाम भी फिट हो)
                                    Expanded(
                                      child: Text(
                                        profileData.fullName ?? "No Name",
                                        style: GoogleFonts.roboto(
                                          fontSize: 24.sp,
                                          fontWeight:
                                              FontWeight.w700, // थोड़ा bold
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                          letterSpacing:
                                              0.2, // थोड़ा spacing बेहतर लगता है
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Right: Switch + Label (Mentor mode वाले users के लिए)
                                    if (userType != "Student" &&
                                        (userType == "Professional" ||
                                            userType == "Mentor")) ...[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // Dynamic label + icon (Mentor mode को highlight करने के लिए)
                                          // Text(
                                          //   profileData.userType == "Mentor"
                                          //       ? "Mentor Mode"
                                          //       : "Switch to Mentor",
                                          //   style: GoogleFonts.roboto(
                                          //     fontSize: 14.sp,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: profileData.userType ==
                                          //             "Mentor"
                                          //         ? const Color(
                                          //             0xFF16A34A) // green when active
                                          //         : Colors.grey[600],
                                          //   ),
                                          // ),
                                          // Switch(
                                          //   value: profileData.userType ==
                                          //       "Mentor",
                                          //   onChanged: isLoadingSwitch
                                          //       ? null
                                          //       : (bool
                                          //           wantToEnableMentor) async {
                                          //           setState(() =>
                                          //               isLoadingSwitch = true);
                                          //           if (wantToEnableMentor) {
                                          //             if (profileData
                                          //                     .userType ==
                                          //                 "Mentor") {
                                          //               Fluttertoast.showToast(
                                          //                   msg:
                                          //                       "You are already a Mentor");
                                          //               setState(() =>
                                          //                   isLoadingSwitch =
                                          //                       false);
                                          //               return;
                                          //             }
                                          //             try {
                                          //               final newUserType =
                                          //                   "Mentor";
                                          //               final body =
                                          //                   SwitchBodyMentor(
                                          //                       user_type:
                                          //                           newUserType);
                                          //               final service =
                                          //                   APIStateNetwork(
                                          //                       createDio());
                                          //               final response =
                                          //                   await service
                                          //                       .swichMentor(
                                          //                           body);
                                          //               if (response.success ==
                                          //                   true) {
                                          //                 Fluttertoast.showToast(
                                          //                     msg: response
                                          //                             .message ??
                                          //                         "Switched to Mentor successfully");
                                          //                 ref.invalidate(
                                          //                     userProfileController);
                                          //               } else {
                                          //                 Fluttertoast
                                          //                     .showToast(
                                          //                   msg: response
                                          //                           .message ??
                                          //                       "Failed to switch",
                                          //                   toastLength: Toast
                                          //                       .LENGTH_LONG,
                                          //                 );
                                          //                 if (response.message
                                          //                         ?.toLowerCase()
                                          //                         .contains(
                                          //                             "already mentor") ??
                                          //                     false) {
                                          //                   ref.invalidate(
                                          //                       userProfileController);
                                          //                 }
                                          //               }
                                          //             } catch (e) {
                                          //               Fluttertoast.showToast(
                                          //                   msg:
                                          //                       "Error: ${e.toString()}");
                                          //             }
                                          //           } else {
                                          //             Fluttertoast.showToast(
                                          //               msg:
                                          //                   "You are already a Mentor. Cannot switch back to Professional.",
                                          //               toastLength:
                                          //                   Toast.LENGTH_LONG,
                                          //             );
                                          //           }
                                          //           setState(() =>
                                          //               isLoadingSwitch =
                                          //                   false);
                                          //         },
                                          //   activeColor:
                                          //       const Color(0xFF16A34A),
                                          //   activeTrackColor:
                                          //       const Color(0xFF16A34A)
                                          //           .withOpacity(0.4),
                                          //   inactiveThumbColor:
                                          //       Colors.grey[400],
                                          //   inactiveTrackColor:
                                          //       Colors.grey[300],
                                          // ),

                                          // Text(
                                          //   profileData.userType == "Mentor"
                                          //       ? "Switch to Professional"
                                          //       : "Switch to Mentor",
                                          //   style: GoogleFonts.roboto(
                                          //     fontSize: 14.sp,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: profileData.userType ==
                                          //             "Mentor"
                                          //         ? Colors.orange
                                          //         : const Color(0xFF16A34A),
                                          //   ),
                                          // ),
                                          // SizedBox(width: 8.w),
                                          // Switch(
                                          //   value: profileData.userType ==
                                          //       "Mentor",
                                          //   onChanged: isLoadingSwitch
                                          //       ? null
                                          //       : (bool enableMentor) async {
                                          //           setState(() =>
                                          //               isLoadingSwitch = true);

                                          //           try {
                                          //             final newUserType =
                                          //                 enableMentor
                                          //                     ? "Mentor"
                                          //                     : "Professional";

                                          //             final body =
                                          //                 SwitchBodyMentor(
                                          //               user_type: newUserType,
                                          //             );

                                          //             final service =
                                          //                 APIStateNetwork(
                                          //                     createDio());

                                          //             final response =
                                          //                 await service
                                          //                     .swichMentor(
                                          //                         body);

                                          //             if (response.success ==
                                          //                 true) {
                                          //               Fluttertoast.showToast(
                                          //                   msg: response
                                          //                           .message ??
                                          //                       "User type updated successfully",
                                          //                   toastLength: Toast
                                          //                       .LENGTH_LONG);

                                          //               // refresh profile
                                          //               ref.invalidate(
                                          //                   userProfileController);
                                          //             } else {
                                          //               Fluttertoast.showToast(
                                          //                 msg: response
                                          //                         .message ??
                                          //                     "Failed to switch user type",
                                          //                 toastLength:
                                          //                     Toast.LENGTH_LONG,
                                          //               );
                                          //             }
                                          //           } catch (e) {
                                          //             Fluttertoast.showToast(
                                          //               msg:
                                          //                   "Error: ${e.toString()}",
                                          //             );
                                          //           }

                                          //           setState(() =>
                                          //               isLoadingSwitch =
                                          //                   false);
                                          //         },
                                          //   activeColor:
                                          //       const Color(0xFF16A34A),
                                          //   activeTrackColor:
                                          //       const Color(0xFF16A34A)
                                          //           .withOpacity(0.4),
                                          //   inactiveThumbColor:
                                          //       Colors.grey[400],
                                          //   inactiveTrackColor:
                                          //       Colors.grey[300],
                                          // ),
                                          Text(
                                            isMentor
                                                ? "Switch to Professional"
                                                : "Switch to Mentor",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: isMentor
                                                  ? Colors.orange
                                                  : const Color(0xFF16A34A),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),

                                          Switch(
                                            value: isMentor,
                                            onChanged: isLoadingSwitch
                                                ? null
                                                : (bool enableMentor) async {
                                                    /// ⭐ instant UI change
                                                    setState(() {
                                                      isMentor = enableMentor;
                                                      isLoadingSwitch = true;
                                                    });

                                                    final previousValue =
                                                        !enableMentor;

                                                    try {
                                                      final newUserType =
                                                          enableMentor
                                                              ? "Mentor"
                                                              : "Professional";

                                                      final body =
                                                          SwitchBodyMentor(
                                                              user_type:
                                                                  newUserType);

                                                      final service =
                                                          APIStateNetwork(
                                                              createDio());

                                                      final response =
                                                          await service
                                                              .swichMentor(
                                                                  body);

                                                      if (response.success ==
                                                          true) {
                                                        Fluttertoast.showToast(
                                                          msg: response
                                                                  .message ??
                                                              "User type updated",
                                                        );

                                                        /// background refresh
                                                        ref.invalidate(
                                                            userProfileController);
                                                      } else {
                                                        setState(() =>
                                                            isMentor =
                                                                previousValue);

                                                        Fluttertoast.showToast(
                                                          msg: response
                                                                  .message ??
                                                              "Switch failed",
                                                        );
                                                      }
                                                    } catch (e) {
                                                      setState(() => isMentor =
                                                          previousValue);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Error: ${e.toString()}");
                                                    }

                                                    setState(() =>
                                                        isLoadingSwitch =
                                                            false);
                                                  },
                                            activeColor:
                                                const Color(0xFF16A34A),
                                            activeTrackColor:
                                                const Color(0xFF16A34A)
                                                    .withOpacity(0.4),
                                            inactiveThumbColor:
                                                Colors.grey[400],
                                            inactiveTrackColor:
                                                Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),

                                if (userType != "Student") ...[
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    profileData.jobRole ?? "No Job",
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
                                  Row(
                                    children: [
                                      Text(
                                        "${profileData.jobCompanyName ?? "No company"} *",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xff666666)
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${profileData.jobLocation ?? ""}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xff666666)
                                              : Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ],

                                if (userType == "Student") ...[
                                  if (profileData.highestQualification !=
                                          null &&
                                      profileData
                                          .highestQualification!.isNotEmpty)
                                    Text(
                                      profileData.highestQualification ??
                                          "No qualification",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xff666666)
                                            : Colors.white,
                                      ),
                                    ),
                                  if (profileData.collegeOrInstituteName !=
                                          null &&
                                      profileData
                                          .collegeOrInstituteName!.isNotEmpty)
                                    Text(
                                      profileData.collegeOrInstituteName ??
                                          "No college",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xff666666)
                                            : Colors.white,
                                      ),
                                    ),
                                ],

                                SizedBox(
                                  height: 16.h,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        minimumSize: Size(400.w, 50.h),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Color(0xff9088F1))),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                ProfileCompletionWidget(true),
                                          ));
                                    },
                                    child: Text(
                                      "Upgrade Profile",
                                      style: GoogleFonts.roboto(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff9088F1)),
                                    )),

                                SizedBox(height: 20.h),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: Color(0xff9088F1))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "About ${profileData.fullName}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      if (userType != "Student")
                                        Text(
                                          "${profileData.totalExperience ?? ""} Yrs Exprience of ${profileData.jobRole ?? ""}",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                      SizedBox(height: 3.h),
                                      if (profileData.description != null &&
                                          profileData.description!.isNotEmpty)
                                        Text(
                                          profileData.description ??
                                              "No description",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
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
                                // Educations
                                Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: Color(0xff9088F1))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Education",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      if (profileData.highestQualification !=
                                              null &&
                                          profileData
                                              .highestQualification!.isNotEmpty)
                                        Text(
                                          profileData.highestQualification ??
                                              "No qualification",
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xff666666)
                                                : Colors.white,
                                          ),
                                        ),
                                      if (userType == "Student") ...[
                                        SizedBox(height: 5.h),
                                        if (profileData
                                                    .collegeOrInstituteName !=
                                                null &&
                                            profileData.collegeOrInstituteName!
                                                .isNotEmpty)
                                          Text(
                                            profileData
                                                    .collegeOrInstituteName ??
                                                "No",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        SizedBox(height: 5.h),
                                        if (profileData.educationYear != null &&
                                            profileData
                                                .educationYear!.isNotEmpty)
                                          Text(
                                            profileData.educationYear ?? "No",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                      ]
                                    ],
                                  ),
                                ),

                                // Experience
                                if (userType != "Student") ...[
                                  SizedBox(height: 15.h),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.w,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    width: MediaQuery.of(context).size.width,
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
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        if (profileData.totalExperience !=
                                                null &&
                                            profileData
                                                .totalExperience!.isNotEmpty)
                                          Text(
                                            "${profileData.totalExperience ?? "No"} Year Exprience",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (profileData.jobRole != null &&
                                            profileData.jobRole!.isNotEmpty)
                                          Text(
                                            "${profileData.jobRole ?? "No"}",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (profileData.jobCompanyName !=
                                                null &&
                                            profileData
                                                .jobCompanyName!.isNotEmpty)
                                          Text(
                                            "${profileData.jobCompanyName ?? "No"}",
                                            style: GoogleFonts.roboto(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xff666666)
                                                  : Colors.white,
                                            ),
                                          ),
                                        if (userType == "Student") ...[
                                          SizedBox(height: 5.h),
                                          if (profileData
                                                      .collegeOrInstituteName !=
                                                  null &&
                                              profileData
                                                  .collegeOrInstituteName!
                                                  .isNotEmpty)
                                            Text(
                                              profileData
                                                      .collegeOrInstituteName ??
                                                  "No",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xff666666)
                                                        : Colors.white,
                                              ),
                                            ),
                                          SizedBox(height: 5.h),
                                          if (profileData.educationYear !=
                                                  null &&
                                              profileData
                                                  .educationYear!.isNotEmpty)
                                            Text(
                                              profileData.educationYear ?? "No",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xff666666)
                                                        : Colors.white,
                                              ),
                                            ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                                SizedBox(height: 15.h),

                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                // Skills
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
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      if (profileData.skills != null &&
                                          profileData.skills!.isNotEmpty)
                                        Wrap(
                                          spacing: 10.w,
                                          runSpacing: 5.h,
                                          children: profileData.skills!
                                              .map<Widget>((skill) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: const Color(
                                                          0xffDEDDEC),
                                                    ),
                                                    child: Text(
                                                      skill.toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      else
                                        Text(
                                          'No skills listed',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black26
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

                                // Language
                                _buildLanguageSection(
                                  title: "Languages",
                                  languageString: profileData.languageKnown,
                                  themeMode: themeMode,
                                ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // Links
                                // _buildInfoSection(
                                //   title: "Github/Drive/Behance/LinkedIn",
                                //   value: profileData.linkedinUser ??
                                //       "Not provided",
                                //   themeMode: themeMode,
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // Gender
                                // _buildInfoSection(
                                //   title: "Gender",
                                //   value: profileData.gender ?? "Not specified",
                                //   themeMode: themeMode,
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // // DOB
                                // _buildInfoSection(
                                //   title: "Date of Birth",
                                //   value: profileData.dob != null
                                //       ? DateFormat('dd/MM/yyyy')
                                //           .format(profileData.dob!)
                                //       : "Not provided",
                                //   themeMode: themeMode,
                                // ),
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
                                        "Interest",
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: themeMode == ThemeMode.dark
                                              ? Color(0xFF1B1B1B)
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      if (profileData.interest != null &&
                                          profileData.interest!.isNotEmpty)
                                        Wrap(
                                          spacing: 10.w,
                                          runSpacing: 5.h,
                                          children: profileData.interest!
                                              .map<Widget>((intr) => Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 8.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      color: const Color(
                                                          0xffDEDDEC),
                                                    ),
                                                    child: Text(
                                                      intr.toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      else
                                        Text(
                                          'No interest listed',
                                          style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: themeMode == ThemeMode.dark
                                                ? Colors.black26
                                                : Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 1.w,
                                ),
                                // // Contact
                                // Text(
                                //   "Contact",
                                //   style: GoogleFonts.roboto(
                                //     fontSize: 20.sp,
                                //     fontWeight: FontWeight.w600,
                                //     color: themeMode == ThemeMode.dark
                                //         ? Color(0xFF1B1B1B)
                                //         : Colors.white,s
                                //   ),
                                // ),
                                // SizedBox(height: 10.h),
                                // Text(
                                //   "Phone: +91 ${profileData.phoneNumber ?? 'N/A'}",
                                //   style: GoogleFonts.roboto(
                                //     fontSize: 15.sp,
                                //     fontWeight: FontWeight.w600,
                                //     color: themeMode == ThemeMode.dark
                                //         ? Color(0xff666666)
                                //         : Colors.white,
                                //   ),
                                // ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                //   thickness: 1.w,
                                // ),
                                // Certificate
                                Text(
                                  "Certificate",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                if (profileData.certificate != null)
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.network(
                                        profileData.certificate!,
                                        fit: BoxFit.cover,
                                        width: 360.w,
                                        height: 250.h,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.upload_sharp,
                                              color: Color(0xff9088F1),
                                              size: 30.sp,
                                            ),
                                            SizedBox(height: 10.h),
                                            Text("Failed to load certificate"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Center(
                                    child: Text(
                                      "No certificate uploaded",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 40.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Profile Picture
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
                              child: profileData.profilePic != null
                                  ? Image.network(
                                      profileData.profilePic!,
                                      height: 141.w,
                                      width: 141.w,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;

                                        return SizedBox(
                                          height: 100.w,
                                          width: 100.w,
                                          child: CircularProgressIndicator(
                                            color: Colors.amber,
                                            strokeWidth: 1,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        height: 182.w,
                                        width: 182.w,
                                        fit: BoxFit.cover,
                                      ),
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

                if (userType != "Student") MentorReview(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log(stack.toString());
          log(error.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () => ref.refresh(userProfileController),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to avoid repeating code
  Widget _buildInfoSection({
    required String title,
    required String value,
    required ThemeMode themeMode,
  }) {
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: const Color(0xffDEDDEC),
            ),
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: themeMode == ThemeMode.dark
                    ? Color(0xff666666)
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
            color:
                themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : Colors.white,
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
                style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.black),
              ),
      ],
    ),
  );
}

///////////////////////////  Mentor Review /////////////////////////////
class MentorReview extends ConsumerWidget {
  const MentorReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = Hive.box("userdata");
    final mentorId = box.get("userid");
    final getMentorReviewProvider =
        ref.watch(getMentorReviewController(mentorId.toString()));
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reviews & Ratings",
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.light
                  ? Color(0xffDEDDEC)
                  : Color(0xff9088F1),
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
                      color: themeMode == ThemeMode.dark
                          ? const Color(0xFF1B1B1B)
                          : Colors.white,
                    ),
                  ),
                );
              }
              // 👇 Take only top 5
              final limitedReviews = snp.reviews!.take(5).toList();

              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: limitedReviews.length,
                itemBuilder: (context, index) {
                  final review = limitedReviews[index];

                  final double avg =
                      double.tryParse(review.rating.toString() ?? "") ?? 0.0;
                  final int rating = avg.clamp(0, 5).toInt();

                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        // color: Color(0xFFF1F2F6),
                        color: themeMode == ThemeMode.dark
                            ? Color(0xffF1F2F6)
                            : Color(0xff9088F1),
                      ),
                      margin: EdgeInsets.only(
                        bottom: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(
                                rating,
                                (indiex) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20.0,
                                ),
                              ),
                              ...List.generate(
                                5 - rating, // Remaining stars (5 - filled stars)
                                (i) => const Icon(
                                  Icons.star_border, // Outlined star icon
                                  color: Colors
                                      .amber, // Use the same color for visual consistency
                                  size: 20.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            review.description ?? '',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              color: themeMode == ThemeMode.light
                                  ? Color(0xffDEDDEC)
                                  : Color(0xFF666666),
                            ),
                          ),
                          Text(
                            review.userName ?? "N/A",
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              color: themeMode == ThemeMode.light
                                  ? Color(0xffDEDDEC)
                                  : Color(0xff9088F1),
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
        ],
      ),
    );
  }
}
