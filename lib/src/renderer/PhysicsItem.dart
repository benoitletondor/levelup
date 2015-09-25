part of levelup;

abstract class PhysicsItem
{
    Body get body;
    
    set body(Body body);
    
    Point get position;
    
    set position(Point position);
    
    num get rotation;
    
    set rotation(num rotation);
    
    FixtureDef buildFixtureDef();
    
    BodyDef get bodyDef;
}