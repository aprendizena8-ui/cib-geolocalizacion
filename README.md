# geolocalizacion

A new Flutter project.

## Getting Started
# 🛰️ ShadowNet: Protocolo de Infiltración Georeferenciada

> *CLASIFICACIÓN:* ULTRA SECRETO  
> *AÑO:* 2084  
> *OPERADORES:* Santiago - Emyl - Laura  

---

# 📖 Reporte de la Resistencia

La IA central conocida como *The Core* ha tomado el control absoluto de las comunicaciones globales.  
Las ciudades permanecen vigiladas y cualquier intento de conexión clandestina es eliminado inmediatamente.

Los Operadores de la resistencia han desarrollado una red secreta llamada *ShadowNet*, capaz de funcionar fuera del alcance de The Core.

Para acceder al sistema es obligatorio:

- ✅ Validar identidad humana mediante biometría.
- 🌍 Confirmar ubicación segura dentro de Mosquera.
- 💻 Completar misiones secretas desde una terminal hacker.

---

# 🎯 Objetivos Técnicos

---

# 🔐 Fase 1 — Blindaje de Acceso

Implementación de autenticación biométrica usando:

- local_auth
- Huella digital
- Bloqueo de acceso hasta autenticar

## ⚠️ Protocolo de Autodestrucción

Si el Operador falla 3 veces:

- ⛔ El sistema se bloquea durante 5 segundos.
- 📳 El dispositivo vibra intensamente.
- 🚨 Se activa el mensaje:

txt
⚠️ Protocolo de Autodestrucción Iniciado


---

# 📡 Fase 2 — Geo-Radar de Nodos

Implementación de geolocalización usando:

- geolocator
- GPS en tiempo real
- Detección de nodos cercanos

## 🌍 Nodos Disponibles

| Nodo | Ubicación | Misión |
|------|------------|---------|
| 🛰️ Nodo Alpha | SENA Mosquera | Hackear servidor de notas |
| 📻 Nodo Beta | Parque Principal | Interceptar señal de radio |
| 🤖 Nodo Gamma | Zona Industrial | Sabotaje de drones |

## 📏 Sistema de Distancia

La aplicación calcula en tiempo real:

- 📍 Distancia al nodo más cercano
- 🚦 Disponibilidad de misión dentro de 500 metros

---

# 💻 Fase 3 — Terminal Hacker

La interfaz fue diseñada como una terminal clandestina inspirada en Linux:

- 🖤 Fondo negro
- 💚 Texto verde fósforo
- 🔤 Fuente RobotoMono
- 🌌 Estilo cyberpunk minimalista

## 📳 Vibración Código Morse

Al detectar una misión:

El dispositivo vibra usando el patrón Morse:

txt
SOS → ... --- ...


---

# 📦 Dependencias Utilizadas

yaml
dependencies:
  flutter:
    sdk: flutter

  provider:
  local_auth:
  geolocator:
  vibration:


---

# 🤖 Configuración Android

## 📄 AndroidManifest.xml

Agregar los siguientes permisos:

xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>


---

# 🚀 Ejecución del Proyecto

bash
flutter pub get
flutter run


---

# 🌑 Arquitectura del Proyecto

txt
lib/
│
├── providers/
│   └── auth_provider.dart
│
├── services/
│   └── node_service.dart
│
├── screens/
│   └── main_screen.dart
│
├── widgets/
│   └── terminal_widget.dart
│
└── main.dart


---

# 🔧 Flujo de Trabajo Git

El proyecto fue desarrollado utilizando:

- 🌿 Branches independientes
- 🔀 Pull Requests
- ✅ Commits organizados por funcionalidad

## 🌱 Ramas Utilizadas

txt
feature/auth-core-santiago
feature/georadar-emyl
feature/ui-morse-laura


---

# 🛰️ Estado del Sistema

txt
[✔️] Biometría Operativa
[✔️] Geo-Radar Activo
[✔️] Terminal ShadowNet Inicializada
[✔️] Comunicación Segura Establecida


---

# ⚠️ Mensaje Final

> “La resistencia no necesita permiso para existir.”  
> — ShadowNet Protocol

---