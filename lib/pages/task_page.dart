import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_aplication/handlers/database_handler.dart';
import 'package:todo_aplication/handlers/date_format_hendler.dart';
import 'package:todo_aplication/models/task_model.dart';
import 'package:todo_aplication/pages/new_task_page.dart';
import 'package:todo_aplication/handlers/shared_pref_handler.dart' as pref;

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final DateFormatHandler _dateFormatHandler = DateFormatHandler();
  final DatabaseHandler handler = DatabaseHandler();
  DateTime _selectedDay = DateTime.now();
  String nama = '',
      picture =
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80';
  List<TaskModel> listTask = [];

  void getTask() {
    handler
        .retrieveTasksByDate(
      _dateFormatHandler.formatDate(
        'yyyy-MM-dd',
        _selectedDay.toString(),
      ),
    )
        .then((value) {
      setState(() {
        listTask = value;
      });
    });
  }

  Future<void> getSharedPref() async {
    var name = await pref.getName();
    var picture = await pref.getPicture();
    setState(() {
      nama = name!;
      picture = picture;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: NetworkImage(
            picture,
          ),
        ),
        title: Text(
          nama,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  getTask();
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(
              'Task List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Column(
              children: listTask
                  .map(
                    (task) => Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever),
                      ),
                      key: ValueKey<int>(task.id!),
                      onDismissed: (DismissDirection direction) async {
                        await handler.deleteTask(task.id!);
                        setState(() {
                          listTask.remove(task);
                        });
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewTaskPage(
                                  isEdit: 1,
                                  taskModel: task,
                                ),
                              ),
                            ).then(
                              (value) {
                                setState(() {
                                  getTask();
                                });
                              },
                            );
                          },
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: task.isDone == '1'
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              'Complete',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: task.isDone == '1'
                                    ? Colors.green
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTaskPage(),
            ),
          ).then(
            (value) {
              getTask();
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
