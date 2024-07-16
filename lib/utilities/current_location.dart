import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  bool _isLocationPicked = false;
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {
    await requestLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    _isLocationPicked = true;
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': "${placemarks.first.street!}, ${placemarks.first.locality!}",
      'isLocationPicked': _isLocationPicked,
    };
  }
}

void main() async {
  LocationService locationService = LocationService();

  try {
    Map<String, dynamic> locationData =
        await locationService.getCurrentLocation();
    print("Latitude: ${locationData['latitude']}");
    print("Longitude: ${locationData['longitude']}");
    print("Address: ${locationData['address']}");
  } catch (e) {
    print("Error getting location: $e");
  }
}
