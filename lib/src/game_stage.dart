/*
 *   Copyright 2015 Benoit LETONDOR
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

part of levelup;

class GameStage implements ContactListener {
  Renderer _renderer;
  World _world;
  StageContactListener _contactListener;
  html.CanvasRenderingContext2D _debugCtx;
  DragNDropManager _dragNDropManager;
  Camera _camera;

  bool _paused = false;

  Set<PhysicsItem> _physicsObjects = new Set<PhysicsItem>();

// ------------------------------------------->

  GameStage(Renderer this._renderer, StageContactListener this._contactListener,
      Camera this._camera) {
    assert(_renderer != null);
    assert(_camera != null);

    // Create Box2d world
    _world = new World.withPool(
        new Vector2(0.0, 0.0), new DefaultWorldPool(100, 10)); //TODO values?

    // Add contact listener if any
    if (_contactListener != null) {
      _world.setContactListener(this);
    }

    // Main rendering loop
    RenderingManager.scheduleRenderingAction(_renderLoop);
  }

  void destroy() {
    RenderingManager.unscheduleRenderingAction(_renderLoop);
    _paused = true;

    stopDebug();
    _world.setContactListener(null);
    for (PhysicsItem item in _physicsObjects) {
      _world.destroyBody(item.body);
    }

    if( _dragNDropManager != null ) {
      _dragNDropManager._destroy();
    }
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
// Add-remove elements

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
      ..angle = object.rotation.toDouble();

    return _world.createBody(def)
      ..createFixtureFromFixtureDef(object.buildFixtureDef()..userData = object)
      ..userData = object; //FIXME circular reference are probably bad
  }

  void removeChild(Item displayObject) {
    assert(displayObject != null);

    if (displayObject is PhysicsItem) {
      PhysicsItem object = displayObject as PhysicsItem;

      if (object.body.getFixtureList() != null) {
        // Can happen in pause mode
        object.body.getFixtureList().userData = null;
      }

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
// Box2D querying

  List<PhysicsItem> getItemsInZone(math.Rectangle zone) {
    _QueryCallbackImpl queryCallback = new _QueryCallbackImpl();

    Vector2 lowerVector =
        new Vector2(zone.left.toDouble(), zone.bottom.toDouble());

    Vector2 upperVector =
        new Vector2(zone.left.toDouble(), zone.top.toDouble());

    _world.queryAABB(
        queryCallback, new AABB.withVec2(lowerVector, upperVector));

    return queryCallback.foundItems;
  }

  Contact getContactBetweenItems(PhysicsItem item1, PhysicsItem item2) {
    for (ContactEdge ce = item1.body.getContactList(); ce != null; ce = ce.next) {
      if (ce.other.userData == item2) {
        return ce.contact;
      }
    }

    return null;
  }

// ------------------------------------------->
// Camera

  void setCameraFocus(PhysicsItem focused, int xDeadZone, int yDeadZone) {
    _camera.follow(focused, xDeadZone, yDeadZone);
  }

  int get cameraX => _camera._xView;

  int get cameraY => _camera._yView;

// ------------------------------------------->
// Render loop

  void _renderLoop(num dt) {
    _world.stepDt(1 / 60, 10, 10); //TODO dynamic values

    _updateCamera();

    for (PhysicsItem object in _physicsObjects) {
      if (!_paused) {
        // Can happen when UI thread finishes after pause
        object.position = new math.Point(
            object.body.worldCenter.x - _camera._xView,
            object.body.worldCenter.y - _camera._yView);
        object.rotation = object.body.getAngle();
      }
    }

    _renderer.render();
  }

  void _updateCamera() {
    if (_camera._followed != null &&
        _camera._followed.body != null &&
        !_paused) {
      _camera.update();
    }
  }

// ------------------------------------------->
// Pause/Resume

  void pause() {
    if (_paused) {
      return;
    }

    _paused = true;
    RenderingManager.unscheduleRenderingAction(_renderLoop);

    for (PhysicsItem object in _physicsObjects) {
      object._paused = true;
    }

    if (_dragNDropManager != null) {
      // Stop drag & drops if any
      _dragNDropManager._onDragStop();
    }
  }

  void resume() {
    if (!_paused) {
      return;
    }

    for (PhysicsItem object in _physicsObjects) {
      object._paused = false;
    }

    _paused = false;
    RenderingManager.scheduleRenderingAction(_renderLoop);
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
