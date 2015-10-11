# 2D Dart game framework

This is an early work in progress to build a custom and light 2D game framework using Dart. This is built for my personal usage, so it's probably not suitable for all cases.

### Idea

I wanted to make a game framework for a long time after participating to some LudumDare hackatons using other frameworks made by great people. And since I also wanted to check what Dart could offer as a programming language I decided to create Level Up.

This is a 2D game framework that offers simple APIs and includes [Box2d](http://box2d.org/) as a physics engine and [Pixi.js](http://www.pixijs.com/) (using [my own Dart port](https://github.com/benoitletondor/pixi2dart)) as a WebGL/Canvas renderer.

### Work in progress

I created this for my own needs and it's far from final. Current APIs includes:

- Stage as a container for all your display objects
- A rendering manager offering easy access to animation frames
- Box2D wrapper for display object to easily implement physics
- Pixi renderer
- Drag&Drop API for both mouse and touch

### How to use

Here's how to use Level Up:

- Clone this repo (A pub package isn't available yet)
- Clone [pixi2dart](https://github.com/benoitletondor/pixi2dart) repo into the same folder (a pub package isn't available yet)
- Add dependency to your _pubspec.yaml_:

```yaml
dependencies:
  levelup:
    version: any
    path: ../levelup/
```

- Import the library and dependencies:

```dart
import 'package:levelup/levelup.dart' as LevelUp;
import 'package:pixi2dart/pixi2dart.dart' as PIXI;
import 'package:box2d/box2d.dart';
import 'package:box2d/box2d_browser.dart';
```

- Import the Pixi.js file into your html:

```html
<script src="packages/pixi2dart/js/pixi.js"></script>
```

That's it, you're ready to use LevelUp APIs to build your game.

### Sample

```dart
void main() {
  // Init stage
  LevelUp.GameStage stage = new LevelUp.GameStage(new LevelUp.PixiRenderer(PIXI.autoDetectRenderer(600, 400)), new _ContactListener())
    ..gravity = new Vector2(0.0, 500.0);

  document.body.append(stage.view);

  // Activate Box2D debug if you need
  CanvasElement canvas = (new Element.tag('canvas') as CanvasElement)
    ..width = 600
    ..height = 400;

  document.body.append.append(canvas);
  stage.debugInCanvas(canvas);

  // Create physics wrapper for your display objects classes (those are physics enabled items, you can use _LevelUp.PixiItem_ if you don't want physics)
  // Note that you can still access directly your class: Bunny bunnySprite = bunny.item
  LevelUp.PixiPhysicsItem bunny = new LevelUp.PixiPhysicsItem(new Bunny()); 
  LevelUp.PixiPhysicsItem ground = new LevelUp.PixiPhysicsItem(new Ground());

  // Set their position on the stage
  bunny.position = new PIXI.Point.fromValues(100, 200);
  ground.position = new PIXI.Point.fromValues(0, 375);

  // Add them to display
  stage.addChild(ground);
  stage.addChild(bunny);

  // If you want to make an item draggable, just use the drag&drop manager
  stage.dragNDropManager.addDragNDropableItem(bunny);
}

class Ground extends PIXI.Graphics implements LevelUp.PhysicsItem {
  bool paused;
  Body body;

  Ground() : super() {
    beginFill(0xFF00FF);
    drawRect(0, 0, 400, 25);
  }

  FixtureDef buildFixtureDef() {
    PolygonShape shape = new PolygonShape()
      ..setAsBox(200.0, 12.5, new Vector2(200.0, 12.5), 0.0);

    return new FixtureDef()
      ..shape = shape
      ..density = 0.0
      ..restitution = 0.0
      ..friction = 0.0;
  }

  BodyDef get bodyDef => new BodyDef()..type = BodyType.KINEMATIC;
}

class Bunny extends PIXI.Sprite implements LevelUp.PhysicsItem {
  bool paused;
  Body body;

  Bunny() : super(new PIXI.Texture.fromImage("bunny.gif"));

  FixtureDef buildFixtureDef() {
    PolygonShape shape = new PolygonShape()
      ..setAsBox(25.0, 25.0, new Vector2(25.0, 25.0), 0.0);

    return new FixtureDef()
      ..shape = shape
      ..friction = 0.2
      ..density = 0.5
      ..restitution = 0.2;
  }

  BodyDef get bodyDef => new BodyDef()
    ..type = BodyType.DYNAMIC
    ..allowSleep = false;
}

class _ContactListener implements LevelUp.StageContactListener {
  void onContactBegin(LevelUp.Item spriteA, LevelUp.Item spriteB, Contact contact) {
  	// Manage box2d contacts here
  }

  void onContactEnd(LevelUp.Item spriteA, LevelUp.Item spriteB, Contact contact) {
  	// Manage box2d contacts here
  }
}

```

### Licence

    Copyright (C) 2015 Benoit LETONDOR

    This program is under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
