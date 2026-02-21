import 'package:educationapp/coreFolder/Controller/reviewController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/StudentDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowCollagePage extends ConsumerStatefulWidget {
  final int id;
  final String collagename;
  const FollowCollagePage(this.id, this.collagename, {super.key});

  @override
  ConsumerState<FollowCollagePage> createState() => _FollowCollagePageState();
}

class _FollowCollagePageState extends ConsumerState<FollowCollagePage> {
  @override
  Widget build(BuildContext context) {
    final reviewAsync = ref.watch(reviewCollegeProvider(widget.id));
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
        backgroundColor: isDark ? Colors.white : const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: Color(0xff9088F1),
          title: Text(
            '${widget.collagename} Alumni',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10.w, top: 10, bottom: 10),
              width: 3.w, // ← yeh chhota kiya
              height: 3.h, // ← yeh chhota kiya
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 6), // ← thoda kam kiya
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color:
                        themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : null,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: reviewAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(
              err.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (snap) {
            final college = snap.collage;

            if (college == null ||
                college.users == null ||
                college.users!.isEmpty) {
              return const Center(
                child: Text(
                  "No users found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final users = college.followers!;

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return GestureDetector(
                  onTap: () {
                    user.userType == "Mentor"
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MentorDetailPage(id: user.id!)))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StudenetDetailPage(id: user.id!)));
                  },
                  child: Card(
                    color: isDark ? Color(0xffF1F2F6) : Color(0xff9088F1),
                    margin: EdgeInsets.only(bottom: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundImage: user.profilePic != null &&
                                    user.profilePic!.isNotEmpty
                                ? NetworkImage(user.profilePic!)
                                : null,
                            child: user.profilePic == null ||
                                    user.profilePic!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? "Unknown User",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Color(0xff9088F1)
                                          : Color(0xffDEDDEC)),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  user.email ?? "",
                                  style: GoogleFonts.roboto(
                                      fontSize: 13.sp,
                                      color: isDark
                                          ? Color(0xFF201F1F)
                                          : Color(0xffDEDDEC)),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  user.userType ?? "",
                                  style: GoogleFonts.roboto(
                                      fontSize: 12.sp,
                                      color: isDark
                                          ? Color(0xFF666666)
                                          : Color(0xffDEDDEC)),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 14,
                              color: isDark
                                  ? Color(0xFF201F1F)
                                  : Color(0xffDEDDEC)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
