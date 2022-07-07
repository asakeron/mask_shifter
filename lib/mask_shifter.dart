library mask_shifter;

import 'package:flutter/services.dart';

class MaskedTextInputFormatterShifter extends TextInputFormatter {
  String maskONE;
  String maskTWO;

  MaskedTextInputFormatterShifter(
      {required this.maskONE, required this.maskTWO});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > maskTWO.length) return oldValue;

        if (newValue.text.length <= maskONE.length &&
            (maskONE[newValue.text.length - 1] != "X") &&
            newValue.text.length != oldValue.text.length) {
          if (maskONE[newValue.text.length - 1] != "X") {
            return TextEditingValue(
              text:
                  '${oldValue.text}${maskONE[newValue.text.length - 1]}${newValue.text.substring(newValue.text.length - 1)}',
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ),
            );
          }
        } else if (newValue.text.length > maskONE.length) {
          String two = "";

          if (oldValue.text.length == maskONE.length) {
            for (var rune in newValue.text.runes) {
              var character = String.fromCharCode(rune);
              if (character != "." && character != "-" && character != "/") {
                two = two + character;
                if (maskTWO[two.length] != "X") {
                  two = '$two${maskTWO[two.length]}';
                }
              }
            }

            return TextEditingValue(
              text: two,
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ),
            );
          }
        }
      } else if (oldValue.text.length > newValue.text.length) {
        if (oldValue.text.length == (maskONE.length + 1)) {
          String one = "";
          for (var rune in newValue.text.runes) {
            var character = String.fromCharCode(rune);
            if (character != "." && character != "-" && character != "/") {
              one = one + character;
              if (maskONE[one.length] != "X") {
                one = '$one${maskONE[one.length]}';
              }
            }
          }
          return TextEditingValue(
            text: one,
            selection: TextSelection.collapsed(
              offset: newValue.selection.end,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
