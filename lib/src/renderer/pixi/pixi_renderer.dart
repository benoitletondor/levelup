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

class PixiRenderer implements Renderer {
  PIXI.Container _container = new PIXI.Container.empty();
  PIXI.SystemRenderer _renderer;

  PixiRenderer(PIXI.SystemRenderer this._renderer) {
    assert(this._renderer != null);
  }

  @override
  void addChild(PixiItem child) => _container.addChild(child._displayObject);

  @override
  void removeChild(PixiItem child) =>
      _container.removeChild(child._displayObject);

  @override
  html.CanvasElement get view => _renderer.view;

  @override
  void render() => _renderer.render(_container);
}
