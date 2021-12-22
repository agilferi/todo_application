class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String? isDone;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isDone,
  });

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        description = res['description'],
        date = res['date'],
        isDone = res['isDone'];

  Map<String, Object?> toMap() {
    return {'id' : id, 'title' : title, 'description' : description, 'date' : date, 'isDone' : isDone};
  }
}
