// ignore: constant_identifier_names
const GOOGLE_API_KEY = "AIzaSyBXWb-TCNbd2nlaVWc3qzBTfE6325kaW2A";

class LocationHelper {
  static String genLocationImage(
      {required double? latitude, required double? longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
}
