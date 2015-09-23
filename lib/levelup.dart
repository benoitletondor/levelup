library levelup;

import 'dart:math';
import 'dart:html';
import 'package:Pixi2dart/pixi2dart.dart';
import 'package:box2d/box2d.dart';
import 'package:box2d/box2d_browser.dart';

part 'src/RenderingManager.dart';
part 'src/GameStage.dart';
part 'src/PhysicsObject.dart';
part 'src/StageContactListener.dart';
part 'src/KeyListener.dart';
part 'src/helper/MathHelper.dart';

class LevelUp
{
    static GameStage _mainStage;
    static KeyListener _keyListener;
    
    static void init(num width, num height, StageContactListener contactListener)
    {
        _mainStage = new GameStage(new Container(), new AutoDetectRenderer(width, height), contactListener);
        _keyListener = new KeyListener();
    }
    
    static GameStage get mainStage => _mainStage;
    static KeyListener get keyListener => _keyListener;
}