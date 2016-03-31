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

class PixiPhysicsItem<T extends PIXI.DisplayObject> extends PixiItem<T>
    implements PhysicsItem {
  bool _paused = false;

  PixiPhysicsItem(T displayObject) : super(displayObject) {
    assert(displayObject is PhysicsItem);
  }

  PhysicsItem get _physicsObject => (_displayObject as PhysicsItem);

  Body get body {
    if (_paused) {
      // Return stub body while paused to avoid transforming it
      return new Body(new BodyDef(), null);
    }

    return _physicsObject.body;
  }

  set body(Body body) {
    if (_paused) {
      return;
    }

    _physicsObject.body = body;
  }

  FixtureDef buildFixtureDef() => _physicsObject.buildFixtureDef();

  BodyDef get bodyDef => _physicsObject.bodyDef;

  bool operator ==(other) {
    if (other is PIXI.DisplayObject) {
      return _displayObject == other;
    }

    return identical(this, other);
  }
}
