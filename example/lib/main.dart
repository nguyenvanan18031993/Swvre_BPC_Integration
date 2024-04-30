import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bpc_swvre/bpc_swvre.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _connectStatus = 'Connect';
  String _setCustomUserProperties = 'Custom User Properties';
  bool _connect = false;
  final _bpcSwvrePlugin = BpcSwvre();
  final TextEditingController _evenController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> connectSwvre() async {
    String connectStatus;
    try {
      connectStatus = await _bpcSwvrePlugin.connectSwvreSDK() ?? 'Connect';
      _connect = !_connect;
    } on PlatformException {
      connectStatus = 'Failed to connect sdk.';
    }
    if (!mounted) return;
    setState(() {
      _connectStatus = connectStatus;
    });
  }

  Future<void> embedSwvre() async {
    String? embedStatus;
    try {
      embedStatus = await _bpcSwvrePlugin.embedCampaignSwvreSDK() ?? 'Connect';
    } on PlatformException {
      embedStatus = 'Failed to embed sdk.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _evenController,
                decoration: const InputDecoration(
                  hintText: 'Enter the event',
                  labelText: 'Event *',
                ),
                onChanged: (value) {
                  setState(() {});
                },
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null) ? 'Please enter event.' : null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _evenController.text != ''
                        ? () async {
                            try {
                              final result =
                                  await _bpcSwvrePlugin.event(_evenController.text, null);
                              print(result);
                              _evenController.text = '';
                              setState(() {});
                            } on PlatformException {
                              print('Failed to embed sdk.');
                            }
                          }
                        : null,
                    child: Text("Send Event"),
                  ),
                  ElevatedButton(
                    onPressed: _evenController.text != ''
                        ? () async {
                            try {
                              final result = await _bpcSwvrePlugin.event(
                                  _evenController.text, {'key1': "value1", 'key2': "value2"});
                              print(result);
                              _evenController.text = '';
                              setState(() {});
                            } on PlatformException {
                              print('Failed to embed sdk.');
                            }
                          }
                        : null,
                    child: Text("Send Event With Payload"),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final userId = await _bpcSwvrePlugin.userUpdate({
                      "first_name": "aa",
                      "last_name": "bb",
                      "balance": 1000,
                      "plan": "plan",
                      "profile_status": "active",
                      "language": "EN",
                      "wallet_size": "mini",
                      "phone_number": "0891699999",
                      "remittance_opt_in": "yes"
                    });
                    setState(() {
                      _setCustomUserProperties = userId ?? "";
                    });
                  } on PlatformException {
                    print('Failed to embed sdk.');
                  }
                },
                child: Text(_setCustomUserProperties),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final userId = await _bpcSwvrePlugin
                        .identifySwrveUser("0471b724-7bc3-49aa-ae2e-9238145257f1");
                    setState(() {
                      _setCustomUserProperties = userId ?? "";
                    });
                  } on PlatformException {
                    print('Failed to embed sdk.');
                  }
                },
                child: Text("Update User Id"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
