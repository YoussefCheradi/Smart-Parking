import 'package:database/profile.dart';
import 'package:flutter/material.dart';

import 'Reservation.dart';
import 'accueil.dart';
import 'login.dart';
import 'main.dart';
import 'map_page.dart';

void parking() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ParkingScreen(),
    );
  }
}

class ParkingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> parkingSpots = [
    {'id': '1 Reserved from 12:30 to 13:30', 'occupied': true}, // Voiture rouge
    {'id': '2 Empty parking', 'occupied': false},
    {'id': '3 Empty parking', 'occupied': false},
    {'id': '4 Empty parking', 'occupied': false},
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Associe le GlobalKey au Scaffold
      drawer: Drawer(
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
      body: Stack(
        children: [
          Stack(
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
              Padding(
                padding: const EdgeInsets.only(top: 270, left: 150),
                child: StreamBuilder<DateTime>(
                  stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                  builder: (context, snapshot) {
                    final now = snapshot.data ?? DateTime.now();
                    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                    final formattedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate, // Affiche la date
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5), // Espacement entre la date et l'heure
                        Text(
                          formattedTime, // Affiche l'heure
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: parkingSpots.length,
                        itemBuilder: (context, index) {
                          final spot = parkingSpots[index];
                          return ParkingSpot(
                            id: spot['id'],
                            occupied: spot['occupied'],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70,left: 50),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationScreen()));

                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                            ),
                          ),
                          elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                        ),
                        child: const Text(
                          'Reserve a place',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ParkingSpot extends StatelessWidget {
  final String id;
  final bool occupied;

  const ParkingSpot({Key? key, required this.id, required this.occupied})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car,
            size: 40,
            color: occupied ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 16),
          Text(
            id,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
