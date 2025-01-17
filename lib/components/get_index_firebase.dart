import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  // Consulta compuesta que requiere un índice
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Sare')
      .where('sare', isEqualTo: 'ORE')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}'); // Mensaje en consola
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['Id'] ?? 'Sin Nombre'),
              subtitle: Text(data['Estado'] ?? 'Sin estado'),
            );
          }).toList(),
        );
      },
    );
  }
}
