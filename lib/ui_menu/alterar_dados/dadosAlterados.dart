import 'package:flutter/material.dart';

class DadosAlterados extends StatefulWidget {
  String alt;

  DadosAlterados(String alt) {
    this.alt = alt;
  }

  @override
  _DadosAlteradosState createState() => _DadosAlteradosState(alt);
}

class _DadosAlteradosState extends State<DadosAlterados> {
  String alt;

  _DadosAlteradosState(String alt) {
    this.alt = alt;
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = sizeHeight * 0.867;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 178, 42),
        body: Column(
          children: [
            Container(
              height: sizeCard,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: sizeCard * 0.15, bottom: sizeCard * 0.04),
                    child: Center(
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidoso2.png?alt=media&token=05b6c274-8504-4170-809c-44ff32f00f6a",
                        fit: BoxFit.contain,
                        height: sizeHeight * 0.4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: sizeCard * 0.06),
                    child: Text(
                      alt,
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 93, 30, 132),
                          fontSize: sizeWidth * 0.065,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "com sucesso!",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 93, 30, 132),
                          fontSize: sizeWidth * 0.065,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: sizeCard * 0.025),
                    child: Container(
                        height: sizeHeight * 0.006,
                        width: sizeWidth * 0.07,
                        color: Color(0xfffab611)
                        //color: Color(0xff670099).withOpacity(0.69),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: sizeHeight * 0.025),
              height: sizeHeight * 0.082,
              width: sizeWidth * 0.6,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/Menu");
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
                    fontSize: (sizeWidth * 0.35) * 0.18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
