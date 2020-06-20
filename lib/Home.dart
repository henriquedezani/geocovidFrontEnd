import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'AlertMonitoramento.dart';
import 'MyMaps.dart';
import 'globais.dart' as globais;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  var tipo;
  Home(this.tipo);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    int countTime = 0;
  var monitoramento = 'Parar Monitoramento';


    RemoverLocalizacao( ) async {

      var tokens = "Bearer " + globais.G_token;

     var corpo = json.encode(
          {
            "email": globais.G_Email
          }
      );

      Response r = await post(
        globais.LinkApi +'Coordenada/remover',
        body: corpo

        ,headers: <String, String>{
        'authorization': tokens,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      );

      if (r.statusCode == 200 ) {
        print("===");
        print("coordeada Removida");
      }
      else{
        print("Erro ao remover");
      }

    }






  _inc(){
    //setState(() {
      //countTime = countTime +1;
    //});
    //print(globais.G_token);
    if (globais.G_token == '')
    {
      monitoramento = 'Parar Monitoramento';
    }
    if(countTime % 2 == 0){
      if (globais.G_Tipo != 'loja') {
        getLocation(globais.G_Tipo , "");
        setState(() {
          if (globais.G_token != "") {
            monitoramento = "Monitorando";
          }
        });
      }
    }
    else{
      setState(() {
        if (globais.G_token != "") {monitoramento = "Monitorando..."; }
      });
    }



  }

    TextEditingController _controllerUsuario = TextEditingController();

  @override
  void initState() {
    //_getPermitions();
   // _getLocation();
    new Timer.periodic(new Duration(seconds: 1), (t) => _inc());

   // getValuesSF();
    super.initState();
  }




    _getPermitions()async {
      Map<PermissionGroup, PermissionStatus> permissions_camera = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
      PermissionStatus permissionNames_camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    }

  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("images/fundo.jpg"), fit: BoxFit.cover)),
    child:

    FadeIn(
    child:
    Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Center(child:
    Container( color: Colors.transparent, width: 300, height: 200 , child:
      Card(color: Color.fromRGBO(255, 255,255, 0.7),
      child: Column(children: [
        Container(height: 3,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              var jsonCoordenadas = await GetGeoLocalizacoes();
              print("json antes " + jsonCoordenadas );
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MyMaps(jsonCoordenadas)));
              },
            padding: EdgeInsets.all(3),
            color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
            child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Visão Geral', style: TextStyle(color: Colors.white) )
                  ,  Icon(
                    Icons.help,
                    color: Colors.white,
                  )
                ],),),
            ),

          ),
        ),
        Container(height: 3,),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: (){
               // if (monitoramento == "Monitorando" || monitoramento == "Monitorando..."){
                  StopMonitoramento(context);
               // }else
               //   {
              //      Navigator.pop(context);
                   // AlterarLogin(context);
                //  }
              },
            padding: EdgeInsets.all(3),
            color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
            child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monitoramento, style: TextStyle(color: Colors.white) )
                  ,  Icon(
                    Icons.help,
                    color: Colors.white,
                  )
              ],),),
            ),

          ),
        )
,
        Container(height: 3,),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: (){
              InserirLojaAberta(context);
              },
            padding: EdgeInsets.all(3),
            color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
            child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Registar Loja Aberta', style: TextStyle(color: Colors.white) )
                  ,  Icon(
                    Icons.help,
                    color: Colors.white,
                  )
                ],),),
            ),

          ),
        ),
        Container(height: 3,),


    ],),))
    ) ])),);
  }
}
