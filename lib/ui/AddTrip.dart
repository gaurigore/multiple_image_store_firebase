import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upload_images_firebase/Firebase/FirebaseServices.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({super.key});

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final ImagePicker _picker = ImagePicker();
  late List<XFile> images = [];
  List<String> photos = [];
  TextEditingController placeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
   late GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Add Trip",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
        ],
        elevation: 0,
        backgroundColor: Colors.grey,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("place"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextField(
              controller: placeController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              )),
            ),
            const Text("Date"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month),
                  )),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  ),
              keyboardType: TextInputType.text
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Flexible(
              child: Column(
                children: const [
                  GoogleMap(

                      initialCameraPosition: CameraPosition(target: LatLng(21.17024, 72.8310),zoom: 12))

                ],
              ),
            ),
            Flexible(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5),
                children: [
                  ...tripImages(),
                  InkWell(
                    onTap: () async {
                      var response = await _picker
                          .pickMultiImage()
                          .whenComplete(() => uploadImages());
                      print("rsult:$response");
                      setState(() {
                        images = response;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey),
                      child: const Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> tripImages() {
    return images.map((e) {
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
            image: DecorationImage(
                image: FileImage(File(e.path)), fit: BoxFit.cover)),
      );
    }).toList();
  }

  Future<void> uploadImages() async {
    for (var element in images) {
      try {
        String fullPath =
            "${placeController.text.trim()}/IMG-${DateTime.now().millisecondsSinceEpoch}.${element.path.split('.').last}";
        print(element.path.toString());
        var reference = await FirebaseServices.storageRef.child(fullPath);
        var downloadUrl = reference
            .putFile(File(element.path))
            .whenComplete(() => reference.getDownloadURL());

        photos.add(fullPath);
      } catch (e) {
        print(e);
      }
      ;
    }
    print("upload sucessful");
    print(photos);
  }
}
