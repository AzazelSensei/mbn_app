import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../widgets/bluetooth_device_list_entry.dart';
import '../widgets/drawer.dart';

class BluetoothView extends StatefulWidget {
  static const String route = '/BluetoothView';
  final bool start = true;
  const BluetoothView({super.key});

  @override
  State<BluetoothView> createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isDiscovering
            ? const Text('DISCOVERING DEVICES')
            : const Text('DISCOVERED DEVICES'),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      drawer: buildDrawer(context, BluetoothView.route),
      body: Column(
        children: [
          const Text(
            "You can connect by long press the device information.",
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: results.length,
            itemBuilder: (BuildContext context, index) {
              BluetoothDiscoveryResult result = results[index];
              final device = result.device;
              final address = device.address;
              return BluetoothDeviceListEntry(
                device: device,
                rssi: result.rssi,
                onLongPress: () async {
                  try {
                    bool bonded = false;
                    if (device.isBonded) {
                      debugPrint('Unbonding from ${device.address}...');
                      await FlutterBluetoothSerial.instance
                          .removeDeviceBondWithAddress(address);
                      debugPrint('Unbonding from ${device.address} has succed');
                    } else {
                      debugPrint('Bonding with ${device.address}...');
                      bonded = (await FlutterBluetoothSerial.instance
                          .bondDeviceAtAddress(address))!;
                      debugPrint(
                          'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                    }
                    setState(() {
                      results[results.indexOf(result)] =
                          BluetoothDiscoveryResult(
                              device: BluetoothDevice(
                                name: device.name ?? '',
                                address: address,
                                type: device.type,
                                bondState: bonded
                                    ? BluetoothBondState.bonded
                                    : BluetoothBondState.none,
                              ),
                              rssi: result.rssi);
                    });
                  } catch (ex) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error occured while bonding'),
                          content: Text(ex.toString()),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
