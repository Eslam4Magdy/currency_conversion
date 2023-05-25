import 'package:currency_app/presentation/pages/currency_conversion_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Exchange Rates App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrencyConversionPage(),
    );
  }
}
