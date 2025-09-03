import 'package:local_basket/components/custom_button.dart';
import 'package:local_basket/components/custom_snackbar.dart';
import 'package:local_basket/core/constants/colors.dart';
import 'package:local_basket/core/constants/img_const.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:local_basket/presentation/cubit/authentication/login/trigger_otp_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/login/trigger_otp_state.dart';
import 'package:local_basket/presentation/cubit/authentication/signin/sigin_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/signin/signin_state.dart';
import 'package:local_basket/presentation/screen/authentication/login_screen.dart';
import 'package:local_basket/presentation/screen/authentication/nameInput_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_basket/presentation/screen/dashboard/main_dashboard_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  String otp;
  String fullName;
  String otpValue;

  OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.otp,
    required this.otpValue,
    required this.fullName,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _otpFocusNode.addListener(() {
      if (_otpFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  void _navigateBasedOnCustomerStatus(BuildContext context) {
    context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);
  }

  @override
  void dispose() {
    otpController.dispose();
    _scrollController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignInCubit, SignInState>(
            listener: (context, state) {
              if (state is SignInLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }

              if (state is SignInLoaded) {
                _navigateBasedOnCustomerStatus(context);
              } else if (state is SignInError) {
                CustomSnackbars.showErrorSnack(
                  context: context,
                  title: "Failed",
                  message:
                      "The OTP you entered is incorrect. Please try again.",
                );
              }
            },
          ),
          BlocListener<TriggerOtpCubit, TriggerOtpState>(
            listener: (context, state) {
              if (state is ResendOtpLoaded) {
                setState(() {
                  widget.otp = state.resendOtp.otp ?? '';
                });
              }
            },
          ),
          BlocListener<CurrentCustomerCubit, CurrentCustomerState>(
            listener: (context, state) {
              if (state is CurrentCustomerLoaded && !_hasNavigated) {
                _hasNavigated = true;
                if (state.currentCustomerModel.eato == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainDashboard()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const NameInputScreen()),
                  );
                }
              } else if (state is CurrentCustomerError) {
                CustomSnackbars.showErrorSnack(
                  context: context,
                  title: "Failed",
                  message: "Something went wrong",
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      dish,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  top: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "OTP Verification",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.PrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Sending tasty updates to +91 ${widget.mobileNumber}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Change",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.PrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.otp != 'true') ...[
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          widget.otp,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Center(
                      child: Pinput(
                        focusNode: _otpFocusNode,
                        controller: otpController,
                        length: 6,
                        onCompleted: (value) {
                          if (value.length == 6) {
                            context.read<SignInCubit>().signIn(
                                  context,
                                  widget.mobileNumber,
                                  value,
                                  widget.fullName,
                                );
                          }
                        },
                        defaultPinTheme: PinTheme(
                          width: 40,
                          height: 40,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColor.PrimaryColor,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.PrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            buttonText: "Verify & Continue",
                            isLoading: state is SignInLoading,
                            onPressed: () {
                              if (otpController.text.length == 6) {
                                context.read<SignInCubit>().signIn(
                                      context,
                                      widget.mobileNumber,
                                      otpController.text,
                                      widget.fullName,
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter a valid 6-digit OTP."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: InkWell(
                        onTap: () {
                          context
                              .read<TriggerOtpCubit>()
                              .resendOtp(context, widget.mobileNumber);
                        },
                        child: Text(
                          "Didn't receive it? Resend OTP",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: Colors.grey.shade700,
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
    );
  }
}
