import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:location_track/model/location_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePageController extends GetxController {
  static String instanceName = "/homepage-controller";

  late Socket socket;
  Location location = Location();

  final RxBool _isLoading = false.obs;
  bool get getIsLoading => _isLoading.value;
  setIsLoading(value) => _isLoading.value = value;

  @override
  void onInit() {
    super.onInit();
    setIsLoading(true);
    checkPermissons();
    initSocket();
    listenChanges();
    setIsLoading(false);
  }

  Future<void> initSocket() async {
    setIsLoading(true);
    try {
      socket = io("http://192.168.1.33:8000", <String, dynamic>{
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
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendDataToApi({required LocationModel location}) async {
    socket.emit(
      "position-change",
      jsonEncode(location.toMap()),
    );
  }

  Future<bool> checkPermissons() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future listenChanges() async {
    if (await checkPermissons()) {
      log("Listening changes ...");
      location.onLocationChanged.listen((LocationData currentLocation) {
        sendDataToApi(
          location: LocationModel(
              latitude: currentLocation.latitude,
              longitude: currentLocation.longitude,
              time: DateTime.now().toString()),
        );
      });
    }
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
