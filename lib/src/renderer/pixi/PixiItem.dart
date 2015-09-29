part of levelup;

class PixiItem implements Item {
  PIXI.DisplayObject _displayObject;

  PixiItem(PIXI.DisplayObject this._displayObject) {
    assert(_displayObject != null);
  }

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
