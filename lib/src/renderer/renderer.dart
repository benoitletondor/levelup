part of levelup;

abstract class Renderer {
  html.CanvasElement get view;

  void render();

  void addChild(Item child);

  void removeChild(Item child);
}
