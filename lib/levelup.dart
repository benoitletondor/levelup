library levelup;

import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:async';
import 'dart:collection';

import 'package:box2d/box2d.dart';
import 'package:box2d/box2d_browser.dart';
import 'package:pixi2dart/pixi2dart.dart' as PIXI;

part 'src/rendering_manager.dart';
part 'src/game_stage.dart';
part 'src/stage_contact_listener.dart';
part 'src/key_listener.dart';
part 'src/helper/math_helper.dart';
part 'src/drag_n_drop_manager.dart';

part 'src/renderer/physics_item.dart';
part 'src/renderer/renderer.dart';
part 'src/renderer/item.dart';
part 'src/renderer/pixi/pixi_item.dart';
part 'src/renderer/pixi/pixi_physics_item.dart';
part 'src/renderer/pixi/pixi_renderer.dart';

// Expose keylistener singleton
KeyListener _keyListener;
KeyListener get keyListener {
  if (_keyListener == null) {
    _keyListener = new KeyListener._internal();
  }

  return _keyListener;
}
