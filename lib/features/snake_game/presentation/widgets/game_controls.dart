import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const GameControls({
    Key? key,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildControlButton(Icons.arrow_upward, onUp),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildControlButton(Icons.arrow_back, onLeft),
                const SizedBox(width: 10),
                _buildControlButton(Icons.arrow_forward, onRight),
              ],
            ),
            const SizedBox(height: 10),
            _buildControlButton(Icons.arrow_downward, onDown),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}
