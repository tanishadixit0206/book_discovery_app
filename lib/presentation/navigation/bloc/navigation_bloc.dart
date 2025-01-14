import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent,NavigationState>{
  NavigationBloc():super(NavigationInitialState()){
    on<NavigateToDetailsEvent>(_onNavigateToDetails);
    on<NavigateBackEvent>(_onNavigateBack);
  }

  void _onNavigateToDetails(event,emit){
    emit(NavigateToDetailsState());
  }

  void _onNavigateBack(event,emit){
    emit(NavigateBackState());
  }
}