import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../coreFolder/Controller/getNotificationController.dart';
import '../coreFolder/Controller/themeController.dart';

// Prefix ke saath import karo
import '../coreFolder/Model/getNotificationResModel.dart' as student;
import '../coreFolder/Model/mentorNotificationResModel.dart' as mentor;

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  late final String userType;

  @override
  void initState() {
    super.initState();
    final box = Hive.box("userdata");
    userType = box.get("userType") ?? "Student";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(getNotificationController);
      ref.invalidate(mentorSideNotificationController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    // final backgroundColor = isDark ? Color(0xFF1B1B1B)87 : const Color(0xff9088F1);
    final textColor = isDark ? Colors.white : Colors.white;

    final notificationAsync = userType == "Student"
        ? ref.watch(mentorSideNotificationController)
        : ref.watch(getNotificationController);
    return Scaffold(
      backgroundColor: isDark ? Colors.white : Color(0xFF1B1B1B),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        backgroundColor: const Color(0xff9088F1),
        // backgroundColor,
        title: Text(
          "Notifications",
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: notificationAsync.when(
        data: (response) {
          // Ab prefix use karke Datum access karo
          List<dynamic>? notifications = [];

          if (response is student.GetNotificationResModel) {
            notifications = response.data ?? [];
          } else if (response is mentor.MentorNotificationResModel) {
            notifications = response.data ?? [];
          }

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                "No notifications",
                style: TextStyle(color: textColor, fontSize: 16.sp),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              // Yahan dynamic use kar rahe hain kyunki dono Datum identical hain
              final item = notifications![index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // color:Colors.red,
                // themeMode == ThemeMode.dark ?  Color(0xFF1B1B1B):Colors.white,
                // isDark ? Colors.grey[900] : Colors.white,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      item.fullName?.isNotEmpty == true
                          ? item.fullName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  title: Text(
                    item.title ?? "No title",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : Color(0xFF1B1B1B),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.body ?? "No message",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  trailing: item.notificationCount != null &&
                          item.notificationCount > 1
                      ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${item.notificationCount}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "Failed to load notifications",
              style: TextStyle(color: Colors.red[300], fontSize: 14.sp),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
