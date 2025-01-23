import 'package:database/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Parking_place.dart';
import 'Payment.dart';
import 'accueil.dart';
import 'login.dart';
import 'main.dart';
import 'map_page.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int? selectedParking; // Variable pour stocker le parking sélectionné
  DateTime? arrivalDateTime;
  DateTime? departureDateTime;
  double price = 0.0; // Prix calculé en fonction de la durée

  // Fonction pour calculer le prix
  void calculatePrice() {
    if (arrivalDateTime != null && departureDateTime != null) {
      final duration = departureDateTime!.difference(arrivalDateTime!).inHours;
      price = duration > 0 ? duration * 5.0 : 0.0; // Exemple : 10 DH par heure
    }
  }

  // Fonction pour afficher un sélecteur de date et heure
  Future<void> selectDateTime(BuildContext context, bool isArrival) async {
    DateTime now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          if (isArrival) {
            arrivalDateTime = selectedDateTime;
          } else {
            departureDateTime = selectedDateTime;
          }
          calculatePrice(); // Recalculer le prix après sélection
        });
      }
    }
  }
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
            padding: const EdgeInsets.only(top: 240,bottom: 20,left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Grille des parkings
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // Nombre de colonnes
                    mainAxisSpacing: 00.0, // Espacement vertical entre les carreaux
                    crossAxisSpacing: 00.0, // Espacement horizontal entre les carreaux
                    children: List.generate(4, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedParking = index + 1; // Sélectionne le parking
                          });
                        },
                        child: Center(
                          child: SizedBox(
                            width: 120, // Largeur des carreaux
                            height: 120, // Hauteur des carreaux
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedParking == index + 1
                                    ? Colors.orange
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Parking - ${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 5),

                // Sélection de l'arrivée
                ElevatedButton(
                  onPressed: () => selectDateTime(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    arrivalDateTime == null
                        ? "Sélectionner l'arrivée"
                        : "Arrivée : ${DateFormat('dd/MM/yyyy HH:mm').format(arrivalDateTime!)}",
                  ),
                ),
                const SizedBox(height: 10),

                // Sélection du départ
                ElevatedButton(
                  onPressed: () => selectDateTime(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    departureDateTime == null
                        ? "Sélectionner le départ"
                        : "Départ : ${DateFormat('dd/MM/yyyy HH:mm').format(departureDateTime!)}",
                  ),
                ),
                const SizedBox(height: 20),

                // Section du prix total
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Le prix de votre réservation sera:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: selectedParking != null &&
                                arrivalDateTime != null &&
                                departureDateTime != null
                                ? () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const payment()));

                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text("PAYER"),
                          ),
                          Text(
                            "${price.toStringAsFixed(2)} DH",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            ]
        ),
    ]
      ),
    );
  }
}

void reservation() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReservationScreen(),
  ));
}
