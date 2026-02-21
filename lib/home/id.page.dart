import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:educationapp/main.dart';
import 'package:educationapp/register/register.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class IdPage extends ConsumerStatefulWidget {
  const IdPage({super.key});

  @override
  ConsumerState<IdPage> createState() => _IdPageState();
}

class _IdPageState extends ConsumerState<IdPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      body: Container(
        height: 956,
        width: 440,
        decoration: BoxDecoration(
            color:
                themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B)),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            BackGroundImage(),
            IdBody(),
          ],
        ),
      ),
    );
  }
}

class IdBody extends ConsumerStatefulWidget {
  const IdBody({super.key});

  @override
  ConsumerState<IdBody> createState() => _IdBodyState();
}

class _IdBodyState extends ConsumerState<IdBody> {
  bool buttonLoader = false;
  File? _image;
  File? _image1;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          pickedFile.path + "_compressed.jpg",
          quality: 60, // lower = more compression
        );

        setState(() {
          _image = File(compressedFile!.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Gallery permission denied");
    }
  }

  Future pickImageFromGallery1() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          pickedFile.path + "_compressed.jpg",
          quality: 60, // lower = more compression
        );

        setState(() {
          _image1 = File(compressedFile!.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Gallery permission denied");
    }
  }

  Future pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          pickedFile.path + "_compressed.jpg",
          quality: 60,
        );

        setState(() {
          _image = File(compressedFile!.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Camera permission denied");
    }
  }

  Future pickImageFromCamera1() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          pickedFile.path + "_compressed.jpg",
          quality: 60,
        );

        setState(() {
          _image1 = File(compressedFile!.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Camera permission denied");
    }
  }

  Future showImage1() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromGallery1();
              },
              child: const Text("Gallery"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromCamera1();
              },
              child: const Text("Camera"),
            ),
          ],
        );
      },
    );
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromGallery();
              },
              child: const Text("Gallery"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImageFromCamera();
              },
              child: const Text("Camera"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(formDataProvider);
    final themeMode = ref.watch(themeProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 60.h, left: 20),
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFDCF881)),
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Center(
            child: Text(
              formData.userType == "Student" ? "Student ID" : "Professional ID",
              style: GoogleFonts.inter(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: themeMode == ThemeMode.dark
                    ? Color(0xFF1B1B1B)
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          InkWell(
            onTap: () {
              showImage();
            },
            child: Center(
              child: DottedBorder(
                  dashPattern: [8, 8],
                  radius: Radius.circular(20.r),
                  borderType: BorderType.RRect,
                  color: Color(0xff9088F1),
                  strokeWidth: 2.w,
                  child: Container(
                    width: 360.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: _image == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_sharp,
                                color: Color(0xff9088F1),
                                size: 30.sp,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                formData.userType == "Student"
                                    ? "Student ID"
                                    : "Professional ID",
                                style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 360.w,
                              height: 200.h,
                            ),
                          ),
                  )),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Center(
            child: Text(
              formData.userType == "Student" ? "Resume" : "Experience Letter",
              style: GoogleFonts.inter(
                fontSize: 25.sp,
                fontWeight: FontWeight.w600,
                color: themeMode == ThemeMode.dark
                    ? Color(0xFF1B1B1B)
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          InkWell(
            onTap: () {
              showImage1();
            },
            child: Center(
              child: DottedBorder(
                  dashPattern: [8, 8],
                  radius: Radius.circular(20.r),
                  borderType: BorderType.RRect,
                  color: Color(0xff9088F1),
                  strokeWidth: 2.w,
                  child: Container(
                    width: 360.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: _image1 == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_sharp,
                                color: Color(0xff9088F1),
                                size: 30.sp,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                formData.userType == "Student"
                                    ? "Resume"
                                    : "Experience Letter",
                                style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.file(
                              _image1!,
                              fit: BoxFit.cover,
                              width: 360.w,
                              height: 200.h,
                            ),
                          ),
                  )),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          SizedBox(
            height: 50.h,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // ✅ Step 1: Determine which message to show based on userType
                final data = formData.userType == "Student"
                    ? "Please select Student ID Card"
                    : "Please select Professional ID Card";
                if (_image == null || _image!.path.isEmpty) {
                  Fluttertoast.showToast(msg: data);
                  return;
                }
                final data1 = formData.userType == "Student"
                    ? "Please select Resume"
                    : "Please select Experience Letter";
                if (_image1 == null || _image1!.path.isEmpty) {
                  Fluttertoast.showToast(msg: data1);
                  return;
                }
                setState(() {
                  buttonLoader = true;
                });

                // ✅ Step 2: Validate if image is picked
                try {
                  // ✅ Step 3: Save image path in Riverpod provider
                  ref
                      .read(myFormDataProvider.notifier)
                      .setIdCarPic(_image!.path);
                  ref
                      .read(myFormDataProvider.notifier)
                      .setExperience_letterc(_image1!.path);

                  await ref.read(myFormDataProvider.notifier).register();

                  Fluttertoast.showToast(msg: "Register Successfull");

                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false,
                  );
                  setState(() {
                    buttonLoader = false;
                  });
                } on DioException catch (e, st) {
                  setState(() => buttonLoader = false);
                  String extractErrorMessages(dynamic errorData) {
                    if (errorData == null) return "Something went wrong";

                    if (errorData['errors'] != null) {
                      final errors =
                          errorData['errors'] as Map<String, dynamic>;

                      final buffer = StringBuffer();

                      errors.forEach((key, value) {
                        if (value is List && value.isNotEmpty) {
                          buffer.writeln(value.first);
                        }
                      });

                      return buffer.toString().trim();
                    }

                    return errorData['message'] ?? "Unknown error";
                  }

                  final data = e.response?.data;

                  final errorMessage = extractErrorMessages(data);

                  Fluttertoast.showToast(
                    msg: errorMessage,
                    textColor: Colors.red,
                    toastLength: Toast.LENGTH_LONG,
                  );

                  log("Register Error: ${e.response?.data}");
                  log(st.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDCF881),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.r),
                ),
                fixedSize: Size(400.w, 60.h),
              ),
              child: buttonLoader
                  ? Center(
                      child: SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    )
                  : Text(
                      "Submit",
                      style: GoogleFonts.roboto(
                        color: Color(0xFF1B1B1B),
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.4,
                        fontSize: 14.4.w,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class FromDataMode {
  String? email;
  String? password;
  String? confirmPass;
  String? fullName;
  String? phoneNumber;
  String? dob;
  String? userType;
  String? serviceType;
  String? profileImage;
  String? idCardImage;
  String? experience_letter;

  FromDataMode({
    this.email,
    this.password,
    this.confirmPass,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.userType,
    this.serviceType,
    this.profileImage,
    this.idCardImage,
    this.experience_letter,
  });

  FromDataMode copyWith({
    String? email,
    String? passwprd,
    String? confirmPass,
    String? fullName,
    String? dob,
    String? phoneNumber,
    String? userType,
    String? serviceType,
    String? profileImage,
    String? idCardImage,
    String? experience_letter,
  }) {
    return FromDataMode(
      email: email ?? this.email,
      password: passwprd ?? this.password,
      confirmPass: confirmPass ?? this.confirmPass,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      userType: userType ?? this.userType,
      serviceType: serviceType ?? this.serviceType,
      profileImage: profileImage ?? this.profileImage,
      idCardImage: idCardImage ?? this.idCardImage,
      experience_letter: experience_letter ?? this.experience_letter,
    );
  }
}

class FormDataNotifier extends StateNotifier<FromDataMode> {
  final APIStateNetwork api;
  FormDataNotifier(this.api) : super(FromDataMode());

  void setName(String name) => state = state.copyWith(fullName: name);

  void setEmail(String email) => state = state.copyWith(email: email);

  void setPassword(String password) =>
      state = state.copyWith(passwprd: password);

  void setConfriPassword(String confirmpassword) =>
      state = state.copyWith(confirmPass: confirmpassword);

  void setPhone(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  // void setDOB(String dob) => state = state.copyWith(dob: dob);

  void setUserType(String type) => state = state.copyWith(userType: type);

  void setSerType(String type) => state = state.copyWith(serviceType: type);

  // void setProfilePicture(String path) =>
  //     state = state.copyWith(profileImage: path);

  void setIdCarPic(String path) => state = state.copyWith(idCardImage: path);
  void setExperience_letterc(String path) =>
      state = state.copyWith(experience_letter: path);

  Future<void> register() async {
    try {
      // File? profileFile;
      File? idCardFile;
      File? exprienceFile;

      // if (state.profileImage != null && state.profileImage!.isNotEmpty) {
      //   profileFile = File(state.profileImage!);
      // }
      if (state.idCardImage != null && state.idCardImage!.isNotEmpty) {
        idCardFile = File(state.idCardImage!);
      }
      if (state.experience_letter != null &&
          state.experience_letter!.isNotEmpty) {
        exprienceFile = File(state.experience_letter!);
      }

      final response = await api.registerUser(
        state.fullName ?? "",
        state.email ?? "",
        state.phoneNumber ?? "",
        state.password ?? "",
        state.confirmPass ?? "",
        // state.dob ?? "",
        state.userType ?? "",
        state.serviceType ?? "",
        // profileFile,
        idCardFile,
        exprienceFile,
      );

      log("✅ Registered successfully: $response");
    } catch (e, st) {
      log("❌ Registration failed: $e");
      log(st.toString());
      rethrow;
    }
  }
}

final myFormDataProvider =
    StateNotifierProvider<FormDataNotifier, FromDataMode>((ref) {
  return FormDataNotifier(APIStateNetwork(createDio()));
});
