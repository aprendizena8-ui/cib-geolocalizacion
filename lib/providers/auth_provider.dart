import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> authenticate() async {
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
      }

      notifyListeners();
    } catch (e) {
      debugPrint("ERROR BIOMETRIA: $e");
    }
  }
}