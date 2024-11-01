import 'package:flutter/material.dart';
import 'storage.dart';
import 'TodoItem.dart';
import 'package:intl/intl.dart';
import 'delete_dialogue.dart';
import 'notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDateTime;
  List<TodoItem> _todoList = [];
  final ValueNotifier<DateTime?> _selectedDateTimeNotifier =
      ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    super.initState();
    _loadTodoList(); // Load the todo list when the app starts
  }

  Future<void> _loadTodoList() async {
    List<TodoItem> loadedTodoList = await StorageHelper.loadTodoList();

    setState(() {
      _todoList = loadedTodoList; // Update the state with the loaded todo list
    });
  }

  Future<void> _saveTodoList() async {
    await StorageHelper.saveTodoList(_todoList);
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _selectedDateTimeNotifier.value = newDateTime;

        setState(() {
          _selectedDateTime = newDateTime;
        });
      }
    }
  }

  void _textInputModal() {
    // Show the input dialog when the button is pressed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter a value and select a date'),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Make the dialog size wrap its content
            children: [
              TextField(
                controller: _textController, // Use the controller here
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Type something...'),
              ),
              const SizedBox(
                  height:
                      20), // Add some space between the text field and the button
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: _selectDateTime,
                  child: ValueListenableBuilder<DateTime?>(
                    valueListenable: _selectedDateTimeNotifier,
                    builder: (context, dateTime, child) {
                      return Text(
                        dateTime == null
                            ? 'Select Date and Time'
                            : '${dateTime.toLocal()}',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                String userInput = _textController.text; // Get the text input
                if (_selectedDateTime != null) {
                  TodoItem newTodo = TodoItem(
                      text: userInput,
                      dateTime: _selectedDateTime!,
                      isCompleted: false);

                  setState(() {
                    _todoList.add(newTodo);
                  });
                  // Save to persistent storage
                  await _saveTodoList();
                  await NotificationService().scheduleNotification(
                    _todoList.length - 1,
                    "Todo Reminder",
                    newTodo.text,
                    newTodo.dateTime,
                  );
                }

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  TodoItem todoItem = _todoList[index];
                  return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(todoItem.text),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy - HH:mm')
                              .format(todoItem.dateTime),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDeleteDialog(context, () {
                              setState(() {
                                _todoList.removeAt(index);
                              });
                              _saveTodoList();
                            });
                          },
                        ),
                      ));
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _textInputModal,
        tooltip: 'Increment',
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _selectedDateTimeNotifier.dispose();
    super.dispose();
  }
}