import 'package:flutter/material.dart';

class TagDexScreen extends StatelessWidget {
  const TagDexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tag Dex')),
      body: const Center(child: Text('Tag List & Search here')),
    );
  }
}
