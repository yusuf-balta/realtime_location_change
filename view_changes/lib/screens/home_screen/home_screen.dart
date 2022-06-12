import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:view_changes/screens/home_screen/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomePageController homePageController =
      Get.put(HomePageController(), tag: HomePageController.instanceName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
            child: homePageController.getIsLoading
                ? CircularProgressIndicator.adaptive()
                : Column(
                    children: List.generate(
                      homePageController.locationList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          homePageController.locationList[index].toString(),
                        ),
                      ),
                    ),
                  ),
          )),
    );
  }
}
