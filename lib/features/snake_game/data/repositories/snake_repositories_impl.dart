import 'dart:math';
import 'package:snake_game/features/snake_game/domain/repositories/snake_reopositories.dart';
import '../../domain/entities/snake.dart';

class SnakeRepositoryImpl implements SnakeRepository {
  late Snake _snake;
  late Position _food;
  late Position? _specialFood = null; // Inicializar como null
  late Snake _rivalSnake; // Añadido para la serpiente rival
  int _score = 0;
  int _eatCount = 0;
  final int _gridSize = 30;
  final Random _random = Random();
  bool _specialFoodVisible = false;
  late DateTime _specialFoodDuration;
  final Duration _specialFoodTimeout = const Duration(seconds: 10);
  bool _rivalSnakeActive = false; // Indica si la serpiente rival está activa

  SnakeRepositoryImpl() {
    _snake = Snake([Position(0, 0)], Direction.right, _gridSize, _gridSize, 5);
    _rivalSnake = Snake([Position(15, 15)], Direction.left, _gridSize,
        _gridSize, 1); // Inicializa la serpiente rival
    _spawnFood();
  }

  @override
  Snake getSnake() {
    return _snake;
  }

  @override
  Snake? getRivalSnake() {
    return _rivalSnakeActive ? _rivalSnake : null;
  }

  @override
  Position getFood() {
    return _food;
  }

  @override
  Position? getSpecialFood() {
    return _specialFood;
  }

  @override
  int getScore() {
    return _score;
  }

  @override
  void moveSnake() {
    _snake.move();
    if (_snake.checkSelfCollision()) {
      _snake.penalize();
      _score -= 5; // Penaliza el puntaje en 5 puntos
    }
    if (_rivalSnakeActive) {
      _rivalSnake.move(); // Mueve la serpiente rival
      _checkRivalCollision(); // Verifica las colisiones con la serpiente rival
    }
    _checkCollision();
  }

  @override
  void changeDirection(Direction direction) {
    _snake.direction = direction;
  }

  @override
  void growSnake() {
    _snake.grow();
    _spawnFood();
  }

  @override
  void spawnFood() {
    _spawnFood();
  }

  @override
  void spawnSpecialFood() {
    _spawnSpecialFood();
  }

  @override
  void spawnRivalSnake() {
    if (!_rivalSnakeActive) {
      _rivalSnakeActive = true;
    }
  }

  void _spawnFood() {
    int x = _random.nextInt(_gridSize);
    int y = _random.nextInt(_gridSize);
    _food = Position(x, y);
  }

  void _spawnSpecialFood() {
    int x = _random.nextInt(_gridSize);
    int y = _random.nextInt(_gridSize);
    _specialFood = Position(x, y);
    _specialFoodVisible = true;
    _specialFoodDuration = DateTime.now();
  }

  void _checkCollision() {
    if (_snake.body.first.x == _food.x && _snake.body.first.y == _food.y) {
      _eatCount++;
      _score += 10;
      _snake.grow(); // Llama al método grow para hacer que la serpiente crezca
      _spawnFood();
      if (_eatCount % 5 == 0) {
        _spawnSpecialFood();
      }
      if (_score >= 100 && !_rivalSnakeActive) {
        spawnRivalSnake(); // Activa la serpiente rival
      }
    }

    if (_specialFood != null &&
        _snake.body.first.x == _specialFood!.x &&
        _snake.body.first.y == _specialFood!.y) {
      _score += 100;
      _specialFood = null;
      _specialFoodVisible = false;
    }

    if (_specialFoodVisible &&
        DateTime.now().difference(_specialFoodDuration) > _specialFoodTimeout) {
      _specialFoodVisible = false;
      _specialFood = null;
    }
  }

  void _checkRivalCollision() {
    if (_snake.body.first.x == _rivalSnake.body.first.x &&
        _snake.body.first.y == _rivalSnake.body.first.y) {
      // Colisión con la serpiente rival
      _snake.penalize();
      _score -= 5; // Penaliza el puntaje en 5 puntos
      _snake.shrink(); // Reduce el tamaño de la serpiente
      if (_snake.lives <= 0) {
        _rivalSnakeActive =
            false; // Desactiva la serpiente rival si el jugador pierde
      }
    }

    if (_rivalSnake.body.first.x == _snake.body.first.x &&
        _rivalSnake.body.first.y == _snake.body.first.y) {
      // La serpiente rival colisiona con la serpiente del jugador
      _rivalSnakeActive = false; // Destruye la serpiente rival
    }
  }
}
