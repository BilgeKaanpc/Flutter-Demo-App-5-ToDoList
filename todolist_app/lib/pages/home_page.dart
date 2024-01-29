import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTasks;

  @override
  void initState() {
    allTasks = <Task>[];
    allTasks.add(Task.create(name: "Test Task", createdDate: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              showButtonAddTask(context);
            },
            child: const Text(
              "Bugün neler yapacaksın?",
              style: TextStyle(color: Colors.black),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                showButtonAddTask(context);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: allTasks.isNotEmpty
            ? ListView.builder(
                itemCount: allTasks.length,
                itemBuilder: (context, index) {
                  var currentTask = allTasks[index];
                  return Dismissible(
                    background: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Bu Görev Siliniyor")
                      ],
                    ),
                    key: Key(currentTask.id),
                    onDismissed: (direction) {
                      setState(() {
                        allTasks.removeAt(index);
                      });
                    },
                    child: TaskItem(task: currentTask)
                  );
                },
              )
            : const Center(
                child: Text("Görev Ekle"),
              ));
  }

  void showButtonAddTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                  hintText: "Görev Nedir?", border: InputBorder.none),
              onSubmitted: (value) {
                if (value.length > 3) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) {
                      setState(() {
                        var newTask =
                            Task.create(name: value, createdDate: time);
                        allTasks.add(newTask);
                      });
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
