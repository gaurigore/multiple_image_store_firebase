import 'package:flutter/material.dart';

import 'AddTrip.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Add TriP"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTrip();
                }));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 18,
              ))
        ],
      ),
    );
  }
}
