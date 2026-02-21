import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/sendOTPResModel.dart';
import 'package:educationapp/coreFolder/Model/verifyOrChangePassBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/login/login.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerifyPage extends ConsumerStatefulWidget {
  final String email;
  const OtpVerifyPage({super.key, required this.email});

  @override
  ConsumerState<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends ConsumerState<OtpVerifyPage> {
  String otpValue = "";
  bool isLoading = false;
  bool isResending = false; // Added to track resend OTP loading state
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  final newpasswordController = TextEditingController();
  final confirmedPassController = TextEditingController();
  bool isShow = false;
  bool conShow = false;

  void resendOTP() async {
    setState(() {
      isResending = true;
    });
    try {
      final body = sendOTPBodyModel(email: widget.email);
      final service = APIStateNetwork(createDio());
      final response = await service.sendOTP(body);
      if (response != null) {
        Fluttertoast.showToast(msg: "OTP Send to your email");

        setState(() {
          isResending = false;
        });
      } else {
        setState(() {
          isResending = false;
        });
        Fluttertoast.showToast(msg: "something went wrong");
      }
    } on DioException catch (e, st) {
      setState(() {
        isResending = false;
      });
      final erromessage = e.response!.data['error'].toString();
      Fluttertoast.showToast(
        msg: erromessage,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      log("$e, $st");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Color(0xFFFFFFFF) : Color(0xFF1B1B1B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 0,
                    bottom: 0,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                  child: Image.asset(
                "assets/appicon.png",
                width: 170.w,
                height: 170.h,
              )),
              SizedBox(height: 30.h),
              Divider(
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                  thickness: 1),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Enter OTP Code",
                  style: GoogleFonts.roboto(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              OtpPinField(
                key: _otpPinFieldController,
                maxLength: 6,
                fieldHeight: 55.h,
                fieldWidth: 55.w,
                keyboardType: TextInputType.number,
                otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                otpPinFieldStyle: OtpPinFieldStyle(
                    activeFieldBackgroundColor: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.grey,
                    defaultFieldBackgroundColor: Colors.white,
                    activeFieldBorderColor: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Color(0xFFDCF881),
                    defaultFieldBorderColor: themeMode == ThemeMode.dark
                        ? Colors.grey
                        : Colors.white),
                onSubmit: (text) {
                  otpValue = text;
                },
                onChange: (text) {
                  setState(() {
                    otpValue = text;
                  });
                },
              ),
              SizedBox(height: 20.h),
              if (otpValue.length == 6)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New Password",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                      controller: newpasswordController,
                      obscureText: isShow ? false : true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 19.w,
                            right: 10.w,
                            top: 15.h,
                            bottom: 15.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(
                              color: themeMode == ThemeMode.dark
                                  ? Color(0xFF1B1B1B)
                                  : Colors.white,
                            ),
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  isShow = !isShow;
                                });
                              },
                              child: Icon(
                                isShow
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ))),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Confirmed Password",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF1B1B1B)
                            : Colors.white,
                      ),
                      controller: confirmedPassController,
                      obscureText: conShow ? false : true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 19.w,
                            right: 10.w,
                            top: 15.h,
                            bottom: 15.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            borderSide: BorderSide(
                              color: themeMode == ThemeMode.dark
                                  ? Color(0xFF1B1B1B)
                                  : Colors.white,
                            ),
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  conShow = !conShow;
                                });
                              },
                              child: Icon(
                                conShow
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ))),
                    ),
                  ],
                ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (newpasswordController.text.trim().isEmpty ||
                        confirmedPassController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all fields."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (newpasswordController.text.trim() !=
                        confirmedPassController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password do not match"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final body = verifyORChangePasswordBodyModel(
                          email: widget.email,
                          otp: otpValue,
                          password: newpasswordController.text,
                          passwordConfirmation: confirmedPassController.text);

                      final service = APIStateNetwork(createDio());
                      final response = await service.verifyORChangePass(body);
                      if (response != null) {
                        Fluttertoast.showToast(
                            msg: "Password Change Sucessfull");
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } on DioException catch (e, st) {
                      _otpPinFieldController.currentState!.clearOtp();
                      newpasswordController.clear();
                      confirmedPassController.clear();
                      final errormessage = e.response!.data['error'].toString();
                      log("${e.toString()} /n ${st.toString()}");
                      Fluttertoast.showToast(msg: errormessage);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCF881),
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator(
                              color: Color(0xFF1B1B1B),
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Verify",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: isResending
                      ? null
                      : () async {
                          resendOTP();
                        },
                  child: isResending
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Resend OTP",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: themeMode == ThemeMode.dark
                                ? Color(0xFFDCF881)
                                : Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
