// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_name/screens/ProductDetail.dart';

class ProductCardWidget extends StatelessWidget {
  final Map objApi;
  

  const ProductCardWidget({
    Key? key,
    required this.objApi,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Get.to(ProductDetailScreen(
          objApi: objApi,
         ));
       },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              child: Image.network(
                objApi['images'][0],
                fit: BoxFit.cover,
              )),
          Container(
            height: 68,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objApi['title'],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  objApi['price'].toString(),
                  style: TextStyle(
                    color: Colors.orange[800],
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
