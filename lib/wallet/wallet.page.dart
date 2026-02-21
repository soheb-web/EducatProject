import 'package:educationapp/coreFolder/Controller/getSkillProvider.dart';
import 'package:educationapp/coreFolder/Controller/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../coreFolder/Controller/buyCoinProvider.dart';
import '../coreFolder/Controller/getCoinProvider.dart';
import '../coreFolder/Controller/transactionGetProvider.dart';
import '../coreFolder/Controller/userProfileController.dart';
import '../coreFolder/Model/PaymentCreateModel.dart';
import '../coreFolder/Model/PaymentVerifyModel.dart';
import '../coreFolder/network/api.state.dart';
import '../coreFolder/utils/preety.dio.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _searchController =
      TextEditingController(); // New
  int? _userId;
  late Razorpay _razorpay;
  bool _isLoading = false;
  int? selectCoins;
  bool _isSearching = false; // New
  String _searchQuery = ''; // New
  String? selectedBudget;
  double selectedPrice = 0; // actual price
  double selectedDiscount = 0; // discount %
  double finalAmount = 0; // price - discount
  String finalammount = "";
  int desi = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _searchController.dispose(); // Added
    _razorpay.clear();
    super.dispose();
  }

  double _getAmountInRupees(int coins) {
    // return (coins * 0.1);
    return (coins.toDouble());
  }

  void _openRazorpayCheckout(int coins) async {
    double amountInRupees = _getAmountInRupees(coins);

    setState(() => _isLoading = true);

    try {
      final String? orderId = await paymentCreateApi(
        amountInRupees.toStringAsFixed(2),
        "INR",
        "$coins Coins Pack",
        context,
      );

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Failed to create order on server");
      }

      var options = {
        'key': 'rzp_test_RuYzRso83l5DsK',
        'amount': (amountInRupees * 100).toInt(),
        'name': 'Education App',
        'description': '$coins Coins Pack',
        'order_id': orderId,
        'timeout': 300,
        'theme': {'color': '#008080'},
        'prefill': {},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Checkout Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);

    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final verifyResponse = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: response.paymentId!,
          razorpay_order_id: response.orderId!,
          razorpay_signature: response.signature!,
        ),
      );

      if (verifyResponse.success != true ||
          verifyResponse.payment?.status != "paid") {
        throw Exception(
            verifyResponse.message ?? "Payment verification failed");
      }

      final int backendPaymentId = verifyResponse.payment!.id!;
      final payload = {
        'coins': selectCoins.toString(),
        'payment_id': backendPaymentId.toString(),
      };
      _handleBuyCoins(payload);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Payment Successful! ${selectCoins ?? ''} Coins added.'),
            backgroundColor: Color(0xff9088F1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please contact support.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet: ${response.walletName}')),
      );
    }
  }

  void _handleBuyCoins(Map<String, dynamic> payload) {
    setState(() => _isLoading = true);
    ref.read(buyCoinProvider(payload).future).then((_) {
      ref.invalidate(userProfileController);
      ref.invalidate(getCoinProvider);
      if (_userId != null) {
        ref.invalidate(transactionProvider(_userId!));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coins added successfully!'),
            backgroundColor: Color(0xff9088F1),
          ),
        );
        Navigator.pop(context);
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding coins: $error')),
        );
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('userdata');
    final userIdRaw = box.get('userid');
    final themeMode = ref.watch(themeProvider);
    final userId =
        userIdRaw != null ? int.tryParse(userIdRaw.toString()) : null;
    final isDark = themeMode == ThemeMode.dark;
    final textColor = isDark ? const Color(0xFF4D4D4D) : Colors.white;
    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return const Scaffold(
        body: Center(child: Text('User ID not found. Please log in again.')),
      );
    }
    _userId = userId;
    final userProfileProvider = ref.watch(userProfileController);
    final String balanceText = userProfileProvider.when<String>(
      data: (profileRes) => profileRes.data?.coins ?? "0",
      loading: () => "0",
      error: (_, __) => "0",
    );
    final transactionState = ref.watch(transactionProvider(userId));
    final budgetProvider = ref.watch(budgetController);
    return Scaffold(
      backgroundColor:
          // themeMode == ThemeMode.dark
          //     ? const Color(0xFF1B1B1B)
          //     :
          const Color(0xff9088F1),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 15),
                  ),
                ),
                const Spacer(),
                Text(
                  "Wallet",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xff9088F1)
                        : Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    height: 44.h,
                    width: 44.w,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(39, 255, 255, 255),
                      borderRadius: BorderRadius.circular(500.r),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Balance",
                        style: GoogleFonts.roboto(
                            fontSize: 14.sp, color: Colors.white)),
                    SizedBox(height: 5.h),
                    Text(
                      "$balanceText Coins",
                      style: GoogleFonts.roboto(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
///////////////////////////////////////////////////////////

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            final int coinsToUse = selectCoins ?? 0;
                            final double amountToPay =
                                _getAmountInRupees(coinsToUse);

                            return budgetProvider.when(
                              data: (snp) {
                                String price = snp.data!.first.price.toString();

                                String disc =
                                    snp.data!.first.discount.toString();

                                return Container(
                                  decoration: BoxDecoration(
                                    color: themeMode == ThemeMode.dark
                                        ? Colors.white
                                        : Color(0xFF1B1B1B),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  padding: EdgeInsets.all(15.w),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 5.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      SizedBox(height: 15.h),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Add Coins",
                                          style: GoogleFonts.roboto(
                                            color: themeMode == ThemeMode.dark
                                                ? Color(0xFF1B1B1B)
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      DropdownButtonFormField<String>(
                                        dropdownColor: isDark
                                            ? Colors.white
                                            : Color(0xFF1B1B1B),
                                        isExpanded: true,
                                        padding: EdgeInsets.zero,
                                        hint: Center(
                                          child: Text(
                                            "--- Select ---",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: textColor),
                                          ),
                                        ),
                                        value: selectedBudget,

                                        icon: Container(
                                            margin:
                                                EdgeInsets.only(right: 10.w),
                                            child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: textColor)),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                              color: themeMode == ThemeMode.dark
                                                  ? const Color(0xFF4D4D4D)
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        items: snp.data!
                                            .where((e) =>
                                                e.price != null) // safety
                                            .map(
                                              (item) =>
                                                  DropdownMenuItem<String>(
                                                value: item.price,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "₹ ${(double.tryParse(item.price ?? '0') ?? 0).toInt()}",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 14.w,
                                                          color: themeMode ==
                                                                  ThemeMode.dark
                                                              ? Color(
                                                                  0xFF1B1B1B)
                                                              : Colors.white),
                                                    ),
                                                    if (item.discount != null)
                                                      Text(
                                                        "${(double.tryParse(item.discount ?? '0') ?? 0).toInt()}% Discount",
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 14.w,
                                                            color: themeMode ==
                                                                    ThemeMode
                                                                        .dark
                                                                ? Color(
                                                                    0xFF1B1B1B)
                                                                : Colors.white),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),

                                        /// 🔹 SELECTED ITEM UI (closed state)
                                        selectedItemBuilder: (context) {
                                          return snp.data!
                                              .where((e) => e.price != null)
                                              .map((item) {
                                            return Row(
                                              children: [
                                                /// LEFT - Amount
                                                Text(
                                                  "₹ ${(double.tryParse(item.price ?? '0') ?? 0).toInt()}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 16.w,
                                                    color: themeMode ==
                                                            ThemeMode.dark
                                                        ? const Color(
                                                            0xFF4D4D4D)
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Spacer(),

                                                /// RIGHT - Discount
                                                if (item.discount != null)
                                                  Text(
                                                    "${(double.tryParse(item.discount ?? '0') ?? 0).toInt()}%",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 16.w,
                                                      color: themeMode ==
                                                              ThemeMode.dark
                                                          ? const Color(
                                                              0xFF4D4D4D)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }).toList();
                                        },
                                        onChanged: (String? value) {
                                          setModalState(() {
                                            selectedBudget = value;

                                            final selectedItem = snp.data!
                                                .firstWhere(
                                                    (e) => e.price == value);

                                            selectedPrice = double.tryParse(
                                                    selectedItem.price ??
                                                        '0') ??
                                                0;

                                            selectedDiscount = double.tryParse(
                                                    selectedItem.discount ??
                                                        '0') ??
                                                0;

                                            // 🔥 FINAL CALCULATION
                                            finalAmount = selectedPrice -
                                                (selectedPrice *
                                                    selectedDiscount /
                                                    100);

                                            // Coins ke liye (agar coins == price)
                                            selectCoins = selectedPrice.toInt();
                                          });
                                        },
                                        validator: (value) => value == null
                                            ? 'Budget is required'
                                            : null,
                                      ),
                                      SizedBox(height: 30.h),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.h, horizontal: 20.w),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff9088F1)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          border: Border.all(
                                              color: const Color(0xff9088F1),
                                              width: 1.5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "You will pay",
                                              style: GoogleFonts.roboto(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    themeMode == ThemeMode.dark
                                                        ? Color(0xFF1B1B1B)
                                                        : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              //  "₹${amountToPay.toStringAsFixed(2)}",
                                              "₹${finalAmount.toStringAsFixed(2)}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xff9088F1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 40.h),
                                      GestureDetector(
                                        onTap: _isLoading || finalAmount <= 0
                                            ? null
                                            : () {
                                                _openRazorpayCheckout(
                                                    finalAmount.toInt());
                                              },
                                        child: Container(
                                          height: 56.h,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                (_isLoading || coinsToUse <= 0)
                                                    ? Colors.grey
                                                    : const Color(0xff9088F1),
                                            borderRadius:
                                                BorderRadius.circular(40.r),
                                          ),
                                          child: Center(
                                            child: _isLoading
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFF1B1B1B))
                                                : Text(
                                                    // "Continue to Pay ₹${amountToPay.toStringAsFixed(2)}",
                                                    "Continue to Pay ₹${finalAmount.toStringAsFixed(2)}",
                                                    style: GoogleFonts.roboto(
                                                      color: Color(0xFF1B1B1B),
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              error: (error, stackTrace) {
                                return Center(
                                  child: Text(error.toString()),
                                );
                              },
                              loading: () => Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 44.h,
                    width: 106.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Color(0xFF1B1B1B), size: 16.sp),
                        SizedBox(width: 3.w),
                        Text("Add Coin",
                            style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1B1B1B))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Color(0xFF1B1B1B),
                // color: themeMode == ThemeMode.dark
                //     ? Colors.white
                //     : const Color(0xFF1B1B1B),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(19.w),
                child: Column(
                  children: [
                    // Search Bar or Title
                    _isSearching
                        ? Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 16.w),
                                const Icon(Icons.search, color: Colors.grey),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    style: TextStyle(
                                        color: themeMode == ThemeMode.dark
                                            ? Color(0xFF1B1B1B)
                                            : Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Search transactions...",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value.toLowerCase();
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSearching = false;
                                      _searchQuery = '';
                                      _searchController.clear();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.w),
                                    child: const Icon(Icons.close,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Payment Transaction",
                              style: GoogleFonts.roboto(
                                color: themeMode == ThemeMode.dark
                                    ? const Color(0xFF1B1B1B)
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                    SizedBox(height: _isSearching ? 15.h : 20.h),
                    Expanded(
                      child: transactionState.when(
                        data: (transactions) {
                          // Filter logic
                          final filteredList =
                              transactions.data!.where((trans) {
                            final query = _searchQuery;
                            if (query.isEmpty) return true;
                            return (trans.description
                                        ?.toLowerCase()
                                        .contains(query) ??
                                    false) ||
                                (trans.type?.toLowerCase().contains(query) ??
                                    false) ||
                                (trans.coins?.toLowerCase().contains(query) ??
                                    false);
                          }).toList();

                          if (filteredList.isEmpty) {
                            return Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? "No payment transaction"
                                    : "No matching transactions found",
                                style: GoogleFonts.roboto(
                                    color: const Color(0xFF666666),
                                    fontSize: 16.sp),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final trans = filteredList[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  color: themeMode == ThemeMode.dark
                                      ? const Color(0xffF1F2F6)
                                      : const Color(0xff9088F1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.person_sharp,
                                        size: 25.sp,
                                        color: themeMode == ThemeMode.dark
                                            ? const Color(0xffF1F2F6)
                                            : Colors.white),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalizeFirst(trans.type ?? ""),
                                            // trans.type!.toUpperCase() ?? 'Unknown',
                                            style: GoogleFonts.inter(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: themeMode ==
                                                        ThemeMode.dark
                                                    ? const Color(0xFF1B1B1B)
                                                    : Colors.white),
                                          ),
                                          Text(
                                            trans.description ?? '',
                                            style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: themeMode ==
                                                        ThemeMode.dark
                                                    ? const Color(0xFF1B1B1B)
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      trans.coins ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: (trans.coins?.startsWith('-') ==
                                                true)
                                            ? Colors.red
                                            : (themeMode == ThemeMode.dark
                                                ? const Color(0xff9088F1)
                                                : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static Future<String?> paymentCreateApi(String amount, String currency,
      String description, BuildContext context) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.razorpayOrder(PaymentCreateModel(
          currency: currency, description: description, amount: amount));
      if (response.data['success'] == true) {
        return response.data['payment']['order_id'].toString();
      } else {
        throw Exception(response.data['message'] ?? "Order creation failed");
      }
    } catch (e) {
      debugPrint("Payment Create Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Order failed: $e")));
      }
      return null;
    }
  }

  static Future<bool> paymentVerifyApi(
    String razorpay_payment_id,
    String razorpay_order_id,
    String razorpay_signature, {
    required BuildContext context,
  }) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.razorpayOrderVerify(
        PaymentVerifyModel(
          razorpay_payment_id: razorpay_payment_id,
          razorpay_order_id: razorpay_order_id,
          razorpay_signature: razorpay_signature,
        ),
      );

      return response.success == true && response.payment?.status == "paid";
    } catch (e) {
      debugPrint("Payment Verify Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Verification failed: $e"),
            backgroundColor: Colors.red));
      }
      return false;
    }
  }
}
