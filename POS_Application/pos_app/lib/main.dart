import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // DİKKAT: Yatay mod kilidini sildik, artık her yöne dönebilir.
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Daniel's Coffee POS",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D1B14)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}