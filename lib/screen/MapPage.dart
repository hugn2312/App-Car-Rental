import 'dart:async';

import 'package:app_car_rental/const/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}
class _MappageState extends State<Mappage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(10.835028663909592, 106.72496926945131);
  static const LatLng destination = LatLng(10.848587796547768, 106.72919251344202);
  List <LatLng> polylineCoordinates =[];
  void getPolyPoints () async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude),);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(
        LatLng(point.latitude, point.longitude)
      ));
      setState(() {
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getPolyPoints();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vị trí của bạn và xe thuê'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation, zoom: 14.5
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          getPolyPoints();
        },
        polylines: {Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
          color: Colors.black
        ),},
        markers: {
          Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
          ),
          Marker(
            markerId: MarkerId("destinaton"),
            position: destination,
          ),
        },
      )
    );
  }
}
