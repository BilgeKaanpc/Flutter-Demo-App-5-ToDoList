import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/data/local_storage.dart';
import 'package:todolist_app/main.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = "";
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var currentTask = filteredList[index];
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
                    filteredList.removeAt(index);
                    await locator<LocalStorage>().deleteTask(task: currentTask);
                    // localStorage.deleteTask(task: currentTask);
                  },
                  child: TaskItem(task: currentTask));
            },
          )
        : Center(
            child: const Text("search").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
