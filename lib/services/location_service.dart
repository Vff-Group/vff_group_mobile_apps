import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:vff_group/services/models/user_location.dart';

class LocationService {
  late UserLocation _currentLocation;

  var location = Location();

  //Continuously get users location
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  //Constructor to request Permissions
  LocationService() {
    location.requestPermission().then((value) {
//If location is granted
      if (value != false) {
        location.onLocationChanged.listen((locationData) {
          if(locationData != null){
            _locationController.add(UserLocation(latitude: locationData.latitude, longitude: locationData.longitude));
          }
         });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } catch (e) {
      print('Could not get the user location::${e}');
    }
    return _currentLocation;
  }
}
