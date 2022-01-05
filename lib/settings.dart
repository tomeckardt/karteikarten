import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  late Box _settings;
  final maxValue = 8000, minValue = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Einstellungen")
      ),
      body: FutureBuilder(
        future: Hive.openBox("settings").then((value) => _settings = Hive.box("settings")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  title: TextField(
                    controller: TextEditingController(text: _settings.get("eSenseName", defaultValue: "")),
                    onSubmitted: (value) => _settings.put("eSenseName", value),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.earbuds_sharp),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        labelText: "Name des Geräts"
                    ),
                  )
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Empfindlichkeit"),
                  subtitle: Row(
                    children: [
                      const Expanded(child: Text("sehr empfindlich", overflow: TextOverflow.clip)),
                      Slider(
                        label: "Empfindlichkeit",
                        onChanged: (value) {
                          setState(() {
                            _settings.put("sensitivity", value.toInt());
                          });
                        },
                        divisions: maxValue - minValue,
                        value: _settings.get("sensitivity", defaultValue: 4000.0).toDouble(),
                        min: minValue.toDouble(), max: maxValue.toDouble(),
                      ),
                      const Expanded(child: Text("wenig empfindlich", overflow: TextOverflow.clip))
                    ],
                  )
                )
              ],
            );
          }
          return const Center(child: Text("Einstellungen werden geladen...", style: TextStyle(color: Colors.grey)));
        },
      )
    );
  }
}

