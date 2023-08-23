import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas',
      theme: ThemeData(
         primarySwatch: Colors.red,  // Color de la barra de navegación
      ),
      home: TodoListScreen(),
    );
  }
}

class Todo {
  final String task;
  bool isDone;

  Todo({
    required this.task,
    this.isDone = false,
  });
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  void addTodo(String task) {
    setState(() {
      todos.add(Todo(task: task));
    });
  }

  void toggleTodoStatus(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas de la Empresa'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: todos[index].isDone,
              onChanged: (_) => toggleTodoStatus(index),
            ),
            title: Text(
              todos[index].task,
              style: TextStyle(
                decoration: todos[index].isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => removeTodo(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return TodoDialog();
            },
          );

          if (newTask != null && newTask.isNotEmpty) {
            addTodo(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoDialog extends StatefulWidget {
  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Tarea'),
      content: TextField(
        controller: _taskController,
        decoration: InputDecoration(labelText: 'Tarea'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final task = _taskController.text;
            if (task.isNotEmpty) {
              Navigator.of(context).pop(task);
            }
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
