import 'package:flutter/material.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderators'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
