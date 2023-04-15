import 'dart:io';

import 'package:flutter/material.dart';

class OnWillBlokPop extends StatelessWidget {

  const OnWillBlokPop({required this.child, this.onWillPop = false, Key? key}) : super(key: key);

  final Widget child;
  final bool onWillPop;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          if(onWillPop){
            Navigator.of(context).pop();
          }
        }
      },
      child: WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: child,
      )
    )
    : WillPopScope(child: child, onWillPop: () async {
      return onWillPop;
    });
  }
}