import 'package:flutter/material.dart';
import 'package:turnosapp/src/pages/bloc/login_bloc.dart';
export 'package:turnosapp/src/pages/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider? _instancia;

  factory Provider({
    /* Key key, Widget child */
    Key? key,
    required Widget child,
  }) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia!;
  }

  final loginBloc = LoginBloc();
  Provider._internal({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  /* static LoginBloc of(BuildContext context) {
    return (context.inheritedWidgetOfExactType(Provider) as Provider);
  } */
}
