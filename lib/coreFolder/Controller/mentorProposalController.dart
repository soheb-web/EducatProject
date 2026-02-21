import 'package:educationapp/coreFolder/Model/mentorProposalResModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mentorProposalController = FutureProvider<MentorproposalResModel>(
  (ref) async {
    final service = APIStateNetwork(createDio());
    return await service.mentorProposal();
  },
);
