/*
 *   Copyright 2016 Benoit LETONDOR
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

class Camera {
  /**
   * Position of camera (left coordinate)
   */
  int _xView;
  /**
   * Position of the camera (top coordinate)
   */
  int _yView;
  /**
   * Viewport width
   */
  int _wView;
  /**
   * Viewport height
   */
  int _hView;
  /**
   * Min distance to horizontal borders
   */
  int _xDeadZone = 0;
  /**
   * Min distance to vertical borders
   */
  int _yDeadZone = 0;
  /**
   * Allow camera to move in vertical and horizontal axis
   */
  CameraAxis _axis;
  /**
   * Object that should be followed
   */
  PhysicsItem _followed;
  /**
   * Rectangle that represents the viewport
   */
  math.MutableRectangle _viewportRect;
  /**
   * Rectangle that represents the world's boundary (room's boundary)
   */
  math.Rectangle _worldRect;

  Camera(int this._xView, int this._yView, int this._wView, int this._hView,
      int worldWidth, int worldHeight, CameraAxis this._axis) {
    _viewportRect = new math.MutableRectangle(_xView, _yView, _wView, _hView);
    _worldRect = new math.Rectangle(0, 0, worldWidth, worldHeight);
  }

  /**
   * Set the followed object and deadzones
   */
  follow(PhysicsItem gameObject, int xDeadZone, int yDeadZone) {
    _followed = gameObject;
    _xDeadZone = xDeadZone;
    _yDeadZone = yDeadZone;
  }

  /**
   * Keep following the player (or other desired object)
   */
  update() {
    if (_followed != null) {
      int posX = _followed.position.x.toInt();
      int posY = _followed.position.y.toInt();

      if (_axis == CameraAxis.HORIZONTAL || _axis == CameraAxis.BOTH) {
        // moves camera on horizontal axis based on followed object position
        if (posX - _xView + _xDeadZone > _wView) {
          _xView = posX - (_wView - _xDeadZone);
        } else if (posX - _xDeadZone < _xView) {
          _xView = posX - _xDeadZone;
        }
      }

      if (_axis == CameraAxis.VERTICAL || _axis == CameraAxis.BOTH) {
        // moves camera on vertical axis based on followed object position
        if (posY - _yView + _yDeadZone > _hView) {
          _yView = posY - (_hView - _yDeadZone);
        } else if (posY - _yDeadZone < _yView) {
          _yView = posY - _yDeadZone;
        }
      }
    }

    // update viewportRect
    _viewportRect.left = _xView;
    _viewportRect.top = _yView;

    // don't let camera leaves the world's boundary
    if (!_worldRect.containsRectangle(_viewportRect)) {
      if (_viewportRect.left < _worldRect.left) {
        _xView = _worldRect.left;
      }
      if (_viewportRect.top < _worldRect.top) {
        _yView = _worldRect.top;
      }
      if (_viewportRect.right > _worldRect.right) {
        _xView = _worldRect.right - _wView;
      }
      if (_viewportRect.bottom > _worldRect.bottom) {
        _yView = _worldRect.bottom - _hView;
      }
    }
  }
}

/**
 * Possibles axis to move the camera
 */
enum CameraAxis { NONE, HORIZONTAL, VERTICAL, BOTH }
