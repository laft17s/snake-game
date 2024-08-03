import '../entities/snake.dart';

abstract class SnakeRepository {
  Snake getSnake();
  Snake? getRivalSnake(); // Añadido para obtener la serpiente rival
  Position getFood();
  Position? getSpecialFood();
  int getScore();
  void moveSnake();
  void changeDirection(Direction direction);
  void growSnake();
  void spawnFood();
  void spawnSpecialFood();
  void spawnRivalSnake(); // Añadido para crear la serpiente rival
}
