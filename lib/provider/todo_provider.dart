import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp_flutter/model/home_screen_model.dart';

// Define a provider for the list of todos
final todoListProvider =
    StateNotifierProvider<TodoListNotifier, List<TodoModel>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<TodoModel>> {
  TodoListNotifier()
      : super([
          TodoModel(
              id: 1,
              title: 'Task 1',
              description: 'Description 1',
              isCompleted: false,
              isPinned: false),
          TodoModel(
              id: 2,
              title: 'Task 2',
              description: 'Description 2',
              isCompleted: true,
              isPinned: true),
        ]);

  void addTodo(TodoModel todo) {
    state = [...state, todo];
  }

  void updateTodoList(List<TodoModel> todos) {
    state = todos;
  }
}
