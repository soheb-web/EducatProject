import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/ReviewGetCompanyModel.dart';
import '../network/api.state.dart';
import '../Model/ReviewGetModel.dart';
import '../utils/preety.dio.dart';

final reviewCollegeProvider =
    FutureProvider.autoDispose.family<ReviewGetModel, int>((ref, id) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);
  return await service.getReview(id.toString());
});


final reviewCompanyProvider =
    FutureProvider.autoDispose.family<ReviewGetCompanyModel, int>((ref, id) async {
  final dio = await createDio();
  final service = APIStateNetwork(dio);


  return await service.getReviewCompany(id.toString());
});
