import 'package:rocket_cli/src/model_generator/models/result.dart';

class ModelsController {
  final List<ModelResult> models = [];

  void clearAll() {
    models.clear();
  }

  void addModel(String result, String title) {
    models.add(ModelResult(title, result));
  }
}
