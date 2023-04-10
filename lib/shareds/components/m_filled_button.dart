import 'package:flutter/material.dart';

class MfilledButton extends StatelessWidget {
  const MfilledButton({Key? key, 
  required this.onPressed,
   required this.text}):super(key: key);
  final void Function()? onPressed;
  final Widget text;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){

    }, child: text);
  }
}