import 'package:example/views/counter_view.dart';
import 'package:example/views/mini_view.dart';
import 'package:example/views/photo_view.dart';
import 'package:example/views/post_view.dart';
import 'package:example/views/todos_view.dart';
import 'package:example/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: MyApp(),
      ),
    ),
    GoRoute(
      path: '/miniview',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: MiniView(
          title: state.extra.toString(),
        ),
      ),
    ),
    GoRoute(
      path: '/counter',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: CounterExample(
          title: state.extra.toString(),
        ),
      ),
    ),
    GoRoute(
      path: '/posts',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: PostExample(
          title: state.extra.toString(),
        ),
      ),
    ),
    GoRoute(
      path: '/posts/:index',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: Details(
          int.tryParse(state.pathParameters['index']!) ?? 1,
        ),
      ),
    ),
    GoRoute(
      path: '/users',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: UserExample(
          title: state.extra.toString(),
        ),
      ),
    ),
    GoRoute(
      path: '/photos',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: PhotoExample(
          title: state.extra.toString(),
        ),
      ),
    ),
    GoRoute(
      path: '/photos/:url',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: ApiImage(state.extra.toString()),
      ),
    ),
    GoRoute(
      path: '/todos',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: TodosExample(
          title: state.extra.toString(),
        ),
      ),
    ),
  ],
  errorPageBuilder: (context, state) => NoTransitionPage<void>(
    key: state.pageKey,
    child: const Scaffold(
      body: Center(child: Text('Unknown error')),
    ),
  ),
);
