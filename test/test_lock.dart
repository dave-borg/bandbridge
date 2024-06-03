import 'dart:async';

Completer<void>? _testLockCompleter;

Future<void> acquireTestLock() async {
  while (_testLockCompleter != null) {
    await _testLockCompleter!.future;
  }
  _testLockCompleter = Completer<void>();
}

void releaseTestLock() {
  _testLockCompleter?.complete();
  _testLockCompleter = null;
}