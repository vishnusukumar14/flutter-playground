import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'model/todo.dart';

part 'todo_list-riverpod.g.dart';

@riverpod
class MyTodo extends _$MyTodo {
  @override
  List<Todos> build() {
    return [
      Todos.create(title: "Sample Task 1", descp: "Complete this task"),
      Todos.create(title: "Sample Task 2", descp: "Another task to do"),
      Todos.create(title: "Sample Task 3", descp: "Third sample task"),
      Todos.create(title: "Sample Task 4", descp: "Fourth sample task"),
    ];
  }

  void add(Todos todo) {
    state = [...state, todo];
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void toggle(String id) {
    state = [
      for (final t in state)
        t.id == id ? t.copyWith(isEnabled: !t.isEnabled) : t,
    ];
  }

  // Helper method to get index by id
  int getIndexById(String id) {
    return state.indexWhere((todo) => todo.id == id);
  }
}

class TodoListRiverpod extends ConsumerStatefulWidget {
  const TodoListRiverpod({super.key});

  @override
  ConsumerState<TodoListRiverpod> createState() => _TodoListRiverpodState();
}

class _TodoListRiverpodState extends ConsumerState<TodoListRiverpod> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Todos> _currentTodos;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentTodos = ref.read(myTodoProvider);
      _isInitialized = true;
    });
  }

  void _handleListChanges(List<Todos> newTodos) {
    if (!_isInitialized) return;

    final oldTodos = _currentTodos;

    // Handle additions (items in new but not in old)
    for (int i = 0; i < newTodos.length; i++) {
      final newTodo = newTodos[i];
      final oldIndex = oldTodos.indexWhere((t) => t.id == newTodo.id);

      if (oldIndex == -1) {
        // New item added
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Handle removals (items in old but not in new)
    for (int i = oldTodos.length - 1; i >= 0; i--) {
      final oldTodo = oldTodos[i];
      final exists = newTodos.any((t) => t.id == oldTodo.id);

      if (!exists) {
        // Item removed
        _listKey.currentState?.removeItem(
          i,
          (context, animation) =>
              _buildTodoItem(oldTodo, animation, isRemoving: true),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    _currentTodos = List.from(newTodos);
  }

  Widget _buildTodoItem(
    Todos todo,
    Animation<double> animation, {
    bool isRemoving = false,
  }) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: isRemoving
            ? _buildTodoCard(todo, isRemoving: true)
            : Dismissible(
                key: Key(todo.id),
                direction: DismissDirection.startToEnd,
                // confirmDismiss: (direction) async {
                //   return await _showDeleteConfirmation(todo);
                // },
                onDismissed: (direction) {
                  _removeTodoWithFeedback(todo);
                },
                background: _buildDismissBackground(),
                child: _buildTodoCard(todo),
              ),
      ),
    );
  }

  Widget _buildTodoCard(Todos todo, {bool isRemoving = false}) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      checkboxSemanticLabel: "Toggle ${todo.title}",
      activeColor: Colors.lightGreen,
      checkboxShape: const CircleBorder(),
      checkColor: Colors.white,
      secondary: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: isRemoving ? null : () => _removeTodoWithConfirmation(todo),
        tooltip: 'Delete todo',
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isEnabled ? TextDecoration.lineThrough : null,
          color: todo.isEnabled ? Colors.grey[600] : null,
          fontWeight: todo.isEnabled ? FontWeight.normal : FontWeight.w500,
        ),
      ),
      subtitle: todo.descp != null && todo.descp!.isNotEmpty
          ? Text(
              todo.descp!,
              style: TextStyle(
                color: todo.isEnabled ? Colors.grey[500] : Colors.grey[700],
              ),
            )
          : null,
      value: todo.isEnabled,
      onChanged: isRemoving ? null : (_) => _toggleTodo(todo.id),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(Todos todo) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Todo'),
            content: Text('Are you sure you want to delete "${todo.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _removeTodoWithConfirmation(Todos todo) async {
    final confirmed = await _showDeleteConfirmation(todo);
    if (confirmed) {
      _removeTodoWithFeedback(todo);
    }
  }

  void _removeTodoWithFeedback(Todos todo) {
    ref.read(myTodoProvider.notifier).remove(todo.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${todo.title} deleted'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            ref.read(myTodoProvider.notifier).add(todo);
          },
        ),
      ),
    );
  }

  void _toggleTodo(String id) {
    ref.read(myTodoProvider.notifier).toggle(id);
  }

  void _addNewTodo() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newTodo = Todos.create(
      title: "New Task $timestamp",
      descp: "Created ${DateTime.now().toString().split('.')[0]}",
    );

    ref.read(myTodoProvider.notifier).add(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(myTodoProvider);

    // Handle list changes efficiently
    if (_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleListChanges(todos);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List (${todos.length})'),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Swipe left to delete, tap checkbox to toggle'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewTodo,
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
      ),
      body: SafeArea(
        child: todos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No todos yet!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first todo',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                ),
              )
            : AnimatedList(
                key: _listKey,
                initialItemCount: todos.length,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                itemBuilder: (context, index, animation) {
                  // Safety check for index bounds
                  if (index >= todos.length) {
                    return const SizedBox.shrink();
                  }
                  return _buildTodoItem(todos[index], animation);
                },
              ),
      ),
    );
  }
}
