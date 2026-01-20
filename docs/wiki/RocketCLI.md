# Rocket CLI

`rocket_cli` is a command-line tool designed to eliminate the boilerplate of creating `RocketModel` classes. It converts any JSON (from a string or a file) into fully optimized Dart code.

## Installation

Activate the CLI globally using Dart:

```bash
dart pub global activate rocket_cli
```

## Usage

You can generate a model from a JSON string:

```bash
rocket_cli -j '{"id": 1, "name": "John"}' -n User
```

Or from a JSON file:

```bash
rocket_cli -f data.json -n Result
```

## Features

-   **Automatic Serialization**: Generates `fromJson` and `toJson` methods.
-   **Field Constants**: Automatically creates `const` strings for field keys to prevent typos.
-   **Performance Optimized**: Generates `updateFields` logic with built-in support for **Selective Rebuilds**.
-   **Nested Detection**: Automatically detects nested objects and lists, generating appropriate sub-models.
-   **DateTime Support**: Automatically detects and handles ISO8601 date strings.

## Generated Model Structure

When you run the tool, it creates a Dart file containing:
1.  **Constants**: `const String userIdField = "id";`
2.  **Model Class**: `class User extends RocketModel<User> { ... }`
3.  **Methods**:
    *   `fromJson`: To parse API data.
    *   `toJson`: To send data back.
    *   `updateFields`: Optimized for high-performance state updates.

## Why use it?
Manually writing model serialization is error-prone and tedious. `rocket_cli` ensures your models are consistent, follow best practices, and are optimized for the latest features of Flutter Rocket.
