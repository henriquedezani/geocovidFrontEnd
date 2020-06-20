import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AlertMonitoramento.dart';
import 'globais.dart' as globais;
import 'package:geocovid/Home.dart';

class MyMaps extends StatefulWidget {

  var JsonCoordenadas;

  MyMaps(this.JsonCoordenadas);


  @override
  _MyMapsState createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  Completer<GoogleMapController> _controller = Completer();

  var LatPosition;
  var LongPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition _cameraPosition = CameraPosition(target: LatLng(-20.815239, -49.395760));

  TextEditingController _controllerSearch = TextEditingController();

  Future<void> _addMakers(Lat , Lon , Id , Label, descricao) async {
    print("markers" + Label);
    print("markerasdasds" + descricao);
  print(Id);
    if (Id.toString().toLowerCase() == 'loja'.toLowerCase()) { Label = descricao;}

  var markerIdVal = Id;
    final MarkerId markerId = MarkerId(markerIdVal);
    print("add markers...");
    // creating a new MARKER
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(Lat, Lon),
      icon: Label == "com" ? Doente : Label =="sem" ? Recuperado : Loja,
      infoWindow: InfoWindow(title: descricao, snippet: '*'),
      onTap: () {
      },
    );

    ///setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
 //   });
  }


  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _movimentarcamera(CameraPosition cameP) async {
    GoogleMapController googleMapController =  await _controller.future;
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameP)
    );
  }

  _adicionarListenerLocalizacao() async {

    //Position position = await Geolocator().getCurrentPosition(
      //  desiredAccuracy: LocationAccuracy.high);

//   var  LatPositionn = position.latitude;
   //var  LongPositionn = position.longitude;

    //print(LatPositionn);
//    var geolocator = geo.Geolocator();
   // var locationOptions = geo.LocationOptions( accuracy: geo.LocationAccuracy.high,distanceFilter: 10);
  //print("camera ");
    LatPosition = globais.G_latitude ;
    LongPosition = globais.G_Longitude ;
//print(LatPosition);
    setState(() {
      _cameraPosition = CameraPosition(target: LatLng(LatPosition, LongPosition),zoom: 5);
    });


    /*geolocator.getPositionStream(locationOptions).listen((geo.Position position){
      LatPosition = position.latitude;
      LongPosition = position.longitude;
      print(LatPosition);
      _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 2);
      _movimentarcamera(_cameraPosition);
    });*/

  }

 /* static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-20.820718, -49.400013),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);*/
@override


_GerenciarMakers(String jsonStr) async {
  var decoded = json.decode(jsonStr);

  print('888'+decoded[0]['tipo']);


     await BitmapDescriptor.fromAssetImage(
       ImageConfiguration(size: Size(1, 1)), 'images/recuperado.png')
        .then((onValue) {
       Recuperado = onValue;
       });



    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'images/doente.png')
        .then((onValue) {
      Doente = onValue;
    });

  await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)), 'images/loja.png')
      .then((onValue) {
    Loja = onValue;
  });

  String email = decoded[0]['email'];
 print(email);

 // String latitude = decoded[0]['latitude'];
 // print(latitude);

//  String longitude = decoded[0]['longitude'];
 // print(longitude);

    for (var word in decoded) {

   String email = word['email'];
   String latitude = word['latitude'];
   String longitude = word['longitude'];
   String tipo = word['tipo'];

   String observacao = word['observacao'];

    print(observacao);
   print(globais.G_Longitude);
   //print(globais.G_Longiude);
print(word['longitude']);
   calculateDistance(double.parse(word['latitude']),double.parse(word['longitude']));

if (tipo == 'loja'){
  if (_controllerSearch.text == ''){
    _addMakers(
        double.parse(latitude), double.parse(longitude), email, tipo, observacao);
  }else{
    if (observacao.toLowerCase().contains(_controllerSearch.text.toLowerCase())){
      _addMakers(
          double.parse(latitude), double.parse(longitude), email, tipo, observacao);
    }else{

    }

  }
}
else {
  _addMakers(
      double.parse(latitude), double.parse(longitude), email, tipo, observacao);
}
  }
    setState(() {
      var size = markers.length;
    });

}

  void initState() {
    // TODO: implement initState
    //print('printjson '+ widget.JsonCoordenadas.toString());
    //_GerenciarMakers(widget.JsonCoordenadas);

  //_adicionarListenerLocalizacao();
  new Timer.periodic(new Duration(seconds: 1), (t) => _adicionarListenerLocalizacao());
  new Timer.periodic(new Duration(seconds: 10), (t) => _autalizarMakers());



    super.initState();
  }

  Future<double> calculateDistance(lat1, lon1) async {

    double lat2;
    double lon2;


    //Position position = await Geolocator().getCurrentPosition(
      //  desiredAccuracy: LocationAccuracy.high);

    lat2 = globais.G_latitude;
    lon2 = globais.G_Longitude;
    print(lat2);
    print(lat1);

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    print("distance");
    print(12742 * asin(sqrt(a)));

    print(lat2.toString()+","+lon2.toString() + "," + lat1.toString() + "," + lon1.toString() + ",");

    var resultado = 12742 * asin(sqrt(a));
    print(resultado);
    print(resultado * 1000);
    if (lat1 != lat2) {

      if (resultado  < 100 && resultado != 0) {
        print("MAIOR");
        /*await showDialog(context: context, builder: (context){
        return AlertDialog(
          content:  Text("Você está perto demais de uma pessoa com Covid19"),
          actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
        );});
      Navigator.pop(context);

       */
      }
    }

    return 12742 * asin(sqrt(a));
  }

_autalizarMakers() async {
  print('refresh a makers');
  var jsonCoordenadas = await GetGeoLocalizacoes();
  _GerenciarMakers(jsonCoordenadas);
}
  BitmapDescriptor Doente;
  BitmapDescriptor Recuperado;
  BitmapDescriptor Loja;
  @override

  Widget build(BuildContext context) {
    return new Scaffold(

          floatingActionButton: Stack(
            children: <Widget>[
              //    Padding(padding: EdgeInsets.only(left:31),
              //  child:
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(padding: EdgeInsets.only(left: 20) ,child:  FloatingActionButton.extended(
                    onPressed: (){Navigator.pop(context);},
                    icon: Icon(Icons.arrow_back),
                    //label: Text("Voltar"),
                    label:  Container(width: 0,height: 0,) ,
                    heroTag:1,)
                    ,
                  )),


            ],
          ),
                  appBar: AppBar(title:      TextFormField(
                    keyboardType: TextInputType.multiline,
                    autofocus: true,

                    decoration: InputDecoration(
                      hintText: 'Pesquisar Loja',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ), controller: _controllerSearch,
                  )
                  ) ,
      body: SafeArea(child:
      GoogleMap(
        markers: Set<Marker>.of(markers.values),
        initialCameraPosition: _cameraPosition ,
        //heroTag:1,)
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,

       // onMapCreated: (GoogleMapController controller) {
         // _controller.complete(controller);
        //},
      ),),
      //floatingActionButton:
      //FloatingActionButton.extended(
      //onPressed: (){},
 //     label: Image.asset('images/doente.png'),
      //label: Text(''),
       // icon: Icon(Icons.directions_boat),
     //),
    );
  }

}