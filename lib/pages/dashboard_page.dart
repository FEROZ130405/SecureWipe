import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'linux_wipe_page.dart';
import 'windows_wipe_page.dart';
import 'android_wipe_page.dart';
import 'certificates_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    
    final pages = isAndroid ? <Widget>[
      const AndroidWipePage(),
      const CertificatesPage(),
    ] : <Widget>[
      const WindowsWipePage(),
      const LinuxWipePage(),
      const AndroidWipePage(),
      const CertificatesPage(),
    ];

    final titles = isAndroid ? <String>['Android Wipe', 'Certificates'] : <String>['Windows Wipe', 'Linux Wipe', 'Android Wipe', 'Certificates'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        children: isAndroid ? const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 8),
            child: Text('Secure Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.smartphone),
            label: Text('Android Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.verified),
            label: Text('Certificates'),
          ),
        ] : const [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 8),
            child: Text('Secure Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.window),
            label: Text('Windows Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.lan),
            label: Text('Linux Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.smartphone),
            label: Text('Android Wipe'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.verified),
            label: Text('Certificates'),
          ),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 900)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              labelType: NavigationRailLabelType.all,
              destinations: isAndroid ? const [
                NavigationRailDestination(icon: Icon(Icons.smartphone), label: Text('Android')),
                NavigationRailDestination(icon: Icon(Icons.verified), label: Text('Certificates')),
              ] : const [
                NavigationRailDestination(icon: Icon(Icons.window), label: Text('Windows')),
                NavigationRailDestination(icon: Icon(Icons.lan), label: Text('Linux')),
                NavigationRailDestination(icon: Icon(Icons.smartphone), label: Text('Android')),
                NavigationRailDestination(icon: Icon(Icons.verified), label: Text('Certificates')),
              ],
            ),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}
