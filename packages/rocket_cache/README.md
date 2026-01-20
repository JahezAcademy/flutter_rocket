# Rocket Cache

A persistence and caching layer for the [Flutter Rocket](https://pub.dev/packages/flutter_rocket) package.

## Features

- Simple key-value persistence using `shared_preferences`.
- Automatically handles serialization for `RocketModel`.
- Support for cache duration/expiration.

## Getting Started

Initialize the cache storage:

```dart
await RocketCache.init();
```

## Usage

Use it directly with `RocketClient`:

```dart
client.request(
  'posts',
  model: postModel,
  cacheKey: 'all_posts',
  cacheDuration: Duration(days: 1),
);
```
