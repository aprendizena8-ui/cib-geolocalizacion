import 'package:geolocator/geolocator.dart';

class Node {
  final String name;
  final String mission;
  final double lat;
  final double lon;

  Node(this.name, this.mission, this.lat, this.lon);
}

class NodeService {
  final List<Node> nodes = [
    Node("Nodo Alpha", "Hackear servidor de notas", 4.710, -74.230),
    Node("Nodo Beta", "Interceptar señal de radio", 4.711, -74.220),
    Node("Nodo Gamma", "Sabotaje de drones", 4.715, -74.225),
  ];
}
