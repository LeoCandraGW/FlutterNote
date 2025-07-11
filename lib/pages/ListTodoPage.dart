import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/datas/Todo.dart';
import 'package:todo/pages/components/CustomCard.dart';
import 'package:todo/pages/components/NavigationContainer.dart';
import 'package:todo/static/Navigation.dart';

class ListTodoPage extends StatefulWidget {
  final int arg;
  const ListTodoPage({super.key, required this.arg});

  @override
  State<ListTodoPage> createState() => _ListTodoPageState();
}

class _ListTodoPageState extends State<ListTodoPage> {
  List<Map<String, dynamic>>? data;
  String? title;
  Color? color;
  bool? isDeleted;

  @override
  initState() {
    super.initState();
    _loadListTodo();
  }

  Future<void> _loadListTodo() async {
    var result;
    var head;
    var bcolor;
    if (widget.arg == 1) {
      result = await Todo.instance.fetchActiveTodo();
      head = 'Active Todo';
      bcolor = Color(0xffffeaa7);
    }
    if (widget.arg == 2) {
      result = await Todo.instance.fetchExpiredTodo();
      head = 'Expired Todo';
      bcolor = Color(0xffff7675);
    }
    if (widget.arg == 3) {
      result = await Todo.instance.fetchFinishedTodo();
      head = 'Finished Todo';
      bcolor = Color(0xff55efc4);
    }
    setState(() {
      data = result;
      title = head;
      color = bcolor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title.toString())),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize;
          bool isTablet = constraints.maxWidth >= 600;
          containerSize = isTablet
              ? constraints.maxWidth * 0.3
              : constraints.maxWidth * 0.3;
          return Stack(
            children: [
              Container(color: Color(0xffa29bfe)),
              ((data?.length ?? 0) <= 0)
                  ? Center(
                      child: NavigationContaienr(
                        size: containerSize,
                        icon: FontAwesomeIcons.plus,
                        navigate: NavigationRoute.DetailTodoPageRoute.name,
                        text: 'Add Todo',
                        color: Color(0xff74b9ff),
                        colorloading: Color(0xff0984e3),
                        isCreate: true,
                        total: '',
                      ),
                    )
                  : ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        final todo = data?[index];
                        return Customcard(
                          color: color ?? Colors.blue,
                          title: todo?['title'] ?? 'No Title',
                          description: todo?['description'] ?? 'No Description',
                          finishedAt: todo?['finishedAt'] ?? 'not set',
                          expiredAt: todo?['expiredAt'] ?? 'not set',
                          id: todo?['id'] ?? 1,
                          args: widget.arg,
                          onDeleted: (deleted) {
                            _loadListTodo();
                          },
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }
}
