import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:fluttertestapp/multi_select.dart';

void main() => runApp(MyApp());

abstract class MyAppEvent {}

class MyAppMultiSelectChangeEvent extends MyAppEvent {
  final List<bool> selected;

  MyAppMultiSelectChangeEvent({
    @required this.selected,
  });
}

class MyAppState {
  final List<bool> selected;

  MyAppState({
    @required this.selected,
  });
}

class MyAppBloc extends Bloc<MyAppEvent, MyAppState> {
  final List<bool> selectedInitialState = [false, false];

  @override
  MyAppState get initialState => MyAppState(selected: selectedInitialState);

  @override
  Stream<MyAppState> mapEventToState(MyAppEvent event) async* {
    if (event is MyAppMultiSelectChangeEvent) {
      yield MyAppState(
        selected: event.selected,
      );
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('App'),
        ),
        body: BlocProvider(
          create: (BuildContext context) => MyAppBloc(),
          child: BlocBuilder<MyAppBloc, MyAppState>(
              builder: (BuildContext context, MyAppState state) {
            return MultiSelect(
              options: [
                MultiSelectOption(
                  title: 'Option A',
                  index: 0,
                  isSelected: state.selected[0],
                ),
              ],
              onChange: (List<bool> selected) {
                BlocProvider.of<MyAppBloc>(context).add(MyAppMultiSelectChangeEvent(selected: selected));
              },
            );
          }),
        ),
      ),
    );
  }
}
