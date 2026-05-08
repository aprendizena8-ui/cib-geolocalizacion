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
  double? distance;

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
    Node? node = await service.getNearestNode(pos);

    if (node != null) {
      double dist = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        node.lat,
        node.lon,
      );
      setState(() {
        nearestNode = node;
        distance = dist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: authProvider.isLocked
                    ? null
                    : () => authProvider.authenticate(),
                child: const Text(
                  "Escanear Huella",
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                authProvider.statusMessage,
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ShadowNet Terminal"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: nearestNode == null
            ? const TerminalWidget(
                message: "🌍 No hay nodos disponibles en tu zona",
              )
            : TerminalWidget(
                message: "📡 Nodo Detectado: ${nearestNode!.name}\n"
                    "Misión: ${nearestNode!.mission}\n"
                    "Distancia: ${distance?.toStringAsFixed(0)} metros",
                missionCompleted: true,
              ),
      ),
    );
  }
}