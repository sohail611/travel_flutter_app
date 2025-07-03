import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Components/dialog_box.dart';
import 'Components/todo_tile.dart';
import 'data/database.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  final _myBox = Hive.box("mybox");
  ToDoDataBase db = ToDoDataBase();



  @override
  void initState() {
    //first time opening app
    if (_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      //already exist data
      db.loadData();
    }
  }


  final _controller = TextEditingController();

  // List toDoList = [
  //   ["Make Tutorial", false,],
  //   ["Do Exercise", false],
  // ];

  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("To Do Useing Hive"),
        backgroundColor: Colors.yellow[200],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChange: (value) => checkBoxChanged(value, index),
            deleteFunction: (context)=> deleteTask(index),
          );
        },
      ),
    );
  }
}
