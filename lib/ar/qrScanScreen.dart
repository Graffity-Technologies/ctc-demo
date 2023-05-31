import 'dart:async';
import 'dart:typed_data';

import 'package:ctc_ar_demo/ar/arscreen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  String zipEventQRPrefix = "https://www.zipeventapp.com/bizcard/";
  bool _isRedirectToAR = false;
  bool _scanningVisible = true;
  late Timer scannerTimer;

  @override
  void initState() {
    scannerTimer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      setState(() {
        _scanningVisible = !_scanningVisible;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    scannerTimer.cancel();
    cameraController.stop();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              // fit: BoxFit.contain,
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (_isRedirectToAR || barcode.rawValue == null) continue;
                  if (!barcode.rawValue!.contains(zipEventQRPrefix)) {
                    continue;
                  }
                  var uid = barcode.rawValue!.split(zipEventQRPrefix).last;
                  debugPrint('QRCode found uid! $uid');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ARScreen(
                          qrcodeId: uid,
                        ),
                      ));
                  _isRedirectToAR = true;
                }
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 120, bottom: 0),
                child: AnimatedOpacity(
                  opacity: _scanningVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: Image.asset(
                    "images/scan-overlay-fix.png",
                    width: 280,
                  ),
                ),
              ),
            ),
            titleWidget(),
          ],
        ),
      ),
    );
  }

  Widget titleWidget() {
    return Container(
      color: const Color(0xfff4165f),
      // height: 60,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Scan QR Code on Your Wristband",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                ),
                // FxText.bodySmall("True Digital Park", color: Colors.white)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: const Text(
                    "To Start AR",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // const Icon(
          //   MdiIcons.accountPlusOutline,
          //   color: Colors.white,
          //   size: 22,
          // )
          SizedBox(
            width: 50,
            // margin: FxSpacing.top(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
                Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
