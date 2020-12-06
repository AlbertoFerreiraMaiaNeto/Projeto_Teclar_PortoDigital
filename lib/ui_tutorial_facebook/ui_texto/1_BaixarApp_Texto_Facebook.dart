import 'package:flutter/material.dart';
import 'package:material_splash_screen/ui_menu/1_Menu.dart';
import 'package:material_splash_screen/ui_menu/2_Aprendizado.dart';

class BaixarApp_Texto_Facebook extends StatefulWidget {
  int cont;
  String nome;
  String link;

  BaixarApp_Texto_Facebook(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  @override
  _BaixarApp_Texto_FacebookState createState() =>
      _BaixarApp_Texto_FacebookState(cont, nome, link);
}

class _BaixarApp_Texto_FacebookState extends State<BaixarApp_Texto_Facebook> {
  int cont;
  String nome;
  String link;

  _BaixarApp_Texto_FacebookState(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.867) - (sizeHeight * 0.105);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight * 0.08),
        child: AppBar(
          elevation: 6,
          backgroundColor: Color.fromARGB(255, 93, 30, 132),
          title: Text(
            "MENU",
            style:
                TextStyle(fontFamily: 'Open Sans', fontSize: sizeWidth * 0.08),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.dehaze,
              color: Colors.white,
            ),
            iconSize: sizeWidth * 0.10,
            splashColor: Color(0xfffab611),
            onPressed: () {
              Navigator.pushNamed(context, "/Gaveta");
            },
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(30)),
                  color: Colors.white),
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.03,
                  top: sizeHeight * 0.008,
                  bottom: sizeHeight * 0.005),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MenuInicial()));
                },
                icon: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 93, 30, 132),
                  size: sizeWidth * 0.11,
                ),
                splashColor: Color(0xfffab611),
                padding: EdgeInsets.only(right: sizeWidth * 0.00001),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 242, 178, 42),
      body: Column(
        children: [
          Container(
            height: sizeCard,
            width: sizeWidth,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.white),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.08),
                    child: Text(
                      cont.toString() + ". COMO BAIXAR",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 93, 30, 132),
                          fontStyle: FontStyle.italic,
                          fontSize: sizeWidth * 0.08,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: Text(
                      "O APP FACEBOOK:",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 93, 30, 132),
                          fontStyle: FontStyle.italic,
                          fontSize: sizeWidth * 0.08,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.06),
                  child: Center(
                    child: Text(
                      "1º PASSO:",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontSize: sizeWidth * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.06),
                  child: Center(
                    child: Text(
                      "Entre no aplicativo da",
                      style: TextStyle(
                          fontFamily: 'Open Sans Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontSize: sizeWidth * 0.075,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      "Play Store ou AppStore:",
                      style: TextStyle(
                          fontFamily: 'Open Sans Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontSize: sizeWidth * 0.075,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: sizeCard * 0.35,
                  width: sizeCard * 0.9,
                  child: Image.network(
                      "https://www.meupositivo.com.br/doseujeito/wp-content/uploads/2017/11/giphy-4-1.gif"),
                )
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: sizeWidth * 0.06, top: sizeHeight * 0.0165),
                  child: Container(
                    height: sizeHeight * 0.082,
                    width: sizeWidth * 0.4,
                    child: RaisedButton(
                      textColor: Colors.white,
                      splashColor: Color(0xfffab611),
                      color: Color.fromARGB(255, 93, 30, 132),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 200)).then((_) {
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => TelaAprendizado()));
                        });
                      },
                      child: Text(
                        "VOLTAR",
                        style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          fontSize: (sizeWidth * 0.35) * 0.17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      left: sizeWidth * 0.086, top: sizeHeight * 0.0165),
                  child: Container(
                    height: sizeHeight * 0.082,
                    width: sizeWidth * 0.4,
                    child: RaisedButton(
                      onPressed: () {
                        /*
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MenuInicial()));*/
                      },
                      textColor: Colors.white,
                      splashColor: Color(0xfffab611),
                      color: Color.fromARGB(255, 93, 30, 132),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.black)),
                      child: Text(
                        "AVANÇAR",
                        style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          fontSize: (sizeWidth * 0.35) * 0.17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
