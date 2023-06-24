import 'package:flutter/material.dart';

class customFormTextField extends StatelessWidget {
  const customFormTextField( {required this.lableText, this.hintText,this.obscureText = false , required this.onchanged  ,required this.emptyText}) ;

  final String? lableText ;
  final String? hintText ;
  final String? emptyText ;
  final bool ? obscureText ;
  final Function(String) ? onchanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onchanged,
      obscureText: obscureText!,
      validator: (value) {
        if (value!.isEmpty) {
          return "$emptyText";
        }
      },
      decoration: InputDecoration(
        labelText: lableText,
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0), borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0), borderSide: BorderSide(color: Colors.grey.shade400)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
      ),
    );
  }
}
