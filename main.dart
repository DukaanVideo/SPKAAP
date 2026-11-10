import 'package:flutter/material.dart';

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

// ==========================================
// 1️⃣ HOME SCREEN (Banner & (+) Button)
// ==========================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
              
              // Gallery Option
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purpleAccent, size: 30),
                title: const Text('Gallery se Photo/Video Uthayein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PreviewScreen(selectedType: 'Gallery Media')),
                  );
                },
              ),
              
              // Camera Option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepOrangeAccent, size: 30),
                title: const Text('Camera se Live Photo Khichein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PreviewScreen(selectedType: 'Camera Live Photo')),
                  );
                },
              ),

              // Text / Script Box Option
              ListTile(
                leading: const Icon(Icons.edit_note, color: Colors.greenAccent, size: 30),
                title: const Text('Dukaan ki Details / Script Likhein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScriptScreen()),
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
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Plus (+) Button
              Center(
                child: GestureDetector(
                  onTap: () => _showMediaOptions(context),
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
                    child: const Icon(Icons.add, size: 50, color: Colors.white),
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

// ==========================================
// 2️⃣ PREVIEW & CONFIRMATION SCREEN
// ==========================================
class PreviewScreen extends StatelessWidget {
  final String selectedType;
  const PreviewScreen({Key? key, required this.selectedType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Preview & Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Aap yeh upload karne ki koshish kar rahe hain:",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              selectedType,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amberAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 80, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    label: const Text('Badlein'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Hataein'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScriptScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text('Aage Badhein (Next)', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3️⃣ TEXT SCRIPT, VOICE-OVER & ₹5 PAYMENT SCREEN (Teesra Part)
// ==========================================
class ScriptScreen extends StatefulWidget {
  const ScriptScreen({Key? key}) : super(key: key);

  @override
  _ScriptScreenState createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  final TextEditingController scriptController = TextEditingController();
  String selectedVoice = 'Ladki ki Aawaz (Female AI)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Script & Voice-Over Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Apni dukan ya offer ki details likhein ya mic se bolein:",
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 10),

            // Text Box & Mic Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: scriptController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Jaise: Hamari dairy par taaza paneer milta hai...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[900],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white, size: 30),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Listening... Bolkar type karein!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Voice-Over Selection (Ladka, Ladki, ya Khud ki Aawaz)
            const Text(
              "Voice-Over Aawaz Chunein:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amberAccent),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedVoice,
              dropdownColor: Colors.grey[900],
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              items: <String>[
                'Ladki ki Aawaz (Female AI)',
                'Ladke ki Aawaz (Male AI)',
                'Meri Apni Aawaz (Voice Clone)'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).formatListOrDrop(), // Standard dropdown format
              onChanged: (String? newValue) {
                setState(() {
                  selectedVoice = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Video Preview & Payment Button
            ElevatedButton.icon(
              onPressed: () {
                // Payment & Download Dialog popup
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Video Download (₹5 Shulk)', style: TextStyle(color: Colors.amberAccent)),
                    content: const Text('Aapka video taiyar hai! Download karne ke liye kewal ₹5 ka UPI/QR payment karein.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Radd Karein', style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment Successful! Video Downloading... 🎉')),
                          );
                        },
                        child: const Text('Pay ₹5 & Download'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_fill, color: Colors.black),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              label: const Text(
                'Video Preview & Pay ₹5 to Download',
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to avoid dropdown formatting issue in standard Dart
extension on List<DropdownMenuItem<String>> {
  formatListOrDrop() => this;
}
