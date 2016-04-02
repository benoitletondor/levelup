part of levelup;

class _QueryCallbackImpl extends QueryCallback {
  List<PhysicsItem> _foundItems = new List();

  @override
  bool reportFixture(Fixture fixture) {
    if (fixture.getBody().userData is PhysicsItem) {
      _foundItems.add(fixture.getBody().userData);
    }

    return true;
  }

  List<PhysicsItem> get foundItems => _foundItems;
}
