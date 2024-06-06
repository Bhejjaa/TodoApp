import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/todo_controller.dart';
import '../widgets/header_widget.dart';

final todoControllerProvider = ChangeNotifierProvider<TodoController>((ref) {
  return TodoController();
});

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoController = ref.watch(todoControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(child: HeaderWidget()),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const TopRow(),
                      const Header(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextFormField(
                          controller: todoController.searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: 'What do you want to do?',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        labelColor: Colors.black,
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Favourite'),
                          Tab(text: 'Done'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ListOfTiles(
                              todos: todoController.filteredTodos,
                              onFavoriteToggle: todoController.toggleFavorite,
                              onDoneToggle: todoController.toggleDone,
                            ),
                            ListOfTiles(
                              todos: todoController.favoriteTodos,
                              onFavoriteToggle: todoController.toggleFavorite,
                              onDoneToggle: todoController.toggleDone,
                            ),
                            ListOfTiles(
                              todos: todoController.doneTodos,
                              onFavoriteToggle: todoController.toggleFavorite,
                              onDoneToggle: todoController.toggleDone,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.web),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.web_asset),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: RichText(
          text: const TextSpan(
            text: 'Todo List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ListOfTiles extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(TodoItem) onFavoriteToggle;
  final Function(TodoItem) onDoneToggle;

  const ListOfTiles({
    required this.todos,
    required this.onFavoriteToggle,
    required this.onDoneToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          leading: Checkbox(
            value: todo.isDone,
            onChanged: (value) {
              onDoneToggle(todo);
            },
          ),
          title: Text(todo.title),
          trailing: IconButton(
            onPressed: () {
              onFavoriteToggle(todo);
            },
            icon: Icon(
              todo.isFavorite ? Icons.star : Icons.star_border,
            ),
          ),
        );
      },
    );
  }
}
