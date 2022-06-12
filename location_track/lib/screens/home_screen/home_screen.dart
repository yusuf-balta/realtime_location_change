import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_track/screens/home_screen/home_controller.dart';

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
                : Text("home page"),
          )),
    );
  }
}
