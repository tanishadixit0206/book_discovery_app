part of 'navigation_bloc.dart';

abstract class NavigationState {}

class NavigationInitialState extends NavigationState{}

class NavigateToDetailsState extends NavigationState{}

class NavigateBackState extends NavigationState{}