import 'dart:developer';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:view_changes/model/location_model.dart';

class HomePageController extends GetxController {
  static String instanceName = "/homepage-controller";

  late Socket socket;

  final RxBool _isLoading = false.obs;
  bool get getIsLoading => _isLoading.value;
  setIsLoading(value) => _isLoading.value = value;

  List<LocationModel> locationList = <LocationModel>[].obs;

  addToList(LocationModel locationModel) {
    locationList.add(locationModel);
    locationList.sort((a, b) => b.time!.compareTo(a.time!));
  }

  @override
  void onInit() {
    super.onInit();
    setIsLoading(true);
    initSocket();
    setIsLoading(false);
  }

  Future<void> initSocket() async {
    setIsLoading(true);
    try {
      socket = io("http://localhost:8000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": true,
        "path": '/socket.io-client'
      });

      socket.connect();

      socket.onConnectTimeout(
        (data) => {
          log(data.toString()),
        },
      );
      socket.onConnectError(
        (data) => {
          log(data.toString()),
        },
      );

      socket.onConnect(
        (data) => {
          log("connect to ${socket.id}"),
        },
      );

      socket.on(
        "position-change",
        (data) => {
          addToList(LocationModel.fromJson(data)),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
