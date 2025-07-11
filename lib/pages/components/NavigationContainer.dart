import 'package:flutter/material.dart';
import 'package:todo/datas/Todo.dart';

class NavigationContaienr extends StatefulWidget {
  final double size;
  final IconData icon;
  final String navigate;
  final int? arg;
  final String text;
  final Color color;
  final Color colorloading;
  final bool isCreate;
  final String total;
  const NavigationContaienr({
    super.key,
    required this.size,
    required this.icon,
    required this.navigate,
    this.arg,
    required this.text,
    required this.color,
    required this.colorloading,
    required this.isCreate,
    required this.total,
  });

  @override
  State<NavigationContaienr> createState() => _NavigationContaienrState();
}

class _NavigationContaienrState extends State<NavigationContaienr> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isCreate) {
          setState(() {
            isLoading = true;
          });
          await Todo.instance.insertTodo();
          int id = await Todo.instance.newtodo();
          Navigator.pushNamed(context, widget.navigate, arguments: id);
        } else {
          Navigator.pushNamed(context, widget.navigate, arguments: widget.arg);
        }
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              spreadRadius: 3,
              offset: Offset(-2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: widget.isCreate
                  ? Icon(widget.icon, size: widget.size * 0.5)
                  : Text(widget.total, style: TextStyle(fontSize: 34)),
            ),
            Text(widget.text, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
