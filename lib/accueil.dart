import 'package:database/Parking_place.dart';
import 'package:database/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Reservation.dart';
import 'VideoPlayerrrr.dart';
import 'login.dart';
import 'map_page.dart';
import 'user.dart';
import 'auth.dart';
import 'main.dart';
import 'database.dart';

void main() => runApp(const MaterialApp(
  home: accueil(),
  debugShowCheckedModeBanner: false,
));

class accueil extends StatefulWidget {
  const accueil({super.key});

  @override
  State<accueil> createState() => accueilscreen();
}

class accueilscreen extends State<accueil> {
  AuthService authService = AuthService();
  late QuerySnapshot? data;

  bool loading = true;
  bool visible = true;
  bool code = true;
  bool showImage = false;
  int refrech = 0;


  Future<void> getData(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('infractions')
        .doc('infraction1')
        .get();
    if (userSnapshot.exists) {
      CollectionReference infractionsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('infractions');
      QuerySnapshot infractionsSnapshot = await infractionsRef.get();
      setState(() {
        data = infractionsSnapshot;
        loading = false;
      });
    } else {
      setState(() {
        data = null;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String currentUid = currentUser.uid;
      getData(currentUid);
    } else {
      // Gérer le cas où aucun utilisateur n'est connecté
      print("Aucun utilisateur n'est connecté.");
    }
  }


  @override
  Future<void> refreshPage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const accueil()));
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
              padding: const EdgeInsets.only(top: 260),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : data == null
                  ? Center(
                  child: const Text(
                    'No data exist',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              )
                  : GridView.builder(
                itemCount: data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisExtent: 160),
                itemBuilder: (context, i) {
                  Map<String, dynamic> item = data!.docs[i].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(top: 20, right: 15),
                    height: 130,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 8),
                            blurRadius: 20,
                            spreadRadius: 20,
                          )
                        ]),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, left: 8),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.orange,
                                        width: 4,
                                      ),
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('tsawer/freepik__background__32786.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["nature d'infraction"] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF00017E),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["localisation"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["date"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item["prix"] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 750, left: 320),
          child: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingScreen()));
            },
            icon: const Icon(
              Icons.add_box_outlined,
              size: 50,
              color: Colors.orange,
            ),
          ),
        ),
          ],
        ),
  ]),
    );
  }
}
