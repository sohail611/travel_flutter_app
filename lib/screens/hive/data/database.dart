import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];

  final _myBox = Hive.box("myBox");

  void createInitialData(){
    toDoList = [
      ["Make Tutorisl", false],
      ["Do Exercise", false],
    ];
  }

  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);

  }
}