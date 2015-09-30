part of levelup;

typedef void RenderingAction(num);

class RenderingManager {
  static Set<RenderingAction> _actions = new Set<RenderingAction>();

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

    _actions.remove(action);
  }

// ------------------------------------------------>

  static void _loop(num dt) {
    if (!_actions.isEmpty) {
      html.window.animationFrame.then(_loop);
    }

    _actions.forEach((action) {
      action(dt);
    });
  }
}
