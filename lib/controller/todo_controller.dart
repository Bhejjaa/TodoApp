import 'package:flutter/material.dart';

class TodoItem {
  String title;
  bool isFavorite;
  bool isDone;

  TodoItem(this.title, {this.isFavorite = false, this.isDone = false});
}

class TodoController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final List<TodoItem> _allTodos = [
    TodoItem('Water'),
    TodoItem('Earth'),
    TodoItem('Fire'),
    TodoItem('Wind'),
  ];

  List<TodoItem> _filteredTodos = [];
  String _searchQuery = "";

  TodoController() {
    _filteredTodos = List.from(_allTodos);
    searchController.addListener(_onSearchChanged);
  }

  List<TodoItem> get filteredTodos => _filteredTodos;
  List<TodoItem> get favoriteTodos => _filteredTodos.where((todo) => todo.isFavorite).toList();
  List<TodoItem> get doneTodos => _filteredTodos.where((todo) => todo.isDone).toList();

  void _onSearchChanged() {
    _searchQuery = searchController.text;
    _filterTodos();
  }

  void _filterTodos() {
    if (_searchQuery.isEmpty) {
      _filteredTodos = List.from(_allTodos);
    } else {
      _filteredTodos = _allTodos
          .where((todo) => todo.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void toggleFavorite(TodoItem todo) {
    todo.isFavorite = !todo.isFavorite;
    notifyListeners();
  }

  void toggleDone(TodoItem todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
