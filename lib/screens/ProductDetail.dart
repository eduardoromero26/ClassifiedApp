import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'detailImage.dart';

double _value = 0.0;

// ignore: camel_case_types
class ProductDetailScreen extends StatelessWidget {
    final Map objApi;


  const ProductDetailScreen({
    Key? key,
    required this.objApi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Get.to(SingleImageSongScreen(
           SingleImageURL: objApi['images'][0],
         ));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objApi['title'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    objApi['price'].toString(),
                    style: TextStyle(
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(objApi['images'][0], fit: BoxFit.cover)),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      size: 12,
                      color: Colors.black54,
                    ),
                    Text(
                      "All",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.lock_clock_outlined,
                        size: 12, color: Colors.black54),
                    Text(
                      "14 Days ago",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                child: Text(objApi['description'],
                style: const TextStyle(
                  fontSize: 18,
                ),),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: 340,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Contact Seller",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
