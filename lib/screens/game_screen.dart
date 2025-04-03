import 'package:flutter/material.dart';
import 'duel_screen.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HectoClash'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
               Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DuelScreen(gameId: "match_1", playerKey: "player1"),
  ),
);

              },
              child: Text('Start Duel'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Local Leaderboard: Not implemented yet')),
                );
              },
              child: Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}