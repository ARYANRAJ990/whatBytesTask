import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../Resources/colors.dart';
import '../../../Utils/fluttertoast.dart';
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
  bool showPending = false;
  bool showDueSoon = false;
  TextEditingController searchController = TextEditingController();
  int selectedIndex = 0; // Track selected tab

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
            child: Row(
              children: [
                Expanded(
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
                      setState(() {}); // Refresh UI
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(showCompleted ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      showCompleted = !showCompleted;
                    });

                    // Show Snackbar with a duration
                    Utils.snackBar(
                      showCompleted ? "Completed tasks are now visible" : "Completed tasks are now hidden",
                      context,
                    );
                    duration: const Duration(seconds: 1);
                  },
                ),

              ],
            ),
          ),
          Expanded(
            child: TaskList(
              selectedPriorityFilter: selectedPriorityFilter,
              showCompleted: showCompleted,
              showPending: showPending,
              showDueSoon: showDueSoon,
              searchController: searchController,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, // Highlight selected button
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task, color: selectedIndex == 0 ? Appcolors.lightblue : Colors.grey),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box,size: 28, color: selectedIndex == 1 ? Appcolors.lightblue : Colors.grey),
            label: "Add Task,",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions, color: selectedIndex == 2 ? Appcolors.midyellow : Colors.grey),
            label: showPending ? "Hide Pending" : "Show Pending",
          ),
        ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;

              if (index == 0) {
                showDueSoon = false;
                showPending = false; // Reset pending filter
                selectedPriorityFilter = "All";
              } else if (index == 1) {
                // Add Task
                showAddTaskDialog(context);
              } else if (index == 2) {
                // Pending button should show only pending tasks
                showPending = !showPending;
                showDueSoon = false;
                // If showing pending tasks, reset filters to avoid other filters interfering
                if (showPending) {
                  selectedPriorityFilter = "All"; // Ensure all priorities are included
                }
              }
            });
          }
      ),
    );
  }
}
