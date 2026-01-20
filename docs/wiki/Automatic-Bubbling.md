# Automatic Bubbling

**Automatic Bubbling** is a built-in orchestration feature in Flutter Rocket that eliminates the need for manual listener management when working with nested models or collections. It ensures that changes in a child model are automatically "bubbled up" to the parent, triggering a rebuild in any widget listening to the parent.

## The Problem

In most state management systems, if you have a list of items (e.g., `Posts`) and you update a property of a single item (e.g., `Post.title`), the list widget itself won't know it needs to rebuild unless you manually notify it or use complex nested listeners.

## The Solution

In Flutter Rocket, every `RocketModel` is "bubbling-aware." When a model is part of a collection (the `all` list), any call to `rebuildWidget()` on the child model automatically triggers a notification to the parent collection.

## How it Works

Imagine you have a `Posts` model that contains a list of single `Post` items.

1.  **The UI**: You have a `RocketView` listening to the `Posts` model.
2.  **The Action**: You change the title of `post[5]` using `currentPost.updateFields(...)`.
3.  **The Bubbling**: 
    - `currentPost` calls its listeners (if any selective rebuild fields match).
    - `currentPost` then notifies its parent (`Posts`).
    - The `RocketView` listening to `Posts` receives the notification and rebuilds.

## Benefits

-   **Zero Extra Code**: You don't need to add special "notifyParent" logic.
-   **Consistent UI**: Your list views, counters, or summary widgets stay in sync with the individual items they contain.
-   **Simplified Architecture**: You can treat your data tree as a single source of truth without worrying about wiring up listeners at every level.

## Example

```dart
// Parent View
RocketView(
  model: postModel, // This is a list of posts
  builder: (context, state) {
    return ListView.builder(
      itemCount: postModel.all!.length,
      itemBuilder: (context, index) {
        final post = postModel.all![index];
        return ListTile(
          title: Text(post.title!),
          onTap: () {
            // Updating the CHILD automatically triggers a rebuild of this PARENT list
            post.updateFields(titleField: 'Updated Title!');
          },
        );
      },
    );
  },
)
```

## Performance Note
While bubbling is convenient, it triggers a rebuild of the parent widget. For extreme performance in large lists, combine Bubbling with [**Selective Rebuilds**](Selective-Rebuilds) by wrapping list items in their own `RocketView` to localize updates.
