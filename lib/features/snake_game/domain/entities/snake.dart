class Snake {
  late List<Position> body;
  late Direction direction;
  final int gridWidth;
  final int gridHeight;
  int lives;

  Snake(this.body, this.direction, this.gridWidth, this.gridHeight, this.lives);

  void move() {
    final head = body.first;
    Position newHead;

    switch (direction) {
      case Direction.up:
        newHead = Position(head.x, (head.y - 1 + gridHeight) % gridHeight);
        break;
      case Direction.down:
        newHead = Position(head.x, (head.y + 1) % gridHeight);
        break;
      case Direction.left:
        newHead = Position((head.x - 1 + gridWidth) % gridWidth, head.y);
        break;
      case Direction.right:
        newHead = Position((head.x + 1) % gridWidth, head.y);
        break;
    }

    body.insert(0, newHead);
    body.removeLast(); // Remove the last segment of the tail
  }

  void grow() {
    final tail = body.last;
    Position newTail;

    switch (direction) {
      case Direction.up:
        newTail = Position(tail.x, (tail.y + 1) % gridHeight);
        break;
      case Direction.down:
        newTail = Position(tail.x, (tail.y - 1 + gridHeight) % gridHeight);
        break;
      case Direction.left:
        newTail = Position((tail.x + 1) % gridWidth, tail.y);
        break;
      case Direction.right:
        newTail = Position((tail.x - 1 + gridWidth) % gridWidth, tail.y);
        break;
    }

    body.add(newTail);
  }

  bool checkSelfCollision() {
    final head = body.first;
    // Check if head collides with any other segment
    return body
        .skip(1)
        .any((segment) => segment.x == head.x && segment.y == head.y);
  }

  void penalize() {
    lives--;
    if (lives > 0) {
      shrink(); // Reduce the size of the snake by 50%
    }
  }

  void shrink() {
    final newSize = (body.length * 0.5).toInt();
    body = body.take(newSize).toList();
  }
}

class RivalSnake {
  late List<Position> body;
  late Direction direction;
  final int gridWidth;
  final int gridHeight;
  final int speed; // Añadido para controlar la velocidad de la serpiente rival

  RivalSnake(
      this.body, this.direction, this.gridWidth, this.gridHeight, this.speed);

  void move(Position playerFood) {
    final head = body.first;
    Position newHead;

    // Determina la dirección en la que la serpiente rival debe moverse
    Direction bestDirection = direction;
    int minDistance = _distance(head, playerFood);

    // Prueba cada dirección posible
    for (var dir in Direction.values) {
      Position candidateHead = _nextPosition(head, dir);
      int distance = _distance(candidateHead, playerFood);

      if (!_isCollision(candidateHead) && distance < minDistance) {
        bestDirection = dir;
        minDistance = distance;
      }
    }

    // Mueve la serpiente rival en la mejor dirección
    newHead = _nextPosition(head, bestDirection);

    // Envuelve alrededor del grid
    newHead = Position(
      (newHead.x + gridWidth) % gridWidth,
      (newHead.y + gridHeight) % gridHeight,
    );

    body.insert(0, newHead);
    body.removeLast(); // Elimina el último segmento de la cola
  }

  Position _nextPosition(Position head, Direction dir) {
    switch (dir) {
      case Direction.up:
        return Position(head.x, (head.y - 1 + gridHeight) % gridHeight);
      case Direction.down:
        return Position(head.x, (head.y + 1) % gridHeight);
      case Direction.left:
        return Position((head.x - 1 + gridWidth) % gridWidth, head.y);
      case Direction.right:
        return Position((head.x + 1) % gridWidth, head.y);
    }
  }

  int _distance(Position a, Position b) {
    return ((a.x - b.x).abs() + (a.y - b.y).abs());
  }

  bool _isCollision(Position pos) {
    return body.any((segment) => segment.x == pos.x && segment.y == pos.y);
  }

  void grow() {
    // Añade un nuevo segmento en la dirección de la cabeza
    final head = body.first;
    Position newSegment;

    switch (direction) {
      case Direction.up:
        newSegment = Position(head.x, (head.y + 1) % gridHeight);
        break;
      case Direction.down:
        newSegment = Position(head.x, (head.y - 1 + gridHeight) % gridHeight);
        break;
      case Direction.left:
        newSegment = Position((head.x + 1) % gridWidth, head.y);
        break;
      case Direction.right:
        newSegment = Position((head.x - 1 + gridWidth) % gridWidth, head.y);
        break;
    }

    body.add(newSegment);
  }
}

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);
}

enum Direction { up, down, left, right }
