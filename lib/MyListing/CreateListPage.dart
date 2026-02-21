import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../coreFolder/Controller/getSkillProvider.dart';
import '../coreFolder/Controller/themeController.dart';
import '../coreFolder/Model/listingBodyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class CreateListPage extends ConsumerStatefulWidget {
  const CreateListPage({super.key});

  @override
  ConsumerState<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends ConsumerState<CreateListPage> {
  final phoneController = TextEditingController();
  final durationController = TextEditingController();
  final localAddressController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? mode, qualification, budget, requires, gender, communicate;
  final TextEditingController _customBudgetController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _communicateController = TextEditingController();
  Key budgetKey = UniqueKey();
  Key communicateKey = UniqueKey();
  bool get showCustomField => budget == "Custom";
  final List<String> selectedSubject = [];
  final List<String> modeList = ["online", "offline"];
  final List<String> qualificationList = [
    "10th",
    "12th",
    "Diploma",
    "Graduate",
    "Postgraduate"
  ];
  final List<String> requireList = ["Part Time", "Full Time"];
  final List<String> genderList = ["Male", "Female", "Other"];
  final List<String> communicateList = ["English", "Hindi", "English & Hindi"];

  // final String finalBudget = budget ?? "";

  @override
  void dispose() {
    phoneController.dispose();
    durationController.dispose();
    localAddressController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  InputDecoration commonInputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;
    final textColor = isDark ? const Color(0xFF4D4D4D) : Colors.white;
    final fillBgColor = isDark
        ? const Color(0xFF1E1E1E) // dark mode bg
        : const Color(0xFFF5F5F5); // light mode bg

    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
      labelStyle: TextStyle(
          color: textColor, fontSize: 13.w, fontWeight: FontWeight.w400),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      errorStyle: TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12.sp),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: const BorderSide(color: Colors.red, width: 2.2),
      ),

      // Normal States
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: textColor, width: 2),
      ),

      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final subjectKeyword = ref.watch(getSkillProvider);
    final budgetProvider = ref.watch(budgetController);
    final isDark = themeMode == ThemeMode.dark;
    final textColor = isDark ? const Color(0xFF4D4D4D) : Colors.white;

    print('${isDark} isDark');
    print('${textColor} textColor');

    return Scaffold(
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : Color(0xFF1B1B1B),
        appBar: AppBar(
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
          backgroundColor: Color(0xff9088F1),
          centerTitle: true,
          title: Text(
            "Create New Listing",
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: subjectKeyword.when(
              data: (subjects) {
                final subjectList =
                    subjects.data.map((e) => e.title.trim()).toSet().toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.h),
                      SizedBox(height: 10.h),
                      FormField<List<String>>(
                        initialValue: selectedSubject,
                        validator: (_) =>
                            selectedSubject.isEmpty ? "Required" : null,
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypeAheadField<String>(
                                // 🔥 CORRECT PARAMETER: builder
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    style: TextStyle(color: textColor),
                                    decoration: commonInputDecoration(
                                      label: "Search Subject / Keyword",
                                      hint: "Type to search subjects...",
                                    ).copyWith(
                                      errorText: field.errorText,
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 1.8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                        borderSide: const BorderSide(
                                            color: Colors.red, width: 2.2),
                                      ),
                                    ),
                                  );
                                },

                                suggestionsCallback: (pattern) {
                                  if (pattern.trim().isEmpty)
                                    return subjectList;
                                  final query = pattern.trim().toLowerCase();
                                  return subjectList
                                      .where((s) =>
                                          s.toLowerCase().contains(query))
                                      .toList();
                                },

                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    dense: true,
                                    tileColor: themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    title: Text(
                                      suggestion,
                                      style: TextStyle(
                                        color: themeMode == ThemeMode.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  );
                                },

                                onSelected: (suggestion) {
                                  if (!selectedSubject.contains(suggestion)) {
                                    setState(() {
                                      selectedSubject.add(suggestion);
                                    });
                                    field.didChange(selectedSubject);
                                  }
                                },
                              ),

                              SizedBox(height: 10.h),

                              // Selected Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: selectedSubject.map((skill) {
                                  return Chip(
                                    label: Text(
                                      skill,
                                      style: TextStyle(
                                        color: themeMode == ThemeMode.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    deleteIconColor: themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                    backgroundColor: themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                    onDeleted: () {
                                      setState(() {
                                        selectedSubject.remove(skill);
                                      });
                                      field.didChange(selectedSubject);
                                    },
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                      // All Dropdowns using same style
                      DropdownButtonFormField<String>(
                        dropdownColor: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        value: qualification,
                        decoration:
                            commonInputDecoration(label: "Education / Level"),
                        padding: EdgeInsets.only(right: 10.w),
                        icon: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.keyboard_arrow_down,
                                color: textColor)),
                        items: qualificationList.map((item) {
                          return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ));
                        }).toList(),
                        onChanged: (v) => setState(() => qualification = v),
                        validator: (v) => v == null ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      TextFormField(
                        controller: localAddressController,
                        decoration:
                            commonInputDecoration(label: "Local Address"),
                        style: TextStyle(color: textColor),
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      TextFormField(
                        controller: stateController,
                        decoration: commonInputDecoration(label: "State"),
                        style: TextStyle(color: textColor),
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      TextFormField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        decoration: commonInputDecoration(label: "Pin Code"),
                        style: TextStyle(color: textColor),
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      TextFormField(
                        controller: durationController,
                        decoration: commonInputDecoration(label: "Duration"),
                        style: TextStyle(color: textColor),
                        validator: (v) =>
                            v?.trim().isEmpty ?? true ? "Required" : null,
                      ),

                      SizedBox(height: 20.h),
                      DropdownButtonFormField<String>(
                        dropdownColor: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        value: gender,
                        decoration:
                            commonInputDecoration(label: "Gender Preference"),
                        icon: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.keyboard_arrow_down,
                                color: textColor)),
                        items: genderList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )))
                            .toList(),
                        onChanged: (v) => setState(() => gender = v),
                        validator: (v) => v == null ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      // DropdownButtonFormField<String>(
                      //   dropdownColor: themeMode == ThemeMode.dark
                      //       ? Colors.white
                      //       : Colors.black,
                      //   value: communicate,
                      //   decoration:
                      //       commonInputDecoration(label: "Communicate in"),
                      //   icon: Container(
                      //       margin: EdgeInsets.only(right: 10.w),
                      //       child: Icon(Icons.keyboard_arrow_down,
                      //           color: textColor)),
                      //   items: communicateList
                      //       .map((item) => DropdownMenuItem(
                      //           value: item,
                      //           child: Text(
                      //             item,
                      //             style: TextStyle(
                      //               color: themeMode == ThemeMode.dark
                      //                   ? Colors.black
                      //                   : Colors.white,
                      //             ),
                      //           )))
                      //       .toList(),
                      //   onChanged: (v) => setState(() => communicate = v),
                      //   validator: (v) => v == null ? "Required" : null,
                      // ),
                      RawAutocomplete<String>(
                        key: communicateKey,
                        initialValue: TextEditingValue(text: communicate ?? ''),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return communicateList;
                          }
                          return communicateList.where((String option) => option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                        },

                        onSelected: (String selection) {
                          setState(() => communicate = selection);
                        },

                        // --- TEXT FIELD PART ---
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          if (_communicateController.text != controller.text &&
                              controller.text.isEmpty) {
                            controller.text = _communicateController.text;
                          }
                          // Is internal 'controller' ko hum use karenge
                          _communicateController.text = controller.text;
                          // Is internal 'controller' ko hum use karenge
                          _communicateController.text = controller.text;
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            style: TextStyle(color: textColor),
                            decoration: commonInputDecoration(
                              label: "Communicate in",
                              hint: "Select or type language",
                            ).copyWith(
                              suffixIcon: Icon(Icons.keyboard_arrow_down,
                                  color: textColor),
                            ),
                            onChanged: (val) {
                              setState(() => communicate = val);
                            },
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return "Required";
                              return null;
                            },
                          );
                        },

                        // --- DROPDOWN LIST PART (Dark/Light Mode logic) ---
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(12),
                              // Background color logic as per your theme
                              color: themeMode == ThemeMode.dark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 40,
                                constraints:
                                    const BoxConstraints(maxHeight: 250),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      tileColor: themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                      title: Text(
                                        option,
                                        style: TextStyle(
                                          color: themeMode == ThemeMode.dark
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 18.h),
                      DropdownButtonFormField<String>(
                        dropdownColor: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        value: mode,
                        decoration:
                            commonInputDecoration(label: "Teaching Mode"),
                        icon: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.keyboard_arrow_down,
                                color: textColor)),
                        items: modeList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item.capitalize(),
                                  style: TextStyle(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )))
                            .toList(),
                        onChanged: (v) => setState(() => mode = v),
                        validator: (v) => v == null ? "Required" : null,
                      ),

                      SizedBox(height: 18.h),
                      DropdownButtonFormField<String>(
                        dropdownColor: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                        value: requires,
                        decoration: commonInputDecoration(label: "Requires"),
                        // dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                        // style: TextStyle(color: textColor),
                        icon: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.keyboard_arrow_down,
                                color: textColor)),
                        items: requireList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )))
                            .toList(),
                        onChanged: (v) => setState(() => requires = v),
                        validator: (v) => v == null ? "Required" : null,
                      ),

                      SizedBox(height: 20.h),
                      ///////////////   ye bhi sahi hai but method different //////
                      // budgetProvider.when(
                      //   data: (snap) {
                      //     // ← Yahaan important change
                      //     final List<String> options = [
                      //       ...snap.data!.map((item) {
                      //         final price =
                      //             (double.tryParse(item.price ?? '0') ?? 0)
                      //                 .toInt();
                      //         return price
                      //             .toString(); // "200", "300" etc. as string
                      //       }),
                      //       "Custom", // ← yeh line add kar do
                      //     ];
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         DropdownButtonFormField<String>(
                      //           dropdownColor: themeMode == ThemeMode.dark
                      //               ? Colors.white
                      //               : Colors.black,
                      //           value: budget,
                      //           decoration:
                      //               commonInputDecoration(label: "Budget"),
                      //           icon: Container(
                      //             margin: EdgeInsets.only(right: 10.w),
                      //             child: Icon(Icons.keyboard_arrow_down,
                      //                 color: textColor),
                      //           ),
                      //           items: options.map((value) {
                      //             return DropdownMenuItem(
                      //               value: value,
                      //               child: Column(
                      //                 children: [
                      //                   Text(
                      //                     value == "Custom"
                      //                         ? "Custom Amount"
                      //                         : "₹$value",
                      //                     style: TextStyle(
                      //                       color: themeMode == ThemeMode.dark
                      //                           ? Colors.black
                      //                           : Colors.white,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           }).toList(),
                      //           onChanged: (v) {
                      //             setState(() {
                      //               budget = v;
                      //               if (v != "Custom") {
                      //                 _customBudgetController.clear();
                      //               }
                      //             });
                      //           },
                      //           validator: (value) {
                      //             if (value == null) return "Required";
                      //             if (value == "Custom" &&
                      //                 _customBudgetController.text
                      //                     .trim()
                      //                     .isEmpty) {
                      //               return "Required";
                      //             }
                      //             return null;
                      //           },
                      //         ),
                      //         if (showCustomField) ...[
                      //           const SizedBox(height: 16),
                      //           TextFormField(
                      //             controller: _customBudgetController,
                      //             keyboardType: TextInputType.number,
                      //             decoration: commonInputDecoration(
                      //                 label: "Enter your budget (₹)",
                      //                 hint: "Enter if you want to share"),
                      //             style: TextStyle(color: textColor),
                      //             validator: (value) {
                      //               if (value == null || value.trim().isEmpty) {
                      //                 return "Amount daalo";
                      //               }
                      //               if (int.tryParse(value.trim()) == null) {
                      //                 return "Sirf number daalo";
                      //               }
                      //               return null;
                      //             },
                      //           ),
                      //         ],
                      //       ],
                      //     );
                      //   },
                      //   loading: () => const CircularProgressIndicator(),
                      //   error: (e, _) => Text("Error: $e",
                      //       style: const TextStyle(color: Colors.red)),
                      // ),

                      budgetProvider.when(
                        data: (snap) {
                          // 1. Data prepare karna
                          final List<String> options = snap.data!.map((item) {
                            final price =
                                (double.tryParse(item.price ?? '0') ?? 0)
                                    .toInt();
                            return price.toString();
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RawAutocomplete<String>(
                                key: budgetKey,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return options;
                                  }
                                  return options.where((String option) =>
                                      option.contains(textEditingValue.text));
                                },
                                onSelected: (String selection) {
                                  setState(() => budget = selection);
                                },
                                fieldViewBuilder: (context, controller,
                                    focusNode, onFieldSubmitted) {
                                  if (controller == null &&
                                      controller.text.isNotEmpty) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      controller.clear();
                                    });
                                  }
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: textColor),
                                    decoration: commonInputDecoration(
                                      label: "Budget",
                                      hint: "Select or type amount (e.g. 500)",
                                    ).copyWith(
                                      suffixIcon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: textColor),
                                    ),
                                    onChanged: (val) {
                                      setState(() => budget = val);
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Required";
                                      }
                                      if (int.tryParse(value.trim()) == null) {
                                        return "Sirf number daalo";
                                      }
                                      return null;
                                    },
                                  );
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(12),
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.grey[900]
                                          : Colors.white,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        constraints: const BoxConstraints(
                                            maxHeight: 250),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final option =
                                                options.elementAt(index);
                                            return ListTile(
                                              tileColor:
                                                  themeMode == ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                              title: Text(
                                                "₹$option",
                                                style: TextStyle(
                                                  color: themeMode ==
                                                          ThemeMode.dark
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                              ),
                                              onTap: () => onSelected(option),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text("Error: $e",
                            style: const TextStyle(color: Colors.red)),
                      ),

                      /////// ye bhi shi code hai ok ///
                      // budgetProvider.when(
                      //   data: (snap) {
                      //     // 1. Data ko prepare karo
                      //     final List<String> options = snap.data!.map((item) {
                      //       final price =
                      //           (double.tryParse(item.price ?? '0') ?? 0)
                      //               .toInt();
                      //       return price.toString();
                      //     }).toList();
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         // Autocomplete search aur type dono allow karta hai
                      //         Autocomplete<String>(
                      //           optionsBuilder:
                      //               (TextEditingValue textEditingValue) {
                      //             // Agar user ne kuch type nahi kiya toh saare options dikhao
                      //             if (textEditingValue.text == '') {
                      //               return options;
                      //             }
                      //             // Filter options based on input
                      //             return options.where((String option) {
                      //               return option
                      //                   .contains(textEditingValue.text);
                      //             });
                      //           },
                      //           onSelected: (String selection) {
                      //             setState(() {
                      //               budget = selection;
                      //             });
                      //           },
                      //           // Yeh hissa TextField ka look control karta hai
                      //           fieldViewBuilder: (context, controller,
                      //               focusNode, onFieldSubmitted) {
                      //             // Controller ko initial value dena agar pehle se budget select hai
                      //             return TextFormField(
                      //               controller: controller,
                      //               focusNode: focusNode,
                      //               keyboardType: TextInputType.number,
                      //               style: TextStyle(color: textColor),
                      //               decoration: commonInputDecoration(
                      //                 label: "Select or Enter Budget",
                      //                 hint: "Type amount...",
                      //               ).copyWith(
                      //                 suffixIcon: Icon(Icons.edit,
                      //                     size: 18,
                      //                     color: textColor.withOpacity(0.5)),
                      //               ),
                      //               onChanged: (val) {
                      //                 setState(() {
                      //                   budget = val; // Manual entry update
                      //                 });
                      //               },
                      //               validator: (value) {
                      //                 if (value == null || value.isEmpty)
                      //                   return "Required";
                      //                 if (double.tryParse(value) == null)
                      //                   return "Sirf number daalo";
                      //                 return null;
                      //               },
                      //             );
                      //           },
                      //           // Yeh dropdown menu ki styling hai
                      //           optionsViewBuilder:
                      //               (context, onSelected, options) {
                      //             return Align(
                      //               alignment: Alignment.topLeft,
                      //               child: Material(
                      //                 elevation: 4.0,
                      //                 borderRadius: BorderRadius.circular(12),
                      //                 color: themeMode == ThemeMode.dark
                      //                     ? Colors.grey[900]
                      //                     : Colors.white,
                      //                 child: Container(
                      //                   width:
                      //                       MediaQuery.of(context).size.width -
                      //                           40, // Adjust width
                      //                   constraints:
                      //                       BoxConstraints(maxHeight: 200),
                      //                   child: ListView.builder(
                      //                     padding: EdgeInsets.zero,
                      //                     shrinkWrap: true,
                      //                     itemCount: options.length,
                      //                     itemBuilder: (BuildContext context,
                      //                         int index) {
                      //                       final String option =
                      //                           options.elementAt(index);
                      //                       return ListTile(
                      //                         title: Text("₹$option",
                      //                             style: TextStyle(
                      //                                 color: textColor)),
                      //                         onTap: () => onSelected(option),
                      //                       );
                      //                     },
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      //   loading: () =>
                      //       const Center(child: CircularProgressIndicator()),
                      //   error: (e, _) => Text("Error: $e",
                      //       style: const TextStyle(color: Colors.red)),
                      // ),

                      SizedBox(height: 18.h),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: commonInputDecoration(
                            label: "Mobile Number (Optional)",
                            hint: "Enter if you want to share"),
                        style: TextStyle(color: textColor),
                      ),

                      SizedBox(height: 35.h),
                      Center(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(380.w, 55.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            // Background color condition ke according
                            backgroundColor: Color(0xff9088F1),
                            // const Color(0xff9088F1), // Normal state mein teal color
                            // Optional: shadow ya elevation ko loading mein kam kar sakte ho
                            elevation: isLoading ? 2 : 6,
                            shadowColor: Color(0xFF1B1B1B).withOpacity(0.3),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  "Create List",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final String finalBudget = (budget == "Custom")
          ? _customBudgetController.text.trim()
          : budget ?? "";

      final body = CreatelistBodyModel(
        education: qualification!,
        subjects: selectedSubject,
        teachingMode: mode!,
        duration: durationController.text.trim(),
        requires: requires!,
        // budget: budget!,
        budget: finalBudget,
        // budget: finalBudget,
        mobileNumber: phoneController.text.trim(),
        gender: gender!.toLowerCase() ?? "",
        communicate: communicate ?? "",
        state: stateController.text.trim(),
        localAddress: localAddressController.text.trim(),
        pincode: pincodeController.text.trim(),
      );

      final service = APIStateNetwork(createDio());
      final response = await service.createList(body);

      if (response.response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: response.response.data['message'] ?? "Success!");

        setState(() {
          selectedSubject.clear();
          qualification =
              mode = requires = budget = gender = communicate = null;
          phoneController.clear();
          durationController.clear();
          localAddressController.clear();
          stateController.clear();
          pincodeController.clear();
          _budgetController.clear();
          _communicateController.clear();
          budgetKey = UniqueKey();
          communicateKey = UniqueKey();
        });
      }
    } on DioException catch (e) {
      String msg = "Something went wrong";
      if (e.response?.data['errors'] != null) {
        msg = (e.response!.data['errors'] as Map).values.first[0];
      }
      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
