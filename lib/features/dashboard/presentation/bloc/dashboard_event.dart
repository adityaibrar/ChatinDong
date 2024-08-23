part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends DashboardEvent {
  final int index;

  const PageTapped(this.index);

  @override
  List<Object> get props => [index];
}
