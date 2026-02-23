// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../dropDown/dropDownController.dart';
// import '../coreFolder/Controller/searchController.dart';
// import '../coreFolder/Model/GetSkillModel.dart';

// final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

// final searchSkillProvider = FutureProvider.autoDispose<SkillGetModel>(
//   (ref) async {
//     final client = await ref.watch(apiClientProvider.future);
//     final params = ref.watch(queryParamsProvider);
//     return await ApiController.getSkill(client, params);
//   },
// );

// class FindSkillPage extends ConsumerStatefulWidget {
//   const FindSkillPage({super.key});
//   @override
//   ConsumerState<FindSkillPage> createState() => _FindSkillPageState();
// }

// class _FindSkillPageState extends ConsumerState<FindSkillPage> {
//   String? selectedLevel;
//   String? selectedIndustry;

//   Timer? _debounce;
//   Map<String, String> _buildQueryParams() {
//     final params = <String, String>{};
//     if (selectedLevel != null &&
//         selectedLevel != "All" &&
//         selectedLevel!.isNotEmpty) {
//       params['level'] = selectedLevel!;
//     }
//     if (selectedIndustry != null &&
//         selectedIndustry != "All" &&
//         selectedIndustry!.isNotEmpty) {
//       params['industry'] = selectedIndustry!;
//     }

//     return params;
//   }

//   void _updateQueryParams() {
//     // Cancel any existing debounce timer
//     _debounce?.cancel();
//     // Start a new timer to delay the API call
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final params = _buildQueryParams();
//       if (params.isNotEmpty) {
//         ref.read(queryParamsProvider.notifier).state = params;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dropDownData = ref.watch(getDropDownProvider);
//     final queryParams = ref.watch(queryParamsProvider);
//     final skillProvider =
//         queryParams.isNotEmpty ? ref.watch(searchSkillProvider) : null;

//     return Scaffold(
//       backgroundColor: const Color(0xFF1B1B1B),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 70.h),
//           _appBar(),
//           SizedBox(height: 30.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//             child: dropDownData.when(
//               data: (dropdown) {
//                 final locations = ["All", ...(dropdown.skills!.levels ?? [])];
//                 final collegeNames = [
//                   "All",
//                   ...(dropdown.skills!.industry ?? [])
//                 ];

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         // padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedLevel,
//                           hint: Text(
//                             "Select Level",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: locations.map((location) {
//                             return DropdownMenuItem<String>(
//                               value: location,
//                               child: Text(
//                                 location,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 12.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedLevel = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: Container(
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         // padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.0.sp),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedIndustry,
//                           hint: Text(
//                             "Select Industry",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: collegeNames.map((college) {
//                             return DropdownMenuItem<String>(
//                               value: college,
//                               child: Text(
//                                 college,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 12.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedIndustry = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.w),
//                   ],
//                 );
//               },
//               error: (error, stackTrace) => Center(
//                 child: Text(
//                   "Error loading dropdowns: $error",
//                   style: GoogleFonts.roboto(color: Colors.white),
//                 ),
//               ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30.r),
//               ),
//               child: queryParams.isEmpty
//                   ? const Center(
//                       child: Text("Please select at least one filter"))
//                   : skillProvider!.when(
//                       data: (skill) => skill.data?.isNotEmpty ?? false
//                           ? GridView.count(
//                               // shrinkWrap: true,
//                               // physics: const NeverScrollableScrollPhysics(),
//                               crossAxisCount:
//                                   2, // Adjust the number of columns as needed
//                               crossAxisSpacing: 8.0,
//                               mainAxisSpacing: 8.0,
//                               children:
//                                   skill.data!.asMap().entries.map((entry) {
//                                 final index = entry.key;
//                                 final skill = entry.value;
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: GestureDetector(
//                                     onTap: () {},
//                                     child: SkillTab(
//                                       id: skill.id!,
//                                       level: skill.level!,
//                                       image: skill.image!,
//                                       name: skill.title ?? 'Unknown College',
//                                       description:
//                                           skill.description ?? 'Unknown',
//                                       location:
//                                           skill.description ?? 'No location',
//                                       course: skill.subTitle ?? 'No course',
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             )
//                           : const Center(child: Text("No colleges found")),
//                       error: (error, stackTrace) => Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Error: $error",
//                                 style: GoogleFonts.roboto(color: Color(0xFF1B1B1B))),
//                             ElevatedButton(
//                               onPressed: () => ref.refresh(searchSkillProvider),
//                               child: const Text("Retry"),
//                             ),
//                           ],
//                         ),
//                       ),
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _appBar() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(width: 30.w),
//         GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             height: 44.h,
//             width: 44.w,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(25, 255, 255, 255),
//               borderRadius: BorderRadius.circular(500.r),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.white,
//                 size: 15,
//               ),
//             ),
//           ),
//         ),
//         const Spacer(),
//         Row(
//           children: [
//             Text(
//               "Trending ",
//               style: GoogleFonts.roboto(
//                   fontSize: 24.sp, color: const Color(0xff9088F1)),
//             ),
//             Text(
//               "Skills",
//               style: GoogleFonts.roboto(
//                   fontSize: 24.sp, color: const Color(0xFFDCF881)),
//             ),
//           ],
//         ),
//         const Spacer(),
//         SizedBox(width: 30.w),
//       ],
//     );
//   }
// }

// class SkillTab extends StatelessWidget {
//   final int id;
//   final String name;
//   final String level;
//   final String image;
//   final String description;
//   final String location;
//   final String course;

//   const SkillTab({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.level,
//     required this.image,
//     required this.description,
//     required this.location,
//     required this.course,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 2,
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 46.h,
//               width: 46.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100.r),
//                 image: DecorationImage(
//                     image: NetworkImage(
//                         'http://education.globallywebsolutions.com/public/${image}')),
//               ),
//             ),
//             Text(
//               "${level}",
//               style: GoogleFonts.roboto(
//                   color: Color(0xff9088F1),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16.w),
//             ),
//             Text(
//               "${name}",
//               style: GoogleFonts.roboto(
//                   color: Color(0xFF1B1B1B),
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16.w),
//             ),
//             SizedBox(
//               height: 10.h,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 10.w, right: 10.w),
//               child: Text(
//                 maxLines: 3,
//                 "${description}",
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.roboto(
//                     fontSize: 11.w,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xff666666)),
//               ),
//             ),
//           ],
//         ));
//   }
// }
/*

import 'dart:async';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/GetSkillModel.dart';

final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

final searchSkillProvider = FutureProvider.autoDispose<SkillGetModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(queryParamsProvider);
    return await ApiController.getSkill(client, params);
  },
);

class FindSkillPage extends ConsumerStatefulWidget {
  const FindSkillPage({super.key});
  @override
  ConsumerState<FindSkillPage> createState() => _FindSkillPageState();
}

class _FindSkillPageState extends ConsumerState<FindSkillPage> {
  String? selectedLevel;
  String? selectedIndustry;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedLevel != null &&
        selectedLevel != "All" &&
        selectedLevel!.isNotEmpty) {
      params['level'] = selectedLevel!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
    }
    if (_searchText.isNotEmpty) {
      params['search'] = _searchText;
    }
    return params;
  }

  void _updateQueryParams() {
    // Cancel any existing debounce timer
    _debounce?.cancel();
    // Start a new timer to delay the API call
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(queryParamsProvider.notifier).state = params;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
    _updateQueryParams();
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        setState(() {
          _searchText = '';
        });
        _updateQueryParams();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger initial load with empty params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(queryParamsProvider.notifier).state = {};
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Clean up the timer
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final queryParams = ref.watch(queryParamsProvider);
    final skillProvider = ref.watch(searchSkillProvider);
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      // backgroundColor: const Color(0xFF1B1B1B),
      backgroundColor:
          // themeMode == ThemeMode.dark
          //     ? const Color(0xFF1B1B1B)
          //     :
          Color(0xff9088F1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.h),
          _appBar(),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(
                    left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                hintText: "Search ...",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 18.sp),
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
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchText = '';
                          });
                          _updateQueryParams();
                        },
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
                final locations = ["All", ...(dropdown.skills?.levels ?? [])];
                final collegeNames = [
                  "All",
                  ...(dropdown.skills?.industry ?? [])
                ];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedLevel,
                          hint: Text(
                            "Level",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: locations.map((location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Text(
                                location,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value;
                              _updateQueryParams(); // Trigger API call with debounce
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedIndustry,
                          hint: Text(
                            "Industry",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: collegeNames.map((college) {
                            return DropdownMenuItem<String>(
                              value: college,
                              child: Text(
                                college,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedIndustry = value;
                              _updateQueryParams(); // Trigger API call with debounce
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  "Error loading dropdowns: $error",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () {
                return DropDownLoading();
              },
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: skillProvider.when(
                data: (skill) {
                  final filteredData =
                      skill.data?.where((item) => item.id != null).toList() ??
                          [];
                  return filteredData.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                          ),
                          // child: GridView.count(
                          //   padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                          //   crossAxisCount: 2,
                          //   crossAxisSpacing: 20,
                          //   mainAxisSpacing: 20,
                          //   children: filteredData.asMap().entries.map((entry) {
                          //     final index = entry.key;
                          //     final skillItem = entry.value;
                          //     return GestureDetector(
                          //       onTap: () {},
                          //       child: SkillTab(
                          //         id: skillItem.id!,
                          //         level: skillItem.level ?? '',
                          //         image: skillItem.image ?? '',
                          //         name: skillItem.title ?? 'Unknown',
                          //         description:
                          //             skillItem.description ?? 'Unknown',
                          //         location:
                          //             skillItem.description ?? 'No location',
                          //         course: skillItem.subTitle ?? 'No course',
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                          child: GridView.builder(
                            padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            itemCount: filteredData.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              final skillItem = filteredData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => TrendingExprtPage(
                                          id: skill.data![index].id ?? 0,
                                        ),
                                      ));
                                },
                                child: SkillTab(
                                  image: skillItem.image ?? '',
                                  level: skillItem.level ?? '',
                                  name: skillItem.title ?? 'Unknown',
                                  description:
                                      skillItem.description ?? 'Unknown',
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("No skills found"));
                },
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load skills: $error",
                        style: GoogleFonts.roboto(color: Color(0xFF1B1B1B)),
                      ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(searchSkillProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () {
                  return GridView.builder(
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 10.h, left: 20.w, right: 20.w),
                    itemCount: 6, // number of shimmer items
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                    ),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor:
                            Colors.grey[300]!, // white theme shimmer base
                        highlightColor: Colors.grey[100]!, // smooth shine
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE PLACEHOLDER
                              Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                  ),
                                  color: Colors.grey[300],
                                ),
                              ),

                              // TEXT PLACEHOLDERS
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 12.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 10.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 10.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    final themeMode = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Container(
          //     height: 46.h,
          //     width: 44.w,
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(25, 255, 255, 255),
          //       borderRadius: BorderRadius.circular(500.r),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.only(left: 6.w),
          //       child: Icon(
          //         Icons.arrow_back_ios,
          //         color: Colors.white,
          //         size: 15,
          //       ),
          //     ),
          //   ),
          // ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 10.w,
              ),
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
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
          Row(
            children: [
              Text(
                "Trending ",
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
              ),
              Text(
                "Course",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xFFDCF881)),
              ),
            ],
          ),
          SizedBox(
            width: 44.w,
          )
          // GestureDetector(
          //   onTap: _toggleSearchBar,
          //   child: Container(
          //     height: 44.h,
          //     width: 44.w,
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(25, 255, 255, 255),
          //       borderRadius: BorderRadius.circular(500.r),
          //     ),
          //     child: Center(
          //       child: Icon(
          //         _showSearchBar ? Icons.close : Icons.search,
          //         color: Colors.white,
          //         size: 24,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SkillTab extends StatelessWidget {
  final String image;
  final String level;
  final String name;
  final String description;

  const SkillTab({
    super.key,
    required this.image,
    required this.level,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r), color: Color(0xFFF1F2F6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              image: DecorationImage(
                image: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              level,
              style: GoogleFonts.roboto(
                  color: Color(0xff9088F1),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.w),
            ),
          ),
          Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  color: Color(0xFF1B1B1B),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.w),
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(
              maxLines: 2,
              textAlign: TextAlign.center,
              description,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff666666),
                  letterSpacing: -0.2),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:async';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/getSaveSkillListController.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/coreFolder/Model/saveSkilsModel.dart';
import 'package:educationapp/coreFolder/network/api.state.dart';
import 'package:educationapp/coreFolder/utils/preety.dio.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:educationapp/home/trendingExprt.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/GetSkillModel.dart';
import '../dropDown/dropDownController.dart';

final queryParamsProvider = StateProvider<Map<String, String>>((ref) => {});

final searchSkillProvider = FutureProvider.autoDispose<SkillGetModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(queryParamsProvider);
    log('SearchSkill API called with params: $params');
    return await ApiController.getSkill(client, params);
  },
);

class FindSkillPage extends ConsumerStatefulWidget {
  const FindSkillPage({super.key});
  @override
  ConsumerState<FindSkillPage> createState() => _FindSkillPageState();
}

class _FindSkillPageState extends ConsumerState<FindSkillPage> {
  String? selectedLevel;
  String? selectedIndustry;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedLevel != null &&
        selectedLevel != "All" &&
        selectedLevel!.isNotEmpty) {
      params['level'] = selectedLevel!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
    }
    // ← search parameter backend mein nahi hai, isliye comment out kar diya
    // if (_searchText.isNotEmpty) {
    //   params['search'] = _searchText;
    // }
    return params;
  }

  void _updateQueryParams() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(queryParamsProvider.notifier).state = params;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
    _updateQueryParams();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(queryParamsProvider.notifier).state = {};
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropDownData = ref.watch(getDropDownProvider);
    final skillProvider = ref.watch(searchSkillProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: const Color(0xff1B1B1B),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          _appBar(),
          SizedBox(height: 20.h),

          // Search Bar – ab level aur industry wise search karega
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                hintText: "Search Trending Course",
                hintStyle:
                    GoogleFonts.roboto(color: Colors.white70, fontSize: 16.sp),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchText = '');
                          _updateQueryParams();
                          ref.refresh(searchSkillProvider);
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          SizedBox(height: 20.h),

          // Dropdowns
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: dropDownData.when(
              data: (dropdown) {
                final levels = <String>["All"];
                if (dropdown.skills?.levels != null) {
                  levels.addAll(
                      dropdown.skills!.levels!.map((e) => e?.toString() ?? ''));
                }

                final industries = <String>["All"];
                if (dropdown.skills?.industry != null) {
                  industries.addAll(dropdown.skills!.industry!
                      .map((e) => e?.toString() ?? ''));
                }

                return Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        value: selectedLevel,
                        hint: "Level",
                        items: levels,
                        onChanged: (val) {
                          setState(() => selectedLevel = val);
                          _updateQueryParams();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildDropdown(
                        value: selectedIndustry,
                        hint: "Industry",
                        items: industries,
                        onChanged: (val) {
                          setState(() => selectedIndustry = val);
                          _updateQueryParams();
                        },
                      ),
                    ),
                  ],
                );
              },
              error: (err, _) => Center(
                  child: Text("Error loading filters: $err",
                      style: const TextStyle(color: Colors.white))),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),

          SizedBox(height: 20.h),

          // Skills Grid with client-side search filter
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: skillProvider.when(
                data: (skillModel) {
                  var skills = skillModel.data ?? [];

                  // Client-side search filter on title, level, description, industry
                  if (_searchText.trim().isNotEmpty) {
                    final searchLower = _searchText.trim().toLowerCase();
                    skills = skills.where((item) {
                      final titleLower = (item.title ?? '').toLowerCase();
                      final levelLower = (item.level ?? '').toLowerCase();
                      final descLower = (item.description ?? '').toLowerCase();
                      final industryLower = (item.industry ?? '').toLowerCase();
                      return titleLower.contains(searchLower) ||
                          levelLower.contains(searchLower) ||
                          descLower.contains(searchLower) ||
                          industryLower.contains(searchLower);
                    }).toList();
                  }

                  if (skills.isEmpty) {
                    return Center(
                      child: Text(
                        _searchText.isNotEmpty
                            ? "No skills found for '$_searchText'"
                            : "No skills found",
                        style: GoogleFonts.roboto(
                            color: Colors.white70, fontSize: 18.sp),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    itemCount: skills.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final skillItem = skills[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => TrendingExprtPage(
                                id: skillItem.id ?? 0,
                              ),
                            ),
                          );
                        },
                        child: SkillTab(
                          image: skillItem.image ?? '',
                          level: skillItem.level ?? '',
                          name: skillItem.title ?? 'Unknown',
                          description:
                              skillItem.description ?? 'No description',
                          skillId: skillItem.id ?? 0,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load skills: $error",
                        style:
                            GoogleFonts.roboto(color: const Color(0xFF1B1B1B)),
                      ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(searchSkillProvider),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () => GridView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 20.h,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r),
                                ),
                                color: Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 12.h,
                                      width: 100.w,
                                      color: Colors.grey[300]),
                                  SizedBox(height: 8.h),
                                  Container(
                                      height: 10.h,
                                      width: 70.w,
                                      color: Colors.grey[300]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    final themeMode = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                    color:
                    themeMode == ThemeMode.dark
                        ? const Color(0xFFFFFFFFF)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text("Trending ",
                  style: GoogleFonts.roboto(
                      fontSize: 24.sp,
                      color:
                      // themeMode == ThemeMode.dark
                      //     ?
                      const Color(0xFFDCF881)
                          // : Colors.white
    )
    ),
              Text("Course",
                  style: GoogleFonts.roboto(
                      fontSize: 24.sp, color: const Color(0xFFDCF881))),
            ],
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final themeMode = ref.watch(themeProvider);
    final bool isDark = themeMode == ThemeMode.dark;

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: DropdownButton<String>(
        borderRadius:
            BorderRadius.circular(12.r), // optional: rounded corners menu को
        value: value,
        hint: Text(hint,
            style: GoogleFonts.roboto(color: Colors.white70, fontSize: 13.sp)),
        isExpanded: true,
        dropdownColor: isDark ? Colors.white : Color(0xFF1B1B1B),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item,
                style: GoogleFonts.roboto(
                    color: isDark ? Color(0xFF1B1B1B) : Colors.white,
                    fontSize: 13.sp)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class SkillTab extends ConsumerStatefulWidget {
  final String image;
  final String level;
  final String name;
  final String description;
  final int skillId;

  const SkillTab({
    super.key,
    required this.image,
    required this.level,
    required this.name,
    required this.description,
    required this.skillId,
  });

  @override
  ConsumerState<SkillTab> createState() => _SkillTabState();
}

class _SkillTabState extends ConsumerState<SkillTab> {
  bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFF1F2F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, right: 10.w),
            child: StatefulBuilder(
              builder: (context, setSaveState) {
                return Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      setSaveState(() {
                        isSaved = !isSaved;
                      });

                      final body = SaveSkillBodyModel(skillId: widget.skillId);

                      try {
                        final service = APIStateNetwork(createDio());
                        final response = await service.saveSkill(body);

                        if (response.status == true) {
                          ref.invalidate(getSaveSkillListControlelr);
                          Fluttertoast.showToast(
                            msg: response.message ?? "Saved successfully",
                          );
                          // Keep the new state (don't revert)
                        } else {
                          // API failed → revert UI
                          setSaveState(() {
                            isSaved = !isSaved;
                          });
                          Fluttertoast.showToast(
                            msg: response.message ?? "Failed to save",
                          );
                        }
                      } catch (e) {
                        // Exception → revert UI
                        setSaveState(() {
                          isSaved = !isSaved;
                        });
                        Fluttertoast.showToast(
                          msg: "Something went wrong",
                          backgroundColor: Colors.red.shade700,
                        );
                        debugPrint("Save error: $e");
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            24.r), // slightly softer corner
                        color: Colors.white,
                        border: Border.all(
                          color: isSaved
                              ? const Color(0xFF6B7280)
                              : Colors.grey.shade300, // dark gray when saved
                          width: 1.4,
                        ),
                        boxShadow: isSaved
                            ? [
                                BoxShadow(
                                  color: Colors.blueGrey.withOpacity(0.18),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated icon scale + icon change
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: isSaved ? 1.25 : 1.0),
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Icon(
                                  isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: isSaved
                                      ? const Color(0xFF2563EB)
                                      : Colors.black87,
                                  size: 18.sp,
                                ),
                              );
                            },
                          ),

                          SizedBox(width: 6.w),
                          Text(
                            isSaved ? "Saved" : "Save",
                            style: GoogleFonts.roboto(
                              // or GoogleFonts.inter if you prefer
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isSaved
                                  ? const Color(0xFF2563EB)
                                  : Colors.black87,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          // Container(
          //   height: 50.h,
          //   width: 50.w,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(100.r),
          //     image: DecorationImage(
          //       image: widget.image.isNotEmpty
          //           ? NetworkImage(widget.image)
          //           : const AssetImage('assets/images/default_profile.png')
          //               as ImageProvider,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          //
          Container(
margin: EdgeInsets.only(left: 20.w),
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
color: Color(0xff0F2854)

            ),

            child: Image.asset("assets/feather2.png",),
          ),

          SizedBox(height: 20.h),
          Container(
            margin: EdgeInsets.only(left: 20.w),

            child: Text(
              widget.level,
              style: GoogleFonts.roboto(
                color: const Color(0xff9088F1),
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            margin: EdgeInsets.only(left: 20.w),

            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: const Color(0xFF1B1B1B),
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            margin: EdgeInsets.only(left: 20.w),

            child: Text(
              widget.description,
              maxLines: 2,
              // textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: const Color(0xff666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
