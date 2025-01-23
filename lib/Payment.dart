import 'package:database/loading.dart';
import 'package:database/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Parking_place.dart';
import 'Reservation.dart';
import 'accueil.dart';
import 'main.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'map_page.dart';
import 'user.dart';
import 'auth.dart';
import 'globale_variable.dart';

void main() => runApp(const MaterialApp(
  home: payment(),
  debugShowCheckedModeBanner: false,
));

class payment extends StatefulWidget {
  const payment({super.key});


  @override
  State<payment> createState() => paymentscreen();
}

class paymentscreen extends State<payment> {

  final formKey = GlobalKey<FormState>();


  String email = '';
  String password = '';
  String UserName = '';
  String error = '';

  final AuthService _auth = AuthService();

  final TextEditingController _controller = TextEditingController();

  bool visible = true;
  bool code = true;

  @override

  void dispose() {
    // N'oubliez pas de nettoyer le contrôleur lorsque le widget est supprimé
    _controller.dispose();
    super.dispose();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Associe le GlobalKey au Scaffold

      resizeToAvoidBottomInset: false,
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
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.only(bottom: 594),
              child: Image.asset('images/background.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150,right: 80),
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset('images/curve.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 340),
            child: IconButton(
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const home()));
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
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18,right: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.numbers,
                              color: Colors.black,),
                            label: Text('Card number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.date_range,
                              color: Colors.black,),
                            label: const Text('Expiration date(MM/YY)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.lock,
                              color: Colors.black,),
                            label: const Text('Number confidentiel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async{

                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 65, vertical: 12),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Bord arrondi du bouton
                                ),
                              ),
                              elevation: MaterialStateProperty.all<double>(15.0), // Élévation du bouton
                            ),
                            child : const Text('Pay',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black
                              ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
