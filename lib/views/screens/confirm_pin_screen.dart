import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  final logger = Logger();
  String enteredPin = "";
  final int pinLength = 4;
  late String action;
  String? phone;
  String? code;
  String? firstPin;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    action = args['action'] ?? 'transaction';
    phone = args['phone'];
    code = args['code'];
    firstPin = args['firstPin'];
  }

  String get title {
    switch (action) {
      case 'confirmUpdate':
        return 'Confirmer le nouveau PIN';
      default:
        return 'Entrer votre PIN';
    }
  }

  void handleKeyTap(String value) {
    setState(() {
      if (value == 'delete') {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else if (value == 'validate') {
        if (enteredPin.length == pinLength) {
          logger.d("PIN entré: \$enteredPin");

          switch (action) {
            case 'confirmUpdate':
              if (firstPin == enteredPin) {
                Get.offAllNamed(
                  AppRoutes.successPage,
                  arguments: {
                    'message': 'PIN mis à jour avec succès',
                    'title': 'Succès',
                    'icon': Icons.check_circle_outline,
                    'nextRoute': AppRoutes.bottom,
                  },
                );
              } else {
                Get.snackbar(
                  'Erreur',
                  'Les deux codes PIN ne correspondent pas',
                );
                enteredPin = '';
              }
              break;
            default:
              logger.w("Action non reconnue: \$action");
          }
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

  Widget _buildKeypad() {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPinDisplay(),
          const SizedBox(height: 30),
          _buildKeypad(),
        ],
      ),
    );
  }
}
