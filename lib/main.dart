import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'keyboard_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FloatingDraggableKeyboardScreen(),
    );
  }
}

class FloatingDraggableKeyboardScreen extends StatelessWidget {
  final KeyboardController keyboardController = Get.put(KeyboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Floating Keyboard'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => TextField(
                        controller: TextEditingController(
                          text: keyboardController.inputText.value,
                        ),
                        onChanged: (text) =>
                            keyboardController.inputText.value = text,
                        decoration: const InputDecoration(
                          labelText: 'Enter text',
                        ),
                        readOnly: true,
                        // Disable system keyboard
                        onTap: () => keyboardController
                            .toggleKeyboard(), // Show keyboard when field is tapped
                      )),
                ),
              ),
            ],
          ),
          // Draggable Floating Keyboard Overlay
          Obx(() => keyboardController.isKeyboardVisible.value
              ? Positioned(
                  top: keyboardController.dy.value,
                  left: keyboardController.dx.value,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      keyboardController.updatePosition(details.delta);
                    },
                    child: _buildKeyboard(),
                  ),
                )
              : Container()),
        ],
      ),
    );
  }

  // Method to build the keyboard (number/alphabet 123 remains the same)
  Widget _buildKeyboard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => !keyboardController.isNumberMode.value
              ? _buildNumberPad() // Show number pad
              : _buildAlphabetPad()), // Show alphabetic keyboard
          !keyboardController.isNumberMode.value
              ? _buildRow(['123', 'Enter'])
              : Container(),
        ],
      ),
    );
  }

  // Method to build the number pad
  Widget _buildNumberPad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['.', '0', 'Backspace']),
      ],
    );
  }

  // Method to build the alphabetic keyboard
  Widget _buildAlphabetPad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
        _buildRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
        _buildRow(['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Backspace']),
        _buildRow(["@", ".", 'Space', '123', 'Enter']),
      ],
    );
  }

  // Method to build a row of keys
  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keys.map((key) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: _buildKey(key),
          );
        }).toList(),
      ),
    );
  }

  // Method to build individual keys
  Widget _buildKey(String keyLabel) {
    return GestureDetector(
      onTap: () {
        if (keyLabel == '123') {
          keyboardController
              .toggleMode(); // 123 between number and alphabet mode
        } else {
          keyboardController.onKeyTap(keyLabel); // Handle key press
        }
      },
      child: Container(
        width: keyLabel == 'Space' ? 200 : (keyLabel == 'Enter' ? 100 : 60),
        // Adjust size for special keys
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: keyLabel == 'Backspace'
              ? const Icon(Icons.backspace, color: Colors.black)
              : Text(
                  keyLabel,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
        ),
      ),
    );
  }
}
