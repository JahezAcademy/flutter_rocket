import 'package:example/models/photo_model.dart';
import 'package:example/models/post_model.dart';
import 'package:example/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

import 'dummy_data.dart';

void main() {
  group(
      'Test Post model (multi, fromJson, toJson, updateFields, updateFieldsByMap, state)',
      () {
    final post = Post();
    const String newTitle = "New title";
    const String newTitleByMap = "New title from UpdateFieldsByMap";
    test("Test Post model (multi, fromJson, toJson)", () {
      // Test setMulti, fromJson & toJson
      post.setMulti(postData);
      expect(post.multi!.first.toJson(), postData.first);
    });
    test("Test Post model UpdateFields", () {
      // Test updateFields
      post.multi!.first.updateFields(titleField: newTitle);
      expect(post.multi!.first.toJson()[postTitleField], newTitle);
    });
    test("Test Post model UpdateFieldsByMap", () {
      // Test updateFieldsByMap
      post.multi!.first.updateFieldsByMap({postTitleField: newTitleByMap});
      expect(post.multi!.first.toJson()[postTitleField], newTitleByMap);
    });
    test("Test Post model Failed State", () {
      // Failed case
      post.multi!.first.updateFieldsByMap({postTitleField: 5});
      expect(post.multi!.first.state, RocketState.failed);
    });
  });
  group(
      'Test Photo model (multi, fromJson, toJson, updateFields, updateFieldsByMap)',
      () {
    final photo = Photo();
    const String newTitle = "New title";
    const String newTitleByMap = "New title from UpdateFieldsByMap";
    test("Test Photo model (multi, fromJson, toJson)", () {
      // Test setMulti, fromJson & toJson
      photo.setMulti(photoData);
      expect(photo.multi!.first.toJson(), photoData.first);
    });
    test("Test Photo model updateFields", () {
      // Test updateFields
      photo.multi!.first.updateFields(titleField: newTitle);
      expect(photo.multi!.first.toJson()[photoTitleField], newTitle);
    });
    test("Test Photo model updateFieldsByMap", () {
      // Test updateFieldsByMap
      photo.multi!.first.updateFieldsByMap({photoTitleField: newTitleByMap});
      expect(photo.multi!.first.toJson()[photoTitleField], newTitleByMap);
    });
    test("Test Photo model Failed State", () {
      // Failed case
      photo.multi!.first.updateFieldsByMap({photoTitleField: 5});
      expect(photo.multi!.first.state, RocketState.failed);
    });
  });

  group(
      'Test User model (multi, fromJson, toJson, updateFields, updateFieldsByMap)',
      () {
    final user = User();
    const String newTitle = "New username";
    const String newTitleByMap = "New username from UpdateFieldsByMap";
    test('Test User model (multi, fromJson, toJson)', () {
      // Test setMulti, fromJson & toJson
      user.setMulti(userData);
      expect(user.multi!.first.toJson(), userData.first);
    });
    test('Test User model updateFields', () {
      // Test updateFields
      user.multi!.first.updateFields(usernameField: newTitle);
      expect(user.multi!.first.toJson()[userUsernameField], newTitle);
    });
    test('Test User model updateFieldsByMap', () {
      // Test updateFieldsByMap
      user.multi!.first.updateFieldsByMap({userUsernameField: newTitleByMap});
      expect(user.multi!.first.toJson()[userUsernameField], newTitleByMap);
    });
    test('Test User model Failed Case', () {
      // Failed case
      user.multi!.first.updateFieldsByMap({userNameField: 5});
      expect(user.multi!.first.state, RocketState.failed);
    });
  });
}
