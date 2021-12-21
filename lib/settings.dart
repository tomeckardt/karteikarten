import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  late Box _settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Einstellungen")
      ),
      body: FutureBuilder(
        future: Hive.openBox("settings").then((value) => _settings = Hive.box("settings")),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ListTile(
                  title: const TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.earbuds_sharp),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        labelText: "Name des Geräts"
                    ),
                  ),
                  trailing: ElevatedButton(onPressed: () { }, child: const Text("Verbinden")),
                ),
              ],
            );
          }
          return const Center(child: Text("Einstellungen werden geladen...", style: TextStyle(color: Colors.grey)));
        },
      )
    );
  }
}

