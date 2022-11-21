import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../widgets/drawer.dart';

class NfcManagerView extends StatefulWidget {
  static const String route = '/nfc_reader';
  const NfcManagerView({super.key});

  @override
  State<NfcManagerView> createState() => _NfcManagerViewState();
}

class _NfcManagerViewState extends State<NfcManagerView> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  bool isAvailable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC MANAGER'),
        centerTitle: true,
      ),
      drawer: buildDrawer(context, NfcManagerView.route),
      body: FutureBuilder<bool>(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) => ss.data != true
            ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
            : Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      constraints: const BoxConstraints.expand(),
                      decoration: BoxDecoration(border: Border.all()),
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder<dynamic>(
                          valueListenable: result,
                          builder: (context, value, _) =>
                              Text('${value ?? ''}'),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ElevatedButton(
                            onPressed: _tagRead,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Tag Read'),
                                Text(
                                    "(Click again to rescan the card after it has been swiped.)")
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
      isAvailable = true;
    });
  }
}
