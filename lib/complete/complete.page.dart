
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:educationapp/coreFolder/Controller/getProfileUserProvider.dart';
import 'package:educationapp/coreFolder/Controller/getSkillProvider.dart';
import 'package:educationapp/coreFolder/Controller/homeDataController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Controller/userProfileController.dart';
import 'package:educationapp/coreFolder/Model/getProfileUserModel.dart';
import 'package:educationapp/coreFolder/auth/login.auth.dart';
import 'package:educationapp/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/CollegeSearchModel.dart';
import 'dart:developer' as developer;

import '../coreFolder/Model/SearchCompanyModel.dart';

final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

final searchCollegeProvider = FutureProvider.autoDispose<SearchCollegeModel>(
      (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(queryParamsProvider);
    developer.log('SearchCollege API called with params: $params',
        name: 'searchCollegeProvider');
    return await ApiController.searchCollege(client, params);
  },
);


final companyQueryParamsProvider =
StateProvider<Map<String, String>>((ref) => {});

final searchCompanyProvider = FutureProvider.autoDispose<SearchCompanyModel>(
      (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(companyQueryParamsProvider);
    developer.log('SearchCompany API called with params: $params');
    return await ApiController.searchCompany(client, params);
  },
);

class ProfileCompletionWidget extends ConsumerStatefulWidget {
  final bool data;

  const ProfileCompletionWidget(this.data, {super.key});

  @override
  ConsumerState<ProfileCompletionWidget> createState() =>
      _ProfileCompletionWidgetState();
}

class _ProfileCompletionWidgetState
    extends ConsumerState<ProfileCompletionWidget> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final totalExperienceController = TextEditingController();
  final optionsController = TextEditingController();
  final languagesController = TextEditingController();
  final linkedinController = TextEditingController();
  final aboutController = TextEditingController();
  final interestController = TextEditingController();
  final collegeController = TextEditingController();
  final eductionController = TextEditingController();
  final companyNameController = TextEditingController();
  final jobRoleController = TextEditingController();
  final jobLocationController = TextEditingController();
  final salaryController = TextEditingController();
  final dateController = TextEditingController();
  File? resumeFile;
  String? resume;
  bool buttonLoder = false;
  String? qualification;
  String? gender;
  List<String> selectedSkills = [];
  List<String> selectedSkillIds = [];
  List<String> qualificationList = [
    "10th",
    "12th",
    "Diploma",
    "graduate",
    "Postgraduate"
  ];
  List<String> genderList = ["Male", "Female", "Other"];
  List<String> interests = [];
  File? _image;
  String? _networkImage;
  File? _image1;
  String? _networkImage1;
  final picker = ImagePicker();
  void addInterest() {
    if (interestController.text.trim().isEmpty) return;
    setState(() {
      interests.add(interestController.text.trim());
    });
    interestController.clear();
  }
  @override
  void initState() {
    loadProfileData();
    super.initState();
  }
  @override
  void dispose() {
    fullNameController.dispose();
    totalExperienceController.dispose();
    optionsController.dispose();
    interestController.dispose();
    languagesController.dispose();
    linkedinController.dispose();
    aboutController.dispose();
    dateController.dispose();
    super.dispose();
  }
  Future pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final compressed = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '${pickedFile.path}_compressed.jpg',
          quality: 50, // Reduce size
        );

        setState(() {
          _image = compressed != null
              ? File(compressed.path)
              : File(pickedFile.path);
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
        final compressed = await FlutterImageCompress.compressAndGetFile(
          pickedFile.path,
          '${pickedFile.path}_compressed.jpg',
          quality: 50, // Reduce size
        );

        setState(() {
          _image1 = compressed != null
              ? File(compressed.path)
              : File(pickedFile.path);
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Camera permission denied");
    }
  }
  Future<void> showFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          resumeFile = File(result.files.single.path!);
          resume = null; // ← yeh line sabse important hai
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "File pick failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  DateTime? selectedDate;
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      dateController.text = formatted;
    }
  }
  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '${pickedFile.path}_compressed.jpg',
        quality: 60,
      );
      setState(() {
        _image =
            compressed != null ? File(compressed.path) : File(pickedFile.path);
      });
    }
  }
  Future pickImageFromGallery1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '${pickedFile.path}_compressed.jpg',
        quality: 60,
      );
      setState(() {
        _image1 =
            compressed != null ? File(compressed.path) : File(pickedFile.path);
      });
    }
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
                pickImageFromCamera(); // agar camera chahiye to implement kar lena
              },
              child: const Text("Camera"),
            ),
          ],
        );
      },
    );
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
                pickImageFromCamera1(); // agar camera chahiye to implement kar lena
              },
              child: const Text("Camera"),
            ),

            // camera option agar chahiye
          ],
        );
      },
    );
  }
  Future<void> loadProfileData() async {
    final profileAsyncValue = await ref.read(getProfileUserProvider.future);
    if (profileAsyncValue.data != null) {
      final data = profileAsyncValue.data!;
      setState(() {
        fullNameController.text = data.fullName ?? "";
        totalExperienceController.text = data.totalExperience ?? '';
        optionsController.text = data.usersField ?? '';
        languagesController.text = data.languageKnown ?? '';
        linkedinController.text = data.linkedinUser ?? '';
        aboutController.text = data.description ?? '';
        dateController.text = formatDate(data.dob.toString());
        jobRoleController.text = data.jobRole ?? "";
        jobLocationController.text = data.jobLocation ?? "";
        companyNameController.text = data.jobCompanyName ?? "";
        salaryController.text = data.salary ?? "";
        gender = data.gender ?? "";
        eductionController.text = data.educationYear ?? "";
        collegeController.text = data.collegeOrInstituteName ?? "";
        selectedCompanyId=data.company_id;
        selectedCollegeId = data.college_id;  // agar model mein collegeId field hai
        qualification = data.highestQualification ?? "";
        selectedSkills = data.skills!.toList();
        interests = data.interest!.toList();
        _networkImage = data.profilePic;
        _networkImage1 = data.certificate;
        resume = data.resumeUpload;
      });
    }
  }
  String formatDate(String dob) {
    if (dob.isEmpty || dob == "null" || dob == "NULL") return "";
    try {
      final parsed = DateTime.tryParse(dob);
      if (parsed != null) {
        return "${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}";
      }
      if (dob.contains('-')) return dob.replaceAll('-', '/');
      return dob;
    } catch (e) {
      return dob;
    }
  }
  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (resumeFile == null && (resume == null || resume!.trim().isEmpty)) {
      Fluttertoast.showToast(
        msg: "Please upload a resume file (.pdf, .doc, or .docx)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }

    if (resumeFile != null) {
      final extension = path.extension(resumeFile!.path).toLowerCase();
      if (!['.pdf', '.doc', '.docx'].contains(extension)) {
        Fluttertoast.showToast(
          msg: "Only .pdf, .doc, .docx files are allowed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }

    setState(() => buttonLoder = true);

    try {
      var box = Hive.box('userdata');
      String userType = box.get('userType', defaultValue: 'Student');

      await Auth.updateUserProfile(
        college_id: selectedCollegeId,          // ← yeh add kar do
        skills: selectedSkillIds,
        certificate: _image1,
        interest: interests,
        userType: userType,
        resumeFile: resumeFile,
        collageName: collegeController.text,
        educationYear: eductionController.text,
        gender: gender.toString(),
        language: languagesController.text,
        linkedIn: linkedinController.text,
        qualification: qualification.toString(),
        description: aboutController.text,
        fullName: fullNameController.text,
        profileImage: _image,
        dob: formatDate(dateController.text),
      );

      if (mounted) {
        setState(() => resumeFile = null);
        await loadProfileData();
        ref.invalidate(userProfileController);
        Navigator.pop(context);
      }
    } catch (e, st) {
      log('Registration error: $e');
      log(st.toString());
    } finally {
      if (mounted) setState(() => buttonLoder = false);
    }
  }
  Future<void> updateProfileMentor() async {
    if (!_formKey.currentState!.validate()) return;

    if (resumeFile == null && (resume == null || resume!.trim().isEmpty)) {
      Fluttertoast.showToast(
        msg: "Please upload a resume file (.pdf, .doc, or .docx)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return;
    }

    if (resumeFile != null) {
      final extension = path.extension(resumeFile!.path).toLowerCase();
      if (!['.pdf', '.doc', '.docx'].contains(extension)) {
        Fluttertoast.showToast(
          msg: "Only .pdf, .doc, .docx files are allowed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }

    setState(() => buttonLoder = true);

    try {
      var box = Hive.box('userdata');
      String userType = box.get('userType', defaultValue: 'Student');

      await Auth.updateUserProfileMentor(
        company_id: selectedCompanyId,          // ← yeh add kar do
        userType: userType,
        certificate: _image1,
        resumeFile: resumeFile,
        totalExperience: totalExperienceController.text,
        skills: selectedSkillIds,
        languageKnown: languagesController.text,
        linkedinUser: linkedinController.text,
        description: aboutController.text,
        fullName: fullNameController.text,
        profileImage: _image,
        dob: formatDate(dateController.text),
        companyName: companyNameController.text,
        gender: gender.toString(),
        jobLocation: jobLocationController.text,
        jobRol: jobRoleController.text,
        salary: salaryController.text,
        qualification: qualification.toString(),
        interest: interests,
      );

      if (mounted) {
        setState(() => resumeFile = null);
        await loadProfileData();
        ref.invalidate(userProfileController);
        ref.invalidate(getHomeMentorDataProvider);
        Navigator.pop(context);
      }
    } catch (e, st) {
      log('Registration error: $e');
      log(st.toString());
    } finally {
      if (mounted) setState(() => buttonLoder = false);
    }
  }
  int? selectedCollegeId;       // ← college select hone pe yeh save hoga
  int? selectedCompanyId;       // ← company select hone pe yeh save hoga
  Widget _buildFilePreview(String fileName) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 16.w, top: 6.h, bottom: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 35.sp, color: Colors.blue),
          SizedBox(height: 8.h),
          Text(
            fileName,
            style: GoogleFonts.roboto(
              fontSize: 12.w,
              color: const Color(0xFF1B1B1B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    var userType = box.get("userType");
    final skillsProvider = ref.watch(getSkillProvider);
    final themeMode = ref.watch(themeProvider);
    final collegeProvider = ref.watch(searchCollegeProvider);
    final companyProvider = ref.watch(searchCompanyProvider);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(color: const Color(0xff9088F1)),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 103.h,
                        width: 392.w,
                        decoration: const BoxDecoration(
                          color: Color(0xff9088F1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 70.h,
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
                  Positioned(
                    top: 25.h,
                    left: 20.w,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "Complete your Profile",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.w,
                            letterSpacing: -0.95,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp),
                      ),
                    ),
                    child: skillsProvider.when(
                      data: (snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.h),
                            RegisterField(
                              type: TextInputType.name,
                              controller: fullNameController,
                              label: 'Full Name',
                              validator: (value) => value!.isEmpty
                                  ? 'Full Name is required'
                                  : null,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 30.w),
                                Text(
                                  "Upload Resume/CV",
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.w,
                                    fontWeight: FontWeight.w400,
                                    color: themeMode == ThemeMode.dark
                                        ? const Color(0xFF4D4D4D)
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 25.w, right: 25.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.sp),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: showFilePicker,
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      margin: EdgeInsets.all(10.sp),
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color(0xff9088F1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Choose File',
                                          style: GoogleFonts.roboto(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: resumeFile != null
                                        ? _buildFilePreview(
                                            resumeFile!.path.split('/').last)
                                        : (resume != null &&
                                                resume!.trim().isNotEmpty)
                                            ? _buildFilePreview(resume!
                                                .split('/')
                                                .last
                                                .split('?')
                                                .first)
                                            : Padding(
                                                padding: EdgeInsets.all(8.w),
                                                child: Text(
                                                  'Upload Resume +',
                                                  style: const TextStyle(
                                                      color: Color(0xFF1B1B1B)),
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // yahan se baaki fields daal dena (skills dropdown, qualification, gender, dob, etc.)
                            // time ke wajah se pura paste nahi kar raha, lekin jo tune diya tha woh sab same rahega

                            FormField<List<String>>(
                              initialValue: selectedSkills,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "Required"
                                      : null,
                              builder: (field) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 28.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TypeAheadField<dynamic>(
                                        builder:
                                            (context, controller, focusNode) {
                                          return TextField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            controller: controller,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              hintText: "Select Skills",
                                              hintStyle: TextStyle(
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Colors.black
                                                        : Colors.white,
                                              ),
                                              // ... aapka existing decoration style ...
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.r)),
                                            ),
                                          );
                                        },
                                        suggestionsCallback: (pattern) {
                                          final query = pattern.toLowerCase();
                                          return snapshot.data
                                              .where((skill) =>
                                                  skill.title
                                                      .toLowerCase()
                                                      .contains(query) &&
                                                  !selectedSkills
                                                      .contains(skill.title))
                                              .toList();
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                              dense: true,
                                              tileColor:
                                                  themeMode == ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                              title: Text(
                                                suggestion.title,
                                                style: TextStyle(
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              ));
                                        },
                                        onSelected: (suggestion) {
                                          setState(() {
                                            // Duplicate check double safety ke liye
                                            if (!selectedSkills
                                                .contains(suggestion.title)) {
                                              selectedSkills
                                                  .add(suggestion.title);
                                              selectedSkillIds.add(
                                                  suggestion.id.toString());
                                            }
                                          });

                                          field.didChange(selectedSkills);
                                        },
                                      ),
                                      SizedBox(height: 8.h),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: selectedSkills
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          String name = entry.value;

                                          return Chip(
                                            deleteIconColor:
                                                themeMode == ThemeMode.dark
                                                    ? Colors.black
                                                    : Colors.white,
                                            backgroundColor:
                                                themeMode == ThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                            label: Text(
                                              name,
                                              style: TextStyle(
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Colors.black
                                                        : Colors.white,
                                              ),
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                selectedSkills.removeAt(index);
                                                selectedSkillIds
                                                    .removeAt(index);
                                              });
                                              field.didChange(selectedSkills);
                                            },
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                            if (userType == "Mentor" ||
                                userType == "Professional") ...[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 28.w, vertical: 20.h),
                                child: DropdownButtonFormField(
                                  dropdownColor: themeMode == ThemeMode.light
                                      ? Color(0xFF1B1B1B)
                                      : Colors.white,
                                  value: qualification == null
                                      ? null
                                      : (qualificationList
                                              .where((item) =>
                                                  item.toLowerCase() ==
                                                  qualification!.toLowerCase())
                                              .isNotEmpty
                                          ? qualification
                                          : null),
                                  decoration: InputDecoration(
                                    labelText: 'Highest Qualification',
                                    labelStyle: GoogleFonts.roboto(
                                      fontSize: 13.w,
                                      fontWeight: FontWeight.w400,
                                      // color: const Color(0xFF4D4D4D),
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF1B1B1B)
                                          : Colors.white,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: const BorderSide(
                                          color: Color(0xff9088F1)),
                                    ),
                                  ),
                                  items: qualificationList
                                      .map((qualification) => DropdownMenuItem(
                                            value: qualification,
                                            child: Text(
                                              qualification,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.w,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF4D4D4D)
                                                        : Colors.white,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      qualification = value;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? 'Qualification is required'
                                      : null,
                                ),
                              ),
                              RegisterField(
                                controller: jobRoleController,
                                label: 'Job Role',
                                validator: (value) => value!.isEmpty
                                    ? 'Job Role are required'
                                    : null,
                              ),
                              RegisterField(
                                controller: jobLocationController,
                                label: 'Job Location',
                                validator: (value) => value!.isEmpty
                                    ? 'Job Location are required'
                                    : null,
                              ),
                           /*   RegisterField(
                                controller: companyNameController,
                                label: 'Company Name',
                                validator: (value) => value!.isEmpty
                                    ? 'Company  are required'
                                    : null,
                              ),*/
                              // ────────────────────────────────────────────────────────────────
//                  Company Name – TypeAheadField (same as College)
// ────────────────────────────────────────────────────────────────
                              SizedBox(height: 10.h),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Company Name",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w400,
                                        color: themeMode == ThemeMode.light
                                            ? Colors.white70
                                            : const Color(0xFF4D4D4D),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    TypeAheadField<DatumCompany>(  // ← yahan Datum company model ka use kar rahe hain
                                      controller: companyNameController,

                                      builder: (context, TextEditingController controller, FocusNode focusNode) {
                                        return Container(
                                          width: double.infinity,  // ← full width force (same as skills & college)
                                          child: TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            autofocus: false,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.search,
                                            style: TextStyle(
                                              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                              fontSize: 15.sp,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "Search your company...",
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 14.sp,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.business_outlined,  // ← company ke liye icon change kiya
                                                color: Colors.grey.shade600,
                                                size: 22.sp,
                                              ),
                                              suffixIcon: controller.text.isNotEmpty
                                                  ? IconButton(
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.grey.shade700,
                                                  size: 20.sp,
                                                ),
                                                onPressed: () {
                                                  controller.clear();
                                                  ref.read(companyQueryParamsProvider.notifier).state = {};
                                                  setState(() {});
                                                },
                                              )
                                                  : null,
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 14.h,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40.r),
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40.r),
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40.r),
                                                borderSide: const BorderSide(
                                                  color: Color(0xff9088F1),
                                                  width: 1.8,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: themeMode == ThemeMode.dark
                                                  ? Colors.white.withOpacity(0.07)
                                                  : Colors.black.withOpacity(0.04),
                                            ),
                                          ),
                                        );
                                      },

                                      // ─── Company Search Logic ───
                                      suggestionsCallback: (pattern) async {
                                        final searchText = pattern.trim();

                                        if (searchText.length < 2) {
                                          ref.read(companyQueryParamsProvider.notifier).state = {};
                                          return <DatumCompany>[];
                                        }

                                        ref.read(companyQueryParamsProvider.notifier).state = {
                                          'search': searchText,
                                        };

                                        try {
                                          final result = await ref.watch(searchCompanyProvider.future);
                                          if (result.status == true && result.data != null) {
                                            return result.data!;
                                          }
                                        } catch (e) {
                                          developer.log("Company search error: $e");
                                        }
                                        return <DatumCompany>[];
                                      },

                                      // ─── Suggestion Item UI (College jaisa hi look) ───
                                      itemBuilder: (context, DatumCompany suggestion) {
                                        return Container(
                                        color:   themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                            leading: suggestion.image != null && suggestion.image!.isNotEmpty
                                                ? CircleAvatar(
                                              radius: 24.r,
                                              backgroundImage: NetworkImage(suggestion.image!),
                                              onBackgroundImageError: (_, __) {},
                                            )
                                                : CircleAvatar(
                                              radius: 24.r,
                                              backgroundColor: Colors.grey.shade200,
                                              child: Icon(Icons.business, color: Colors.grey.shade600),
                                            ),
                                            title: Text(
                                              suggestion.collageName ?? "Unknown Company",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp,
                                                color: themeMode == ThemeMode.dark ?Colors.black87: Colors.white ,
                                              ),
                                            ),
                                            subtitle: Text(
                                              [
                                                suggestion.city ?? '',
                                                suggestion.location ?? '',
                                              ].where((e) => e.isNotEmpty).join(', '),
                                              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                                            ),
                                          ),
                                        );
                                      },

                                      onSelected: (DatumCompany suggestion) {
                                        companyNameController.text = suggestion.collageName ?? '';
                                        selectedCompanyId = suggestion.id;   // ← company ka ID save kar rahe hain
                                        companyNameController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: companyNameController.text.length),
                                        );
                                      },

                                      loadingBuilder: (context) => Padding(
                                        padding: EdgeInsets.all(20.h),
                                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                                      ),

                                      hideOnEmpty: false,
                                      hideOnLoading: false,
                                      hideOnError: true,
                                      debounceDuration: const Duration(milliseconds: 400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              RegisterField(
                                controller: salaryController,
                                label: 'Salary',
                                validator: (value) => value!.isEmpty
                                    ? 'Salary  are required'
                                    : null,
                              ),
                              SizedBox(height: 10.h),
                              RegisterField(
                                type: TextInputType.number,
                                controller: totalExperienceController,
                                label: 'Total Experience',
                                validator: (value) => value!.isEmpty
                                    ? 'Total Experience is required'
                                    : null,
                              ),
                              // SizedBox(height: 20.h),
                            ] else ...[
                              SizedBox(height: 20.h),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 28.w),
                                child: DropdownButtonFormField(
                                  dropdownColor: themeMode == ThemeMode.light
                                      ? Color(0xFF1B1B1B)
                                      : Colors.white,
                                  value: qualification == null
                                      ? null
                                      : (qualificationList
                                              .where((item) =>
                                                  item.toLowerCase() ==
                                                  qualification!.toLowerCase())
                                              .isNotEmpty
                                          ? qualification
                                          : null),
                                  decoration: InputDecoration(
                                    labelText: 'Highest Qualification',
                                    labelStyle: GoogleFonts.roboto(
                                      fontSize: 13.w,
                                      fontWeight: FontWeight.w400,
                                      // color: const Color(0xFF4D4D4D),
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF1B1B1B)
                                          : Colors.white,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      borderSide: const BorderSide(
                                          color: Color(0xff9088F1)),
                                    ),
                                  ),
                                  items: qualificationList
                                      .map((qualification) => DropdownMenuItem(
                                            value: qualification,
                                            child: Text(
                                              qualification,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.w,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF4D4D4D)
                                                        : Colors.white,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      qualification = value;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? 'Qualification is required'
                                      : null,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              RegisterField(
                                controller: eductionController,
                                label: 'Education Year',
                                validator: (value) => value!.isEmpty
                                    ? 'Education Year are required'
                                    : null,
                              ),
                              SizedBox(height: 20.h),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "College / Institute Name",
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.w,
                                              color: themeMode == ThemeMode.dark ?   Color(0xFF4D4D4D):Colors.white70
                                            ),
                                          ),


                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Label
                                                Text(
                                                  "College / Institute Name",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.w,
                                                    fontWeight: FontWeight.w500,
                                                    color: themeMode == ThemeMode.dark
                                                        ? Colors.white70
                                                        : const Color(0xFF4D4D4D),
                                                  ),
                                                ),

                                                SizedBox(height: 8.h),

                                                TypeAheadField<Datum>(

                                                  controller: collegeController,
                                                  // ─── Yeh builder ab required hai ───
                                                  builder: (context, TextEditingController controller, FocusNode focusNode) {
                                                    return TextField(

                                                      controller: controller,   // ← yeh important: provided controller use karo
                                                      focusNode: focusNode,     // ← provided focusNode use karo
                                                      autofocus: false,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.search,
                                                      style:
                                                      TextStyle(
                                                        color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                                                        fontSize: 15.sp,
                                                      ),
                                                      decoration: InputDecoration(
                                                        hintText: "Search your college / institute...",
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey.shade500,
                                                          fontSize: 14.sp,
                                                        ),
                                                        prefixIcon: Icon(
                                                          Icons.school_outlined,
                                                          color: Colors.grey.shade600,
                                                          size: 22.sp,
                                                        ),
                                                        suffixIcon: controller.text.isNotEmpty
                                                            ? IconButton(
                                                          icon: Icon(
                                                            Icons.clear,
                                                            color: Colors.grey.shade700,
                                                            size: 20.sp,
                                                          ),
                                                          onPressed: () {
                                                            controller.clear();
                                                            ref.read(queryParamsProvider.notifier).state = {};
                                                            setState(() {});
                                                          },
                                                        )
                                                            : null,
                                                        contentPadding: EdgeInsets.symmetric(
                                                          horizontal: 16.w,
                                                          vertical: 14.h,
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(40.r),
                                                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(40.r),
                                                          borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(40.r),
                                                          borderSide: const BorderSide(
                                                            color: Color(0xff9088F1),
                                                            width: 1.8,
                                                          ),
                                                        ),
                                                        // filled: true,
                                                        // fillColor: themeMode == ThemeMode.dark
                                                        //     ? Colors.black.withOpacity(0.04):  Colors.white.withOpacity(0.07)
                                                      ),
                                                    );
                                                  },



                                                  suggestionsCallback: (pattern) async {
                                                    final searchText = pattern.trim();
                                                    if (searchText.length < 2) {
                                                      ref.read(queryParamsProvider.notifier).state = {};
                                                      return <Datum>[];
                                                    }
                                                    ref.read(queryParamsProvider.notifier).state = {'search': searchText};
                                                    try {
                                                      final result = await ref.watch(searchCollegeProvider.future);
                                                      if (result.success == true && result.data != null) {
                                                        return result.data!;
                                                      }
                                                    } catch (e) {
                                                      developer.log("College search error: $e");
                                                    }
                                                    return <Datum>[];
                                                  },

                                                  itemBuilder: (context, Datum suggestion) {
                                                    return Container(
                                                   color:    themeMode == ThemeMode.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      child: ListTile(

                                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                                        leading: suggestion.image != null && suggestion.image!.isNotEmpty
                                                            ? CircleAvatar(
                                                          radius: 24.r,
                                                          backgroundImage: NetworkImage(suggestion.image!),
                                                          onBackgroundImageError: (_, __) {},
                                                        )
                                                            : CircleAvatar(
                                                          radius: 24.r,
                                                          backgroundColor: Colors.grey.shade200,
                                                          child: Icon(Icons.school, color: Colors.grey.shade600),
                                                        ),
                                                        title: Text(
                                                          suggestion.name ?? "Unknown College",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15.sp,
                                                            color: themeMode == ThemeMode.dark ?Colors.black87: Colors.white ,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          [
                                                            suggestion.city ?? '',
                                                            suggestion.state ?? '',
                                                            suggestion.country ?? '',
                                                          ].where((e) => e.isNotEmpty).join(', '),
                                                          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                                                        ),
                                                      ),
                                                    );
                                                  },

                                                  onSelected: (Datum suggestion) {
                                                    collegeController.text = suggestion.name ?? '';
                                                    selectedCollegeId = suggestion.id;   // ← ID save kar rahe hain
                                                    collegeController.selection = TextSelection.fromPosition(
                                                      TextPosition(offset: collegeController.text.length),
                                                    );
                                                  },

                                                  loadingBuilder: (context) => Padding(
                                                    padding: EdgeInsets.all(20.h),
                                                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                                                  ),

                                                  // noItemsFoundBuilder: (context) => Padding(
                                                  //   padding: EdgeInsets.all(20.h),
                                                  //   child: Text(
                                                  //     "No colleges found for this search",
                                                  //     style: TextStyle(color: Colors.grey.shade600, fontSize: 15.sp),
                                                  //     textAlign: TextAlign.center,
                                                  //   ),
                                                  // ),

                                                  hideOnEmpty: false,
                                                  hideOnLoading: false,
                                                  hideOnError: true,
                                                  debounceDuration: const Duration(milliseconds: 400),
                                                ),


                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),


                            ],
                            SizedBox(height: 25.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28.w),
                              child: DropdownButtonFormField(
                                dropdownColor: themeMode == ThemeMode.light
                                    ? Color(0xFF1B1B1B)
                                    : Colors.white,
                                // value: gender,
                                // ⭐ UPDATED VALUE FIX HERE
                                value: gender == null
                                    ? null
                                    : genderList.firstWhere(
                                        (item) =>
                                            item.toLowerCase() ==
                                            gender!.toLowerCase(),
                                        orElse: () => genderList[0],
                                      ),

                                decoration: InputDecoration(
                                  labelText: 'Select Gender',
                                  labelStyle: GoogleFonts.roboto(
                                    fontSize: 13.w,
                                    fontWeight: FontWeight.w400,
                                    // color: const Color(0xFF4D4D4D),
                                    color: themeMode == ThemeMode.dark
                                        ? Color(0xFF1B1B1B)
                                        : Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.sp),
                                    borderSide: const BorderSide(
                                        color: Color(0xff9088F1)),
                                  ),
                                ),
                                items: genderList
                                    .map((gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(
                                            gender,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.w,
                                              color: themeMode == ThemeMode.dark
                                                  ? Color(0xFF4D4D4D)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'gender is required' : null,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 28.w, right: 28.w, top: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date of birth",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.w,
                                      // fontWeight: FontWeight.w400,
                                      //color: const Color(0xFF4D4D4D),
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  TextFormField(
                                    onTap: () {
                                      pickDate();
                                    },
                                    controller: dateController,
                                    style: TextStyle(
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 10.w, top: 20.h, bottom: 20.h),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.date_range_outlined,
                                        color: Color(0xFFC8C8C8),
                                      ),
                                      hintText: "Date of Birth",
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        // fontWeight: FontWeight.w600,
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xFF1B1B1B)
                                            : Colors.white,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select your date of birth';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),

                            RegisterField(
                              controller: languagesController,
                              label: 'Languages known',
                              validator: (value) => value!.isEmpty
                                  ? 'Languages known is required'
                                  : null,
                            ),
                            SizedBox(height: 15.h),
                            RegisterField(
                              controller: linkedinController,
                              label: 'Github/Drive/Behance/link',
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Github/Drive/Behance/link is required';
                                return null;
                              },
                            ),

                            // RegisterField(
                            //   controller: interestController,
                            //   maxLine: 2,
                            //   label: 'Interest',
                            //   validator: (value) => value!.isEmpty
                            //       ? 'Interest is required'
                            //       : null,
                            // ),

                            /// 🔹 TextField
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 28.w, right: 28.w, top: 28.h),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: interestController,
                                textInputAction: TextInputAction.done,
                                onSaved: (_) => addInterest(),
                                decoration: InputDecoration(
                                  hintText: "Add Interest",
                                  hintStyle: TextStyle(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    onPressed: addInterest,
                                  ),
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
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Please add atleast one interested";
                                //   }
                                //   return null;
                                // },
                              ),
                            ),

                            SizedBox(height: 10),

                            /// 🔹 Show Added Interests
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 28.w, right: 28.w),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: interests.map((item) {
                                    return Chip(
                                      backgroundColor:
                                          themeMode == ThemeMode.dark
                                              ? Colors.white
                                              : Colors.black,
                                      label: Text(
                                        item,
                                        style: TextStyle(
                                          color: themeMode == ThemeMode.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      deleteIcon: Icon(
                                        Icons.close,
                                        color: themeMode == ThemeMode.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      onDeleted: () {
                                        setState(() {
                                          interests.remove(item);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            // ===== ABOUT FIELD (100 words limit) =====
                            SizedBox(height: 20.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "About",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.w,
                                      fontWeight: FontWeight.w400,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  TextFormField(
                                    controller: aboutController,
                                    minLines: 3,
                                    maxLines: null, // Auto expand
                                    keyboardType: TextInputType.multiline,
                                    inputFormatters: [
                                      WordLimitInputFormatter(
                                          100), // ← Tumhari class use ki
                                    ],
                                    decoration: InputDecoration(
                                      counterText:
                                          '', // ← Yeh line add kar do (empty string)
                                      hintText:
                                          "Tell us about yourself (max 100 words)",
                                      hintStyle: GoogleFonts.roboto(
                                          color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.sp),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.sp),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.sp),
                                        borderSide: const BorderSide(
                                            color: Color(0xff9088F1)),
                                      ),
                                      // Optional: Real-time word counter
                                      // counterText: "${aboutController.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length}/100 words",
                                    ),
                                    style: TextStyle(
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'About is required';
                                      }
                                      final wordCount = value
                                          .trim()
                                          .split(RegExp(r'\s+'))
                                          .where((w) => w.isNotEmpty)
                                          .length;
                                      if (wordCount > 100) {
                                        return 'About cannot exceed 100 words (current: $wordCount)';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile Photo",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showImage();
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  width: 360.w,
                                  height: 250.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: Colors.grey)),
                                  child: _image != null
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              child: Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                                width: 360.w,
                                                height: 250.h,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFDCF881)),
                                                  onPressed: () {
                                                    showImage();
                                                  },
                                                  icon: Icon(Icons.edit,
                                                      color:
                                                          Color(0xFF1B1B1B))),
                                            )
                                          ],
                                        )
                                      : (_networkImage != null &&
                                              _networkImage!.isNotEmpty
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  child: Image.network(
                                                    _networkImage!,
                                                    fit: BoxFit.cover,
                                                    width: 360.w,
                                                    height: 250.h,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.upload_sharp,
                                                          color:
                                                              Color(0xff9088F1),
                                                          size: 30.sp,
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                      style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              Color(
                                                                  0xFFDCF881)),
                                                      onPressed: () {
                                                        showImage();
                                                      },
                                                      icon: Icon(Icons.edit,
                                                          color: Color(
                                                              0xFF1B1B1B))),
                                                )
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_sharp,
                                                  color: Color(0xff9088F1),
                                                  size: 30.sp,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            )),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),

                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 28.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Certificate",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: themeMode == ThemeMode.dark
                                          ? Color(0xFF4D4D4D)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showImage1();
                              },
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  width: 360.w,
                                  height: 250.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: Colors.grey)),
                                  child: _image1 != null
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              child: Image.file(
                                                _image1!,
                                                fit: BoxFit.cover,
                                                width: 360.w,
                                                height: 250.h,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFDCF881)),
                                                  onPressed: () {
                                                    showImage1();
                                                  },
                                                  icon: Icon(Icons.edit,
                                                      color:
                                                          Color(0xFF1B1B1B))),
                                            )
                                          ],
                                        )
                                      : (_networkImage1 != null &&
                                              _networkImage1!.isNotEmpty
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r),
                                                  child: Image.network(
                                                    _networkImage1!,
                                                    fit: BoxFit.cover,
                                                    width: 360.w,
                                                    height: 250.h,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.upload_sharp,
                                                          color:
                                                              Color(0xff9088F1),
                                                          size: 30.sp,
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: IconButton(
                                                      style: IconButton.styleFrom(
                                                          backgroundColor:
                                                              Color(
                                                                  0xFFDCF881)),
                                                      onPressed: () {
                                                        showImage1();
                                                      },
                                                      icon: Icon(Icons.edit,
                                                          color: Color(
                                                              0xFF1B1B1B))),
                                                )
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_sharp,
                                                  color: Color(0xff9088F1),
                                                  size: 30.sp,
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            )),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),


                            // end mein submit button
                            GestureDetector(
                              onTap: buttonLoder
                                  ? null
                                  : () {
                                      if (userType == "Mentor" ||
                                          userType == "Professional") {
                                        updateProfileMentor();
                                      } else {
                                        updateProfile();
                                      }
                                    },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 28.w, vertical: 10.h),
                                height: 52.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  color: const Color(0xFFDCF881),
                                ),
                                child: Center(
                                  child: buttonLoder
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          "Submit Now",
                                          style: GoogleFonts.roboto(
                                            color: const Color(0xFF1B1B1B),
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
                        );
                      },
                      error: (error, stackTrace) {
                        log(stackTrace.toString());
                        return Center(child: Text(error.toString()));
                      },
                      loading: () => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w),
      child: Column(
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
      ),
    );
  }
}
class WordLimitInputFormatter extends TextInputFormatter {
  final int maxWords;

  WordLimitInputFormatter(this.maxWords);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final words = newValue.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;

    if (words <= maxWords) {
      return newValue;
    }
    return oldValue;
  }
}