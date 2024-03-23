import 'package:frontend/models/board/Board.dart';

abstract interface class BoardApi {
  Future<List<Board>> getAllBoards();

  static late BoardApi _impl;

  static void init(BoardApi impl) {
    _impl = impl;
  }

  static BoardApi getInstance() => _impl;
}