import 'package:flutter/material.dart';
import 'package:pdi_deme/constant/app_color.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String enteredPin = "";

  final int pinLength = 4;

  void handleKeyTap(String value) {
    setState(() {
      if (value == 'delete') {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else if (value == 'validate') {
        if (enteredPin.length == pinLength) {
          // TODO : vérifier ou envoyer le code PIN
          print("PIN validé: $enteredPin");
        }
      } else {
        if (enteredPin.length < pinLength) {
          enteredPin += value;
        }
      }
    });
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        return Container(
          margin: const EdgeInsets.all(8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                index < enteredPin.length
                    ? AppColors.primary
                    : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget _buildKey(String value, {IconData? icon}) {
    return GestureDetector(
      onTap: () => handleKeyTap(value),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Center(
          child:
              icon != null
                  ? Icon(icon, size: 28)
                  : Text(value, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrer le code PIN')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPinDisplay(),
              const SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildKey('delete', icon: Icons.backspace),
                      _buildKey('0'),
                      _buildKey('validate', icon: Icons.check_circle),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
