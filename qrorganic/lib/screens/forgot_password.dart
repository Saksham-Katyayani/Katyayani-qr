import 'package:flutter/material.dart';
import 'package:qrorganic/Provider/auth_provider.dart';
import 'package:qrorganic/custom/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isSendingOtp = false;
  bool _isEmailValid = false;
  bool _isEmailEmpty = true;

  final AuthProvider _authProvider = AuthProvider();

  void _showSnackbar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? Colors.black : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _validateEmail(String email) {
    setState(() {
      _isEmailEmpty = email.isEmpty;
      _isEmailValid = RegExp(r'\S+@\S+\.\S+').hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 62.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please enter your email',
                        style: TextStyle(color: AppColors.black),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: AppColors.black, fontSize: 16),
                                cursorColor: AppColors.blueAccent,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                    color: AppColors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: _inputBorder(AppColors.blueAccent.withOpacity(0.7)),
                                  focusedBorder: _inputBorder(AppColors.blueAccent),
                                  errorBorder: _inputBorder(Colors.red),
                                  focusedErrorBorder: _inputBorder(Colors.red),
                                  suffixIcon: _emailController.text.isNotEmpty
                                      ? Icon(
                                          _isEmailValid ? Icons.check_circle : Icons.cancel,
                                          color: _isEmailValid ? Colors.green : Colors.red,
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  hintText: 'example@example.com',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _validateEmail(value);
                                },
                                enabled: !_isOtpVerified,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _otpController,
                                enabled: _isOtpSent && !_isOtpVerified,
                                style: const TextStyle(color: AppColors.black, fontSize: 16),
                                cursorColor: AppColors.blueAccent,
                                decoration: InputDecoration(
                                  labelText: 'OTP',
                                  labelStyle: const TextStyle(
                                    color: AppColors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: _inputBorder(AppColors.blueAccent.withOpacity(0.7)),
                                  focusedBorder: _inputBorder(AppColors.blueAccent),
                                  errorBorder: _inputBorder(Colors.red),
                                  focusedErrorBorder: _inputBorder(Colors.red),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  hintText: 'Enter your OTP',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your OTP';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: !_isEmailValid || _isEmailEmpty
                                          ? null
                                          : _emailController.text.isNotEmpty && !_isOtpSent
                                              ? () async {
                                                  setState(() {
                                                    _isSendingOtp = true;
                                                  });

                                                  final result = await _authProvider.forgotPassword(_emailController.text);
                                                  _showSnackbar(result['message'], isSuccess: result['success']);

                                                  if (result['success']) {
                                                    setState(() {
                                                      _isOtpSent = true;
                                                      _isSendingOtp = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _isSendingOtp = false;
                                                    });
                                                  }
                                                }
                                              : _isOtpSent && !_isOtpVerified
                                                  ? () async {
                                                      final result = await _authProvider.verifyOtp(
                                                        _emailController.text,
                                                        _otpController.text,
                                                      );
                                                      _showSnackbar(result['message'], isSuccess: result['success']);
                                                      if (result['success']) {
                                                        setState(() {
                                                          _isOtpVerified = true;
                                                        });
                                                      }
                                                    }
                                                  : null,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: AppColors.primaryBlue,
                                        backgroundColor: AppColors.white,
                                      ),
                                      child: Text(_isSendingOtp ? 'Sending...' : _isOtpSent ? 'Verify' : 'Send OTP'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isOtpVerified
                                  ? () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        Navigator.pushNamed(context, '/reset_password');
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.primaryBlue,
                                backgroundColor: AppColors.white,
                              ),
                              child: const Text('Reset Password'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
