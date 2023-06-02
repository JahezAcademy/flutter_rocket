
## Getting started

Rocket Singleton easy package for save and get data from memory by type or key

## Usage

```dart
// Use save extension
final Post post = Post().save(key: "post", readOnly: true);
// Or
// Use Rocket object
Rocket.add(value,readOnly: true); // you can't edit it if readonly true
// or
// add by key if you have multi object with same type
Rocket.add<Type>(value, key: "key");
// [get] return value
Rocket.get<Type>("key");
// or get only by Type
Rocket.get<Type>()
// [remove]
Rocket.remove("key");
// remove with condition
Rocket.removeWhere((key,value)=>key.contains("ke"));

```