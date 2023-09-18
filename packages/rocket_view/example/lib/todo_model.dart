import 'package:rocket_view/rocket_view.dart';

const String todoUserIdField = "userId";
const String todoIdField = "id";
const String todoTitleField = "title";
const String todoCompletedField = "completed";
// TODO : Fix issue on this example
class Todo extends RocketModel<Todo> {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  Todo({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    userId = json[todoUserIdField];
    id = json[todoIdField];
    title = json[todoTitleField];
    completed = json[todoCompletedField];
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
    int? userIdField,
    int? idField,
    String? titleField,
    bool? completedField,
  }) {
    userId = userIdField ?? userId;
    id = idField ?? id;
    title = titleField ?? title;
    completed = completedField ?? completed;
    rebuildWidget(fromUpdate: true);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[todoUserIdField] = userId;
    data[todoIdField] = id;
    data[todoTitleField] = title;
    data[todoCompletedField] = completed;

    return data;
  }

  Future<void> fetch() async {
    state = RocketState.loading;
    await Future.delayed(const Duration(seconds: 3));
    try {
      final data = [
        {
          'userId': 1,
          'id': 1,
          'title': 'delectus aut autem',
          'completed': false
        }
      ];
      setMulti(data);
    } catch (e) {
      setException(RocketException(exception: 'Failed to load data: $e'));
    }
  }

  @override
  get instance => Todo();
}
