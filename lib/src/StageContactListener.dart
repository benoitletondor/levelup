part of levelup;

abstract class StageContactListener
{
    void onContactBegin(DisplayObject spriteA, DisplayObject spriteB, Contact contact);
    
    void onContactEnd(DisplayObject spriteA, DisplayObject spriteB, Contact contact);
}