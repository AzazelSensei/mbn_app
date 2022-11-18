import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class BluetoothView extends StatefulWidget {
  static const String route = '/BluetoothView';
  const BluetoothView({super.key});

  @override
  State<BluetoothView> createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLUETOOTH"),
        centerTitle: true,
      ),
      drawer: buildDrawer(context, BluetoothView.route),
    );
  }
}
