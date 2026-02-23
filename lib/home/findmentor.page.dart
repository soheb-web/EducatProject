
import 'dart:async';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/MentorDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../MyListing/CreateListPage.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/searchMentorModel.dart';

final mentorQueryParamsProvider =
    StateProvider<Map<String, String>>((ref) => {});

final searchMentorProvider = FutureProvider.autoDispose<SearchMentorModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(mentorQueryParamsProvider);
    return await ApiController.searchMentor(client, params);
  },
);

class FindMentorPage extends ConsumerStatefulWidget {
  const FindMentorPage({super.key});

  @override
  ConsumerState<FindMentorPage> createState() => _FindMentorPageState();
}

class _FindMentorPageState extends ConsumerState<FindMentorPage> {
  String? selectedSkill;
  String? selectedIndustry;
  String? selectedExperience;
  String _searchText = '';
  String? _searchedSkillId;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mentorQueryParamsProvider.notifier).state = {};
    });
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    // Skill filter: search bar (skill name → ID) has higher priority than dropdown
    String? finalSkillId;
    if (_searchedSkillId != null && _searchedSkillId!.isNotEmpty) {
      finalSkillId = _searchedSkillId;
    } else if (selectedSkill != null &&
        selectedSkill != "All" &&
        selectedSkill!.isNotEmpty) {
      finalSkillId = selectedSkill;
    }

    if (finalSkillId != null) {
      params['skills_id'] = finalSkillId;
    }

    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['users_field'] = selectedIndustry!;
    }

    if (selectedExperience != null &&
        selectedExperience != "All" &&
        selectedExperience!.isNotEmpty) {
      params['total_experience'] = selectedExperience!;
    }

    return params;
  }
  void _updateQueryParams() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(mentorQueryParamsProvider.notifier).state = params;
    });
  }
  void _updateSearchedSkillId() {
    if (_searchText.trim().isEmpty) {
      setState(() => _searchedSkillId = null);
      return;
    }

    final dropdownAsync = ref.read(getDropDownProvider);
    final dropdown = dropdownAsync.valueOrNull;

    if (dropdown == null || dropdown.mentors?.skills == null) {
      setState(() => _searchedSkillId = null);
      return;
    }

    final skillsMap = dropdown.mentors!.skills!;
    String? matchedId;

    final searchLower = _searchText.toLowerCase().trim();

    for (var entry in skillsMap.entries) {
      final nameLower = (entry.value as String).toLowerCase().trim();
      if (nameLower.contains(searchLower)) {
        matchedId = entry.key;
        break; // first match hi le lenge
      }
    }

    setState(() {
      _searchedSkillId = matchedId;
    });
  }
  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
    _updateSearchedSkillId();
    _updateQueryParams();
  }
  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();

    setState(() {
      _searchText = '';
      _searchedSkillId = null;
    });

    // Immediately reset all params → show all mentors
    ref.read(mentorQueryParamsProvider.notifier).state = {};
  }
  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final mentorProvider = ref.watch(searchMentorProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: const Color(0xff1B1B1B),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          _buildAppBar(themeMode),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                hintText: "Search by skill (Flutter, Python, Marketing...)",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 16.sp),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white, size: 20),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: dropDownData.when(
              data: (dropdown) {
                final skills = [
                  "All",
                  ...?dropdown.mentors?.skills?.keys.toList()
                ];
                final industries = ["All", ...?dropdown.mentors?.industry];
                final experiences = [
                  "All",
                  ...?dropdown.mentors?.totalExperience?.keys.toList()
                ];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdownFilter(
                      value: selectedSkill,
                      hint: "Skill",
                      items: skills,

                      displayMap: dropdown.mentors?.skills,
                      onChanged: (v) {
                        setState(() => selectedSkill = v);
                        _updateQueryParams();
                      },

                    ),
                    // SizedBox(width: 12.w),
                    _buildDropdownFilter(
                      value: selectedIndustry,
                      hint: "Industry",
                      items: industries,
                      onChanged: (v) {
                        setState(() => selectedIndustry = v);
                        _updateQueryParams();
                      },

                    ),
                    // SizedBox(width: 12.w),
                    _buildDropdownFilter(
                      value: selectedExperience,
                      hint: "Experience",
                      items: experiences,
                      displayMap: dropdown.mentors?.totalExperience,
                      onChanged: (v) {
                        setState(() => selectedExperience = v);
                        _updateQueryParams();
                      },

                    ),
                  ],
                );
              },
              error: (err, st) => Center(
                child: Text(
                  "Failed to load filters: $err",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () => const DropDownLoading(),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Stack(
              children:[
                Container(
                decoration: BoxDecoration(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      :  Color(0xFF1B1B1B),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.sp),topRight: Radius.circular(30.sp))
                ),
                child: mentorProvider.when(
                  data: (mentors) {
                    if (mentors.data?.isEmpty ?? true) {
                      return const Center(child: Text("No mentors found"));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10.h),
                      itemCount: mentors.data!.length,
                      itemBuilder: (context, index) {
                        final mentor = mentors.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) =>
                                      MentorDetailPage(id: mentor.id ?? 0),
                                ),
                              );
                            },
                            child: UserTabs(
                              image: mentor.profilePic ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                              id: mentor.id!,
                              fullname: mentor.fullName ?? 'Unknown',
                              dec: mentor.description ?? 'No description',
                              servicetype: mentor.serviceType?.split(', ') ?? [],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (err, st) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Failed to load mentors: $err",
                          style:
                              GoogleFonts.roboto(color: const Color(0xFF1B1B1B)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(searchMentorProvider),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const DataLoading(),
                ),
              ),

                // 2. Bottom floating card (stays fixed)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF4D7),
                      // borderRadius: BorderRadius.circular(20.sp),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    // margin: EdgeInsets.all(20.sp),
                    padding: EdgeInsets.all(20.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Don’t find the right mentor ?",
                                style: GoogleFonts.roboto(
                                  color: Color(0xff1C4D8D),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Upload your custom request and let the mentors bid on it",
                                style: GoogleFonts.roboto(
                                  color: Color(0xff2E2E2E),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateListPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.sp),
                              color: const Color(0xff0F2854),
                            ),
                            padding: EdgeInsets.all(10.sp),
                            child: Text(
                              "Upload Request",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(final isDark) {
    final themeMode = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // InkWell(
          //   onTap: () => Navigator.pop(context),
          //   child: Container(
          //     width: 40.w,
          //     height: 40.h,
          //     decoration: const BoxDecoration(
          //         color: Color(0xff262626), shape: BoxShape.circle),
          //     child: Center(
          //       child: Icon(
          //         Icons.arrow_back_ios,
          //         size: 15.sp,
          //         color: themeMode == ThemeMode.dark
          //             ? const Color(0xFFFFFFFF)
          //             : null,
          //       ),
          //     ),
          //   ),
          // ),

          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                  color: Color(0xff262626), shape: BoxShape.circle),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xFFFFFFFFF)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Find a ",
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFDCF881)
                      : Colors.white,
                ),
              ),
              Text(
                "Mentor",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xFFDCF881)),
              ),
            ],
          ),
          const SizedBox(width: 40), // balance
        ],
      ),
    );
  }

  Widget _buildDropdownFilter( {
    required String? value,
    required String hint,
    required List<String> items,
    Map<String, dynamic>? displayMap,
    required void Function(String?) onChanged,
  }) {
    final themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10.w,left: 10.w),
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 14.sp),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(12.r), // optional: rounded corners menu को
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.roboto(  fontSize: 12.sp),
          ),
          isExpanded: true,
          dropdownColor:  isDark ? Colors.white: Color(0xFF1B1B1B) ,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white),
          underline: const SizedBox(),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                displayMap?[item] ?? item,
                style: GoogleFonts.roboto( color:isDark ? Color(0xFF1B1B1B) : Colors.white, fontSize: 10.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// UserTabs, DropDownLoading, DataLoading classes (same as before)
// ──────────────────────────────────────────────────────────────

class UserTabs extends StatelessWidget {
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> servicetype;

  const UserTabs({
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

class DropDownLoading extends StatelessWidget {
  const DropDownLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[600]!,
              child: Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: const Color(0xFF2C2C2C),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DataLoading extends StatelessWidget {
  const DataLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 127.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color.fromARGB(25, 0, 0, 0)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      height: 111.h,
                      width: 112.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 180.w,
                              height: 16.h,
                              color: Colors.grey[300]),
                          SizedBox(height: 8.h),
                          Container(
                              width: 150.w,
                              height: 14.h,
                              color: Colors.grey[300]),
                          SizedBox(height: 10.h),
                          Container(height: 0.5.h, color: Colors.grey[300]),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 26.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Container(
                                  width: 60.w,
                                  height: 26.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
