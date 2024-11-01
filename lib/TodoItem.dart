class TodoItem {
  final String text;
  final DateTime dateTime;
  final bool isCompleted;

  TodoItem({
    required this.text,
    required this.dateTime,
    required this.isCompleted,
  });

  // Convert a TodoItem to a Map
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'dateTime': dateTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create a TodoItem from a Map
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      text: json['text'],
      dateTime: DateTime.parse(json['dateTime']),
      isCompleted: json['isCompleted'],
    );
  }
}