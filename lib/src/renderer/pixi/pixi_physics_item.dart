part of levelup;

class PixiPhysicsItem<T extends PIXI.DisplayObject> extends PixiItem<T> implements PhysicsItem {
  bool _paused = false;

  PixiPhysicsItem(PIXI.DisplayObject displayObject) : super(displayObject) {
    assert(displayObject is PhysicsItem);
  }

  PhysicsItem get _physicsObject => (_displayObject as PhysicsItem);

  Body get body {
    if (_paused) {
      // Return stub body while paused to avoid transforming it
      return new Body(new BodyDef(), null);
    }

    return _physicsObject.body;
  }

  set body(Body body) {
    if (_paused) {
      return;
    }

    _physicsObject.body = body;
  }

  FixtureDef buildFixtureDef() => _physicsObject.buildFixtureDef();

  BodyDef get bodyDef => _physicsObject.bodyDef;

  bool operator ==(other) {
    if (other is PIXI.DisplayObject) {
      return _displayObject == other;
    }

    return identical(this, other);
  }
}
