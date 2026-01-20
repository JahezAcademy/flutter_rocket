# RocketView

`RocketView` is the primary widget used to bind your `RocketModel` to the UI. It automatically reacts to state changes (loading, done, failed) and rebuilds when data changes.

## Basic Usage

```dart
RocketView(
  model: postModel,
  fetch: () => client.request('posts', model: postModel),
  builder: (context, state) {
    return ListView.builder(
      itemCount: postModel.all!.length,
      itemBuilder: (context, index) => Text(postModel.all![index].title!),
    );
  },
)
```

## Parameters

- `model`: The `RocketModel` instance to listen to.
- `fetch`: A function that makes the API call. Runs automatically based on `callType`.
- `builder`: The UI builder. Receives the current `RocketState`.
- `loader`: (Optional) Custom widget to show during `loading`.
- `onError`: (Optional) Custom widget to show on `failed`. Receives the exception and a reload function.
- `callType`: Determines when `fetch` is called:
    - `CallType.callIfModelEmpty`: Only fetch if `model.all` is empty.
    - `CallType.callAsStream`: Repeatedly fetch data every `secondsOfStream`.
    - `CallType.callAsFuture`: Always fetch when the widget is initialized.

## Performance Optimization

Use the `fields` parameter to implement **Selective Rebuilds**. This tells `RocketView` to only rebuild if specific properties of the model change.

```dart
RocketView(
  model: currentPost,
  fields: [postTitleField], // Only rebuilds if the 'title' property changes
  builder: (context, state) => Text(currentPost.title!),
)
```

## Mini Views

For simple local state (like a counter or a toggling boolean), use `RocketMiniView` with `RocketValue`.

```dart
final count = 0.mini;

RocketMiniView(
  value: count,
  builder: () => Text('Count: ${count.v}'),
)
```
