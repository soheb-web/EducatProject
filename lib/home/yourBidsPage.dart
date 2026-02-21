import 'dart:developer';

import 'package:educationapp/coreFolder/Controller/homeDataController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/chating.page.dart';
import 'package:educationapp/home/home.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class YourBidsPage extends ConsumerStatefulWidget {
  const YourBidsPage({super.key});

  @override
  ConsumerState<YourBidsPage> createState() => _YourBidsPageState();
}

class _YourBidsPageState extends ConsumerState<YourBidsPage> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    final getHomeMentorData = ref.watch(getHomeMentorDataProvider);
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? Colors.white : Color(0xff9088F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
                color: themeMode == ThemeMode.dark
                    ? Color(0xFF1B1B1B)
                    : Colors.white)),
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : Color(0xff9088F1),
        title: Text(
          "Your Bids",
          style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: themeMode == ThemeMode.dark
                  ? Color(0xFF1B1B1B)
                  : Colors.white),
        ),
      ),
      body: getHomeMentorData.when(
        data: (mentorData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mentorData.data!.acceptedStudents!.isEmpty
                  ? Center(
                      child: Text(
                        "No Accepted Student",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          color: themeMode == ThemeMode.dark
                              ? Color(0xFF1B1B1B)
                              : Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mentorData.data!.acceptedStudents!.length,
                      itemBuilder: (context, index) {
                        final student =
                            mentorData.data!.acceptedStudents![index];
                        return InkWell(
                          onTap: () {
                            log(box.get("userid").toString());
                            log(
                              mentorData.data!.acceptedStudents![index].id
                                  .toString(),
                            );
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChatingPage(
                                      id: box.get("userid").toString(),
                                      otherUesrid: mentorData
                                          .data!.acceptedStudents![index].id
                                          .toString(),
                                      name: student.fullName ?? "No Name"),
                                ));
                          },
                          child: MyContainer(
                            image: student.profilePic ??
                                "https://flutter.github.io/assets-for-api-docs/assets/widgets/puffin.jpg",
                            title: student.fullName ?? "N/A",
                            email: student.email ?? "No Email",
                            description: student.description ?? "",
                          ),
                        );
                      },
                    ),
              SizedBox(height: 10.h),
            ],
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
