import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/node_service.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/terminal_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Node? nearestNode;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("GPS desactivado");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Permiso denegado");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Permisos bloqueados para siempre");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    NodeService service = NodeService();
    nearestNode = await service.getNearestNode(pos);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ElevatedButton(
            onPressed: authProvider.authenticate,
            child: const Text("Escanear Huella"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("ShadowNet Terminal")),
      body: Center(
        child: nearestNode == null
            ? const TerminalWidget(message: "🌍 No hay nodos disponibles")
            : TerminalWidget(message: "📡 Nodo Detectado: ${nearestNode!.name}"),
      ),
    );
  }
}
