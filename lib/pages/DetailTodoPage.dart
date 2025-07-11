import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/datas/Todo.dart';
import 'package:todo/pages/components/Calendar.dart';
import 'package:todo/pages/components/CustomTextField.dart';
import 'package:todo/static/Navigation.dart';

class Detailtodopage extends StatefulWidget {
  final int id;
  const Detailtodopage({super.key, required this.id});

  @override
  State<Detailtodopage> createState() => _DetailtodopageState();
}

class _DetailtodopageState extends State<Detailtodopage> {
  Map<String, dynamic>? data;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? expiredAt;
  bool isButtonDisabled = false;
  bool isFinishButton = false;

  @override
  void initState() {
    super.initState();
    _loadTodo();
  }

  Future<void> _loadTodo() async {
    final result = await Todo.instance.fetchDetailTodo(widget.id);
    final today = DateTime.now();
    setState(() {
      data = result;
      _titleController.text = data!['title'] ?? '';
      _descriptionController.text = data!['description'] ?? '';
      if (data!['expiredAt'] != null) {
        expiredAt = DateTime.tryParse(data!['expiredAt']);
      }
    });
    if ((data!['expiredAt'] == null ||
            DateTime.parse(data!['expiredAt']).isAfter(today)) &&
        data!['finishedAt'] == null) {
      setState(() {
        isFinishButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail')),
      floatingActionButton: isFinishButton
          ? FloatingActionButton.extended(
              onPressed: () {
                isButtonDisabled ? '' : _doFinish();
              },
              icon: Icon(FontAwesomeIcons.check),
              label: Text('Finish'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            )
          : SizedBox.shrink(),
      body: Stack(
        children: [
          Container(color: Color(0xffffeaa7)),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CalendarRow(
                      text: 'Expired At : ',
                      datepicked: expiredAt,
                      onDateSelected: (picked) {
                        setState(() {
                          expiredAt = picked;
                        });
                      },
                    ),
                    CustomTextField(
                      hintText: 'Titel',
                      controller: _titleController,
                      bordercolor: Color(0xff6c5ce7),
                      isDesc: false,
                    ),
                    CustomTextField(
                      hintText: 'Description',
                      controller: _descriptionController,
                      bordercolor: Color(0xff6c5ce7),
                      isDesc: true,
                    ),
                    Padding(padding: const EdgeInsets.all(10)),
                    InkWell(
                      onTap: () {
                        isButtonDisabled ? null : _doSubmit();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: isButtonDisabled ? Colors.grey : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              spreadRadius: 3,
                              offset: Offset(-2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _doSubmit() async {
    setState(() {
      isButtonDisabled = true;
    });

    await Todo.instance.updateTodo(
      widget.id,
      _titleController.text,
      _descriptionController.text,
      expiredAt?.toString() ?? '',
    );

    Navigator.pushNamed(context, NavigationRoute.HomepageRoute.name);
  }

  Future _doFinish() async {
    setState(() {
      isButtonDisabled = true;
    });
    await Todo.instance.updateFinished(widget.id);
    Navigator.pushReplacementNamed(
      context,
      NavigationRoute.ListTodoPageRoute.name,
      arguments: 1,
    );
  }
}
