// ==========================================
// 📂 SAVED VIDEOS / HISTORY SCREEN (Aage ka naya feature)
// ==========================================
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Demo ke liye kuch saved videos ki list
    final List> savedVideos = [
      {'title': 'Doodh Dairy Promo', 'date': '26 Oct 2026', 'status': 'Downloaded (₹5 Paid)'},
      {'title': 'Mobile Store Offer', 'date': '25 Oct 2026', 'status': 'Downloaded (₹5 Paid)'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meri Banyi Huyi Videos'),
        backgroundColor: Colors.purple[900],
      ),
      body: savedVideos.isEmpty
          // Agar koi video na ho toh yeh dikhega
          ? const Center(
              child: Text(
                'Abhi tak koi video nahi banayi hai!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          // Agar videos hain toh list dikhegi
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
