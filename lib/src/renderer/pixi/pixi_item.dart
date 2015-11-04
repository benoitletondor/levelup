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

class PixiItem<T extends PIXI.DisplayObject> implements Item<T> {
  T _displayObject;

  PixiItem(T this._displayObject) {
    assert(_displayObject != null);
  }

  T get item => _displayObject;

  set position(math.Point point) =>
      _displayObject.position = new PIXI.Point.fromValues(point.x, point.y);
  math.Point get position => _displayObject.position;

  num get rotation => _displayObject.rotation;
  set rotation(num rotation) => _displayObject.rotation = rotation;

  bool operator ==(other) {
    if (other is PIXI.DisplayObject) {
      return _displayObject == other;
    }

    return identical(this, other);
  }
}
