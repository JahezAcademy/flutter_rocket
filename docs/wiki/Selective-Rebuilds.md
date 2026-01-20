# Selective Rebuilds

Selective Rebuilds are a powerful optimization in Flutter Rocket that allows you to specify exactly which UI components should update when a model property changes. This prevents unnecessary rebuilds and keeps your app silky smooth, even with large data sets.

## The Problem

In traditional state management, updating a single property in an object often triggers a rebuild of every widget listening to that object. If you have a list of 100 items and update the title of one item, you don't want to rebuild the entire list or even the entire list item widget if only a small part of it changed.

## The Solution

Flutter Rocket solves this by allowing you to:
1.  **Register listeners** for specific field names.
2.  **Notify listeners** only for specific field names.

## How to Implement

### 1. In your Model
Update your model's `updateFields` method to track changed fields.

```dart
void updateFields({String? titleField, String? bodyField}) {
  List<String> changedFields = [];
  
  if (titleField != null) {
    title = titleField;
    changedFields.add(postTitleField);
  }
  
  if (bodyField != null) {
    body = bodyField;
    changedFields.add(postBodyField);
  }
  
  // Notify only the widgets listening to these fields
  rebuildWidget(fields: changedFields.isEmpty ? null : changedFields);
}
```

### 2. In your UI
Wrap your specific UI components in `RocketView` and provide the `fields` list.

```dart
// This widget ONLY rebuilds when 'title' changes
RocketView(
  model: post,
  fields: [postTitleField],
  builder: (context, state) => Text(post.title!),
)

// This widget ONLY rebuilds when 'body' changes
RocketView(
  model: post,
  fields: [postBodyField],
  builder: (context, state) => Text(post.body!),
)
```

## Why it's "Premium" Performance
- **Reduced Build Time**: Only the smallest necessary part of the UI tree is rebuilt.
- **CPU Savings**: Less work for the Flutter framework to diff the widget tree.
- **Battery Efficiency**: Lower energy consumption by minimizing rendering work.

## Relationship with Automatic Bubbling
Selective Rebuilds used in conjunction with [**Automatic Bubbling**](Automatic-Bubbling) provide the ultimate performance strategy:
- **Bubbling** ensures the parent (like a list) knows an item changed.
- **Selective Rebuilds** ensure that only the specific property inside that item is redrawn, rather than the entire list entry.

## Pro Tip
Using **Rocket CLI** version 1.1.0 or higher will automatically generate the `updateFields` logic for you, making this optimization effortless.
