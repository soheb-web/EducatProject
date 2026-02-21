import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import '../utils/preety.dio.dart';
import 'package:path/path.dart' as path;

class Auth {
  static Future<void> updateUserProfile({
    required String userType,
    required String fullName,

     int? college_id,

    required List<String> interest,
    required List<String> skills,
    File? resumeFile,
    File? certificate,
    required String qualification,
    required String educationYear,
    required String collageName,
    required String gender,
    required String dob,
    // required List<String> skills_id,
    required String description,
    required String language,
    required String linkedIn,
    File? profileImage,
  }) async {
    try {
      final dio = await createDio();
      final url = 'https://educatservicesindia.com/admin/api/update-profile';

      final Map<String, dynamic> body = {
        'user_type': userType,
        'full_name': fullName,
        'college_id': college_id,
        'highest_qualification': qualification,
        'college_or_institute_name': collageName,
        'language_known': language,
        'linkedin_user': linkedIn,
        'description': description,
        'gender': gender,
        'dob': dob,
        // "skills_id": skills_id,
        "education_year": educationYear,
      };

      // Resume File
      if (resumeFile != null) {
        body['resume_upload'] = await MultipartFile.fromFile(
          resumeFile.path,
          filename: path.basename(resumeFile.path),
        );
      }

      if (certificate != null) {
        body['certificate'] = await MultipartFile.fromFile(
          certificate.path,
          filename: path.basename(certificate.path),
        );
      }
      // Profile Image (IMPORTANT)
      if (profileImage != null) {
        body['profile_pic'] = await MultipartFile.fromFile(
          profileImage.path,
          filename: path.basename(profileImage.path),
        );
      }

      final formData = FormData.fromMap(body);

      // ✅ Corrected: Interest loop
      for (final item in interest) {
        formData.fields.add(MapEntry('interest[]', item));
      }

// ✅ FIX: Interest ki jagah 'skills' list ko use karein
      for (final item in skills) {
        formData.fields.add(MapEntry('skills_id[]', item));
      }

      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final box = await Hive.openBox('userdata');
        final userId = response.data['data']['id'].toString(); // Corrected
        await box.put('user_id', userId); // Use 'user_id' instead of 'token'
        Fluttertoast.showToast(
          msg: response.data['message'] ?? 'Profile updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Profile update successful');
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          error: response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Failed to update profile';
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $errorMessage');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $e');
    }
  }

  static Future<void> updateUserProfileMentor({
    required String userType,
    File? resumeFile,
    File? certificate,
    required String fullName,
     int? college_id,
     int? company_id,
    required String jobRol,
    required String jobLocation,
    required String companyName,
    required String salary,
    required String totalExperience,
    required String gender,
    required String dob,
    required String qualification,
    File? profileImage,
    required String languageKnown,
    required String linkedinUser,
    required String description,
    required List<String> skills,
    required List<String> interest,
  }) async {
    try {
      final dio = await createDio();
      final url = 'https://educatservicesindia.com/admin/api/update-profile';

      final Map<String, dynamic> body = {
        'user_type': userType,
        'total_experience': totalExperience,
        //'skills_id': skills_id,
        'company_id':company_id,
        'college_id':college_id,
        'language_known': languageKnown,
        'linkedin_user': linkedinUser,
        'description': description,
        'full_name': fullName,
        // 'interest': interest,
        'dob': dob,
        "job_role": jobRol,
        "job_location": jobLocation,
        "job_company_name": companyName,
        "gender": gender,
        'salary': salary,
        'highest_qualification': qualification,
        // "skills": skills,
      };

      // Resume File
      if (resumeFile != null) {
        body['resume_upload'] = await MultipartFile.fromFile(
          resumeFile.path,
          filename: path.basename(resumeFile.path),
        );
      }

      if (certificate != null) {
        body['certificate'] = await MultipartFile.fromFile(
          certificate.path,
          filename: path.basename(certificate.path),
        );
      }

      // Profile Image (IMPORTANT)
      if (profileImage != null) {
        body['profile_pic'] = await MultipartFile.fromFile(
          profileImage.path,
          filename: path.basename(profileImage.path),
        );
      }

      final formData = FormData.fromMap(body);

      for (final item in interest) {
        formData.fields.add(MapEntry('interest[]', item));
      }

// ✅ FIX: Interest ki jagah 'skills' list ko use karein
      for (final item in skills) {
        formData.fields.add(MapEntry('skills_id[]', item));
      }
      final response = await dio.post(url, data: formData);

      log("UPLOAD RESPONSE = ${response.data}");

      if (response.statusCode == 200) {
        final box = await Hive.openBox('userdata');
        final userId = response.data['data']['id'].toString(); // Corrected
        await box.put('user_id', userId); // Use 'user_id' instead of 'token'
        Fluttertoast.showToast(
          msg: response.data['message'] ?? 'Profile updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Profile update successful: ${response.data}');
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          error: response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Failed to update profile';
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $errorMessage');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to update profile: $e');
    }
  }
}
