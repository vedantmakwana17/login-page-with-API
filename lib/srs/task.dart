// import 'package:demo/jsonTodart/demo_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../jsonToDart/model.dart';

class Task2 extends StatefulWidget {
  const Task2({super.key});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  final dio = Dio();
  List<Data> listMyData = [];
  bool isLoading = false;

  Future<List<Data>> _getData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await dio.get(
        "https://dummy.restapiexample.com/api/v1/employees",
        options: Options(
          sendTimeout: const Duration(seconds: 1),
          receiveTimeout: const Duration(seconds: 1),
        ),
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        List listData = response.data['data'] as List;
        listMyData = listData.map((e) => Data.fromJson(e)).toList();
        setState(() {});
      } else if (response.statusCode == 500) {
        debugPrint("Internal server down");
      }
      setState(() => isLoading = false);
      return listMyData;
    } on DioException catch (e) {
      setState(() => isLoading = false);
      if (e.response != null) {
      } else {
        debugPrint('----e>$e');
        debugPrint('-----requestOptions> ${e.requestOptions}');
        debugPrint('-----message> ${e.message}');
      }
      return listMyData;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
        centerTitle: true,
      ),
      body: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black87,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: listMyData.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    color: Colors.greenAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "employee_name: ${listMyData[index].employeeName.toString()}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
