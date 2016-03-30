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
part 'src/camera.dart';

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
