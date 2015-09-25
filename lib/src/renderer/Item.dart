part of levelup;

abstract class Item
{
    set positionX(num x);
    num get positionX;
    
    set positionY(num y);
    num get positionY;
    
    set position(Point point);
    Point get position;
    
    num get rotation;
    set rotation(num rotation);
}