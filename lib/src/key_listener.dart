/*
 *   Copyright 2015 Benoit LETONDOR
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

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
