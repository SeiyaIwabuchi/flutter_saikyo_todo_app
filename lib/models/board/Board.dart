class Board {
  final int boardId;
  final List<int> taskOrderList;

  Board({required this.boardId, required this.taskOrderList});

  Board copyWith({List<int>? taskOrderList}) {
    return Board(
        boardId: boardId, taskOrderList: taskOrderList ?? this.taskOrderList);
  }

  @override
  String toString() {
    return 'Board{boardId: $boardId, taskOrderList: $taskOrderList}';
  }

  factory Board.fromMap(Map<String, dynamic> raw) {
    List<dynamic> list = raw["tasks_order_list"];
    return Board(
        boardId: raw["board_id"], taskOrderList: list.whereType<int>().toList());
  }

  static List<Board> fromList(List<dynamic> list) {
    return list.map((e) => Board.fromMap(e)).toList();
  }
}
