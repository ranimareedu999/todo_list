import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  void addTask(String title) {
    final task = Task(
      id: DateTime.now().toString(),
      title: title,
    );
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    notifyListeners();
  }

  void editTask(String id, String newTitle) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].title = newTitle;
      saveTasks();
      notifyListeners();
    }
  }


  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(_tasks.map((t) => t.toMap()).toList());
    prefs.setString('tasks', tasksJson);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = json.decode(tasksJson);
      _tasks = decoded.map((e) => Task.fromMap(e)).toList();
      notifyListeners();
    }
  }
}
