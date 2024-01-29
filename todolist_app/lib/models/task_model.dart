import 'package:uuid/uuid.dart';

class Task{
  final String id;
  String name;
  final DateTime createdDate;
  bool isCompleted;

  Task({required this.id, required this.name, required this.createdDate, required this.isCompleted});

  factory Task.create({required String name, required DateTime createdDate}){
      return Task(id: const Uuid().v1(), name: name, createdDate: createdDate, isCompleted: false);
  }
}