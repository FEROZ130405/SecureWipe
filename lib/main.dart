import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/auth/signup_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/windows_wipe_page.dart';
import 'pages/linux_wipe_page.dart';
import 'pages/android_wipe_page.dart';
import 'pages/certificates_page.dart';
import 'pages/not_found_page.dart';
import 'state/wipe_provider.dart';

void main() {
  runApp(const SecureWipeApp());
}

class SecureWipeApp extends StatelessWidget {
  const SecureWipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WipeProvider()),
      ],
      child: MaterialApp(
        title: 'Secure Wipe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B5FFF),
            brightness: Brightness.light,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Use hash-based routing for GitHub Pages compatibility
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/windows-wipe': (context) => const WindowsWipePage(),
          '/linux-wipe': (context) => const LinuxWipePage(),
          '/android-wipe': (context) => const AndroidWipePage(),
          '/certificates': (context) => const CertificatesPage(),
        },
        // Handle unknown routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const NotFoundPage(),
          );
        },
      ),
    );
  }
}
