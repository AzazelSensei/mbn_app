import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbn_app/features/view/bluetooth_view.dart';
import 'features/view/location_history_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        LocationHistoryView.route: (context) => const LocationHistoryView(),
        BluetoothView.route: (context) => const BluetoothView(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Study Case',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        primarySwatch: Colors.deepPurple,
      ),
      home: const LocationHistoryView(),
    );
  }
}
