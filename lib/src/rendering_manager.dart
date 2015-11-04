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

typedef void RenderingAction(num);

class RenderingManager {
  static Set<RenderingAction> _actions = new Set<RenderingAction>();

  // Use a queue for items to remove to prevent thread collision, removing them into the render loop
  static ListQueue<RenderingAction> _actionsToRemove =
      new ListQueue<RenderingAction>();

// ------------------------------------------->

  static void scheduleRenderingAction(RenderingAction action) {
    assert(action != null);

    _actions.add(action);

    // If they were no actions before, start scheduling
    if (_actions.length == 1) {
      html.window.animationFrame.then(_loop);
    }
  }

  static void unscheduleRenderingAction(RenderingAction action) {
    assert(action != null);

    _actionsToRemove.add(action);
  }

// ------------------------------------------------>

  static void _loop(num dt) {
    if (!_actions.isEmpty) {
      html.window.animationFrame.then(_loop);
    }

    _actions.forEach((action) {
      action(dt);
    });

    if (!_actionsToRemove.isEmpty) {
      RenderingAction action = _actionsToRemove.removeFirst();
      _actions.remove(action);
    }
  }
}
