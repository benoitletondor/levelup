library levelup;

import 'dart:math' as math;
import 'dart:html' as html;

import 'package:box2d/box2d.dart';
import 'package:box2d/box2d_browser.dart';
import 'package:Pixi2dart/pixi2dart.dart' as PIXI;

part 'src/RenderingManager.dart';
part 'src/GameStage.dart';
part 'src/StageContactListener.dart';
part 'src/KeyListener.dart';
part 'src/helper/MathHelper.dart';
part 'src/DragNDropManager.dart';

part 'src/renderer/PhysicsItem.dart';
part 'src/renderer/Renderer.dart';
part 'src/renderer/Item.dart';
part 'src/renderer/pixi/PixiItem.dart';
part 'src/renderer/pixi/PixiPhysicsItem.dart';
part 'src/renderer/pixi/PixiRenderer.dart';

// Expose keylistener singleton
KeyListener _keyListener;
KeyListener get keyListener {
  if (_keyListener == null) {
    _keyListener = new KeyListener._internal();
  }

  return _keyListener;
}
