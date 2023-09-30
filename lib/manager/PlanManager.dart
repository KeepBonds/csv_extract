class PlanManager {
  static PlanManager? _manager;

  bool _isFree = true;
  static bool get isFree => getState()._isFree;

  PlanManager._internal() {
    _isFree = true;
  }

  static PlanManager getState() {
    return _manager ??= PlanManager._internal();
  }
}