part of levelup;

class GameStage implements ContactListener {
  Renderer _renderer;
  World _world;
  StageContactListener _contactListener;
  html.CanvasRenderingContext2D _debugCtx;
  DragNDropManager _dragNDropManager;

  Set<PhysicsItem> _physicsObjects = new Set<PhysicsItem>();

// ------------------------------------------->

  GameStage(
      Renderer this._renderer, StageContactListener this._contactListener) {
    assert(_renderer != null);

    // Create Box2d world
    _world = new World.withPool(
        new Vector2(0.0, 0.0), new DefaultWorldPool(100, 10)); //TODO gravity

    // Add contact listener if any
    if (_contactListener != null) {
      _world.setContactListener(this);
    }

    // Main rendering loop
    RenderingManager.scheduleRenderingAction(_renderLoop);
  }

  html.CanvasElement get view => _renderer.view;

  set gravity(Vector2 gravity) => _world.setGravity(gravity);

  DragNDropManager get dragNDropManager {
    if (_dragNDropManager == null) {
      _dragNDropManager = new DragNDropManager._internal();
    }

    return _dragNDropManager;
  }

// ------------------------------------------->

  void addChild(Item displayObject) {
    assert(displayObject != null);

    if (displayObject is PhysicsItem) {
      PhysicsItem object = displayObject as PhysicsItem;
      object.body = _createBody(object);
      _physicsObjects.add(object);
    }

    _renderer.addChild(displayObject);
  }

  Body _createBody(PhysicsItem object) {
    BodyDef def = object.bodyDef
      ..position
          .setValues(object.position.x.toDouble(), object.position.y.toDouble())
      ..angle = MathHelper.degreeToRadian(object.rotation);

    return _world.createBody(def)
      ..createFixtureFromFixtureDef(object.buildFixtureDef()
        ..userData = object); //FIXME circular reference are probably bad
  }

  void removeChild(Item displayObject) {
    assert(displayObject != null);

    if (displayObject is PhysicsItem) {
      PhysicsItem object = displayObject as PhysicsItem;

      object.body.getFixtureList().userData = null;
      object.body.userData = null;
      _world.destroyBody(object.body);
      object.body = null;

      _physicsObjects.remove(object);

      if (_dragNDropManager != null) {
        // Remove from draggable object in case it's added
        _dragNDropManager.removeDragNDropableItem(object);
      }
    }

    _renderer.removeChild(displayObject);
  }

// ------------------------------------------->

  void _renderLoop(num dt) {
    _world.stepDt(1 / 60, 10, 10); //TODO dynamic values

    for (PhysicsItem object in _physicsObjects) {
      object.position =
          new html.Point(object.body.position.x, object.body.position.y);
      object.rotation = MathHelper.radianToDegree(object.body.getAngle());
    }

    _renderer.render();
  }

// ------------------------------------------->
// Debug draw

  void debugInCanvas(html.CanvasElement canvas) {
    if (_debugCtx != null) {
      stopDebug();
    }

    // Revert Y axis (since debug is inverted)
    var cssAtribute = canvas.getAttribute("style");
    if (cssAtribute != null) {
      cssAtribute += ";";
    } else {
      cssAtribute = "";
    }

    cssAtribute += "transform: scaleY(-1)";
    canvas.setAttribute("style", cssAtribute);

    // Create and asign debug viewport
    var viewport = new CanvasViewportTransform(
        new Vector2(canvas.width / 2.0, canvas.height / 2.0),
        new Vector2(canvas.width.toDouble(), canvas.height.toDouble()))
      ..scale = 1.0
      ..yFlip = false;

    _debugCtx = canvas.context2D;

    _world.debugDraw = new CanvasDraw(viewport, _debugCtx);
    RenderingManager.scheduleRenderingAction(_debugLoop);
  }

  void stopDebug() {
    if (_debugCtx != null) {
      _world.debugDraw = null;
      _debugCtx = null;
      RenderingManager.unscheduleRenderingAction(_debugLoop);
    }
  }

  void _debugLoop(num dt) {
    _debugCtx.clearRect(0, 0, _debugCtx.canvas.width, _debugCtx.canvas.height);
    _world.drawDebugData();
  }

// ------------------------------------------->
// Contact Listener

  void beginContact(Contact contact) {
    Item displayObjectA = contact.fixtureA.userData as Item;
    Item displayObjectB = contact.fixtureB.userData as Item;

    _contactListener.onContactBegin(displayObjectA, displayObjectB, contact);
  }

  void endContact(Contact contact) {
    Item displayObjectA = contact.fixtureA.userData as Item;
    Item displayObjectB = contact.fixtureB.userData as Item;

    _contactListener.onContactEnd(displayObjectA, displayObjectB, contact);
  }

  void preSolve(Contact contact, Manifold oldManifold) {}

  void postSolve(Contact contact, ContactImpulse impulse) {}
}
