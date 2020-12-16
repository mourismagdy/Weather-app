
import'package:weather_app/events.dart';
import 'package:bloc/bloc.dart';

class ChangeBloc extends Bloc<Event,DateTime>{
  ChangeBloc(DateTime initialState) : super(initialState);


  @override
  Stream<DateTime> mapEventToState(Event event) async*{
    switch (event){
      case Event.change:
        yield DateTime.now();
        break;
    }


  }



}
