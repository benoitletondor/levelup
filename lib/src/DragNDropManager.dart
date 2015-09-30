part of levelup;

class DragNDropManager {
  Vector2 _mousePosition = new Vector2(0.0, 0.0);

  Set<PhysicsItem> _dragNDropablesItems = new Set<PhysicsItem>();

  List<PhysicsItem> _draggedItems = new List<PhysicsItem>();
  List<Vector2> _draggedItemsOffset = new List<Vector2>();

  DragNDropManager._internal() {
    document.onMouseDown.listen(_onMouseDown);
    document.onMouseUp.listen(_onMouseUp);
    document.onMouseMove.listen(_onMouseMove);
  }

// ---------------------------------------->

  void addDragNDropableItem(PhysicsItem item) {
    _dragNDropablesItems.add(item);
  }

  void removeDragNDropableItem(PhysicsItem item) {
    _dragNDropablesItems.remove(item);
  }

// ---------------------------------------->

  void _onMouseDown(MouseEvent event) {
    RenderingManager.scheduleRenderingAction(_renderLoop);

    _mousePosition.setValues(
        event.client.x.toDouble(), event.client.y.toDouble());

    if (!_dragNDropablesItems.isEmpty) {
      for (PhysicsItem item in _dragNDropablesItems) {
        Vector2 mousePosition =
            new Vector2(event.client.x.toDouble(), event.client.y.toDouble());

        if (item.body.getFixtureList().testPoint(mousePosition)) {
          _draggedItems.add(item);
          _draggedItemsOffset.add(new Vector2(
              item.position.x - _mousePosition.x,
              item.position.y - _mousePosition.y));
        }
      }
    }
  }

  void _onMouseUp(MouseEvent event) {
    _draggedItems.clear();
    _draggedItemsOffset.clear();
    RenderingManager.unscheduleRenderingAction(_renderLoop);
  }

  void _onMouseMove(MouseEvent event) {
    _mousePosition.setValues(
        event.client.x.toDouble(), event.client.y.toDouble());
  }

  void _renderLoop(num dt) {
    int i = 0;
    for (PhysicsItem item in _draggedItems) {
      item.body.setTransform(
          new Vector2.copy(_mousePosition).add(_draggedItemsOffset[i]),
          MathHelper.degreeToRadian(item.rotation).toDouble());
      i++;
    }
  }
}
