part of levelup;

class KeyListener {
  Set<int> _pressedKeys = new Set<int>();

  KeyListener._internal() {
    html.document.onKeyDown.listen(_onKeyDown);
    html.document.onKeyUp.listen(_onKeyUp);
  }

// ---------------------------------------->

  bool isKeyPressed(int keyCode) => _pressedKeys.contains(keyCode);

  Set<int> getPressedKeys() => _pressedKeys;

// ---------------------------------------->

  void _onKeyDown(html.KeyboardEvent event) {
    _pressedKeys.add(event.keyCode);
  }

  void _onKeyUp(html.KeyboardEvent event) {
    _pressedKeys.remove(event.keyCode);
  }
}
