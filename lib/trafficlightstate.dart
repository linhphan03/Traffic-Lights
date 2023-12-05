//new type with fixed number of values it can take on
// import 'dart:html';

enum Color {
  //initialize these enum vars with string rep
  //because line 14
  none('-'),
  green('g'),
  yellow('y'),
  red('r');

  final String color;

  const Color(this.color);

  Color changeState() {
    //only if curState != Color.red
    if (this == Color.none) {
      return Color.green;
    }
    if (this == Color.green) {
      return Color.yellow;
    }
    //yellow
    return Color.red;
  }

  @override
  String toString() => color.toString();
}

enum Player {
  none('-'),
  one('Player 1'),
  two('Player 2');

  final String p;

  const Player(this.p);

  @override
  String toString() => p.toString();
}

class TrafficLightState {
  static const width = 3;
  static const height = 4;
  static const numCells = width * height;
  //all winning states
  static const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [9, 10, 11],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [4, 7, 10],
    [5, 8, 11],
    [0, 4, 8],
    [3, 7, 11], //changed from 4 -> 3
    [5, 7, 9],
    [2, 4, 6]
  ];

  late List<Color> board;
  late Player currentPlayer, winner;

  TrafficLightState() {
    //reset the state
    reset();
  }

  void reset() {
    board = List.filled(numCells, Color.none);
    currentPlayer = Player.one;
    winner = Player.none;
  }

  bool playAt(int i) {
    if (winner == Player.none && board[i] != Color.red) {
      board[i] = board[i].changeState();
      currentPlayer = (currentPlayer == Player.one) ? Player.two : Player.one;
      _checkWinner();
      return true;
    }
    return false;
  }

  void _checkWinner() {
    for (List<int> line in lines) {
      if (board[line[0]] != Color.none && 
        board[line[0]] == board[line[1]] && 
        board[line[1]] == board[line[2]]) {
          winner = (currentPlayer == Player.one) ? Player.two : Player.one;
          return;
      }
    }
  }

  Player getWinner() => winner;
  
  bool isGameOver() => winner != Player.none;
  
  String getStatus() {
    if (isGameOver()) {
      if (winner == Player.none) {
        return 'Draw';
      }
      return '$winner wins!';
    }
    return '$currentPlayer to play';
  }

  @override
  //toString for TicTacToeState
  String toString() {
    var sb = StringBuffer();

    for (int i = 0; i < board.length; i++) {
      sb.write(board[i].toString());

      if (i % width == width - 1) {
        sb.writeln();
      }
    }
    sb.writeln(getStatus());
    return sb.toString();
  }
}

//Test code
void main() {
  var s = TrafficLightState();
  print(s);
  var plays = [4, 0, 4, 6, 4, 5, 7, 1, 8];
  for (var i in plays) {
    print('Playing at $i.');
    s.playAt(i);
    print(s);
  }
}