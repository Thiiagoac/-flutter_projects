import 'package:flutter/material.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';
import 'package:lista_tarefas/widgets/todo_list_item.dart';

import '../models/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerTarefa = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> tarefas = [];

  Todo? deletedTodo;
  int? deletedTodoIndex;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lista de Tarefas',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: controllerTarefa,
                        onSubmitted: ,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff00d7f3), width: 2)),
                          labelText: 'Adicione uma tarefa',
                          labelStyle: const TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                          hintText: 'Ex: Estudar flutter',
                          border: const OutlineInputBorder(),
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: adicionarTarefa,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(18),
                          backgroundColor: const Color(0xff00d7f3),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in tarefas)
                        TodoListItem(tarefa: todo, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tarefas.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: limparTudo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        backgroundColor: const Color(0xff00d7f3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Limpar Tudo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoIndex = tarefas.indexOf(todo);

    setState(() {
      tarefas.remove(todo);
    });
    todoRepository.saveList(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: const TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          textColor: const Color(0xff00d7f3),
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              tarefas.insert(deletedTodoIndex!, deletedTodo!);
            });
            todoRepository.saveList(tarefas);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void adicionarTarefa() {
    String text = controllerTarefa.text;

    if (text.isEmpty) {
      setState(() {
        errorText = 'Preencha o campo da tarefa';
      });
      return;
    }

    setState(() {
      Todo newTodo = Todo(
        title: text,
        dateTime: DateTime.now(),
      );
      tarefas.add(newTodo);
      errorText = null;
    });
    controllerTarefa.clear();
    todoRepository.saveList(tarefas);
  }

  limparTudo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Limpar tudo?',
        ),
        content: const Text(
          'Você tem certeza que deseja apagar todas as tarefas?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xff00d7f3)),
            child: const Text(
              'Cancelar',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              clearTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              'Limpar',
            ),
          ),
        ],
      ),
    );
  }

  void clearTodos() {
    setState(() {
      tarefas.clear();
    });
    todoRepository.saveList(tarefas);
  }
}
