# RocketModel

`RocketModel` is the base class for all your data models. It provides built-in state management, JSON serialization, and notification logic.

## Defining a Model

A `RocketModel` typically consists of:
1. **Properties**: Your data fields.
2. **Field Constants**: String keys matched to JSON keys.
3. **fromJson**: Logic to populate fields from a Map.
4. **updateFields**: Logic to update specific fields and trigger selective rebuilds.

### Example Model

```dart
import 'package:flutter_rocket/flutter_rocket.dart';

// 1. Define field keys as constants for reliability
const String userIdField = "userId";
const String idField = "id";
const String titleField = "title";

class Post extends RocketModel<Post> {
  // 2. Properties
  int? userId;
  int? id;
  String? title;

  Post({this.userId, this.id, this.title});

  // 3. Populate from JSON
  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if (json == null) return;
    userId = json[userIdField];
    id = json[idField];
    title = json[titleField];
    super.fromJson(json, isSub: isSub);
  }

  // 4. Update fields and trigger selective rebuilds
  void updateFields({int? userIdField, int? idField, String? titleField}) {
    List<String> fields = [];
    if (userIdField != null) {
      userId = userIdField;
      fields.add(userIdField);
    }
    // ... add logic for other fields
    rebuildWidget(fromUpdate: true, fields: fields.isEmpty ? null : fields);
  }

  @override
  Post get instance => Post();
}
```

## State Management

Every `RocketModel` has a `state` property of type `RocketState`:
- `RocketState.loading`: Data is being fetched.
- `RocketState.done`: Data is loaded successfully.
- `RocketState.failed`: An error occurred.

You can check the state in your UI to show loaders or error messages.

## Data Collections

When you fetch a list of items, the `all` property of the `RocketModel` holds the list. It is also an instance of `RocketModel` (or a subclass) that manages the list state.

```dart
final Post posts = Post();
// After fetching...
print(posts.all!.length);
```

## Tips
- Use **Rocket CLI** to generate these models instantly.
- Always use constant strings for field names to avoid typos.
- Override `enableDebug` to `true` during development to see state transition logs.
