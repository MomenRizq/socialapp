import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  const customButton({ this.title, this.onTap , this.color}) ;

  final String? title ;
  final VoidCallback ? onTap;
  final Color ? color ;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(Size(50, 50)),
        backgroundColor: MaterialStateProperty.all(color),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed:onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            40, 10, 40, 10),
        child: Text(title!.toUpperCase(),
          style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white),),
      ),
    );
  }
}
