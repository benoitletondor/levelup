part of levelup;

class DragNDropManager {
  Vector2 _mousePosition = new Vector2(0.0, 0.0);

  Set<PhysicsItem> _dragNDropablesItems = new Set<PhysicsItem>();

  List<PhysicsItem> _draggedItems = new List<PhysicsItem>();
  List<Vector2> _draggedItemsOffset = new List<Vector2>();

  DragNDropManager._internal() {
    if (html.TouchEvent.supported) {
      html.document.onTouchEnd.listen(_onTouchEnd);
      html.document.onTouchStart.listen(_onTouchStart);
      html.document.onTouchMove.listen(_onTouchMove);
    } else {
      html.document.onMouseDown.listen(_onMouseDown);
      html.document.onMouseMove.listen(_onMouseMove);
      html.document.onMouseUp.listen(_onMouseUp);
    }
  }

// ---------------------------------------->

  void addDragNDropableItem(PhysicsItem item) {
    _dragNDropablesItems.add(item);
  }

  void removeDragNDropableItem(PhysicsItem item) {
    _dragNDropablesItems.remove(item);
  }

// ---------------------------------------->

  void _onStartDrag() {
    RenderingManager.scheduleRenderingAction(_renderLoop);

    if (!_dragNDropablesItems.isEmpty) {
      for (PhysicsItem item in _dragNDropablesItems) {
        if (item.body.getFixtureList().testPoint(_mousePosition)) {
          _draggedItems.add(item);
          _draggedItemsOffset.add(new Vector2(
              item.position.x - _mousePosition.x,
              item.position.y - _mousePosition.y));
        }
      }
    }
  }

  void _onDragStop() {
    _draggedItems.clear();
    _draggedItemsOffset.clear();
    RenderingManager.unscheduleRenderingAction(_renderLoop);
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

// ---------------------------------------->

  void _onMouseDown(html.MouseEvent event) {
    _mousePosition.setValues(
        event.client.x.toDouble(), event.client.y.toDouble());

    _onStartDrag();
  }

  void _onTouchStart(html.TouchEvent event) {
    event.preventDefault();

    _mousePosition.setValues(event.touches.first.client.x.toDouble(),
        event.touches.first.client.y.toDouble());

    _onStartDrag();
  }

  void _onMouseUp(html.MouseEvent event) {
    _onDragStop();
  }

  void _onTouchEnd(html.TouchEvent event) {
    _onDragStop();
  }

  void _onMouseMove(html.MouseEvent event) {
    _mousePosition.setValues(
        event.client.x.toDouble(), event.client.y.toDouble());
  }

  void _onTouchMove(html.TouchEvent event) {
    event.preventDefault();

    _mousePosition.setValues(event.touches.first.client.x.toDouble(),
        event.touches.first.client.y.toDouble());
  }
}