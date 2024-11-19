import 'package:equatable/equatable.dart';

enum NavItem {
  homeView,
  courseView,
  emailView,
  documentView,
  document
}

class NavDrawerState extends Equatable {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);

  @override
  List<Object?> get props => [
    selectedItem,
  ];
}