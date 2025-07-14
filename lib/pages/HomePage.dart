import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo/datas/Todo.dart';
import 'package:todo/pages/components/NavigationContainer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/static/Navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? activeList;
  int? finishedList;
  int? expiredList;

  @override
  void initState() {
    super.initState();
    _loadTodo();
  }

  Future<void> _loadTodo() async {
    final active = await Todo.instance.fetchActiveTodo();
    final expired = await Todo.instance.fetchExpiredTodo();
    final finished = await Todo.instance.fetchFinishedTodo();
    setState(() {
      activeList = active.length;
      finishedList = finished.length;
      expiredList = expired.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Color(0xffa29bfe)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.arrowDownLong),
                Text('Scroll down to Refresh'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double containerSize;
                bool isTablet = constraints.maxWidth >= 600;
                containerSize = isTablet
                    ? constraints.maxWidth * 0.2
                    : constraints.maxWidth * 0.3;
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NavigationContaienr(
                                size: containerSize,
                                icon: FontAwesomeIcons.plus,
                                navigate:
                                    NavigationRoute.DetailTodoPageRoute.name,
                                text: 'Add Todo',
                                color: Color(0xff74b9ff),
                                colorloading: Color(0xff0984e3),
                                isCreate: true,
                                total: '',
                              ),
                              NavigationContaienr(
                                size: containerSize,
                                icon: FontAwesomeIcons.plus,
                                navigate:
                                    NavigationRoute.ListTodoPageRoute.name,
                                arg: 1,
                                text: 'Active Todo',
                                color: Color(0xffffeaa7),
                                colorloading: Color(0xfffdcb6e),
                                isCreate: false,
                                total: activeList.toString(),
                              ),
                            ],
                          ),
                          Padding(padding: const EdgeInsets.all(20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NavigationContaienr(
                                size: containerSize,
                                icon: FontAwesomeIcons.plus,
                                navigate:
                                    NavigationRoute.ListTodoPageRoute.name,
                                arg: 2,
                                text: 'Expired Todo',
                                color: Color(0xffff7675),
                                colorloading: Color(0xffd63031),
                                isCreate: false,
                                total: expiredList.toString(),
                              ),
                              NavigationContaienr(
                                size: containerSize,
                                icon: FontAwesomeIcons.plus,
                                navigate:
                                    NavigationRoute.ListTodoPageRoute.name,
                                arg: 3,
                                text: 'Finished Todo',
                                color: Color(0xff55efc4),
                                colorloading: Color(0xff00b894),
                                isCreate: false,
                                total: finishedList.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _refresh() async {
    await _loadTodo();
  }
}
