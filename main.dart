import 'package:flutter/material.dart';

// --- POINT NO. 1: App Start Point (Bina login/password ke direct khulne wala system) ---
void main() {
  runApp(const DukaanVideoApp());
}

class DukaanVideoApp extends StatelessWidget {
  const DukaanVideoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DukaanVideo App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // --- (+) Button dabane par niche se khulne wala Media Menu (Gallery, Camera, Text) ---
  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Apni Dukan ki Media Chunein",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 20),
              
              // 1. Gallery Option
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purpleAccent, size: 30),
                title: const Text('Gallery se Photo/Video Uthayein'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery option selected!')),
                  );
                },
              ),
              
              // 2. Camera Option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepOrangeAccent, size: 30),
                title: const Text('Camera se Live Photo Khichein'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera option selected!')),
                  );
                },
              ),

              // 3. Text / Script Box Option
              ListTile(
                leading: const Icon(Icons.edit_note, color: Colors.greenAccent, size: 30),
                title: const Text('Dukaan ki Details / Script Likhein'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Text Script option selected!')),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- POINT NO. 2: Exact Name Banner ("DukaanVideo") ---
              const Text(
                "DukaanVideo",
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Apni dukan, dairy ya game ke liye turant video banayein",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // --- POINT NO. 3: Plus (+) Button Layout ---
              Center(
                child: GestureDetector(
                  onTap: () {
                    // (+) button click hone par menu open hoga
                    _showMediaOptions(context);
                  },
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Naye Video ke liye '+' par click karein",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
