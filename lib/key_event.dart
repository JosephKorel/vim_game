base class CursorEvent {
  const CursorEvent();
}

base class NavigationEvent extends CursorEvent {
  const NavigationEvent(this.stepsToMove);

  final int stepsToMove;

  bool get horizontal => false;
  bool get vertical => false;

  NavigationEvent withUpdatedSteps(int updatedSteps) => this;
}

final class GoLeftEvent extends NavigationEvent {
  const GoLeftEvent(super.stepsToMove);

  @override
  bool get horizontal => true;

  @override
  NavigationEvent withUpdatedSteps(int updatedSteps) =>
      GoLeftEvent(updatedSteps);
}

final class GoRightEvent extends NavigationEvent {
  const GoRightEvent(super.stepsToMove);

  @override
  bool get horizontal => true;

  @override
  NavigationEvent withUpdatedSteps(int updatedSteps) =>
      GoRightEvent(updatedSteps);
}

final class GoUpEvent extends NavigationEvent {
  const GoUpEvent(super.stepsToMove);

  @override
  bool get vertical => true;

  @override
  NavigationEvent withUpdatedSteps(int updatedSteps) => GoUpEvent(updatedSteps);
}

final class GoDownEvent extends NavigationEvent {
  const GoDownEvent(super.stepsToMove);

  @override
  bool get vertical => true;

  @override
  NavigationEvent withUpdatedSteps(int updatedSteps) =>
      GoDownEvent(updatedSteps);
}
