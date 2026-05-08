import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vibration/vibration.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticated = false;
  int _failedAttempts = 0;
  bool _isLocked = false;
  String _statusMessage = "";

  bool get isAuthenticated => _isAuthenticated;
  bool get isLocked => _isLocked;
  String get statusMessage => _statusMessage;

  Future<void> authenticate() async {
    if (_isLocked) return;

    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        debugPrint("Biometría no disponible");
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Escanea tu huella para acceder a ShadowNet',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        _isAuthenticated = true;
        _failedAttempts = 0;
        _statusMessage = "";
      } else {
        _failedAttempts++;

        if (_failedAttempts >= 3) {
          await _triggerSelfDestruct();
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint("ERROR BIOMETRIA: $e");
    }
  }

  Future<void> _triggerSelfDestruct() async {
    _isAuthenticated = false;
    _isLocked = true;

    _statusMessage =
        "⚠️ Protocolo de Autodestrucción Iniciado\nBloqueado 5 segundos";

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 5000, amplitude: 255);
    }

    notifyListeners();

    await Future.delayed(const Duration(seconds: 5));

    _failedAttempts = 0;
    _isLocked = false;
    _statusMessage = "✅ Puedes intentar nuevamente";

    notifyListeners();
  }
}