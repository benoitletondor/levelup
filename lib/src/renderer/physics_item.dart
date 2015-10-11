part of levelup;

abstract class PhysicsItem {
  bool _paused = false;

  Body get body;
  set body(Body body);

  math.Point get position;
  set position(math.Point position);

  num get rotation;
  set rotation(num rotation);

  FixtureDef buildFixtureDef();

  BodyDef get bodyDef;
}
