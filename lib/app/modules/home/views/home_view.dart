import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exports.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  Size? size;

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = Get.size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.homeTitle,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 150,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Quick Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Add Task'),
              onTap: () {
                Get.to(() => TasksView(), transition: Transition.rightToLeft);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.remove('userLoggedIn');
                Get.offAll(() => LoginView());
              },
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: taskList(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => TasksView(), transition: Transition.rightToLeft);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> getObjectIDFromSharedPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('userObjectId');
  }

  Widget taskList(BuildContext context) {
    return FutureBuilder<String?>(
      future: getObjectIDFromSharedPreferences(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgress();
        } else if (snapshot.hasData) {
          return FutureBuilder<List<Task>?>(
            future: controller.fetchTasks(snapshot.data),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgress();
              } else if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data![index]),
                    itemCount: snapshot.data!.length,
                    controller: controller.listScrollController,
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No tasks yet!",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return const CircularProgress();
              }
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildItem(BuildContext context, Task task) {
    String formattedDueDate = DateFormat.yMMMd().format(task.taskDueDate!);
    IconData iconData = task.taskCompleted! ? Icons.check_circle : Icons.circle;
    Color iconColor = task.taskCompleted! ? Colors.green : Colors.red;

    return ListTile(
      leading: const Icon(Icons.task),
      title: Text(
        task.title!,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        formattedDueDate,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Icon(
        iconData,
        color: iconColor,
      ),
      onTap: () {
        Get.to(
          () => TasksView(currentTask: task),
          transition: Transition.rightToLeft,
        );
      },
    );
  }
}
