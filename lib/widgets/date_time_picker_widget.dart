import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/core/utils/date_time_helper.dart';

class DateTimePickerWidget extends StatefulWidget {
  const DateTimePickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime currentDateTime = DateTime.now();

  _onChangeDate() async {
    final date = await DateTimeHelper.getDate(context);
    if (date != null) {
      setState(() {
        currentDateTime = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('dd-MM-yyyy | kk:mm').format(currentDateTime)),
          IconButton(
              onPressed: () {
                _onChangeDate();
              },
              icon: const Icon(Icons.calendar_month)),
        ],
      ),
    );
  }
}
