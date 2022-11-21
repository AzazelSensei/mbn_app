import 'package:flutter/material.dart';
import 'package:mbn_app/features/view/bluetooth_view.dart';
import 'package:mbn_app/features/view/nfc_manager_view.dart';

import '../view/location_history_view.dart';

Widget _buildMenuItem(
    BuildContext context, Widget title, String routeName, String currentRoute) {
  final isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Study Case'),
          ),
        ),
        _buildMenuItem(
          context,
          const Text('Location History'),
          LocationHistoryView.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('Bluetooth'),
          BluetoothView.route,
          currentRoute,
        ),
        _buildMenuItem(
          context,
          const Text('NFC Reader'),
          NfcManagerView.route,
          currentRoute,
        ),
      ],
    ),
  );
}
