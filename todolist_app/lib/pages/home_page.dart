import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todolist_app/data/local_storage.dart';
import 'package:todolist_app/helper/translations_helper.dart';
import 'package:todolist_app/main.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/widgets/custom_search_delegate.dart';
import 'package:todolist_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTasks;
  late LocalStorage localStorage;

  @override
  void initState() {
    localStorage = locator<LocalStorage>();
    allTasks = <Task>[];
    getAllTaskFromDB();
    super.initState();
  }

  getAllTaskFromDB() async {
    allTasks = await localStorage.gelAllTask();
    setState(() {});
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
              "title",
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                showSearchPage();
              },
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
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("remove_task").tr()
                        ],
                      ),
                      key: Key(currentTask.id),
                      onDismissed: (direction) async {
                        allTasks.removeAt(index);
                        await localStorage.deleteTask(task: currentTask);
                        setState(() {});
                      },
                      child: TaskItem(task: currentTask));
                },
              )
            : Center(
                child: const Text("empty_task_list").tr(),
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
              decoration: InputDecoration(
                  hintText: "add_Task".tr(), border: InputBorder.none),
              onSubmitted: (value) {
                if (value.length > 3) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationHelper.getDeviceLanguage(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var newTask = Task.create(name: value, createdDate: time);
                      await localStorage.addTask(task: newTask);
                      allTasks.insert(0, newTask);
                      setState(() {});
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

  void showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: allTasks));
    getAllTaskFromDB();
  }
}
