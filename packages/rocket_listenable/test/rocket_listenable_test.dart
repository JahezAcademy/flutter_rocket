import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_listenable/rocket_listenable.dart';

void main() {
  group('RocketListenable', () {
    test('register and call listener', () {
      final listenable = _TestListenable();
      var listenerCalled = false;
      listenable.registerListener('key', () {
        listenerCalled = true;
      });
      listenable.callListener('key');
      expect(listenerCalled, isTrue);
    });

    test('register and remove listener', () {
      final listenable = _TestListenable();
      var listenerCalled = false;
      listener() {
        listenerCalled = true;
      }

      listenable.registerListener('key', listener);
      listenable.removeListener('key', listener);
      listenable.callListener('key');
      expect(listenerCalled, isFalse);
    });

    test('register and remove all listeners', () {
      final listenable = _TestListenable();
      var listenerCalled = false;
      listenable.registerListener('key', () {
        listenerCalled = true;
      });
      listenable.dispose();
      listenable.callListener('key');
      expect(listenerCalled, isFalse);
    });

    test('register multiple listeners', () {
      final listenable = _TestListenable();
      var listener1Called = false;
      var listener2Called = false;
      listenable.registerListeners({
        'key1': [
          () {
            listener1Called = true;
          }
        ],
        'key2': [
          () {
            listener2Called = true;
          }
        ]
      });
      listenable.callListener('key1');
      listenable.callListener('key2');
      expect(listener1Called, isTrue);
      expect(listener2Called, isTrue);
    });

    test('remove multiple listeners', () {
      final listenable = _TestListenable();
      var listener1Called = false;
      var listener2Called = false;
      listener1() {
        listener1Called = true;
      }

      listener2() {
        listener2Called = true;
      }

      listenable.registerListeners({
        'key1': [listener1],
        'key2': [listener2]
      });
      listenable.removeListeners(['key1', 'key2'], [listener1, listener2]);
      listenable.callListeners(['key1', 'key2']);
      expect(listener1Called, isFalse);
      expect(listener2Called, isFalse);
    });

    test('get list of listeners keys', () {
      final listenable = _TestListenable();
      listenable.registerListener('key1', () {});
      listenable.registerListener('key2', () {});
      expect(listenable.getListenersKeys, containsAll(['key1', 'key2']));
    });

    test('check if key has listeners', () {
      final listenable = _TestListenable();
      listenable.registerListener('key', () {});
      expect(listenable.keyHasListeners('key'), isTrue);
    });

    test('check if object is merged', () {
      final listenable1 = _TestListenable();
      final listenable2 = _TestListenable();
      listenable1.merges = [listenable2];
      expect(listenable1.isMerged, isTrue);
    });
  });
}

class _TestListenable extends RocketListenable {}
