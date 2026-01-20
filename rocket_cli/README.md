# Rocket CLI

A powerful command-line tool to generate `RocketModel` classes from JSON data.

## Features

- Generate models from raw JSON strings.
- Generate models from JSON files.
- Automatically handles nested objects and lists.
- Supports custom class names and output directories.

## Installation

You can run it directly using `dart run` within the package:

```bash
dart run rocket_cli [arguments]
```

Or activate it globally:

```bash
dart pub global activate --source path .
rocket_cli [arguments]
```

## Usage

### Generate from JSON file

```bash
rocket_cli -f data.json -n UserProfile -o lib/models
```

### Generate from raw JSON string

```bash
rocket_cli -j '{"id":1, "name":"John"}' -n User
```

### Arguments

| Argument | Abbr | Description | Default |
| --- | --- | --- | --- |
| `--json` | `-j` | Raw JSON string | |
| `--file` | `-f` | Path to JSON file | |
| `--name` | `-n` | Root class name | `MyModel` |
| `--output` | `-o` | Output directory | `lib/models` |
| `--help` | `-h` | Show help | |