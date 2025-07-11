import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/datas/Todo.dart';
import 'package:todo/static/Navigation.dart';

class Customcard extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final String finishedAt;
  final String expiredAt;
  final int id;
  final int args;
  final ValueChanged<bool> onDeleted;
  const Customcard({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.finishedAt,
    required this.expiredAt,
    required this.id,
    required this.args,
    required this.onDeleted,
  });

  Future<void> _isDeleted(BuildContext context) async {
    final bool deleted = true;
    if (deleted != false) {
      onDeleted(deleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            NavigationRoute.DetailTodoPageRoute.name,
            arguments: id,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 3,
                blurRadius: 0,
                offset: Offset(-2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title : $title', softWrap: true),
                          Text('Description : $description', softWrap: true),
                          Text('finishedAt : $finishedAt', softWrap: true),
                          Text('expiredAt: $expiredAt', softWrap: true),
                        ],
                      ),
                      
                    ],
                  ),
                ),
                (args == 2 || args == 3)
                    ? GestureDetector(
                        onTap: () {
                          _doDelete(context);
                        },
                        child: Icon(FontAwesomeIcons.trash),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _doDelete(BuildContext context) async {
    await Todo.instance.deleteTodo(id);
    _isDeleted(context);
  }
}
