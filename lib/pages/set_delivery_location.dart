import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vff_group/routings/route_names.dart';
import 'package:vff_group/utils/app_colors.dart';
import 'package:vff_group/utils/app_styles.dart';
import 'package:vff_group/widgets/toolbar_custom.dart';

class SetDeliveryLocationPage extends StatefulWidget {
  const SetDeliveryLocationPage({super.key});

  @override
  State<SetDeliveryLocationPage> createState() =>
      _SetDeliveryLocationPageState();
}

class _SetDeliveryLocationPageState extends State<SetDeliveryLocationPage> {
//   void main() async {
//   // Get the user's current location.
//   Position position = await Geolocator.getCurrentPosition();

//   // Get the user's latitude and longitude.
//   double latitude = position.latitude;
//   double longitude = position.longitude;

//   // Print the user's latitude and longitude to the console.
//   print('Latitude: $latitude');
//   print('Longitude: $longitude');
// }
  LatLng _userLocation = LatLng(0.0, 0.0);

  // Get the user's current location.
  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    print("position::$position");
    // Set the user's current location.
    _userLocation = LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();

    // Get the user's current location.
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Set Delivery Location',
            style: nunitoStyle.copyWith(
              color: AppColors.backColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: AppColors.secondaryBackColor,
        body: GoogleMap(
          // Set the user's current location.
          initialCameraPosition: CameraPosition(
            target: _userLocation,
            zoom: 15,
          ),
        ));
  }
}
