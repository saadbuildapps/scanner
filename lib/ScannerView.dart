import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gscankit/gscankit.dart';

class CustomScannerScreen extends StatefulWidget {
  const CustomScannerScreen({super.key});

  @override
  State<CustomScannerScreen> createState() => _CustomScannerScreenState();
}

class _CustomScannerScreenState extends State<CustomScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final ValueNotifier<bool?> scanSuccess = ValueNotifier<bool?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// ✅ Main Scanner
          GscanKit(
            controller: controller,
            scanWindow: Rect.fromCenter(
              center: Offset(200, 400),
              width: 280,
              height: 400,
            ),

            extendBodyBehindAppBar: true,
            setPortraitOrientation: true,
            fit: BoxFit.cover,
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue ?? "No data";
              scanSuccess.value = true;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Scanned: $code")));
            },
            gscanOverlayConfig: GscanOverlayConfig(
              scannerScanArea: ScannerScanArea.center,
              // scannerOverlayBackgroundColor: Colors.black.withOpacity(1),
              scannerOverlayBackground: ScannerOverlayBackground.none,
              borderColor: Colors.white,
              background: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 130,
                    width: 200,
                    color: Colors.white.withOpacity(1), // slight tint on blur
                  ),
                ),
              ),

              cornerRadius: 28.0,
              cornerLength: 70,
              borderRadius: 30.0,
              scannerBorder: ScannerBorder.visible,
              scannerBorderPulseEffect: ScannerBorderPulseEffect.none,
              scannerLineAnimation: ScannerLineAnimation.enabled,
              scannerLineAnimationColor: Colors.white,
              scannerLineanimationDuration: const Duration(milliseconds: 1200),
              lineThickness: 5.5,
            ),
          ),

          /// ✅ Gradient overlay at top (for fade-in AppBar)
          // Container(
          //   height: 200,
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [Colors.black54, Colors.transparent],
          //     ),
          //   ),
          // ),

          /// ✅ Top bar (like iOS style)
          Positioned(
            top: 5,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 100),
                    const Text(
                      "Scanning",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 30), // balance layout
                  ],
                ),
              ),
            ),
          ),

          /// ✅ Bottom actions
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Center circular scan button
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 30),

                  /// Torch toggle button
                  ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, state, child) {
                      final isTorchOn = state.torchState == TorchState.on;
                      return IconButton(
                        onPressed: () => controller.toggleTorch(),
                        icon: Icon(
                          isTorchOn
                              ? CupertinoIcons.lightbulb_fill
                              : CupertinoIcons.lightbulb,
                          color: Colors.white70,
                          size: 28,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
