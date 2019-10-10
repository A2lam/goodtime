import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goodtime/models/Bar.dart';
import 'package:goodtime/services/BarService.dart';

class MapBarRoute extends StatefulWidget
{
  final BarService _barService = new BarService();
  final bool isFavBarScreen;

  MapBarRoute({ Key key, this.isFavBarScreen }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MapBarRouteState();
}

class _MapBarRouteState extends State<MapBarRoute>
{
  Map<String, Marker> _markers = {};
  final LatLng _initialMapPosition = const LatLng(48.859201, 2.342820);

  /// Construct markers for all bars
  void _loadBarMarkers() {
    widget._barService.getBars().then((bars) => {
      setState(() {
        _markers.clear();
        for (Bar bar in bars) {
          final marker = Marker(
            markerId: MarkerId(bar.id.toString()),
            position: LatLng(bar.address.latitude, bar.address.longitude),
            infoWindow: InfoWindow(
              title: bar.name,
              snippet: bar.address.number.toString() + " " + bar.address.street + ", " + bar.address.post_code.toString() + " " + bar.address.city,
            ),
          );
          _markers[bar.id.toString()] = marker;
        }
      })
    });
  }

  /// Construct markers for user fav bars
  void _loadFavBarMarkers() {
    widget._barService.getBars().then((bars) => {
      setState(() {
        _markers.clear();
        for (Bar bar in bars) {
          final marker = Marker(
            markerId: MarkerId(bar.id.toString()),
            position: LatLng(bar.address.latitude, bar.address.longitude),
            infoWindow: InfoWindow(
              title: bar.name,
              snippet: bar.address.number.toString() + " " + bar.address.street + ", " + bar.address.post_code.toString() + " " + bar.address.city,
            ),
          );
          _markers[bar.id.toString()] = marker;
        }
      })
    });
  }

  /// Map Initialization
  void _onMapCreated(GoogleMapController controller) {
    super.initState();
    if (widget.isFavBarScreen)
      _loadFavBarMarkers();
    else
      _loadBarMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialMapPosition,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
