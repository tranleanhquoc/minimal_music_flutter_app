import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/playlist_provider.dart';
import 'pages/home_page.dart';
import 'themes/theme_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: <ListenableProvider<dynamic>>[
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<PlaylistProvider>(
          create: (_) => PlaylistProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
