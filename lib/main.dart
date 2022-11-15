import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const kWebRecaptchaSiteKey = '6Lefm-wiAAAAAHEU6LGhlqe1iDnVf06RqtEy-mr-';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  firebaseAppCheck.installAppCheckProviderFactory(
      PlayIntegrityAppCheckProviderFactory.());

  runApp(MaterialApp(home: TestForConnection()));
}

class TestForConnection extends StatelessWidget {
  TestForConnection({Key? key}) : super(key: key);

  final DatabaseReference _mesRef = FirebaseDatabase.instance.ref().child('private').child('codes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Column(
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD06700),
                  foregroundColor: Colors.black,
                  //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  //fixedSize: const Size(0, 50),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
              ),
              child: Text('Send Code', style: TextStyle(fontSize: 18)),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Send Code'),
                    content: Text('resetChatMessage'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          print("test test test ++++++++++++++++++");
                          //
                          await _mesRef.child("PAAAAA5").child("status").set(false);
                        },
                        child: Text('confirm'),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }
}


class MyHome extends StatelessWidget {
  MyHome({Key? key}) : super(key: key);

  final DatabaseReference _mesRef = FirebaseDatabase.instance.ref().child('private').child('codes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QRViewExample(),
                ));
              },
              child: const Text('qrView'),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD06700),
                    foregroundColor: Colors.black,
                    //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    //fixedSize: const Size(0, 50),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                ),
                child: Text('Send Code', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Send Code'),
                      content: Text('resetChatMessage'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            await _mesRef.set({
                              "PAAAAA1": {
                                "status": false
                              }
                            });
                          },
                          child: Text('confirm'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final DatabaseReference _mesRef = FirebaseDatabase.instance.ref().child('private').child('codes');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                            if(result != null){


                            }
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD06700),
                              foregroundColor: Colors.black,
                              //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                              //fixedSize: const Size(0, 50),
                              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                          ),
                          child: Text('Send Code', style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Send Code'),
                                content: Text('resetChatMessage'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if(result != null && result?.code != null){
                                        int? length = result!.code?.length;
                                        String? code = result?.code.toString().split("/").last;
                                        print(code! + "+++++++++++++++++++++++++++++" + result!.code.toString());
                                        await _mesRef.set({
                                          code.toString(): {
                                            "status": false
                                          }
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text('confirm'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}