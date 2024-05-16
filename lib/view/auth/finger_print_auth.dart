import 'package:flutter/material.dart';

import '../../app_export.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({super.key});

  @override
  State<FingerPrintAuth> createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
   final LocalAuthentication auth = LocalAuthentication();
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}