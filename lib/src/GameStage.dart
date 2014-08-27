part of levelup;

class GameStage implements ContactListener
{
    Stage _stage;
    Renderer _renderer;
    World _world;
    StageContactListener _contactListener;
    
    Set<PhysicsObject> _physicsObjects = new Set<PhysicsObject>();
    
// ------------------------------------------->
        
    GameStage(Stage this._stage, Renderer this._renderer, StageContactListener this._contactListener)
    {
        assert(_stage != null);
        assert(_renderer != null);
        
        // Create Box2d world
        _world = new World(new Vector2(0.0, 500.0), true, new DefaultWorldPool()); //TODO gravity  
        
        // Add contact listener if any
        if( _contactListener != null )
        {
            _world.contactListener = this;
        }
       
        // Main rendering loop
        RenderingManager.scheduleRenderingAction(_renderLoop);
    }
    
    CanvasElement get view => _renderer.view;
    
    World get world => _world;
    
// ------------------------------------------->
    
    void addChild(DisplayObject displayObject)
    {
        assert(displayObject != null);
        
        if( displayObject is PhysicsObject )
        {
            PhysicsObject object = displayObject as PhysicsObject;
            object.body = _createBody(object);
            _physicsObjects.add(object);
        }
        
        _stage.addChild(displayObject);
    }
    
    Body _createBody(PhysicsObject object)
    {
        BodyDef def = new BodyDef()
            ..type = object.bodyType
            ..position.setValues(object.position.x.toDouble(), object.position.y.toDouble())
            ..angle = MathHelper.degreeToRadian(object.rotation);
        
        return _world.createBody(def)
            ..createFixture(object.buildFixtureDef()..userData = object); //FIXME circular reference are probably bad
    }
    
    void removeChild(DisplayObject displayObject)
    {
        assert(displayObject != null);
        
        if( displayObject is PhysicsObject )
        {
            PhysicsObject object = displayObject as PhysicsObject;
            
            object.body.fixtureList.userData = null;
            object.body.userData = null;
            _world.destroyBody(object.body);
            object.body = null;
            
            _physicsObjects.remove(object);
        }
        
        _stage.removeChild(displayObject);
    }
    
// ------------------------------------------->
    
    void _renderLoop(num dt)
    {
        _world.step(1/60, 10, 10); //TODO dynmatic values
        
        for(PhysicsObject object in _physicsObjects)
        {
            object.position = new Point(object.body.position.x, object.body.position.y);
            object.rotation = MathHelper.radianToDegree(object.body.angle);
        }
        
        _renderer.render(_stage);
    }
    
// ------------------------------------------->
// Contact Listener
    
    void beginContact(Contact contact)
    {
        DisplayObject displayObjectA = contact.fixtureA.userData as DisplayObject;
        DisplayObject displayObjectB = contact.fixtureB.userData as DisplayObject;
        
        _contactListener.onContactBegin(displayObjectA, displayObjectB, contact);
    }

    void endContact(Contact contact)
    {
        DisplayObject displayObjectA = contact.fixtureA.userData as DisplayObject;
        DisplayObject displayObjectB = contact.fixtureB.userData as DisplayObject;
        
        _contactListener.onContactEnd(displayObjectA, displayObjectB, contact);
    }
 
    void preSolve(Contact contact, Manifold oldManifold)
    {
           
    }

    void postSolve(Contact contact, ContactImpulse impulse)
    {
        
    }
}