part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  final int selectedIndex;
  const DashboardState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial() : super(selectedIndex: 0);
}

class PageChangedState extends DashboardState {
  const PageChangedState(int selectedIndex)
      : super(selectedIndex: selectedIndex);
}
