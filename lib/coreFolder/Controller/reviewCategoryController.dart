import 'package:educationapp/coreFolder/Model/reviewCategoryResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewCategoryController =
    FutureProvider.family<ReivewCategoryResModel, String>(
  (ref, id) async {
    final service = APIStateNetwork(createDio());
    return await service.reviewCategory(id);
  },
);
