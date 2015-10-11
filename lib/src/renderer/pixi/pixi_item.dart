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
