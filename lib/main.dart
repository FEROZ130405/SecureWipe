import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/auth/login_page.dart';
import 'pages/dashboard_page.dart';
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
        // -----------------------------
        // Enable hash-based routing for GitHub Pages
        // -----------------------------
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(), // your dashboard route
          // Add other routes here if needed
        },
        // Enable hash-based URLs for web
        routerDelegate: null,
        routeInformationParser: null,
        // Flutter Web will now use URLs like /#/dashboard instead of /dashboard
        // which avoids white screens on GitHub Pages project sites
      ),
    );
  }
}
