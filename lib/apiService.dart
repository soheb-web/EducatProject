import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:educationapp/coreFolder/Model/sendNotifcationBodyModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'coreFolder/Model/bodyNewModel.dart';

class ApiService {
  final Dio dio = Dio();



  Future<void> sendNotification({
    required String title,
    required String b,
    required String mentorId,
  }) async {
    try {
      final body = SendNotifcationBodyModel(
         title: title, body: b, mentorId: mentorId);
      final service = APIStateNetwork(createDio());
      final respons = await service.sendNotifcation(body);
      if (respons.response.statusCode == 200 ||
          respons.response.statusCode == 200) {
        //Fluttertoast.showToast(msg: "send Notification");
      }
    } catch (e, st) {
      log(e.toString());
    }
  }




  Future<void> sendNotificationMentor({
    required String title,
    required String b,
    required String user_Id,
  }) async {
    try {
      final body = MentorBodyNotification(
        title: title, body: b, user_id: user_Id,);
      final service = APIStateNetwork(createDio());
      final respons = await service.sendNotifcationMentorside(body);
      if (respons.response.statusCode == 200 ||
          respons.response.statusCode == 200) {
        //Fluttertoast.showToast(msg: "send Notification");
      }
    } catch (e, st) {
      log(e.toString());
    }
  }
}


