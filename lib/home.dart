import 'package:flutter/material.dart';
import 'Task/Task.dart';
import 'Task/AddTaskScreen.dart';
import 'Task/TaskDetailsScreen.dart';
import 'AddCategoryScreen.dart';
import 'Utilities/localnotifcation.dart';
import 'Utilities/AlertWidget.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = ['Work', 'Personal', 'Shopping', 'Health', 'Other'];

  List<Task> _tasks = [];
  List<Task> filteredTasks = [];
  String? selectedCategory;
  String? searchedTask;
  String? selectedFilter;
  String? selectedPriority;
  bool showCategoriesMenu = true;
  bool showPriorityMenu = false;
  bool status = true;

  void filterTasksByCategory(String? category) {
    if (category != null && category != 'All') {
      setState(() {
        selectedCategory = category;
        filteredTasks =
            _tasks.where((task) => task.category == category).toList();
      });
    } else {
      setState(() {
        selectedCategory = null;
        filteredTasks = _tasks;
      });
    }
  }

  void filterTasksBySearch(String? TaskName) {
    if (TaskName != null) {
      setState(() {
        filteredTasks = _tasks.where((task) => task.name == TaskName).toList();
      });
    } else {
      setState(() {
        filteredTasks = _tasks;
      });
    }
  }

  void filterTasksByPriority(String? priority) {
    if (priority != null && priority != "none") {
      setState(() {
        selectedPriority = priority;
        filteredTasks =
            _tasks.where((task) => task.priority == priority).toList();
      });
    } else {
      setState(() {
        selectedPriority = null;
        filteredTasks = _tasks;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    filteredTasks = _tasks;
  }

  void notificationMessage() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => const Dialog(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text('This is a typical dialog.')],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCategoryScreen(categories)),
                ).then((newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      categories.add(newCategory);
                    });
                  }
                });
              },
            ),
            Container(
              child: FlutterSwitch(
                value: status,
                activeText: "Filter By Category",
                activeTextColor: Colors.black,
                inactiveTextColor: Colors.black,
                inactiveText: "Filter By Priority",
                activeColor: Colors.white30,
                inactiveColor: Colors.white30,
                toggleSize: 12,
                valueFontSize: 12,
                toggleColor: Colors.teal,
                padding: 8,
                width: 140,
                height: 35,
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    status = val;
                  });
                  if (val) {
                    setState(() {
                      showPriorityMenu = false;
                      showCategoriesMenu = true;
                    });
                  } else {
                    setState(() {
                      showCategoriesMenu = false;
                      showPriorityMenu = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: SearchAnchor(
              viewBackgroundColor: Colors.grey[200],
              viewSurfaceTintColor: Colors.grey[200],
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  surfaceTintColor: MaterialStateProperty.all(Colors.white),
                  controller: controller,
                  hintText: 'Search...',
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (String query) {
                    setState(() {
                      filteredTasks = _tasks
                          .where((task) => task.name
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    });
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                // Filter the tasks based on the entered text
                List<Task> filteredTasks = _tasks
                    .where((task) => task.name
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();

                return List<ListTile>.generate(filteredTasks.length,
                    (int index) {
                  return ListTile(
                    title: Text(filteredTasks[index].name),
                    onTap: () {
                      setState(() {
                        controller.closeView(filteredTasks[index].name);
                        filterTasksBySearch(filteredTasks[index].name);
                      });
                    },
                  );
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: showCategoriesMenu,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(12),
                          alignment: AlignmentDirectional.center,
                          value: selectedCategory,
                          hint: const Text('Select Category'),
                          onChanged: (String? value) {
                            filterTasksByCategory(value);
                          },
                          items: [...categories, 'All'].map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Center(child: Text(category)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showPriorityMenu,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(12),
                            alignment: AlignmentDirectional.center,
                            value: selectedPriority,
                            hint: const Text('Assign Priority'),
                            onChanged: (String? value) {
                              setState(() {
                                filterTasksByPriority(value);
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  child: Center(child: Text("1  (Highest Priority)")), value: "1"),
                              DropdownMenuItem(
                                  child: Center(child: Text("2")), value: "2"),
                              DropdownMenuItem(
                                  child: Center(child: Text("3")), value: "3"),
                              DropdownMenuItem(
                                  child: Center(child: Text("4")), value: "4"),
                              DropdownMenuItem(
                                  child: Center(child: Text("5  (Least Priority)")), value: "5"),
                              DropdownMenuItem(
                                  child: Center(child: Text("none")),
                                  value: "none"),
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                    right: 5,
                    left: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      filteredTasks[index].name,
                      style: TextStyle(
                        decoration: filteredTasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Checkbox(
                      value: filteredTasks[index].isCompleted,
                      onChanged: (value) {
                        setState(() {
                          filteredTasks[index].isCompleted = value!;
                          if (filteredTasks[index].isCompleted) {
                            LocalNotifications.cancelNotifications(
                                filteredTasks[index].taskId);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertWidget();
                              },
                            );
                          }
                        });
                      },
                      fillColor: MaterialStateColor.resolveWith((states) =>
                          filteredTasks[index].isCompleted
                              ? Colors.green
                              : Colors.transparent),
                      checkColor: filteredTasks[index].isCompleted
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    tileColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TaskDetailsScreen(task: filteredTasks[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          Task newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(categories: categories),
            ),
          );
          if (newTask != null) {
            setState(() {
              _tasks.add(newTask);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
