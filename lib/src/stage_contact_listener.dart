part of levelup;

abstract class StageContactListener {
  void onContactBegin(Item spriteA, Item spriteB, Contact contact);

  void onContactEnd(Item spriteA, Item spriteB, Contact contact);
}
