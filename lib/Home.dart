import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _positionCamera =
      CameraPosition(target: LatLng(-23.565160, -46.651797), zoom: 19);
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_positionCamera));
  }

  _loadMarkers() {
    /*Set<Marker> markerLocal = {};

    Marker markerMall = Marker(
        markerId: MarkerId("marker-mall"),
        position: LatLng(-23.563370, -46.652923),
        infoWindow: InfoWindow(
            title: "Mall City of São Paulo"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueMagenta
        ),
        onTap: (){
          print("Mall!!");
        }
      //rotation: 45
    );

    Marker markerRegistry = Marker(
        markerId: MarkerId("marker-registry"),
        position: LatLng(-23.562868, -46.655874),
        infoWindow: InfoWindow(
            title: "12 Notes Registry"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue
        ),
        onTap: (){
          print("Registry!!");
        }
    );

    markerLocal.add( markerMall );
    markerLocal.add( markerRegistry );

    setState(() {
      _markers = markerLocal;
    });

    //Set<Polygon> listPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 20,
        points: [
          LatLng(-23.561816, -46.652044),
          LatLng(-23.563625, -46.653642),
          LatLng(-23.564786, -46.652226),
          LatLng(-23.563085, -46.650531),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("click 1");
        },
        zIndex: 1
    );

    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon2"),
        fillColor: Colors.blue[50],
        strokeColor: Colors.blue[300],
        strokeWidth: 20,
        points: [
          LatLng(-23.561629, -46.653031),
          LatLng(-23.565189, -46.651872),
          LatLng(-23.562032, -46.650831),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("click 2");
        },
        zIndex: 0
    );

    //listPolygons.add( polygon1 );
    listPolygons.add( polygon2 );

    setState(() {
      _polygons = listPolygons;
    });*/

    Set<Polyline> listPolylines = {};
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
        color: Colors.red,
        width: 40,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: [
          LatLng(-23.563645, -46.653642),
          LatLng(-23.565160, -46.651797),
          LatLng(-23.563232, -46.648020),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("CLICK AT AREA");
        });

    listPolylines.add(polyline);
    setState(() {
      _polylines = listPolylines;
    });
  }

  _getCurrentLocation() async {
    var geoLocator = Geolocator();
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //-23.570893, -46.644995
    //-23,570893, -46,644995

    setState(() {
      _positionCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
      _moveCamera();
    });
  }

  _addListenerLocation() {
    var geoLocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    geoLocator.getPositionStream(locationOptions).listen((Position position) {
      print("Current location: " + position.toString());

      Marker markerUser = Marker(
          markerId: MarkerId("marker-user"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "My local"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          onTap: () {
            print("Click at my local!!");
          }
          //rotation: 45
          );

      setState(() {
        //-23.566989, -46.649598
        //-23.568395, -46.648353
        //_marcadores.add( marcadorUsuario );
        _positionCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
        _moveCamera();
      });
    });
  }

  _getLocalToAddress() async {
    List<Placemark> listAddress =
        await Geolocator().placemarkFromAddress("Av. Paulista, 1372");

    print("total: " + listAddress.length.toString());

    if (listAddress != null && listAddress.length > 0) {
      Placemark address = listAddress[0];
      String result;
      result = "\n administrativeArea " + address.administrativeArea;
      result += "\n subAdministrativeArea " + address.subAdministrativeArea;
      result += "\n locality " + address.locality;
      result += "\n subLocality " + address.subLocality;
      result += "\n thoroughfare " + address.thoroughfare;
      result += "\n subThoroughfare " + address.subThoroughfare;
      result += "\n postalCode " + address.postalCode;
      result += "\n country " + address.country;
      result += "\n isoCountryCode " + address.isoCountryCode;
      result += "\n position " + address.position.toString();

      print("result: " + result);
      //-23.565564, -46.652753

    }
  }

  _getAddressToLatLong() async {
    List<Placemark> listAddress =
        await Geolocator().placemarkFromCoordinates(-23.565564, -46.652753);

    print("total: " + listAddress.length.toString());

    if (listAddress != null && listAddress.length > 0) {
      Placemark address = listAddress[0];

      String result;

      result = "\n administrativeArea " + address.administrativeArea;
      result += "\n subAdministrativeArea " + address.subAdministrativeArea;
      result += "\n locality " + address.locality;
      result += "\n subLocality " + address.subLocality;
      result += "\n thoroughfare " + address.thoroughfare;
      result += "\n subThoroughfare " + address.subThoroughfare;
      result += "\n postalCode " + address.postalCode;
      result += "\n country " + address.country;
      result += "\n isoCountryCode " + address.isoCountryCode;
      result += "\n position " + address.position.toString();

      print("result: " + result);
      //-23.565564, -46.652753

    }
  }

  @override
  void initState() {
    super.initState();
    //_loadMarkers();
    //_getCurrentLocation()
    _addListenerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps and Geo"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _moveCamera,
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          //-23.562436, -46.655005
          initialCameraPosition: _positionCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          /*
          initialCameraPosition:
              CameraPosition(target: LatLng(-23.563370, -46.652923), zoom: 16),
          onMapCreated: _onMapCreated,
          */
          markers: _markers,
          //polygons: _polygons,
          //polylines: _polylines,
        ),
      ),
    );
  }
}
