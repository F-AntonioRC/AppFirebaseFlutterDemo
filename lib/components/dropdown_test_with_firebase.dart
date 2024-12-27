import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropdownTestWithFirebase extends StatefulWidget {
  const DropdownTestWithFirebase({super.key});

  @override
  State<DropdownTestWithFirebase> createState() =>
      _DropdownTestWithFirebaseState();
}

class _DropdownTestWithFirebaseState extends State<DropdownTestWithFirebase> {
  String selectedValue = "0";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dependencia')
                  .snapshots(),
              builder: (context, snapshots) {
                List<DropdownMenuItem> firebaseItems = [];
                if (!snapshots.hasData) {
                  const CircularProgressIndicator();
                } else {
                  final datas = snapshots.data?.docs.reversed.toList();
                  firebaseItems.add(const DropdownMenuItem(
                      value: "0", child: Text('Selecciona una opción')));
                  for (var data in datas!) {
                    firebaseItems.add(DropdownMenuItem(
                      value: data.id,
                      child: Text(data['NombreDependencia']),
                    ));
                  }
                }
                return DropdownButton(
                    items: firebaseItems, onChanged: (firebaseValue) {
                      setState(() {
                        selectedValue = firebaseValue;
                      });
                      print(firebaseValue);},
                  value: selectedValue, isExpanded: false,);
              })
        ],
      ),
    );
  }
}
