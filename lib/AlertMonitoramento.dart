import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Home.dart';
import 'globais.dart' as globais;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

TextEditingController _controllerUsuario = TextEditingController();
TextEditingController _controllerSenha = TextEditingController();

TextEditingController _controllerObservacoes = TextEditingController();



logar(context , contUsuario, contSenha , tipo) async {

  //if (kIsWeb) {
    //globais.LinkApi = 'http://localhost:5000/api/';
  //}

print("logar" + tipo);
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year);


  print(contUsuario);

  String username = contUsuario;
  String password = contSenha;

  if ( username == "" || password ==""){

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content:  Text("Email/Telefone ou Senha em branco"),
        actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
      );}
    );
    return "";
  }
  var bytes = utf8.encode(password);
  var base64Str = base64.encode(bytes);

  var corpo = json.encode(
  {
  "EmailTelefone": username.toLowerCase(),
  "senha": base64Str
  }
  );

  Response r = await post(
    globais.LinkApi +'login',
    body: corpo

    ,headers: {"Content-Type": "application/json"},
  );

print(json.decode(r.body)["token"]);

if (r.statusCode == 200 ) {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String emailShared = contUsuario;
  String senhaShared = contSenha;

  await prefs.setString('login', emailShared);
  await prefs.setString('senha', senhaShared);

  globais.G_Email = contUsuario.toLowerCase();
  globais.G_token = json.decode(r.body)["token"];

  if (json.decode(r.body)["coordenada"] == null){
    globais.G_Tipo = tipo;
  }else {
    print(globais.G_Tipo = json.decode(r.body)["coordenada"]["tipo"]);
    globais.G_Tipo = json.decode(r.body)["coordenada"]["tipo"];
  }


  Navigator.push(context, MaterialPageRoute(
      builder: (context) => Home(globais.G_Tipo)));
  }
  if (r.statusCode == 401 ) {
    showDialog(context: context, builder: (context){
      return AlertDialog(

        content:  Text("Usuário ou Senha Invalido"),
        actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Voltar"),)],
      );}
    );
  }else if (r.statusCode != 200 ) {

    showDialog(context: context, builder: (context){
      return AlertDialog(

        content:  Text("Sem Conexão com o Banco de Dados"),

        actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Voltar"),)],
      );});

  }

  //return globais.G_token;
}

CriarUsuario(context , username, password) async {

  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year);

  //String username = _controllerUsuario.text;
  //String password = _controllerSenha.text;

  if ( username == "" || password ==""){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content:  Text("Email/Telefone ou Senha em branco"),
        actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
      );}
    );
    return "";
  }
  var bytes = utf8.encode(password);
  var base64Str = base64.encode(bytes);

  var corpo = json.encode(
      {
        "EmailTelefone": username.toLowerCase(),
        "senha": base64Str
      }
  );

  Response r = await post(
    globais.LinkApi +'usuario',
    body: corpo

    ,headers: {"Content-Type": "application/json"},
  );

  if (r.statusCode == 200 ) {
   // globais.G_token = json.decode(r.body)["access_token"];
  }
  //Navigator.pop(context);

  if (r.statusCode == 401 ) {
    //showDialog(context: context, builder: (context){
    //  return AlertDialog(

     //   content:  Text("Usuário ou Senha Invalido"),
     //   actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Voltar"),)],
     // );}
   // );
  }else if (r.statusCode != 200 ) {

   // showDialog(context: context, builder: (context){
     // return AlertDialog(

       // content:  Text("Sem Conexão com o Banco de Dados"),

        //actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Voltar"),)],
      //);});

  }else if (r.statusCode == 200 ) {

  }
  return globais.G_token;

}


AlterarLogin(context) async {


  return showDialog(context: context, builder: (context){
    return AlertDialog(
    //  title: Center(child:Text("Selecione um Analista" ) ,),
      content:

      Container( color: Colors.white ,
        height: 200.0,
        width: 340.0,
        child:
        Column(children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: true,

            decoration: InputDecoration(
              hintText: 'Email/Telefone',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ), controller: _controllerUsuario,
          )
          ,
          Container(height: 10,)
          ,
          TextField(
            obscureText: true,
            onSubmitted: (value){

            },
            decoration: InputDecoration(
              hintText: 'Senha',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),controller: _controllerSenha,
          )
          ,
          Container(height: 10,)

          ,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: ()
              async {
               // await CriarUsuario(context ,"" ,"");
                var vusuario = _controllerUsuario.text;
                var vsenha = _controllerSenha.text;

               // await logar(context , vusuario , vsenha);
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(3),
              color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
              child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ativar Monitoramento', style: TextStyle(color: Colors.white) )
                    ,
                    //Icon(
                      //Icons.help,
                   //   color: Colors.white,
                  //  )
                  ],),),
              ),

            ),
          )

        ],),


      )
      ,

      actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
    );});


}

RemoverLocalizacao( ) async {

  var tokens = "Bearer " + globais.G_token;

  var corpo = json.encode(
      {
        "email": globais.G_Email.toLowerCase()
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
    globais.G_Email = "";
    globais.G_token = "";



      SharedPreferences prefs = await SharedPreferences.getInstance();
      String stringlogin = prefs.getString('');
      String stringsenha = prefs.getString('');

    print(r.body);
    print("===");
    print("coordeada Removida");
  }
  else{
    print("Erro ao remover");
  }

}


StopMonitoramento(context) async {


  return showDialog(context: context, builder: (context){
    return AlertDialog(
      content:

      Container( color: Colors.white ,
        height: 130.0,
        width: 340.0,
        child:
        Column(children: [
          Text("Tem Certeza que deseja Parar o \nMonitoramento e remover a localização salva")
          ,

          Container(height: 10,)
          ,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: ()
              async {
                await RemoverLocalizacao();
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(3),
              color: Colors.red,
              child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Parar Monitoramento', style: TextStyle(color: Colors.white) )
                  ],),),
              ),

            ),
          )

        ],),


      )
      ,

      actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
    );});


}
GetGeoLocalizacoes() async {

  print('getting coordenadas');
  var tokens = "Bearer " + globais.G_token;
  Response r = await get(
    globais.LinkApi +'Coordenada',
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json"
    },
  );


  if (r.statusCode == 200 ) {
    return(r.body);
    print(r.body);
    print("===");
    print("coordeada atualizada");
  }
  else{
    print("Erro");
  }

}



InserirLojaAberta(context) async {

  _controllerObservacoes.text = "";
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      content:
     Container( color: Colors.white ,
        height: 200.0,
        width: 340.0,
        child:
        Column(children: [
          Container(height: 10,)
          ,
          TextFormField(
            keyboardType: TextInputType.multiline,
            autofocus: true,

            decoration: InputDecoration(
              hintText: 'Descricao Loja',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ), controller: _controllerObservacoes,
          )
          ,
          Container(height: 10,)

          ,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: ()
              async {
                globais.G_Tipo = 'loja';
                getLocation("loja", _controllerObservacoes.text);
//                GravarGeoLocalizacao(globais.G_latitude ,globais.G_Longitude,"loja", _controllerObservacoes.text);
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(3),
              color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
              child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cadastrar Loja', style: TextStyle(color: Colors.white) )
                  ],),),
              ),

            ),
          )

        ],),


      )
      ,

      actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
    );});


}


GravarGeoLocalizacao(Latitude , Longitude , tipo , observacoes ) async {

  var tokens = "Bearer " + globais.G_token;

  globais.G_latitude = Latitude;
  globais.G_Longitude = Longitude;

  print("99" +globais.G_Email.toLowerCase() +"99");
  var corpo = json.encode(
      {
        "email": globais.G_Email.toLowerCase(),
        "latitude": Latitude.toString(),
        "longitude": Longitude.toString(),
        "tipo": tipo,
        "observacao": observacoes
      }
  );

  Response r = await post(
    globais.LinkApi +'Coordenada',
    body: corpo

    ,headers: <String, String>{
    'authorization': tokens,
    "Content-Type": "application/json",
    "Accept": "application/json"
  },
  );


  if (r.statusCode == 200 ) {
    print("===");
    print("coordeada atualizada");
  }
  else{
    print("Erro");
  }

}


getLocation(tipo , descricao) async {
  var LatPositionn;
  var LongPositionn;

  Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  LatPositionn = position.latitude;
  LongPositionn = position.longitude;

  globais.G_latitude = position.latitude;
  globais.G_Longitude = position.longitude;

  GravarGeoLocalizacao(LatPositionn,LongPositionn ,tipo,descricao);

}