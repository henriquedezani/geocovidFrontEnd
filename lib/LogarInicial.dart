import 'package:http/http.dart';
import 'dart:convert';
import 'AlertMonitoramento.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class LogarInicial extends StatefulWidget {
  @override
  _LogarInicialState createState() => _LogarInicialState();
}

class _LogarInicialState extends State<LogarInicial> {
  TextEditingController _controllerUsuarioo = TextEditingController();
  TextEditingController _controllerSenhaa = TextEditingController();
  var cor_sim = false ;
  var cor_nao = false;

  var situacao = '';

  getValuesSF() async {
  print("shared2");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringlogin = prefs.getString('login');
    String stringsenha = prefs.getString('senha');

  print('..' + stringlogin);
    if (stringsenha != null ){
      await logar(context , stringlogin, stringsenha , "");
    }
  }

  _mudarCorSelecionado(valor)
  {
    situacao = valor;
    print(valor);
    if (valor=="sem")
    {
      setState(() {
        cor_nao = false;
        cor_sim = true;

      });
      return '';
    }

    if (valor=="com")
    {
      setState(() {
        cor_nao = true;
        cor_sim = false;
      });
      return '';
    }
  }
  _getPermitions() async {
    Map<PermissionGroup, PermissionStatus> permissions_camera = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    PermissionStatus permissionNames_camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  }
  @override
  void initState() {
    // TODO: implement initState
    _getPermitions();
    getValuesSF();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/fundo.jpg"), fit: BoxFit.cover)),
        child:
    Scaffold(backgroundColor: Colors.transparent,
        body:

        Center(child: Container(width: 400, height: 350,
          child: Card(
              color: Color.fromRGBO(255, 255,255, 0.7),
    child:
      Padding(padding: EdgeInsets.all(20),
        child: Column(children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: true,

              decoration: InputDecoration(
                hintText: 'Email/Telefone',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ), controller: _controllerUsuarioo,
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
              ),controller: _controllerSenhaa,
            )
            ,
            Container(height: 10,),
          Padding(
              padding: const EdgeInsets.all(2),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: (){

                      _mudarCorSelecionado('sem');
                      //Navigator.push(
                      //  context,
                      //  MaterialPageRoute(builder: (context) => ValorFGTS(widget.cidade , "1")),
                      // );

                    },
                    padding: EdgeInsets.all(2),
                    color: cor_sim == true ? Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1) : Colors.white,
                    //color: Color.fromRGBO(globals.cor_escura_R, globals.cor_escura_G, globals.cor_escura_B, 1),
                    child: Text("    Sem Convid19    ", style: TextStyle(color: cor_sim == true ? Colors.white : Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: (){
                      _mudarCorSelecionado('com');
                      //Navigator.pus(
                      // context,
                      //MaterialPageRoute(builder: (context) => RendaTela(widget.cidade , "1" , "0")),
                      //);

                    },
                    padding: EdgeInsets.all(2),
                    color: cor_nao == true ? Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1) : Colors.white,
                    child: Text("    Com Convid19    ", style: TextStyle(color: cor_nao == true ? Colors.white : Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1))),
                  ),
                ),

              ]

              )
            // child: showloading == false ? CircularProgressIndicator() : ListaOrdem()
          )
,
        Container(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: ()
              async {
                var vusuario = _controllerUsuarioo.text;
                var vsenha = _controllerSenhaa.text;
                  await CriarUsuario(context, vusuario, vsenha);
                  await logar(context, vusuario, vsenha , "loja");

              },
              padding: EdgeInsets.all(3),
              color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
              child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cadastrar/Entrar como Loja', style: TextStyle(color: Colors.white) )
                  ],),),
              ),
            ),
          )
            ,
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: ()
                async {
                  var vusuario = _controllerUsuarioo.text;
                  var vsenha = _controllerSenhaa.text;
                  if (situacao == ""){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content:  Text("Informe sua situação."),
                        actions: <Widget>[FlatButton(onPressed: (){Navigator.pop(context);},child: Text("Cancelar"),)],
                      );});
                        }else {
                    await CriarUsuario(context, vusuario, vsenha);
                    await logar(context, vusuario, vsenha , situacao);
                  }
                },
                padding: EdgeInsets.all(3),
                color: Color.fromRGBO(globais.cor_escura_R, globais.cor_escura_G, globais.cor_escura_B, 1),
                child:  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container( width: 200, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cadastrar/Entrar', style: TextStyle(color: Colors.white) )
                    ],),),
                ),

              ),
            )



        ],),
      )

      ),
        ),)) ,);
  }
}
