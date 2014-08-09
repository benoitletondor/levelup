part of levelup;

abstract class StageContactListener
{
    void onContactBegin(Sprite spriteA, Sprite spriteB, Contact contact);
    
    void onContactEnd(Sprite spriteA, Sprite spriteB, Contact contact);
}