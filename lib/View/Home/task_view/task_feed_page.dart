import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../Resources/colors.dart';
import '../../../View_Model/taskViewModel.dart';
import '../../Side_navbar.dart';
import 'task_list.dart';
import 'task_filter.dart';
import 'task_dialog.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String selectedPriorityFilter = "All";
  bool showCompleted = true;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = Provider.of<TasksViewModel>(context);
    String todayDate = DateFormat.yMMMMd().format(DateTime.now());
    String todayDay = DateFormat.EEEE().format(DateTime.now());

    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$todayDay, $todayDate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Appcolors.white),
            ),
            SizedBox(height: 4),
            Text(
              "My Tasks",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Appcolors.white),
            ),
          ],
        ),
        backgroundColor: Appcolors.lightblue,
        actions: [
          TaskFilterDropdown(
            selectedPriorityFilter: selectedPriorityFilter,
            onChanged: (newValue) {
              setState(() {
                selectedPriorityFilter = newValue;
              });
            },
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: const NavBar(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: TaskList(
              selectedPriorityFilter: selectedPriorityFilter,
              showCompleted: showCompleted,
              searchController: searchController,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Task",
          ),
          BottomNavigationBarItem(
            icon: Icon(showCompleted ? Icons.visibility_off : Icons.visibility),
            label: showCompleted ? "Hide Completed" : "Show Completed",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            showAddTaskDialog(context);
          } else {
            setState(() {
              showCompleted = !showCompleted;
            });
          }
        },
      ),
    );
  }
}
