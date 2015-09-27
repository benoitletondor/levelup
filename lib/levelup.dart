library levelup;

import 'dart:math';
import 'dart:html';
import 'package:box2d/box2d.dart';
import 'package:box2d/box2d_browser.dart';

part 'src/RenderingManager.dart';
part 'src/GameStage.dart';
part 'src/StageContactListener.dart';
part 'src/KeyListener.dart';
part 'src/helper/MathHelper.dart';

part 'src/renderer/PhysicsItem.dart';
part 'src/renderer/Renderer.dart';
part 'src/renderer/Item.dart';

class LevelUp {
  static GameStage _mainStage;
  static KeyListener _keyListener;

  static void init(Renderer renderer, StageContactListener contactListener) {
    _mainStage = new GameStage(renderer, contactListener);
    _keyListener = new KeyListener();
  }

  static GameStage get mainStage => _mainStage;
  static KeyListener get keyListener => _keyListener;
}
