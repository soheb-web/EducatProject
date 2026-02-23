// import 'dart:async';
// import 'dart:developer';
// import 'package:educationapp/coreFolder/Controller/themeController.dart';
// import 'package:educationapp/home/CompanyDetail.dart';
// import 'package:educationapp/home/findmentor.page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../dropDown/dropDownController.dart';
// import '../coreFolder/Controller/searchController.dart';
// import '../coreFolder/Model/SearchCompanyModel.dart';

// final companyQueryParamsProvider =
//     StateProvider<Map<String, String>>((ref) => {});
// final searchCompanyProvider = FutureProvider.autoDispose<SearchCompanyModel>(
//   (ref) async {
//     final client = await ref.watch(apiClientProvider.future);
//     final params = ref.watch(companyQueryParamsProvider);
//     return await ApiController.searchCompany(client, params);
//   },
// );

// class FindCompanyPage extends ConsumerStatefulWidget {
//   const FindCompanyPage({super.key});
//   @override
//   ConsumerState<FindCompanyPage> createState() => _FindCompanyPageState();
// }

// class _FindCompanyPageState extends ConsumerState<FindCompanyPage> {
//   String? selectedSkill;
//   String? selectedIndustry;
//   String? selectedLocation;
//   String _searchText = '';
//   bool _showSearchBar = false;
//   Timer? _debounce;
//   final TextEditingController _searchController = TextEditingController();

//   Map<String, String> _buildQueryParams() {
//     final params = <String, String>{};
//     if (selectedSkill != null &&
//         selectedSkill != "All" &&
//         selectedSkill!.isNotEmpty) {
//       params['skills'] = selectedSkill!;
//     }
//     if (selectedIndustry != null &&
//         selectedIndustry != "All" &&
//         selectedIndustry!.isNotEmpty) {
//       params['industry'] = selectedIndustry!;
//     }
//     if (selectedLocation != null &&
//         selectedLocation != "All" &&
//         selectedLocation!.isNotEmpty) {
//       params['location'] = selectedLocation!;
//     }
//     if (_searchText.isNotEmpty) {
//       params['search'] = _searchText;
//     }
//     return params;
//   }

//   void _updateQueryParams() {
//     // Cancel any existing debounce timer
//     _debounce?.cancel();
//     // Start a new timer to delay the API call
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final params = _buildQueryParams();
//       ref.read(companyQueryParamsProvider.notifier).state = params;
//     });
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       _searchText = value;
//     });
//     _updateQueryParams();
//   }

//   void _toggleSearchBar() {
//     setState(() {
//       _showSearchBar = !_showSearchBar;
//       if (!_showSearchBar) {
//         _searchController.clear();
//         setState(() {
//           _searchText = '';
//         });
//         _updateQueryParams(); // Clear search param
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Trigger initial load with empty params
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(companyQueryParamsProvider.notifier).state = {};
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel(); // Clean up the timer
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dropDownData = ref.watch(getDropDownProvider);
//     final queryParams = ref.watch(companyQueryParamsProvider);
//     final companyProvider = ref.watch(searchCompanyProvider);
//     final themeMode = ref.watch(themeProvider);
//     return Scaffold(
//       backgroundColor:
//           // themeMode == ThemeMode.dark
//           //     ? const Color(0xFF1B1B1B)
//           //     :
//           Color(0xff9088F1),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 30.h),
//           _appBar(),
//           SizedBox(height: 20.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: TextField(
//               controller: _searchController,
//               style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
//               decoration: InputDecoration(
//                 isDense: true,
//                 contentPadding: EdgeInsets.only(
//                     left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
//                 hintText: "Search company...",
//                 hintStyle:
//                     GoogleFonts.roboto(color: Colors.white70, fontSize: 18.sp),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.r),
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.r),
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//                 prefixIcon:
//                     const Icon(Icons.search, color: Colors.white, size: 20),
//                 suffixIcon: _searchText.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, color: Colors.white),
//                         onPressed: () {
//                           _searchController.clear();
//                           setState(() {
//                             _searchText = '';
//                           });
//                           _updateQueryParams();
//                         },
//                       )
//                     : null,
//               ),
//               onChanged: _onSearchChanged,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
//             child: dropDownData.when(
//               data: (dropdown) {
//                 final skills = ["All", ...(dropdown.companies?.skills ?? [])];
//                 final industries = [
//                   "All",
//                   ...(dropdown.companies?.industry ?? [])
//                 ];
//                 final locations = [
//                   "All",
//                   ...(dropdown.companies?.locations ?? [])
//                 ];

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 40.h,
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedSkill,
//                           hint: Text(
//                             "Skill",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: skills.map((skill) {
//                             return DropdownMenuItem<String>(
//                               value: skill,
//                               child: Text(
//                                 skill,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 10.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedSkill = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Container(
//                         height: 40.h,
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedIndustry,
//                           hint: Text(
//                             "Industry",
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white, fontSize: 12.sp),
//                           ),
//                           isExpanded: true,
//                           dropdownColor: const Color(0xFF1B1B1B),
//                           icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                               color: Colors.white),
//                           underline: const SizedBox(),
//                           items: industries.map((industry) {
//                             return DropdownMenuItem<String>(
//                               value: industry,
//                               child: Text(
//                                 industry,
//                                 style: GoogleFonts.roboto(
//                                     color: Colors.white, fontSize: 10.sp),
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
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Container(
//                         height: 40.h,
//                         padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.white,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: DropdownButton<String>(
//                           padding: EdgeInsets.zero,
//                           value: selectedLocation,
//                           hint: Text(
//                             "Location",
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
//                                     color: Colors.white, fontSize: 10.sp),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedLocation = value;
//                               _updateQueryParams(); // Trigger API call with debounce
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               error: (error, stackTrace) => Center(
//                 child: Text(
//                   "Failed to load filters: $error",
//                   style: GoogleFonts.roboto(color: Colors.white),
//                 ),
//               ),
//               loading: () => DropDownLoading(),
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Expanded(
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 // color: Colors.white,
//                 color: themeMode == ThemeMode.dark
//                     ? Colors.white
//                     : const Color(0xFF1B1B1B),
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.r),
//                     topRight: Radius.circular(30.r)),
//               ),
//               child: companyProvider.when(
//                 data: (companies) => companies.data?.isNotEmpty ?? false
//                     ? ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: companies.data!.length,
//                         itemBuilder: (context, index) {
//                           final company = companies.data![index];
//                           return Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => CompanyDetailPage(
//                                               company.id!,
//                                             )));
//                               },
//                               child: CompanyTab(
//                                 // id: company.id!,
//                                 // name: company.collageName ?? 'Unknown',
//                                 // location: company.location ?? 'Unknown',
//                                 // industry: company.industry ?? 'Unknown',
//                                 image: company.image.toString(),
//                                 id: company.id!,
//                                 fullname: company.collageName ?? "Unknown",
//                                 dec: company.collageDescription ??
//                                     "No description",
//                                 facility: [company.facilities![index]],
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : Center(
//                         child: Text(
//                         "No companies found",
//                         style: TextStyle(
//                             color: themeMode == ThemeMode.dark
//                                 ? const Color(0xFF1B1B1B)
//                                 : Colors.white),
//                       )),
//                 error: (error, stackTrace) {
//                   log(error.toString());
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Failed to load companies: $error",
//                           style: GoogleFonts.roboto(color: Color(0xFF1B1B1B)),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => ref.refresh(searchCompanyProvider),
//                           child: const Text("Retry"),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 loading: () => DataLoading(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _appBar() {
//     final themeMode = ref.watch(themeProvider);

//     return Container(
//       margin: EdgeInsets.only(left: 10.w, right: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               margin: EdgeInsets.only(
//                 left: 10.w,
//               ),
//               width: 40.w,
//               height: 40.h,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 8),
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     size: 20,
//                     color:
//                         themeMode == ThemeMode.dark ? Color(0xFF1B1B1B) : null,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Text(
//                 "Find a ",
//                 style: GoogleFonts.roboto(
//                   fontSize: 24.sp,
//                   // color: const Color(0xff9088F1),
//                   color: themeMode == ThemeMode.dark
//                       ? Color(0xFF1B1B1B)
//                       : Colors.white,
//                 ),
//               ),
//               Text(
//                 "Company",
//                 style: GoogleFonts.roboto(
//                     fontSize: 24.sp, color: const Color(0xFFDCF881)),
//               ),
//             ],
//           ),
//           SizedBox(),
//         ],
//       ),
//     );
//   }
// }

// class CompanyTab extends StatelessWidget {
//   final String image;
//   final int id;
//   final String fullname;
//   final String dec;
//   final List<String> facility;

//   const CompanyTab(
//       {super.key,
//       required this.image,
//       required this.id,
//       required this.fullname,
//       required this.dec,
//       required this.facility});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 127.h,
//       width: 400.w,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(color: const Color.fromARGB(25, 0, 0, 0), width: 1),
//       ),
//       margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0.w),
//             child: Container(
//               height: 111.h,
//               width: 112.w,
//               decoration: BoxDecoration(
//                 color: Color(0xFF1B1B1B),
//                 borderRadius: BorderRadius.circular(12.r),
//                 // image: DecorationImage(
//                 //   image: image.isNotEmpty
//                 //       ? NetworkImage(image)
//                 //       : const AssetImage('assets/images/default_profile.png')
//                 //           as ImageProvider,
//                 //   fit: BoxFit.cover,
//                 // ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12.r),
//                 child: Image.network(
//                   image,
//                   height: 111.h,
//                   width: 112.w,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Image.network(
//                       "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=",
//                       height: 111.h,
//                       width: 112.w,
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 10.w),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.h),
//                 Text(
//                   fullname,
//                   style: GoogleFonts.roboto(
//                     color: Color(0xFF1B1B1B),
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   dec,
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.roboto(
//                     color: Color(0xFF1B1B1B),
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Container(
//                   height: 0.5.h,
//                   color: Colors.grey.shade400,
//                 ),
//                 SizedBox(height: 10.h),
//                 Wrap(
//                   spacing: 8.w,
//                   runSpacing: 8.h,
//                   children: List.generate(facility.length, (index) {
//                     return Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(225, 222, 221, 236),
//                         borderRadius: BorderRadius.circular(50.r),
//                       ),
//                       child: Text(
//                         facility[index],
//                         style: GoogleFonts.roboto(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xFF1B1B1B),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

///////////// firs time skill java pr data show karega
/*

import 'dart:async';
import 'dart:developer';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/CompanyDetail.dart';
import 'package:educationapp/home/findmentor.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dropDown/dropDownController.dart';
import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/SearchCompanyModel.dart';

final companyQueryParamsProvider =
    StateProvider<Map<String, String>>((ref) => {});
final searchCompanyProvider = FutureProvider.autoDispose<SearchCompanyModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(companyQueryParamsProvider);
    return await ApiController.searchCompany(client, params);
  },
);

class FindCompanyPage extends ConsumerStatefulWidget {
  const FindCompanyPage({super.key});
  @override
  ConsumerState<FindCompanyPage> createState() => _FindCompanyPageState();
}

class _FindCompanyPageState extends ConsumerState<FindCompanyPage> {
  String? selectedSkill;
  String? selectedIndustry;
  String? selectedLocation;
  String _searchText = '';
  bool _showSearchBar = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedSkill != null &&
        selectedSkill != "All" &&
        selectedSkill!.isNotEmpty) {
      params['skills'] = selectedSkill!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
    }
    if (selectedLocation != null &&
        selectedLocation != "All" &&
        selectedLocation!.isNotEmpty) {
      params['location'] = selectedLocation!;
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
      ref.read(companyQueryParamsProvider.notifier).state = params;
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
        _updateQueryParams(); // Clear search param
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger initial load with empty params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyQueryParamsProvider.notifier).state = {};
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
    final queryParams = ref.watch(companyQueryParamsProvider);
    final companyProvider = ref.watch(searchCompanyProvider);
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
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
                hintText: "Search company...",
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
                final skills = ["All", ...(dropdown.companies?.skills ?? [])];
                final industries = [
                  "All",
                  ...(dropdown.companies?.industry ?? [])
                ];
                final locations = [
                  "All",
                  ...(dropdown.companies?.locations ?? [])
                ];

                // Set initial values when data loads
                bool shouldUpdate = false;
                String? initialSkill;
                if (dropdown.companies?.skills?.isNotEmpty ?? false) {
                  initialSkill = dropdown.companies!.skills!.first;
                } else {
                  initialSkill = "All";
                }
                if (selectedSkill == null) {
                  selectedSkill = initialSkill;
                  shouldUpdate = true;
                }
                if (selectedIndustry == null) {
                  selectedIndustry = "All";
                  shouldUpdate = true;
                }
                if (selectedLocation == null) {
                  selectedLocation = "All";
                  shouldUpdate = true;
                }
                if (shouldUpdate && mounted) {
                  setState(() {});
                  _updateQueryParams();
                }

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
                          value: selectedSkill,
                          hint: Text(
                            "Skill",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 12.sp),
                          ),
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1B1B1B),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white),
                          underline: const SizedBox(),
                          items: skills.map((skill) {
                            return DropdownMenuItem<String>(
                              value: skill,
                              child: Text(
                                skill,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 10.sp),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSkill = value;
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
                          items: industries.map((industry) {
                            return DropdownMenuItem<String>(
                              value: industry,
                              child: Text(
                                industry,
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
                          value: selectedLocation,
                          hint: Text(
                            "Location",
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
                              selectedLocation = value;
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
                  "Failed to load filters: $error",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              loading: () => DropDownLoading(),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.white,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r)),
              ),
              child: companyProvider.when(
                data: (companies) => companies.data?.isNotEmpty ?? false
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: companies.data!.length,
                        itemBuilder: (context, index) {
                          final company = companies.data![index];
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompanyDetailPage(
                                              company.id!,
                                            )));
                              },
                              child: CompanyTab(
                                // id: company.id!,
                                // name: company.collageName ?? 'Unknown',
                                // location: company.location ?? 'Unknown',
                                // industry: company.industry ?? 'Unknown',
                                image: company.image.toString(),
                                id: company.id!,
                                fullname: company.collageName ?? "Unknown",
                                dec: company.collageDescription ??
                                    "No description",
                                facility: company.facilities ?? [],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        "No companies found",
                        style: TextStyle(
                            color: themeMode == ThemeMode.dark
                                ? const Color(0xFF1B1B1B)
                                : Colors.white),
                      )),
                error: (error, stackTrace) {
                  log(error.toString());
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Failed to load companies: $error",
                          style: GoogleFonts.roboto(color: Color(0xFF1B1B1B)),
                        ),
                        ElevatedButton(
                          onPressed: () => ref.refresh(searchCompanyProvider),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => DataLoading(),
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
                "Find a ",
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  // color: const Color(0xff9088F1),
                  color: themeMode == ThemeMode.dark
                      ? Color(0xFF1B1B1B)
                      : Colors.white,
                ),
              ),
              Text(
                "Company",
                style: GoogleFonts.roboto(
                    fontSize: 24.sp, color: const Color(0xFFDCF881)),
              ),
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }
}

class CompanyTab extends StatelessWidget {
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> facility;

  const CompanyTab(
      {super.key,
      required this.image,
      required this.id,
      required this.fullname,
      required this.dec,
      required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 127.h,
      width: 400.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(25, 0, 0, 0), width: 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Container(
              height: 111.h,
              width: 112.w,
              decoration: BoxDecoration(
                color: Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(12.r),
                // image: DecorationImage(
                //   image: image.isNotEmpty
                //       ? NetworkImage(image)
                //       : const AssetImage('assets/images/default_profile.png')
                //           as ImageProvider,
                //   fit: BoxFit.cover,
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  image,
                  height: 111.h,
                  width: 112.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=",
                      height: 111.h,
                      width: 112.w,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  fullname,
                  style: GoogleFonts.roboto(
                    color: Color(0xFF1B1B1B),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  dec,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    color: Color(0xFF1B1B1B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 0.5.h,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(facility.length, (index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(225, 222, 221, 236),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text(
                        facility[index],
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:async';
import 'dart:developer' as developer;

import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:educationapp/home/CompanyDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../coreFolder/Controller/searchController.dart';
import '../coreFolder/Model/SearchCompanyModel.dart';
import '../dropDown/dropDownController.dart';

final companyQueryParamsProvider =
    StateProvider<Map<String, String>>((ref) => {});

final searchCompanyProvider = FutureProvider.autoDispose<SearchCompanyModel>(
  (ref) async {
    final client = await ref.watch(apiClientProvider.future);
    final params = ref.watch(companyQueryParamsProvider);
    developer.log('SearchCompany API called with params: $params');
    return await ApiController.searchCompany(client, params);
  },
);

class FindCompanyPage extends ConsumerStatefulWidget {
  const FindCompanyPage({super.key});
  @override
  ConsumerState<FindCompanyPage> createState() => _FindCompanyPageState();
}

class _FindCompanyPageState extends ConsumerState<FindCompanyPage> {
  String? selectedSkill;
  String? selectedIndustry;
  String? selectedLocation;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  Map<String, String> _buildQueryParams() {
    final params = <String, String>{};
    if (selectedSkill != null &&
        selectedSkill != "All" &&
        selectedSkill!.isNotEmpty) {
      params['skills'] = selectedSkill!;
    }
    if (selectedIndustry != null &&
        selectedIndustry != "All" &&
        selectedIndustry!.isNotEmpty) {
      params['industry'] = selectedIndustry!;
    }
    if (selectedLocation != null &&
        selectedLocation != "All" &&
        selectedLocation!.isNotEmpty) {
      params['location'] = selectedLocation!;
    }

    // ← Yeh line hata di — backend mein search param nahi hai
    // if (_searchText.isNotEmpty) {
    //   params['search'] = _searchText;
    // }

    return params;
  }

  void _updateQueryParams() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final params = _buildQueryParams();
      ref.read(companyQueryParamsProvider.notifier).state = params;
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
      ref.read(companyQueryParamsProvider.notifier).state = {};
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
    final companyProvider = ref.watch(searchCompanyProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: const Color(0xff1B1B1B),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          _appBar(),
          SizedBox(height: 20.h),

          // Search Bar (ab skill wise search karega)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 20.sp),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                hintText: "Search Company",
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
                          ref.refresh(searchCompanyProvider);
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
                final skills = <String>["All"];

                if (dropdown.companies?.skills != null) {
                  skills.addAll(dropdown.companies!.skills!
                      .map((e) => e?.toString() ?? ''));
                }

                final industries = <String>["All"];
                if (dropdown.companies?.industry != null) {
                  industries.addAll(dropdown.companies!.industry!
                      .map((e) => e?.toString() ?? ''));
                }

                final locations = <String>["All"];
                if (dropdown.companies?.locations != null) {
                  locations.addAll(dropdown.companies!.locations!
                      .map((e) => e?.toString() ?? ''));
                }

                return Row(
                  children: [
                    Expanded(
                        child: _buildDropdown("Skill", selectedSkill, skills,
                            (val) {
                      setState(() => selectedSkill = val);
                      _updateQueryParams();
                    },
                            themeMode
                        )),
                    SizedBox(width: 8.w),
                    Expanded(
                        child: _buildDropdown(
                            "Industry", selectedIndustry, industries, (val) {
                      setState(() => selectedIndustry = val);
                      _updateQueryParams();
                    },themeMode)),
                    SizedBox(width: 8.w),
                    Expanded(
                        child: _buildDropdown(
                            "Location", selectedLocation, locations, (val) {
                      setState(() => selectedLocation = val);
                      _updateQueryParams();
                    },themeMode)),
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

          SizedBox(height: 16.h),

          // Company List with client-side skill search
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
              child: companyProvider.when(
                data: (model) {
                  var companies = model.data ?? [];

                  // 🔴 API empty response
                  if (companies.isEmpty) {
                    return Center(
                      child: Text(
                        "No companies found",
                        style: GoogleFonts.roboto(
                          color: themeMode == ThemeMode.dark
                              ? Colors.black54
                              : Colors.white70,
                          fontSize: 18.sp,
                        ),
                      ),
                    );
                  }

                  // // Client-side filter: search text ko skills list mein check karo
                  // if (_searchText.trim().isNotEmpty) {
                  //   final searchLower = _searchText.trim().toLowerCase();
                  //   companies = companies.where((company) {
                  //     // skills list mein koi bhi skill match kare
                  //     return company.skills?.any((skill) {
                  //           final skillLower = (skill ?? '').toLowerCase();
                  //           return skillLower.contains(searchLower);
                  //         }) ??
                  //         false;
                  //   }).toList();
                  // }

                  // if (companies.isEmpty) {
                  //   return Center(
                  //     child: Text(
                  //       _searchText.isNotEmpty
                  //           ? "No companies found with skill '$_searchText'"
                  //           : "No companies found",
                  //       style: GoogleFonts.roboto(
                  //           color: Colors.white70, fontSize: 18.sp),
                  //     ),
                  //   );
                  // }
                  // 🔍 Client side search filter
                  var filteredCompanies = companies;

                  if (_searchText.trim().isNotEmpty) {
                    final searchLower = _searchText.trim().toLowerCase();

                    filteredCompanies = companies.where((company) {
                      // 1. Collage Name se search (String check)
                      final nameMatch = (company.collageName ?? '')
                          .toLowerCase()
                          .contains(searchLower);

                      // 2. Agar aap City ya kisi aur field se bhi search karna chahte hain (Optional)
                      final cityMatch = (company.city ?? '')
                          .toLowerCase()
                          .contains(searchLower);

                      return nameMatch || cityMatch;
                    }).toList();
                  }
                  // 🔴 Filter ke baad bhi empty
                  if (filteredCompanies.isEmpty) {
                    return Center(
                      child: Text(
                        "No companies found with skill '$_searchText'",
                        style: GoogleFonts.roboto(
                          color: themeMode == ThemeMode.dark
                              ? Colors.black54
                              : Colors.white70,
                          fontSize: 18.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(12.w),
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      final company = companies[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompanyDetailPage(company.id!),
                              ),
                            );
                          },
                          child: CompanyTab(
                            image: company.image ?? '',
                            id: company.id ?? 0,
                            fullname: company.collageName ?? "Unknown",
                            dec: company.collageDescription ?? "No description",
                            facility: company.facilities ?? [],
                            rating: company.rating!.toStringAsFixed(2) ?? "0",
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: $err",
                          style: GoogleFonts.roboto(color: Colors.redAccent)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(searchCompanyProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFDCF881))),
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
              Text("Find a ",
                  style: GoogleFonts.roboto(
                      fontSize: 24.sp,
                      color:
                      // themeMode == ThemeMode.dark
                      //     ?
                      const Color(0xFFDCF881)
                          // : Colors.white
                  )),
              Text("Company",
                  style: GoogleFonts.roboto(
                      fontSize: 24.sp, color: const Color(0xFFDCF881))),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String hint,
      String? value,
      List<String> items,
      void Function(String?) onChanged,
      ThemeMode themeMode,
      ) {
    final bool isDark = themeMode == ThemeMode.dark;

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all( color:isDark ?Colors.white: Color(0xFF1B1B1B) ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hint,
          style: GoogleFonts.roboto( color:isDark ?Colors.white: Color(0xFF1B1B1B)  , fontSize: 13.sp),
        ),
        isExpanded: true,
        dropdownColor:  isDark ? Colors.white: Color(0xFF1B1B1B) ,
        // elevation: 0,                 // optional: shadow हटाने के लिए
        borderRadius: BorderRadius.circular(12.r), // optional: rounded corners menu को
        icon:  Icon(Icons.keyboard_arrow_down, color: isDark ?Colors.white: Color(0xFF1B1B1B) ),
        underline: const SizedBox(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.roboto(
                color:isDark ? Color(0xFF1B1B1B) : Colors.white,
                // color: isDark ? Colors.white : Color(0xFF1B1B1B),
                fontSize: 13.sp,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
 /* Widget _buildDropdown(String hint, String? value, List<String> items,
      void Function(String?) onChanged, ThemeMode themeMode) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(

        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint,
            style: GoogleFonts.roboto(color: Colors.white70, fontSize: 13.sp)),
        isExpanded: true,
        dropdownColor: const Color(0xFF1B1B1B),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
        underline: const SizedBox(),
        items: items
            .map((item) => DropdownMenuItem(

                value: item,
                child: Text(item,
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontSize: 13.sp)))
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }*/
}

class CompanyTab extends StatelessWidget {
  final String image;
  final int id;
  final String fullname;
  final String dec;
  final List<String> facility;
  final String rating;

  const CompanyTab({
    super.key,
    required this.image,
    required this.id,
    required this.fullname,
    required this.dec,
    required this.facility,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 127.h,
      padding: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(25, 0, 0, 0)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                image,
                width: 112.w,
                height: 111.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.network(
                  "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=",
                  width: 112.w,
                  height: 111.h,
                  fit: BoxFit.cover,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1B1B)),
                ),
                SizedBox(height: 5.h),
                Text(
                  dec,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                      fontSize: 12.sp, color: const Color(0xFF1B1B1B)),
                ),
                SizedBox(height: 10.h),
                Container(height: 0.5.h, color: Colors.grey.shade400),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: facility.map((f) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(225, 222, 221, 236),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.roboto(
                            fontSize: 12.sp, color: const Color(0xFF1B1B1B)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10.w),
                  // padding:
                  //     EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  width: 100.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: const Color(0xFFDEDDEC),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xff9088F1),
                        size: 15.sp,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "${rating} Review",
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2E2E2E),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
