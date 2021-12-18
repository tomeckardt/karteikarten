import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts _flutterTts = FlutterTts();

class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);

  Future<void> _initTts() async {
    await _flutterTts.speak("Hallo hey");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const TextField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Name des Geräts",
              ),
            ),
            const Divider(),
            ElevatedButton.icon(
              icon: const Icon(
                  Icons.refresh,
                  color: Colors.white
              ),
              label: Text('Nicht verbunden'),
              onPressed: () { },
            ),
            const Divider(),
            Center(
              child: ElevatedButton.icon(onPressed: _initTts, icon: Icon(Icons.play_arrow), label: Text("Session starten"))
            )
          ],
        )
      );
  }
}

/*

 */
