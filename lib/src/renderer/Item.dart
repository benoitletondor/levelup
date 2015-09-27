part of levelup;

abstract class Item {
  set position(math.Point point);
  math.Point get position;

  num get rotation;
  set rotation(num rotation);
}
