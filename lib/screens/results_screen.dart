import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Game Results")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('scores').orderBy('score', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var scores = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    var data = scores[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['player_name'] ?? 'Unknown'),
                      subtitle: Text("Score: ${data['score']}"),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('scores').get().then((snapshot) {
                  for (DocumentSnapshot doc in snapshot.docs) {
                    doc.reference.delete(); // Clear previous scores
                  }
                });
                Navigator.pop(context); // Navigate back to the main screen
              },
              child: Text("Play Again"),
            ),
          ),
        ],
      ),
    );
  }
}
