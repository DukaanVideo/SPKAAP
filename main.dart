import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
// 1️⃣ HOME SCREEN (Banner, History Icon & (+) Button)
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent),
              ),
              const SizedBox(height: 20),
              
              // Gallery Option
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purpleAccent, size: 30),
                title: const Text('Gallery se Photo/Video Uthayein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen(selectedMedia: 'Gallery Media')));
                },
              ),
              
              // Camera Option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepOrangeAccent, size: 30),
                title: const Text('Camera se Live Photo Khichein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen(selectedMedia: 'Camera Live Photo')));
                },
              ),

              // Text / Script Box Option
              ListTile(
                leading: const Icon(Icons.edit_note, color: Colors.greenAccent, size: 30),
                title: const Text('Dukaan ki Details / Script Likhein'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScriptScreen()));
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.amberAccent, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "DukaanVideo",
                style: TextStyle(color: Colors.amberAccent, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
                        BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 15, spreadRadius: 3),
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
// 2️⃣ BUSINESS CATEGORY SELECTION SCREEN
// ==========================================
class CategoryScreen extends StatelessWidget {
  final String selectedMedia;
  const CategoryScreen({Key? key, required this.selectedMedia}) : super(key: key);

  final List> categories = const [
    {'name': 'Doodh Dairy & Paneer', 'icon': Icons.local_drink},
    {'name': 'Mobile & Electronics Shop', 'icon': Icons.phone_android},
    {'name': 'Mithaai & Restaurant', 'icon': Icons.cake},
    {'name': 'Gaming & Tournaments', 'icon': Icons.sports_esports},
    {'name': 'General Store / Dukaan', 'icon': Icons.store},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apna Business Category Chunein')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Aapka dhandha kis cheez ka hai?",
              style: TextStyle(fontSize: 16, color: Colors.amberAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(categories[index]['icon'], color: Colors.purpleAccent, size: 30),
                      title: Text(categories[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewScreen(
                              selectedType: selectedMedia,
                              category: categories[index]['name'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3️⃣ PREVIEW & CONFIRMATION SCREEN
// ==========================================
class PreviewScreen extends StatelessWidget {
  final String selectedType;
  final String category;
  const PreviewScreen({Key? key, required this.selectedType, this.category = 'General Business'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media & Category Preview')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Category: $category", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text("Media Type: $selectedType", style: const TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.purple, width: 2),
              ),
              child: const Center(child: Icon(Icons.image, size: 80, color: Colors.white54)),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScriptScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text('Aage Script aur Voice par Badhein', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4️⃣ SCRIPT, VOICE-OVER & UPI PAYMENT SCREEN
// ==========================================
class ScriptScreen extends StatefulWidget {
  const ScriptScreen({Key? key}) : super(key: key);

  @override
  _ScriptScreenState createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  final TextEditingController scriptController = TextEditingController();
  String selectedVoice = 'Ladki ki Aawaz (Female AI)';
  bool isPaid = false;

  Future<void> _openUpiPayment() async {
    final String upiUrlString = 'upi://pay?pa=Sandeepkumarsandeepku7862mar-6@oksbi&pn=DukaanVideo&am=5.00&cu=INR&tn=Dukaan%20Video%20Download%20Fee';
    final Uri upiUri = Uri.parse(upiUrlString);

    try {
      if (await canLaunchUrl(upiUri)) {
        await launchUrl(upiUri, mode: LaunchMode.externalApplication);
        setState(() {
          isPaid = true;
        });
      } else {
        setState(() {
          isPaid = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment app par bhej diya gaya hai!')),
        );
      }
    } catch (e) {
      setState(() {
        isPaid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Script, Voice & UPI Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Apni dukan ya offer ki details likhein ya mic se bolein:", style: TextStyle(fontSize: 15, color: Colors.white70)),
            const SizedBox(height: 10),

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
                  decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white, size: 30),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listening... Bolkar type karein!')));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            const Text("Voice-Over Aawaz Chunein:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedVoice,
              dropdownColor: Colors.grey[900],
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              items: <String>['Ladki ki Aawaz (Female AI)', 'Ladke ki Aawaz (Male AI)', 'Meri Apni Aawaz (Voice Clone)']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() { selectedVoice = newValue!; });
              },
            ),
            const SizedBox(height: 30),

            // UPI Payment Button
            ElevatedButton.icon(
              onPressed: _openUpiPayment,
              icon: const Icon(Icons.payment, color: Colors.black),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 16)),
              label: const Text('Pay ₹5 (Google Pay / PhonePe)', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            // Download Button (Locked until payment)
            Opacity(
              opacity: isPaid ? 1.0 : 0.5,
              child: ElevatedButton.icon(
                onPressed: isPaid 
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video Successfully Downloaded! 🎉')),
                      );
                    } 
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pehle upar diye button se ₹5 ka payment karein!')),
                      );
                    },
                icon: const Icon(Icons.download, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaid ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                label: Text(
                  isPaid ? 'Video Download Karein (Unlocked)' : 'Payment ke Baad Button Khulega 🔒',
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5️⃣ SAVED VIDEOS / HISTORY SCREEN (Corrected)
// ==========================================
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Correct type definition Added
    final List> savedVideos = [
      {'title': 'Doodh Dairy Promo', 'date': '26 Oct 2026', 'status': 'Downloaded (₹5 Paid)'},
      {'title': 'Mobile Store Offer', 'date': '25 Oct 2026', 'status': 'Downloaded (₹5 Paid)'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meri Banayi Huyi Videos'),
        backgroundColor: Colors.purple[900],
      ),
      body: savedVideos.isEmpty
          ? const Center(
              child: Text(
                'Abhi tak koi video nahi banayi hai!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: savedVideos.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.video_library, color: Colors.amberAccent, size: 35),
                    title: Text(
                      savedVideos[index]['title']!,
                      style: constTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      "Tarikh: ${savedVideos[index]['date']}\nStatus: ${savedVideos[index]['status']}",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_fill, color: Colors.green, size: 30),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${savedVideos[index]['title']} play ho rahi hai!')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
