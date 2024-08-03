import 'package:flutter/material.dart';
import '../../domain/entities/snake.dart';

class SnakePainter extends CustomPainter {
  final Snake snake;
  final Position food;
  final Position? specialFood;
  final RivalSnake? rivalSnake; // Corregido para aceptar RivalSnake
  final int gridSize;

  SnakePainter(
      this.snake, this.food, this.specialFood, this.rivalSnake, this.gridSize);

  @override
  void paint(Canvas canvas, Size size) {
    final snakePaint = Paint()..color = Colors.green;
    final foodPaint = Paint()..color = Colors.red;
    final specialFoodPaint = Paint()..color = Colors.cyan;
    final rivalSnakePaint = Paint()
      ..color = Colors.yellow; // Color para la serpiente rival
    final cellSize = size.width / gridSize;

    // Dibuja la serpiente
    for (var segment in snake.body) {
      final rect = Rect.fromLTWH(
        segment.x * cellSize,
        segment.y * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(rect, snakePaint);
    }

    // Dibuja la serpiente rival si existe
    if (rivalSnake != null) {
      for (var segment in rivalSnake!.body) {
        final rect = Rect.fromLTWH(
          segment.x * cellSize,
          segment.y * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, rivalSnakePaint);
      }
    }

    // Dibuja la comida
    final foodRect = Rect.fromLTWH(
      food.x * cellSize,
      food.y * cellSize,
      cellSize,
      cellSize,
    );
    canvas.drawRect(foodRect, foodPaint);

    // Dibuja los puntos especiales
    if (specialFood != null) {
      final specialFoodRect = Rect.fromLTWH(
        specialFood!.x * cellSize,
        specialFood!.y * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(specialFoodRect, specialFoodPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
