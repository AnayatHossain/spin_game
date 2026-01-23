import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelSpinner extends StatefulWidget {
  final List<String> items;
  final Function(int index)? onSpinEnd;
  final double wheelSize;
  final Duration spinDuration;

  const FortuneWheelSpinner({
    super.key,
    required this.items,
    this.onSpinEnd,
    this.wheelSize = 300.0,
    this.spinDuration = const Duration(seconds: 3),
  });

  @override
  FortuneWheelSpinnerState createState() => FortuneWheelSpinnerState();
}

class FortuneWheelSpinnerState extends State<FortuneWheelSpinner> {
  final StreamController<int> _selected = StreamController<int>();
  bool _isSpinning = false;

  int? _pendingIndex; // ✅ store result until animation actually ends

  bool get isSpinning => _isSpinning;

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void spin() {
    if (_isSpinning) return;

    setState(() => _isSpinning = true);

    _pendingIndex = Fortune.randomInt(0, widget.items.length);
    _selected.add(_pendingIndex!);
  }

  void _handleAnimationEnd() {
    if (_pendingIndex == null) return;

    final resultIndex = _pendingIndex!;
    _pendingIndex = null;

    widget.onSpinEnd?.call(resultIndex);

    if (mounted) {
      setState(() => _isSpinning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [const Color(0xFFF9DF5F), const Color(0xFF85D084)];

    return SizedBox(
      height: widget.wheelSize,
      width: widget.wheelSize,
      child: FortuneWheel(
        animateFirst: false,
        selected: _selected.stream,

        // ✅ This is the REAL "spin finished" moment
        onAnimationEnd: _handleAnimationEnd,

        physics: CircularPanPhysics(
          duration: widget.spinDuration, // 3 seconds
          curve: Curves.decelerate,
        ),

        items: List.generate(
          widget.items.length,
              (i) => FortuneItem(
            child: Text(
              widget.items[i],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            style: FortuneItemStyle(
              color: colors[i % colors.length],
              borderColor: Colors.deepOrangeAccent,
              borderWidth: 4.0,
            ),
          ),
        ),
      ),
    );
  }
}
