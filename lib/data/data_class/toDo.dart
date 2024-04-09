class ToDo {
// Database id(Key)
  int? id;

  final String todo;
  final int todoDate;
  final String time;
  late final String timeLeft;
  final String percentageRemaining = '60%';

  ToDo({
    required this.todo,
    required this.todoDate,
    required this.time,
    required this.timeLeft,
    // required this.percentageRemaining,
  });

  // Map with string keys and values
  Map<String, dynamic> toMap() {
    return {
      'todo': todo,
      'todoDate': todoDate,
      'time': time,
      'timeLeft': timeLeft,
      // 'percentageRemaining': percentageRemaining,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      todo: map['todo'],
      todoDate: map['todoDate'],
      time: map['time'],
      timeLeft: map['timeLeft'] ?? '',
      // percentageRemaining: map['percentageRemaining'],
    );
  }
}
