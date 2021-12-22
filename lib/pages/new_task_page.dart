import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_aplication/handlers/database_handler.dart';
import 'package:todo_aplication/handlers/date_format_hendler.dart';
import 'package:todo_aplication/handlers/validator_handler.dart';
import 'package:todo_aplication/models/task_model.dart';

class NewTaskPage extends StatefulWidget {
  final TaskModel? taskModel;
  final int? isEdit;
  const NewTaskPage({Key? key, this.taskModel, this.isEdit}) : super(key: key);

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final DateFormatHandler _dateFormatHandler = DateFormatHandler();
  final ValidatorHandler _validatorHandler = ValidatorHandler();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DatabaseHandler handler = DatabaseHandler();
  String title = '', description = '', isDone = '';
  DateTime _selectedDay = DateTime.now();

  Future<int> addTask() async {
    TaskModel taskOne = TaskModel(
      title: title,
      description: description,
      date: _dateFormatHandler.formatDate(
        'yyyy-MM-dd',
        _selectedDay.toString(),
      ),
      isDone: '0',
    );
    List<TaskModel> listOfTask = [taskOne];
    return await handler.insertTask(listOfTask);
  }

  Future<int> updateTask() async {
    TaskModel taskTwo = TaskModel(
      id: widget.taskModel!.id,
      title: title,
      description: description,
      date: _dateFormatHandler.formatDate(
        'yyyy-MM-dd',
        _selectedDay.toString(),
      ),
      isDone: isDone,
    );
    List<TaskModel> listOfTask = [taskTwo];
    return await handler.updateTask(listOfTask);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == 1) {
      title = widget.taskModel!.title;
      description = widget.taskModel!.description;
      _selectedDay = DateTime.parse(widget.taskModel!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: widget.isEdit == 1
            ? const Text(
                'My Task',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              )
            : const Text(
                'New Task',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Date',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2010),
                lastDay: DateTime.utc(2030),
                calendarStyle: const CalendarStyle(
                  canMarkersOverflow: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  validator: _validatorHandler.validateBasic,
                  initialValue: title,
                  decoration: const InputDecoration(
                    hintText: 'Fill title',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      title = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  validator: _validatorHandler.validateBasic,
                  maxLines: 5,
                  initialValue: description,
                  decoration: const InputDecoration(
                    hintText: 'Fill description',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      description = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              widget.isEdit == 1
                  ? Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                if (widget.isEdit == 1) {
                                  isDone = '1';
                                  updateTask();
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 48.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green,
                              ),
                              child: const Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                if (widget.isEdit == 1) {
                                  updateTask();
                                } else {
                                  addTask();
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 48.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: widget.isEdit == 1
                                    ? const Text(
                                        'Edit Task',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      )
                                    : const Text(
                                        'Create Task',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          if (widget.isEdit == 1) {
                            updateTask();
                          } else {
                            addTask();
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: widget.isEdit == 1
                              ? const Text(
                                  'Edit Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                )
                              : const Text(
                                  'Create Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
