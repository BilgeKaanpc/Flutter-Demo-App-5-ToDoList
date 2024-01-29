// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem({required this.task, super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController taskName = TextEditingController();

  @override
  void initState() {
    taskName.text = widget.task.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.isCompleted = !widget.task.isCompleted;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2)),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
              minLines: 1,
              maxLines: null,
              textInputAction: TextInputAction.done,
                controller: taskName,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  setState(() {
                    if (value.length > 3) {
                      widget.task.name = value;
                    }
                  });
                },
              ),
        trailing: Text(
          DateFormat("hh:mm a").format(widget.task.createdDate),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
