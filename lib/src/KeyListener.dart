part of levelup;

class KeyListener {
  Set<int> _pressedKeys = new Set<int>();

  KeyListener() {
    document.onKeyDown.listen(_onKeyDown);
    document.onKeyUp.listen(_onKeyUp);
  }

// ---------------------------------------->

  bool isKeyPressed(int keyCode) => _pressedKeys.contains(keyCode);

  Set<int> getPressedKeys() => _pressedKeys;

// ---------------------------------------->

  void _onKeyDown(KeyboardEvent event) {
    _pressedKeys.add(event.keyCode);
  }

  void _onKeyUp(KeyboardEvent event) {
    _pressedKeys.remove(event.keyCode);
  }
}
