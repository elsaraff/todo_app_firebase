class TaskModel {
  late String id;
  late String title;
  late String date;
  late String time;
  late String order;
  late String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.order,
    required this.status,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'order': order,
      'status': status,
    };
  }
}
