part of levelup;

class GameStage implements ContactListener
{
    Container _container;
    Renderer _renderer;
    World _world;
    StageContactListener _contactListener;
    CanvasRenderingContext2D _debugCtx;
    
    Set<PhysicsObject> _physicsObjects = new Set<PhysicsObject>();
    
// ------------------------------------------->
        
    GameStage(Container this._container, Renderer this._renderer, StageContactListener this._contactListener)
    {
        assert(_container != null);
        assert(_renderer != null);
        
        // Create Box2d world
        _world = new World.withPool(new Vector2(0.0, 500.0), new DefaultWorldPool(100, 10)); //TODO gravity  
        
        // Add contact listener if any
        if( _contactListener != null )
        {
            _world.setContactListener(this);
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
        
        _container.addChild(displayObject);
    }
    
    Body _createBody(PhysicsObject object)
    {
        BodyDef def = new BodyDef()
            ..type = object.bodyType
            ..position.setValues(object.position.x.toDouble(), object.position.y.toDouble())
            ..angle = MathHelper.degreeToRadian(object.rotation)
            ..allowSleep = object.allowBodySleep;
        
        return _world.createBody(def)
            ..createFixtureFromFixtureDef(object.buildFixtureDef()..userData = object); //FIXME circular reference are probably bad
    }
    
    void removeChild(DisplayObject displayObject)
    {
        assert(displayObject != null);
        
        if( displayObject is PhysicsObject )
        {
            PhysicsObject object = displayObject as PhysicsObject;
            
            object.body.getFixtureList().userData = null;
            object.body.userData = null;
            _world.destroyBody(object.body);
            object.body = null;
            
            _physicsObjects.remove(object);
        }
        
        _container.removeChild(displayObject);
    }
    
// ------------------------------------------->
    
    void _renderLoop(num dt)
    {
        _world.stepDt(1/60, 10, 10); //TODO dynamic values
        
        for(PhysicsObject object in _physicsObjects)
        {
            object.position = new Point(object.body.position.x, object.body.position.y);
            object.rotation = MathHelper.radianToDegree(object.body.getAngle());
        }
        
        _renderer.render(_container);
    }
    
// ------------------------------------------->
// Debug draw
    
    void debugInCanvas(CanvasElement canvas)
    {
        if( _debugCtx != null )
        {
            stopDebug();
        }
        
        var viewport = new CanvasViewportTransform(new Vector2(canvas.width / 2.0, canvas.height / 2.0), new Vector2(canvas.width.toDouble(), canvas.height.toDouble()))
            ..scale = 1.0
            ..yFlip = false;
        
        _debugCtx = canvas.context2D;
        
        _world.debugDraw = new CanvasDraw(viewport, _debugCtx);
        RenderingManager.scheduleRenderingAction(_debugLoop);
    }
    
    void stopDebug()
    {
        if( _debugCtx != null )
        {
            _world.debugDraw = null;
            _debugCtx = null;
            RenderingManager.unscheduleRenderingAction(_debugLoop);
        }
    }
    
    void _debugLoop(num dt)
    {
        _debugCtx.clearRect(0, 0, 400, 400);        
        _world.drawDebugData();
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