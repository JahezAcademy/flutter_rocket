import 'package:example/models/todos.dart';

import 'request.dart';

const String todosEndpoint = "todos";

class GetTodos {
  static Future gettodos(Todos todosModel) =>
      baseRequest.request(todosEndpoint, model: todosModel);
}
