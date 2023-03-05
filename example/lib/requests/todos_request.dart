import 'package:example/models/todo.dart';

import 'request.dart';

const String todosEndpoint = "todos";

class GetTodos {
  static Future getTodos(Todos todosModel) =>
      baseRequest.request(todosEndpoint, model: todosModel);
}
