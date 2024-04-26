import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exports.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                hintText: 'Enter your user name',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String userName = userNameController.text;
                    String password = passwordController.text;
                    bool? success =
                        await controller.createUser(userName, password);
                    if (success == true) {
                      await saveToSharedPreferences('userLoggedIn', true);
                      Get.to(
                        () => HomeView(),
                        transition: Transition.rightToLeft,
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveToSharedPreferences(String key, bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }
}
