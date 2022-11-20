import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

import '../widgets/drawer.dart';

class BluetoothView extends StatefulWidget {
  static const String route = '/BluetoothView';
  const BluetoothView({super.key});

  @override
  State<BluetoothView> createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  bool isClicked = false;
  BleManager bleManager = BleManager();

  @override
  initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLUETOOTH"),
        centerTitle: true,
      ),
      drawer: buildDrawer(context, BluetoothView.route),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
