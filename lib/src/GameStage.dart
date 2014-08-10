part of levelup;

class GameStage
{
    static Stage _stage;
    static Renderer _renderer;
    static World _world;
    
    static Set<PhysicsObject> _physicsObjects = new Set<PhysicsObject>();
    
// ------------------------------------------->
        
    static void _init(Stage stage, Renderer renderer, StageContactListener contactListener)
    {
        assert(stage != null);
        assert(renderer != null);
        
        _stage = stage;
        _renderer = renderer;
        
        // Create Box2d world
        _world = new World(new Vector2(0.0, 50.0), true, new DefaultWorldPool()); //TODO gravity  
        
        // Add contact listener if any
        if( contactListener != null )
        {
            _world.contactListener = new _Listener(contactListener);
        }
       
        // Main rendering loop
        RenderingManager.scheduleRenderingAction(_renderLoop);
    }
    
    static CanvasElement get view => _renderer.view;
    
// ------------------------------------------->
    
    static void addChild(DisplayObject displayObject)
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
    
    static Body _createBody(PhysicsObject object)
    {
        BodyDef def = new BodyDef()
            ..type = object.bodyType
            ..position.setValues(object.position.x.toDouble(), object.position.y.toDouble())
            ..angle = MathHelper.degreeToRadian(object.rotation);
        
        return _world.createBody(def)
            ..createFixture(object.buildFixtureDef()..userData = object); //FIXME circular reference are probably bad
    }
    
    static void removeChild(DisplayObject displayObject)
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
    
    static void _renderLoop(num dt)
    {
        _world.step(100.0, 10, 10); //TODO dynmatic values
        
        for(PhysicsObject object in _physicsObjects)
        {
            object.position = new Point(object.body.position.x, object.body.position.y);
            object.rotation = MathHelper.radianToDegree(object.body.angle);
        }
        
        _renderer.render(_stage);
    }
}

class _Listener implements ContactListener
{
    StageContactListener _contactListener;
    
    _Listener(StageContactListener this._contactListener);
    
// ----------------------------------------->
    
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