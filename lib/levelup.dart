library levelup;

import 'dart:math';
import 'dart:html';
import 'package:pixi2dart/pixi2dart.dart';
import 'package:box2d/box2d.dart';

part 'src/RenderingManager.dart';
part 'src/GameStage.dart';
part 'src/PhysicsObject.dart';
part 'src/StageContactListener.dart';
part 'src/helper/MathHelper.dart';

class LevelUp
{
    static GameStage _mainStage;
    
    static void initStage(num stageColor, num width, num height, StageContactListener contactListener)
    {
        _mainStage = new GameStage(new Stage(stageColor), new AutoDetectRenderer(width, height), contactListener);
    }
    
    static GameStage get mainStage => _mainStage;
}