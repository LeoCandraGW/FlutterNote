import 'package:flutter/material.dart';
import 'package:todo/pages/DetailTodoPage.dart';
import 'package:todo/pages/HomePage.dart';
import 'package:todo/pages/ListTodoPage.dart';
import 'package:todo/static/Navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: NavigationRoute.HomepageRoute.name,
      routes: {
        NavigationRoute.HomepageRoute.name: (context) => const HomePage(),
        NavigationRoute.DetailTodoPageRoute.name: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return Detailtodopage(id: id);
        },
        NavigationRoute.ListTodoPageRoute.name: (context) {
          final arg = ModalRoute.of(context)!.settings.arguments as int;
          return ListTodoPage(arg: arg);
        },
      },
    );
  }
}
