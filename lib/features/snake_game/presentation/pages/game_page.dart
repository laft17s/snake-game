import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/features/snake_game/presentation/widgets/snake_painter.dart';
import '../widgets/game_controls.dart';
import '../../domain/entities/snake.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Snake _snake;
  late RivalSnake _rivalSnake; // Agregado para la serpiente rival
  late Position _food;
  late Position? _specialFood = null;
  int _score = 0;
  int _eatCount = 0;
  final int _gridSize = 30;
  final Random _random = Random();
  bool _specialFoodVisible = false;
  bool _rivalSnakeVisible =
      false; // Agregado para controlar la visibilidad de la serpiente rival
  late Timer _timer;
  late Timer
      _rivalSnakeTimer; // Agregado para el temporizador de la serpiente rival
  late DateTime _specialFoodDuration;
  final Duration _specialFoodTimeout = const Duration(seconds: 10);
  static const int _updateInterval = 150; // Velocidad de la serpiente principal
  int _rivalUpdateInterval = 400; // Velocidad de la serpiente rival ajustada

  @override
  void initState() {
    super.initState();
    _snake = Snake([Position(0, 0)], Direction.right, _gridSize, _gridSize, 5);
    _rivalSnake = RivalSnake([Position(15, 15)], Direction.left, _gridSize,
        _gridSize, 1); // Inicialización corregida
    _spawnFood();
    _startGame();
  }

  void _startGame() {
    _timer =
        Timer.periodic(Duration(milliseconds: _updateInterval), (Timer timer) {
      if (_specialFoodVisible &&
          DateTime.now().difference(_specialFoodDuration) >
              _specialFoodTimeout) {
        setState(() {
          _specialFoodVisible = false;
          _specialFood = null;
        });
      }

      setState(() {
        _snake.move();
        if (_rivalSnakeVisible) {
          _rivalSnake.move(
              _food); // Mueve la serpiente rival hacia la comida del jugador
        }
        if (_snake.checkSelfCollision()) {
          _snake.penalize();
          _score -= 5; // Penaliza el puntaje en 5 puntos
        }
        _checkCollision();
      });
    });

    _rivalSnakeTimer = Timer.periodic(
        Duration(milliseconds: _rivalUpdateInterval), (Timer timer) {
      if (_rivalSnakeVisible) {
        setState(() {
          _rivalSnake.move(
              _food); // Mueve la serpiente rival hacia la comida del jugador
          _checkRivalCollision();
        });
      }
    });
  }

  void _spawnFood() {
    int x = _random.nextInt(_gridSize);
    int y = _random.nextInt(_gridSize);
    setState(() {
      _food = Position(x, y);
    });
  }

  void _spawnSpecialFood() {
    int x = _random.nextInt(_gridSize);
    int y = _random.nextInt(_gridSize);
    setState(() {
      _specialFood = Position(x, y);
      _specialFoodVisible = true;
      _specialFoodDuration = DateTime.now();
    });
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

      if (_score >= 100 && !_rivalSnakeVisible) {
        setState(() {
          _rivalSnakeVisible =
              true; // Muestra la serpiente rival después de alcanzar 100 puntos
        });
      }
    }

    if (_specialFood != null &&
        _snake.body.first.x == _specialFood!.x &&
        _snake.body.first.y == _specialFood!.y) {
      _score += 100;
      _specialFood = null;
      _specialFoodVisible = false;
    }
  }

  void _checkRivalCollision() {
    // Verifica si la serpiente rival colisiona con la serpiente principal
    if (_rivalSnake.body.any((segment) =>
        segment.x == _snake.body.first.x && segment.y == _snake.body.first.y)) {
      setState(() {
        _rivalSnakeVisible = false; // Destruye la serpiente rival
      });

      // Reconfigura la serpiente rival para reaparecer después de alcanzar otros 100 puntos
      _rivalSnake = RivalSnake(
          [Position(15, 15)], Direction.left, _gridSize, _gridSize, 1);
      _rivalUpdateInterval =
          400; // Restablece la velocidad de la serpiente rival
    }

    // Verifica si la serpiente rival come comida
    if (_rivalSnake.body.first.x == _food.x &&
        _rivalSnake.body.first.y == _food.y) {
      _score += 10; // Incrementa el puntaje si la serpiente rival come
      _rivalSnake
          .grow(); // Llama al método grow para hacer que la serpiente rival crezca
      _spawnFood(); // Reposiciona la comida
    }
  }

  void _changeDirection(Direction newDirection) {
    setState(() {
      _snake.direction = newDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Score: $_score | Lives: ${_snake.lives}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.black,
                child: CustomPaint(
                  painter: SnakePainter(_snake, _food, _specialFood,
                      _rivalSnakeVisible ? _rivalSnake : null, _gridSize),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GameControls(
              onUp: () => _changeDirection(Direction.up),
              onDown: () => _changeDirection(Direction.down),
              onLeft: () => _changeDirection(Direction.left),
              onRight: () => _changeDirection(Direction.right),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _rivalSnakeTimer.cancel();
    super.dispose();
  }
}
