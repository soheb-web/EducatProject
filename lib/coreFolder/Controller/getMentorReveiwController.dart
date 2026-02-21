import 'package:educationapp/coreFolder/Model/getMentorReviewModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMentorReviewController =
    FutureProvider.family<GetmentorReviewModel, String>(
  (ref, id) async {
    final service = APIStateNetwork(createDio());
    return await service.getmentorReview(id);
  },
);
