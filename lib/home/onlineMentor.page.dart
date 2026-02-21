/*
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnlineMentorPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> onlineMentors;
  const OnlineMentorPage({
    super.key,
    required this.onlineMentors,
  });

  @override
  ConsumerState<OnlineMentorPage> createState() => _OnlineMentorPageState();
}

class _OnlineMentorPageState extends ConsumerState<OnlineMentorPage> {
  final _searchController = TextEditingController();
  String query = "";
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final filteredMentors = widget.onlineMentors.where((mentor) {
      final name = mentor['full_name']?.toString().toLowerCase() ?? '';
      final services = mentor['service_type']?.toString().toLowerCase() ?? '';

      return name.contains(query.toLowerCase()) ||
          services.contains(query.toLowerCase());
    }).toList();
    return Scaffold(
      backgroundColor:
          // themeMode == ThemeMode.dark
          //     ? const Color(0xFF1B1B1B)
          //     :
          Color(0xff9088F1),
      appBar: AppBar(
        backgroundColor:
            // themeMode == ThemeMode.dark
            //     ? const Color(0xFF1B1B1B)
            //     :
            Color(0xff9088F1),
        title: Text(
          "Online Mentors",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                  hintText: "Search mentors...",
                  hintStyle: GoogleFonts.roboto(
                      color: Colors.white70, fontSize: 18.sp),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white, size: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              )),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
                // color: Colors.white

                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xFF1B1B1B),
              ),
              child: filteredMentors.isEmpty
                  ? Center(
                      child: Text(
                        "No Online Mentor",
                        style: TextStyle(color: Color(0xFF1B1B1B)),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        final item = filteredMentors[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => MentorDetailPage(
                                            id: item['id'] ?? 0,
                                          )));
                            },
                            child: UserTabs(
                              image: item['profile_pic'] ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                              id: item['id'],
                              fullname: item['full_name'] ?? "No Name",
                              dec: item['description'] ?? "N/A",
                              // servicetype: item['service_type'] == null
                              //     ? []
                              //     : item['service_type']
                              //         .toString()
                              //         .split(',')
                              //         .map((e) => e.trim())
                              //         .toList(),
                              servicetype: item['serviceType'],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
*/

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class OnlineMentorPage extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> onlineMentors;
  const OnlineMentorPage({
    super.key,
    required this.onlineMentors,
  });

  @override
  ConsumerState<OnlineMentorPage> createState() => _OnlineMentorPageState();
}

class _OnlineMentorPageState extends ConsumerState<OnlineMentorPage> {
  final _searchController = TextEditingController();
  String query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final filteredMentors = widget.onlineMentors.where((mentor) {
      final name = (mentor['full_name'] ?? '').toString().toLowerCase();
      final service = (mentor['service_type'] ?? '').toString().toLowerCase();
      return name.contains(query.toLowerCase()) ||
          service.contains(query.toLowerCase());
    }).toList();

    final backgroundColor =
        isDark ? const Color(0xffF5F5F5) : const Color(0xFF121212);
    final cardColor = isDark ? Colors.white : const Color(0xFF1E1E1E);
    final textColor = isDark ? Colors.black87 : Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xff9088F1), // header / top color
      appBar: AppBar(
        backgroundColor: const Color(0xff9088F1),
        title: const Text(
          "Online Mentors",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 18.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Search mentors...",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 16.sp),
                filled: true,
                fillColor: Colors.white.withOpacity(0.25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white70, size: 22),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: filteredMentors.isEmpty
                  ? Center(
                      child: Text(
                        "No Online Mentors Found",
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        final mentor = filteredMentors[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => MentorDetailPage(
                                    id: mentor['id'] ?? 0,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: cardColor,
                              elevation: isDark ? 2 : 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: MentorData(
                                // image: mentor['profile_pic']
                                //             ?.toString()
                                //             .isNotEmpty ==
                                //         true
                                //     ? mentor['profile_pic']
                                //     : "https://via.placeholder.com/150",
                                // id: mentor['id'],
                                // fullname: mentor['full_name']?.toString() ??
                                //     "Unknown",
                                // dec: mentor['description']?.toString() ??
                                //     "No description",
                                // servicetype:
                                //     mentor['serviceType'] ?? "No servicetype",

                                image: mentor['profile_pic'] ??
                                    "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                id: mentor['id'],
                                fullname: mentor['full_name'] ?? "No Name",
                                dec: mentor['description'] ?? "N/A",
                                servicetype: mentor['service_type'] == null
                                    ? []
                                    : mentor['service_type']
                                        .toString()
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class MentorData extends StatelessWidget {
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> servicetype;

  const MentorData({
    super.key,
    required this.image,
    required this.id,
    required this.fullname,
    required this.dec,
    required this.servicetype,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(25, 0, 0, 0), width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                height: 111.h,
                width: 112.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      image.isNotEmpty
                          ? image
                          : "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  fullname,
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  dec,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(height: 0.5.h, color: Colors.grey.shade400),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 30.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: servicetype.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Container(
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(225, 222, 221, 236),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Center(
                              child: Text(
                                servicetype[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF1B1B1B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
