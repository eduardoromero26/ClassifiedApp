import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_name/screens/EditAdd.dart';

class MyAdsWidget extends StatelessWidget {
  final Map objApi;

  const MyAdsWidget({
    Key? key,
    required this.objApi,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(EditAddScreen(
            objApi: objApi,
          ));
          print(objApi);
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.network(
                  objApi['images'][0],
                  fit: BoxFit.cover,
                  height: 120,
                  width: 80,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        objApi['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: const [
                          Icon(Icons.alarm_on, size: 12, color: Colors.black45),
                          Text(
                            "15 days ago",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        objApi['price'].toString(),
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
