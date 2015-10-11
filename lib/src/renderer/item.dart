part of levelup;

abstract class Item<T> {
  set position(math.Point point);
  math.Point get position;

  num get rotation;
  set rotation(num rotation);

  T get item;
}
