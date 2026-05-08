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
  Position? _lastPosition;
  bool _checkingLocation = false;
  bool _locationChecked = false;

  Future<void> _checkLocation() async {
    if (_checkingLocation) return;
    _checkingLocation = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("GPS desactivado");
      setState(() {
        nearestNode = null;
        distance = null;
      });
      _checkingLocation = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Permiso denegado");
        _checkingLocation = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Permisos bloqueados para siempre");
      _checkingLocation = false;
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    _lastPosition = pos;

    NodeService service = NodeService();
    Node? node = await service.getNearestNodeInRange(pos, 500);

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
    } else {
      setState(() {
        nearestNode = null;
        distance = null;
      });
    }

    _locationChecked = true;
    _checkingLocation = false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isAuthenticated && !_locationChecked && !_checkingLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkLocation();
        }
      });
    }

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!authProvider.isLocked)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  onPressed: () => authProvider.authenticate(),
                  child: const Text(
                    "🔐 ESCANEAR HUELLA",
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: authProvider.isLocked ? Colors.red : Colors.greenAccent,
                    width: 2,
                  ),
                  color: authProvider.isLocked ? const Color.fromRGBO(255, 0, 0, 0.1) : Colors.transparent,
                ),
                child: Text(
                  authProvider.statusMessage.isEmpty
                      ? "Esperando autenticación..."
                      : authProvider.statusMessage,
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    color: authProvider.isLocked ? Colors.red : Colors.greenAccent,
                    fontSize: authProvider.isLocked ? 18 : 14,
                    fontWeight: authProvider.isLocked ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final allNodesDistances = _lastPosition != null
        ? NodeService().nodes.map((node) {
            return MapEntry(node, Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              node.lat,
              node.lon,
            ));
          }).toList()
        : <MapEntry<Node, double>>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ShadowNet Terminal"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: nearestNode == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TerminalWidget(
                    message: _locationChecked
                        ? "🌍 No hay nodos disponibles a menos de 500 metros"
                        : "⏳ Buscando nodos...",
                  ),
                  const SizedBox(height: 20),
                  if (_lastPosition != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tu ubicación: ${_lastPosition!.latitude.toStringAsFixed(6)}, ${_lastPosition!.longitude.toStringAsFixed(6)}",
                            style: const TextStyle(
                              fontFamily: 'RobotoMono',
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...allNodesDistances.map((entry) {
                            return Text(
                              "${entry.key.name}: ${entry.value.toStringAsFixed(0)} m",
                              style: const TextStyle(
                                fontFamily: 'RobotoMono',
                                color: Colors.greenAccent,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                ],
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
