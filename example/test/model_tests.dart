import 'package:example/models/photo_model.dart';
import 'package:example/models/post_model.dart';
import 'package:example/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

import 'dummy_data.dart';

void main() {
  test('Test Post model', () {
    final post = Post();
    post.setMulti(postData);
    expect(post.multi![0].toJson(), postData[0]);
    expect(post.state, RocketState.done);
  });
  test('Test Photo model', () {
    final post = Photo();
    post.setMulti(photoData);
    expect(post.multi![0].toJson(), photoData[0]);
    expect(post.state, RocketState.done);
  });
  test('Test User model', () {
    final post = User();
    post.setMulti(userData);
    expect(post.multi![0].toJson(), userData[0]);
    expect(post.state, RocketState.done);
  });
}
