import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DuelScreen extends StatefulWidget {
  final String gameId;
  final String playerKey; // "player1" or "player2"

  DuelScreen({required this.gameId, required this.playerKey});

  @override
  _DuelScreenState createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  int userScore = 0;
  int opponentScore = 0;

  @override
  void initState() {
    super.initState();
    _listenToGameUpdates();
  }

void _listenToGameUpdates() {
  _database.ref("matches/${widget.gameId}").onValue.listen((event) {
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      print("🔥 Firebase Data: $data"); // Debugging line

      setState(() {
        userScore = (data[widget.playerKey]?['score'] ?? 0);
        opponentScore = (data[widget.playerKey == "player1" ? "player2" : "player1"]?['score'] ?? 0);
      });

      print("🎯 Updated Scores -> User: $userScore, Opponent: $opponentScore"); // Debugging line
    } else {
      print("❌ No data found for gameId: ${widget.gameId}");
    }
  });
}


void _submitAnswer(bool isCorrect) async {
  if (isCorrect) {
    DatabaseReference playerScoreRef = _database.ref("matches/${widget.gameId}/${widget.playerKey}/score");

    // Fetch the latest score from Firebase before updating
    DataSnapshot snapshot = await playerScoreRef.get();
    int currentScore = (snapshot.value as int?) ?? 0;
    
    print("🔄 Current Score from Firebase: $currentScore"); // Debugging line

    // Update the score in Firebase
    await playerScoreRef.set(currentScore + 1);
    print("✅ Updated Score in Firebase!");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HectoClash Duel")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Your Score: $userScore", style: TextStyle(fontSize: 24)),
          Text("Opponent Score: $opponentScore", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _submitAnswer(true),
            child: Text("Correct Answer"),
          ),
          ElevatedButton(
            onPressed: () => _submitAnswer(false),
            child: Text("Wrong Answer"),
          ),
        ],
      ),
    );
  }
}
