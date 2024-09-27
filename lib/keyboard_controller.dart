import 'dart:ui';

import 'package:get/get.dart';

class KeyboardController extends GetxController {
  var isKeyboardVisible = false.obs;

  var inputText = ''.obs;

  var isNumberMode = true.obs;

  var dx = 0.0.obs;
  var dy = 400.0.obs;

  void onKeyTap(String keyLabel) {
    if (keyLabel == 'Backspace') {
      if (inputText.isNotEmpty) {
        inputText.value = inputText.substring(0, inputText.value.length - 1);
      }
    } else if (keyLabel == 'Enter') {
      toggleKeyboard();
    } else if (keyLabel != 'Space') {
      inputText.value += keyLabel;
    } else {
      inputText.value += ' ';
    }
  }

  void toggleKeyboard() {
    isKeyboardVisible.value = !isKeyboardVisible.value;
  }

  void toggleMode() {
    isNumberMode.value = !isNumberMode.value;
  }

  void updatePosition(Offset offset) {
    dx.value += offset.dx;
    dy.value += offset.dy;
  }
}
