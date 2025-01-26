import 'package:flutter/material.dart';
import 'package:management_mobile/controller/user_controller.dart';
import 'package:management_mobile/models/user.dart';

class UserProvider extends InheritedWidget {
  final Widget child;

  // List<User> users = [];

  UserProvider(
    {
      required this.child,
    }
  ) : super(child: child);

  static UserProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>();
  }
  
  bool updateShouldNotify(UserProvider widget) {
    return true;
  }
}