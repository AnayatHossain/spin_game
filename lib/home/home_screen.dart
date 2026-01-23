import 'package:flutter/material.dart';
import 'budget_controller.dart';

class SpinPopupView extends StatefulWidget {
  const SpinPopupView({super.key});

  @override
  State<SpinPopupView> createState() => _SpinPopupViewState();
}

class _SpinPopupViewState extends State<SpinPopupView> {
  final GlobalKey<FortuneWheelSpinnerState> _spinnerKey = GlobalKey();
  String? spinResult;

  final items = <String>[
    '120\$ for shoes',
    '85\$ for sneakers',
    '250\$ for boots',
    '60\$ for sandals',
    '300\$ for heels',
    '175\$ for loafers',
    '95\$ for flip-flops',
    '220\$ for trainers',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FortuneWheelSpinner(
              key: _spinnerKey,
              items: items,
              wheelSize: 300,
              onSpinEnd: (index) {
                setState(() {
                  spinResult = items[index];
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("You won: ${items[index]}")),
                );
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: (_spinnerKey.currentState?.isSpinning ?? false)
                  ? null
                  : () => _spinnerKey.currentState?.spin(),
              child: Text(
                (_spinnerKey.currentState?.isSpinning ?? false) ? "Spinning..." : "Spin",
              ),
            ),


            const SizedBox(height: 12),

            if (spinResult != null)
              Text(
                "Result: $spinResult",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }
}
