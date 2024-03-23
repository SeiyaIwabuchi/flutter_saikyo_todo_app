import 'package:frontend/apis/commons/Middleware.dart';
import 'package:frontend/models/board/Board.dart';

import 'BoardApi.dart';

class BoardApiImpl implements BoardApi {
  @override
  Future<List<Board>> getAllBoards() async {
    dynamic boardList = await Middleware.getInstance().get_all_boards();
    return Board.fromList(boardList);
  }
}