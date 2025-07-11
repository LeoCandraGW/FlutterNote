import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

class CalendarRow extends StatelessWidget {
  final String text;
  final DateTime? datepicked;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarRow({
    super.key,
    required this.text,
    required this.datepicked,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: datepicked ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              Text(text),
              SizedBox(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Row(
                        children: [
                          Text(
                            datepicked != null
                                ? DateFormat('yyyy-MM-dd').format(datepicked!)
                                : 'Select date',
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today, color: Color(0xff0984e3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
