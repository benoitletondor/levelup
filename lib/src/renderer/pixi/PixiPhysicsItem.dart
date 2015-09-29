part of levelup;

class PixiPhysicsItem extends PixiItem implements PhysicsItem {
  PixiPhysicsItem(PIXI.DisplayObject displayObject) : super(displayObject) {
    assert(displayObject is PhysicsItem);
  }

  PhysicsItem get _physicsObject => (_displayObject as PhysicsItem);

  Body get body => _physicsObject.body;

  set body(Body body) => _physicsObject.body = body;

  FixtureDef buildFixtureDef() => _physicsObject.buildFixtureDef();

  BodyDef get bodyDef => _physicsObject.bodyDef;

  bool operator ==(other) {
    if (other is PIXI.DisplayObject) {
      return _displayObject == other;
    }

    return identical(this, other);
  }
}
