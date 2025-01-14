part of 'navigation_bloc.dart';

abstract class NavigationEvent {}

class NavigateToDetailsEvent extends NavigationEvent{}

class NavigateBackEvent extends NavigationEvent{}