import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task/srs/task.dart';

void main() {
  runApp(
    MaterialApp(
      home: Task(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/second': (context) => Task2(),
      },
    ),
  );
}

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final dio = Dio();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future login() async {
    try {
      final response = await dio.post(
        "https://reqres.in/api/login",
        data: {
          "email": "eve.holt@reqres.in",
          "password": "cityslicka"
          // "email": nameController.text,
          // "password": passwordController.text
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Form submitted successfully'),
          duration: Duration(seconds: 7),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pushNamed('/second');
        debugPrint('----> ${response.data}');
        nameController.text = '';
        passwordController.text = '';
      } else {
        debugPrint("statusCode---> ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('invalid details'),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('error at login $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow.shade800,
      appBar: AppBar(
        title: Text("Create Account"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // SingleChildScrollView(
          //   child: Center(child: Image(image: AssetImage(cute))),
          // ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              // hintText: " Password",
                              // label: Text("Name"),
                              labelText: "name",
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.login),
                              // fillColor: Colors.white,
                              // focusColor: Colors.white,
                              prefixIconColor: Colors.black,
                              // hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              filled: true),
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              // hintText: " Password",
                              // label: Text("password"),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(Icons.password),
                              prefixIconColor: Colors.black,
                              // hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              filled: true),
                          controller: passwordController,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: SizedBox(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.all(1000),
                        backgroundColor: Colors.green,
                        elevation: 10,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Text("Create"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
