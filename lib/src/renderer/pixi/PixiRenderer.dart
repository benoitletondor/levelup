part of levelup;

class PixiRenderer implements Renderer {
  PIXI.Container _container = new PIXI.Container.empty();
  PIXI.SystemRenderer _renderer;

  PixiRenderer(PIXI.SystemRenderer this._renderer) {
    assert(this._renderer != null);
  }

  void addChild(PixiItem child) => _container.addChild(child._displayObject);

  void removeChild(PixiItem child) =>
      _container.removeChild(child._displayObject);

  CanvasElement get view => _renderer.view;

  void render() => _renderer.render(_container);
}
