import 'package:flutter/material.dart';
import 'package:material_splash_screen/ui_cadastro/3_cadastroCPF.dart';
import 'package:material_splash_screen/ui_cadastro/cadastroVideo.dart';

class CadastrarNome extends StatefulWidget {
  @override
  _CadastrarNomeState createState() => _CadastrarNomeState();
}

class _CadastrarNomeState extends State<CadastrarNome> {
  TextEditingController nomeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = sizeHeight * 0.867;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 178, 42),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: sizeCard,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black38),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: sizeCard * 0.12, bottom: sizeCard * 0.04),
                    child: Center(
                      child: Image.asset(
                        "images/LOGOTIPO.png",
                        fit: BoxFit.contain,
                        height: sizeHeight * 0.15,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: sizeCard * 0.04),
                      child: Text(
                        "Digite seu",
                        style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            color: Color.fromARGB(255, 48, 48, 48),
                            fontStyle: FontStyle.italic,
                            fontSize: sizeWidth * 0.090,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "nome completo:",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontStyle: FontStyle.italic,
                          fontSize: sizeWidth * 0.090,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: sizeCard * 0.06,
                            bottom: sizeCard * 0.01,
                            left: sizeWidth * 0.03),
                        child: Container(
                          padding: EdgeInsets.only(right: sizeCard * 0.015),
                          height: sizeCard * 0.12,
                          width: sizeWidth * 0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            controller: nomeController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "DIGITE AQUI",
                                hintStyle: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontStyle: FontStyle.italic,
                                    fontSize: sizeWidth * 0.04,
                                    color: Color.fromARGB(180, 48, 48, 48))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Insira o seu nome completo!';
                              }
                            },
                          ),
                        )),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: sizeWidth * 0.06, top: sizeHeight * 0.025),
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
                                builder: (context) => Cadastrar1()));
                          });
                        },
                        child: Text(
                          "VOLTAR",
                          style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            fontSize: (sizeWidth * 0.35) * 0.16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: sizeWidth * 0.086, top: sizeHeight * 0.025),
                    child: Container(
                      height: sizeHeight * 0.082,
                      width: sizeWidth * 0.4,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CadastrarCPF(nomeController.text)));
                          }
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
                            fontSize: (sizeWidth * 0.35) * 0.16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
