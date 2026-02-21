import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SkillDetailsPage extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final String level;

  const SkillDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.level,
  });

  @override
  State<SkillDetailsPage> createState() => _SkillDetailsPageState();
}

class _SkillDetailsPageState extends State<SkillDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Animated Header with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xff9088F1),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: widget.image, // Hero animation ke liye
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(widget.image, fit: BoxFit.cover),
                    // Image par gradient taaki text dikhe
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 2. Body Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Badge
                  _buildLevelBadge(widget.level),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle/Organization
                  Row(
                    children: [
                      const Icon(Icons.account_balance_rounded,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        widget.subtitle,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),

                  // About Section
                  const Text(
                    "About this Skill",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "This course/skill from ${widget.subtitle} is designed to take you from a ${widget.level} level to advanced mastery. It covers all the core fundamentals and practical applications required in the industry today.",
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey[700], height: 1.6),
                  ),

                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                          Icons.timer_outlined, "Duration", "12 Weeks"),
                      _buildStatItem(
                          Icons.star_border_rounded, "Rating", "4.8/5.0"),
                      _buildStatItem(
                          Icons.people_outline_rounded, "Students", "2.5k+"),
                    ],
                  ),

                  const SizedBox(height: 100), // Bottom space for button
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Floating Action Button / Bottom Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.share_outlined, color: Colors.black),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9088F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Continue Learning",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff9088F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
            color: Color(0xff9088F1),
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
