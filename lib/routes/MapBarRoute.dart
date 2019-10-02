import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBarRoute extends StatefulWidget
{
  MapBarRoute({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MapBarRouteState();
}

class _MapBarRouteState extends State<MapBarRoute>
{
  GoogleMapController mapController;
  final LatLng _center = const LatLng(48.859201, 2.342820);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
