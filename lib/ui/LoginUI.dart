import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dummygram/models/User.dart';
import 'package:dummygram/ui/ProfileUI.dart';
import 'dart:math' as math;
class LoginUI extends StatefulWidget{
  @override
  _LoginUI createState()=>_LoginUI();

}
class _LoginUI extends State<LoginUI>{
  UserInf user = new UserInf();
  /*int gender;
  bool validateString(String input) {
    if(input==null) return false;
    if(input.length==0) return false;
    String output = input.replaceAll(" ", "");
    if(output == "") {
      return false;
    }
    return true;
  }*/
  @override
  Widget build(BuildContext context) {

  }
}
/*
class MaxLinesTextInputFormatter extends TextInputFormatter {
  MaxLinesTextInputFormatter(this.maxLines)
      : assert(maxLines == null || maxLines == -1 || maxLines > 0);

  final int maxLines;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    if (maxLines != null && maxLines > 0) {
      final regEx = RegExp("^.*((\n?.*){0,${maxLines - 1}})");
      String newString = regEx.stringMatch(newValue.text) ?? "";

      final maxLength = newString.length;
      if (newValue.text.runes.length > maxLength) {
        final TextSelection newSelection = newValue.selection.copyWith(
          baseOffset: math.min(newValue.selection.start, maxLength),
          extentOffset: math.min(newValue.selection.end, maxLength),
        );
        final RuneIterator iterator = RuneIterator(newValue.text);
        if (iterator.moveNext())
          for (int count = 0; count < maxLength; ++count)
            if (!iterator.moveNext()) break;
        final String truncated = newValue.text.substring(0, iterator.rawIndex);
        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
      return newValue;
    }
    return newValue;
  }
}*/
