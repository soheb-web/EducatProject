import 'package:educationapp/coreFolder/Controller/getSaveSkillListController.dart';
import 'package:educationapp/home/TendingSkill.dart';
import 'package:educationapp/home/saveSkillDetails.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedSkilListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SavedSkilListPage> createState() => _SavedSkilListPageState();
}

class _SavedSkilListPageState extends ConsumerState<SavedSkilListPage> {
  @override
  Widget build(BuildContext context) {
    // Provider call (Assuming getSaveSkillListControlelr is defined)
    final getSaveSkillListProvider = ref.watch(getSaveSkillListControlelr);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly softer grey
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          "My Saved Skills",
          style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w800,
              fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: getSaveSkillListProvider.when(
        data: (data) {
          if (data.data == null || data.data!.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: data.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final skill = data.data![index];
              return _buildEnhancedSkillCard(
                image: skill.image ?? "",
                level: skill.level ?? "BEGINNER",
                title: skill.title ?? "Untitled Skill",
                subtitle: skill.description ?? "No description available",
                callback: () {
                  // Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //       builder: (context) => SkillDetailsPage(
                  //         image: skill.image ?? "",
                  //         level: skill.level ?? "BEGINNER",
                  //         title: skill.title ?? "Untitled Skill",
                  //         subtitle:
                  //             skill.description ?? "No description available",
                  //       ),
                  //     ));
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TrendingExprtPage(
                        id: data.data![index].skillsId ?? 0,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        error: (error, stackTrace) => _buildErrorState(error.toString()),
        loading: () => _buildLoadingState(),
      ),
    );
  }

  // --- Refined Skill Card ---
  Widget _buildEnhancedSkillCard({
    required String image,
    required String title,
    required String subtitle,
    required String level,
    required VoidCallback callback,
  }) {
    Color levelColor = _getLevelColor(level);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: callback,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Image with Shadow
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        image,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, __) => Container(
                          height: 75,
                          width: 75,
                          color: Colors.grey[100],
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: levelColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                level.toUpperCase(),
                                style: TextStyle(
                                    color: levelColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  // Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Better Empty State ---
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            Icon(CupertinoIcons.square_stack_3d_up_slash,
                size: 100, color: Colors.blue.withOpacity(0.2)),
            const SizedBox(height: 24),
            Text("Your collection is empty",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey)),
            const SizedBox(height: 12),
            Text(
              "Save skills you're interested in to see them here later.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: Colors.grey[500], height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FindSkillPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff9088F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Explore Skills",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---
  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'INTERMEDIATE':
        return Colors.orange[700]!;
      case 'EXPERT':
        return Colors.purple[700]!;
      case 'BEGINNER':
        return Colors.blue[700]!;
      default:
        return Colors.teal[700]!;
    }
  }

  Widget _buildLoadingState() {
    return const Center(child: CupertinoActivityIndicator(radius: 15));
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text("Oops! Something went wrong: $error"));
  }
}
