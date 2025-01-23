import 'package:database/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Parking_place.dart';
import 'Reservation.dart';
import 'accueil.dart';
import 'login.dart';
import 'main.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LocationData? _currentLocation;
  final Location _location = Location();
  double _currentZoom = 15.0; // Niveau de zoom initial

  // Liste des emplacements des parkings (latitude, longitude, et nom) à Rabat, Maroc
  final List<Map<String, dynamic>> _parkings = [
    {'name': 'Parking 1', 'lat': 37.4419, 'lng': -122.1430},  // Parking 1 à Palo Alto
    {'name': 'Parking 2', 'lat': 37.4450, 'lng': -122.1420},  // Parking 2 à Palo Alto
    {'name': 'Parking 3', 'lat': 37.4380, 'lng': -122.1450},  // Parking 3 à Palo Alto
    {'name': 'Parking 4', 'lat': 37.4400, 'lng': -122.1480},
    {'name': 'Parking 1', 'lat': 34.266191, 'lng': -6.566128},
    {'name': 'Parking 2', 'lat': 34.254998, 'lng': -6.600829},
    {'name': 'Parking 3', 'lat': 34.251009, 'lng': -6.653890},
    {'name': 'Parking 4', 'lat': 34.244999, 'lng': 6.600087},
    {'name': 'Parking 1', 'lat': 31.633978, 'lng': -7.998913},
    {'name': 'Parking 2', 'lat': 31.628234, 'lng': -8.004681},
    {'name': 'Parking 3', 'lat': 31.635620, 'lng': -7.985032},
    {'name': 'Parking 4', 'lat': 31.629504, 'lng': -7.984152},
    {'name': 'Parking 5', 'lat': 31.621415, 'lng': -7.991256},
    {'name': 'Parking 1', 'lat': 27.141000, 'lng': -13.202050},
    {'name': 'Parking 2', 'lat': 27.146500, 'lng': -13.204850},
    {'name': 'Parking 3', 'lat': 27.139300, 'lng': -13.198500},
    {'name': 'Parking 4', 'lat': 27.142000, 'lng': -13.206200},
    {'name': 'Parking 5', 'lat': 27.137400, 'lng': -13.200900},// Parking 4 à Palo Alto
  ];

  final MapController _mapController = MapController();
  List<LatLng> _route = [];  // Liste des points pour dessiner l'itinéraire

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      setState(() {});
    } catch (e) {
      print("Erreur lors de la récupération de la localisation : $e");
    }
  }

  // Fonction pour récupérer l'itinéraire via OpenRouteService
  Future<void> _getDirections(LatLng destination) async {
    if (_currentLocation != null) {
      final origin = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);

      final url = Uri.parse(
          "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248dc611cfc919642488dd759dcfd5d5a0a&start=${origin.longitude},${origin.latitude}&end=${destination.longitude},${destination.latitude}"
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];

        setState(() {
          _route = coordinates
              .map<LatLng>((point) => LatLng(point[1], point[0]))
              .toList();
        });
      } else {
        print('Erreur lors du calcul de l\'itinéraire');
      }
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 1;
    });
    _mapController.move(
      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      _currentZoom,
    );
  }

  void _zoomOut() {
    setState(() {
      _currentZoom -= 1;
    });
    _mapController.move(
      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      _currentZoom,
    );
  }

  void _locateUser() {
    if (_currentLocation != null) {
      _mapController.move(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        _currentZoom,
      );
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        // Your drawer content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffffcc80), Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('Edit profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.orange),
              title: const Text('My Reservations'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const accueil()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_parking, color: Colors.orange),
              title: const Text('Parkings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined, color: Colors.orange),
              title: const Text('Add Reservations'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined, color: Colors.orange),
              title: const Text('Map'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
              },
            ),

            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const login()));
              },
            ),
          ],
        ),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.only(bottom: 594),
            child: Image.asset('images/background.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, right: 80),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset('images/curve.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 340),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const home()));
              },
              icon: const Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: const Padding(
              padding: EdgeInsets.only(bottom: 570,right: 200),
              child: CircleAvatar(
                backgroundImage: AssetImage('tsawer/freepik__background__51925.png'),
                backgroundColor: Colors.transparent,
                radius: 160,
              ),
            ),
          ),
          // Votre fond ou autres widgets ici
          Padding(
            padding: const EdgeInsets.only(top: 180, left: 280),
            child: IconButton(
              onPressed: () {
                // Utilise le GlobalKey pour ouvrir le Drawer
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(
                Icons.menu_open_outlined,
                size: 50,
                color: Colors.black,
              ),
            ),
          ),
          // Carte principale
          Padding(
            padding: const EdgeInsets.only(top: 270, bottom: 60, left: 30, right: 30),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                initialZoom: _currentZoom,
              ),
              children: [
                // Couche de la carte
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                // Couche des marqueurs dynamiques
                MarkerLayer(
                  markers: [
                    // Marqueur pour la position actuelle
                    Marker(
                      point: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      width: 50.0,
                      height: 50.0,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                    // Marqueurs des parkings à Rabat
                    ..._parkings.map((parking) {
                      return Marker(
                        point: LatLng(parking['lat'], parking['lng']),
                        width: 80.0, // Ajuster la largeur
                        height: 80.0, // Ajuster la hauteur
                        child: GestureDetector(
                          onTap: () {
                            _getDirections(LatLng(parking['lat'], parking['lng']));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_parking,
                                color: Colors.red,
                                size: 30.0,
                              ),
                              SizedBox(height: 4), // Espace entre l'icône et le texte
                              Text(
                                'Parkify', // Texte statique
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                // Couche pour dessiner l'itinéraire
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Boutons flottants pour le zoom et la localisation
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  heroTag: "btnZoomIn",
                  child: Icon(Icons.add),
                  mini: true,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  heroTag: "btnZoomOut",
                  child: Icon(Icons.remove),
                  mini: true,
                ),
                SizedBox(height: 10),
                // Bouton pour localiser l'utilisateur
                FloatingActionButton(
                  onPressed: _locateUser,
                  heroTag: "btnLocateUser",
                  child: Icon(Icons.my_location),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
