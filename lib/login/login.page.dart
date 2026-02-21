/*
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/login.body.model.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/forgot/forgotPassword.page.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff9088F1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 343.h,
                        width: 392.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loginBack.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 250.h,
                        width: 250.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/whitevector.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.white,
                  color: themeMode == ThemeMode.light
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.w),
                    topRight: Radius.circular(40.w),
                  ),
                ),
                child: const RegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false; // Renamed for clarity
  bool secure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> fcmGetToken() async {
    const int maxRetries = 6; // प्रयासों की संख्या बढ़ाएँ
    const Duration initialDelay =
        Duration(seconds: 2); // पहला विलंब 2 सेकंड का रखें
    const Duration maxTotalWait =
        Duration(seconds: 15); // अधिकतम 15 सेकंड इंतजार करें
    DateTime startTime = DateTime.now();

    // अनुमति केवल पहले प्रयास में
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return "no_permission";
    }

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      // ⏳ चेक करें कि क्या कुल प्रतीक्षा समय पार हो गया है
      if (DateTime.now().difference(startTime) > maxTotalWait) {
        log('FCM Token fetching aborted after 15 seconds.');
        break; // लूप तोड़ दें
      }

      // हर प्रयास से पहले एक्सपोनेंशियल विलंब (2s, 4s, 6s, आदि)
      await Future.delayed(initialDelay * attempt);

      try {
        String? Fcmtoken = await FirebaseMessaging.instance.getToken();

        if (Fcmtoken != null) {
          log('FCM Token (Attempt $attempt): $Fcmtoken');
          return Fcmtoken; // ✅ सफलता
        }

        log('FCM Token is null on attempt $attempt. Retrying...');
      } catch (e) {
        log('FCM Token Error on attempt $attempt: $e');

        if (attempt == maxRetries ||
            DateTime.now().difference(startTime) > maxTotalWait) {
          // 🛑 अंतिम विफलता, उपयोगकर्ता को Play Services ठीक करने का निर्देश दें
          Fluttertoast.showToast(
            msg:
                "Notification Error. Play Services busy. Please clear Google Play Services data/cache or restart your phone.",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
          );
          return "error_fetching_token";
        }
      }
    }
    return "error_fetching_token";
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      // 🔄 संशोधित fcmGetToken फंक्शन का उपयोग करें
      final deviceToken = await fcmGetToken();

      // 🛑 FIX 1: यदि टोकन प्राप्त करने में त्रुटि हुई है, तो यहाँ रुकें
      if (deviceToken == "error_fetching_token" ||
          deviceToken == "no_permission") {
        // fcmGetToken पहले ही टोस्ट दिखा चुका है, इसलिए हम बस लोडिंग बंद करेंगे।
        setState(() {
          isLoading = false;
        });
        return; // Login process यहीं रोक दिया जाएगा
      }

      try {
        final body = LoginBodyModel(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          deviceToken: deviceToken,
        );

        final service = APIStateNetwork(createDio());
        final response = await service.login(body);

        if (response.data != null) {
          final box = await Hive.openBox('userdata');
          await box.clear();
          await box.put('token', response.data!.token);
          await box.put('full_name', response.data!.fullName);
          await box.put('userType', response.data!.userType);
          await box.put('email', response.data!.email);
          await box.put('userid', response.data!.userid);

          Fluttertoast.showToast(msg: response.message!);
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (_) => HomePage(0)),
            (route) => false,
          );
        } else {
          // ✅ Clean failure handling for invalid credentials
          Fluttertoast.showToast(
            msg: response.message ?? "Invalid credentials",
            backgroundColor: Colors.purple,
          );
        }
      } on DioException catch (e) {
        final error = e.response!.data['error'];
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
        );
      } catch (e, st) {
        log("Login exception: $e\n$st");
        Fluttertoast.showToast(msg: "Unexpected error");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final themeMode = ref.watch(themeProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          Text(
            "Welcome Back !",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 26.w,
                letterSpacing: -0.95,
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : Color(
                        0xFF1B1B1B,
                      )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 15.w,
                  letterSpacing: -0.50,
                  color: themeMode == ThemeMode.light
                      ? Colors.white
                      : Color(
                          0xFF1B1B1B,
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartPAge(),
                    ),
                  );
                },
                child: Text(
                  "Sign up",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.w,
                    letterSpacing: -0.50,
                    color: const Color(0xff9088F1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: const Divider(height: 1),
          ),
          SizedBox(height: 10.h),
          RegisterField(
            controller: emailController,
            label: 'Email Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email field required";
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return "Enter a valid email address";
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(right: 28.w, left: 28.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Password",
                      style: GoogleFonts.roboto(
                        fontSize: 13.w,
                        fontWeight: FontWeight.w400,
                        // color: const Color(0xFF4D4D4D),
                        color: themeMode == ThemeMode.dark
                            ? Color(0xFF4D4D4D)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  style: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF4D4D4D)
                        : Colors.white,
                  ),
                  controller: passwordController,
                  obscureText: secure,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            secure = !secure;
                          });
                        },
                        child: Icon(
                          secure ? Icons.visibility_off : Icons.visibility,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF4D4D4D)
                              : Colors.white,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeMode == ThemeMode.dark
                            ? Colors.grey
                            : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password field required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.only(
                        left: 15.w, right: 20.w, top: 6.h, bottom: 6.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ));
                },
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: themeMode == ThemeMode.dark
                        ? Color(0xFF1B1B1B)
                        : Colors.white,
                  ),
                )),
          ),
          //  SizedBox(height: 10.h),
          GestureDetector(
            onTap: isLoading
                ? null
                : _handleLogin, // Disable button during loading
            child: Container(
              height: 52.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color: const Color(0xFFDCF881),
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF1B1B1B)),
                        ),
                      )
                    : Text(
                        "Login",
                        style: GoogleFonts.roboto(
                          color: Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                          fontSize: 14.4.w,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class RegisterField extends ConsumerStatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? type;
  final bool obscureText;
  final int? maxLine;
  final String? Function(String?)? validator;

  const RegisterField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.maxLine,
    this.type,
  });

  @override
  ConsumerState<RegisterField> createState() => _RegisterFieldState();
}

class _RegisterFieldState extends ConsumerState<RegisterField> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.only(top: 10.h, right: 28.w, left: 28.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.roboto(
                  fontSize: 13.w,
                  fontWeight: FontWeight.w400,
                  // color: const Color(0xFF4D4D4D),
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF4D4D4D)
                      : Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextFormField(
            style: TextStyle(
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF4D4D4D)
                  : Colors.white,
            ),
            controller: widget.controller,
            obscureText: widget.obscureText,
            maxLines: widget.maxLine,
            keyboardType: widget.type,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  // color: Color(0xFF1B1B1B),
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFF4D4D4D)
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  //color: Colors.grey
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Controller/getSaveSkillListController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/login.body.model.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/forgot/forgotPassword.page.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:educationapp/splash/getstart.page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: const Color(0xff9088F1),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.48,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 343.h,
                        width: 392.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loginBack.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 250.h,
                        width: 250.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/whitevector.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.52,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeMode == ThemeMode.light
                      ? const Color(0xFF1B1B1B)
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.w),
                    topRight: Radius.circular(40.w),
                  ),
                ),
                child: const RegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool secure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────
  //          Safe FCM Token Fetching (Best Practice)
  // ────────────────────────────────────────────────
  Future<String> getFcmTokenSafely() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        developer.log('Notification permission denied');
        return "";
      }

      const maxRetries = 3;
      Duration delay = const Duration(seconds: 2);

      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          final token = await FirebaseMessaging.instance
              .getToken()
              .timeout(const Duration(seconds: 10), onTimeout: () => null);

          if (token != null && token.isNotEmpty) {
            developer.log('FCM Token success (attempt $attempt): $token');
            return token;
          }

          if (attempt == maxRetries) break;

          await Future.delayed(delay);
          delay *= 2; // 2s → 4s → 8s
        } catch (e) {
          developer.log('getToken attempt $attempt failed: $e');
          if (attempt == maxRetries) break;
          await Future.delayed(delay);
          delay *= 2;
        }
      }

      developer.log('Could not fetch FCM token after $maxRetries attempts');

      if (kDebugMode) {
        Fluttertoast.showToast(
          msg:
              "Notifications might be delayed.\nWe'll try again in background.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.orange,
        );
      }

      return "";
    } catch (e, stack) {
      developer.log('FCM critical error: $e\n$stack');
      if (kDebugMode) {
        Fluttertoast.showToast(
          msg: "FCM issue: $e",
          backgroundColor: Colors.red,
        );
      }
      return "";
    }
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    // Get token — never blocks login
    final deviceToken = await getFcmTokenSafely();

    try {
      final body = LoginBodyModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        deviceToken:
            deviceToken, // can be empty string — backend should accept it
      );

      final service = APIStateNetwork(createDio());
      final response = await service.login(body);

      if (response.data != null) {
        final box = await Hive.openBox('userdata');
        await box.clear();
        await box.put('token', response.data!.token);
        await box.put('full_name', response.data!.fullName);
        await box.put('userType', response.data!.userType);
        await box.put('email', response.data!.email);
        await box.put('userid', response.data!.userid);

        Fluttertoast.showToast(
          msg: response.message ?? "Login successful!",
          backgroundColor: Colors.green,
        );

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => HomePage(0)),
          (route) => false,
        );
        ref.invalidate(getSaveSkillListControlelr);
      } else {
        Fluttertoast.showToast(
          msg: response.message ?? "Invalid credentials",
          backgroundColor: Colors.purple,
        );
      }
    } on DioException catch (e) {
      String errorMsg = e.response?.data['error'] ?? "Network error occurred";
      Fluttertoast.showToast(msg: errorMsg, backgroundColor: Colors.red);
    } catch (e) {
      developer.log("Login unexpected error: $e");
      Fluttertoast.showToast(
          msg: "Something went wrong", backgroundColor: Colors.red);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25.h),
            Text(
              "Welcome Back!",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 28.w,
                color: themeMode == ThemeMode.light
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account? ",
                  style: GoogleFonts.roboto(
                    fontSize: 15.w,
                    color: themeMode == ThemeMode.light
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GetStartPAge()),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.w,
                      color: const Color(0xff9088F1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            RegisterField(
              label: 'Email Address',
              controller: emailController,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return "Email is required";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return "Enter valid email";
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            // Password field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: GoogleFonts.roboto(
                    fontSize: 14.w,
                    color: themeMode == ThemeMode.light
                        ? Colors.white70
                        : const Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: passwordController,
                  obscureText: secure,
                  style: TextStyle(
                    color: themeMode == ThemeMode.light
                        ? Colors.white
                        : const Color(0xFF1B1B1B),
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        secure ? Icons.visibility_off : Icons.visibility,
                        color: themeMode == ThemeMode.light
                            ? Colors.white70
                            : Colors.grey,
                      ),
                      onPressed: () => setState(() => secure = !secure),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      borderSide: BorderSide(
                        color: themeMode == ThemeMode.light
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Password is required";
                    if (value.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => const ForgotPasswordPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.roboto(
                    color: const Color(0xff9088F1),
                    fontSize: 14.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: isLoading ? null : _handleLogin,
              child: Container(
                height: 52.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF881),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          height: 28.h,
                          width: 28.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1B1B1B)),
                          ),
                        )
                      : Text(
                          "Login",
                          style: GoogleFonts.roboto(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B1B1B),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class RegisterField extends ConsumerWidget {
  final TextInputType? type;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const RegisterField({
    this.type,
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14.w,
            color: themeMode == ThemeMode.light
                ? Colors.white70
                : const Color(0xFF4D4D4D),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: themeMode == ThemeMode.light
                ? Colors.white
                : const Color(0xFF1B1B1B),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: BorderSide(
                color:
                    themeMode == ThemeMode.light ? Colors.white : Colors.grey,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
