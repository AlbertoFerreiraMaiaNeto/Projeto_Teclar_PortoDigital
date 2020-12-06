import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_login/trocandoDeSenha.dart';

class EsqueceuSenha extends StatefulWidget {
  @override
  _EsqueceuSenhaState createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  TextEditingController cpfController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Usuario> _recuperarDados() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("cpf", isEqualTo: cpfController.text)
        .where("nome", isEqualTo: nomeController.text)
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      Usuario usuario = new Usuario(
          false,
          dados["cpf"],
          dados["email"],
          dados["nome"],
          dados["pontuacao"],
          dados["senha"],
          dados["urlImagemPerfil"]);
      return usuario;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = sizeHeight * 0.867;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 178, 42),
      body: SingleChildScrollView(
        child: Column(
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
                        top: sizeCard * 0.12, bottom: sizeCard * 0.08),
                    child: Center(
                      child: Image.asset(
                        "images/LOGOTIPO.png",
                        fit: BoxFit.contain,
                        height: sizeHeight * 0.15,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Digite o seu CPF:",
                      style: TextStyle(
                        fontFamily: 'Open Sans Extra Bold',
                        color: Color.fromARGB(255, 48, 48, 48),
                        fontStyle: FontStyle.italic,
                        fontSize: sizeWidth * 0.085,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: sizeCard * 0.03,
                          bottom: sizeCard * 0.01,
                          left: sizeWidth * 0.03),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: sizeCard * 0.015),
                            height: sizeCard * 0.12,
                            width: sizeWidth * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: cpfController,
                              maxLength: 11,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite aqui",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontStyle: FontStyle.italic,
                                      fontSize: sizeWidth * 0.04,
                                      color: Color.fromARGB(180, 48, 48, 48))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Insira o seu cpf!';
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: sizeCard * 0.05, bottom: sizeCard * 0.02),
                            child: Center(
                              child: Text(
                                "Digite o seu nome completo:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Open Sans Extra Bold',
                                  color: Color.fromARGB(255, 48, 48, 48),
                                  fontStyle: FontStyle.italic,
                                  fontSize: sizeWidth * 0.085,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: sizeCard * 0.015),
                            height: sizeCard * 0.12,
                            width: sizeWidth * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              controller: nomeController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite aqui",
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
                          ),
                        ],
                      ),
                    ),
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
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "VOLTAR",
                          style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            fontSize: (sizeWidth * 0.35) * 0.18,
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Usuario usuario = await _recuperarDados();
                            if (usuario != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      TrocandoDeSenha(usuario)));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => janelaPopUp(
                                      context, sizeWidth, sizeHeight));
                            }
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
                            fontSize: (sizeWidth * 0.35) * 0.18,
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

  AlertDialog janelaPopUp(context, double sizeWidth, double sizeHeight) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 24,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black)),
      title: Text(
        "Erro!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 93, 30, 132),
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.09,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Usuário não encotrado!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          height: sizeHeight * 0.07,
          width: sizeWidth * 0.65,
          margin: EdgeInsets.only(
              right: sizeWidth * 0.05, bottom: sizeHeight * 0.01),
          child: Expanded(
            child: RaisedButton(
              splashColor: Color(0xfffab611),
              color: Color.fromARGB(255, 93, 30, 132),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Entendi",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Open Sans Extra Bold',
                  fontSize: sizeWidth * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
