import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';


class ParcelDetailScreen extends StatelessWidget {
  final DocumentSnapshot parcel;

  const ParcelDetailScreen({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = parcel.data() as Map<String, dynamic>;
    data['id'] = parcel.id;

    // Create a list of Text widgets for each field in the data map
    List<Widget> textWidgets = data.entries.map((entry) {
      return Text('${entry.key}: ${entry.value}');
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parcel Details'),
        backgroundColor: tThemeMain,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: textWidgets,
        ),
      ),
    );
  }
}
