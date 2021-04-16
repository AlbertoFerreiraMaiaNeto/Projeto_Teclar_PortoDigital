import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/main.dart';
import 'package:material_splash_screen/ui_login/google_auth.dart';
import 'package:material_splash_screen/ui_menu/1_Menu.dart';
import 'package:material_splash_screen/ui_login/esqueceuSenha.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _exibirSenha = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  Future<bool> _recuperarDados() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("email", isEqualTo: emailController.text)
        .where("senha", isEqualTo: senhaController.text)
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = sizeHeight * 0.930;

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
                        top: sizeCard * 0.12, bottom: sizeCard * 0.05),
                    child: Center(
                      child: Image.asset(
                        "images/LOGOTIPO.png",
                        fit: BoxFit.contain,
                        height: sizeHeight * 0.08,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: sizeWidth * 0.40, bottom: sizeCard * 0.007),
                      child: Text(
                        "Faça o seu login:",
                        style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            color: Color.fromARGB(255, 48, 48, 48),
                            fontStyle: FontStyle.italic,
                            fontSize: sizeWidth * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey1,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: sizeCard * 0.04,
                            bottom: sizeCard * 0.01,
                            left: sizeWidth * 0.03),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(right: sizeWidth * 0.500),
                              child: Text(
                                "SEU EMAIL:",
                                style: TextStyle(
                                    fontFamily: 'Open Sans Extra Bold',
                                    color: Color.fromARGB(210, 48, 48, 48),
                                    fontSize: sizeWidth * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: sizeCard * 0.02),
                                  padding:
                                      EdgeInsets.only(left: sizeWidth * 0.020),
                                  height: sizeCard * 0.1,
                                  width: sizeWidth * 0.900,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "DIGITE AQUI",
                                        hintStyle: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontStyle: FontStyle.italic,
                                            fontSize: sizeWidth * 0.04,
                                            color: Color.fromARGB(
                                                180, 48, 48, 48))),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Insira o seu e-mail!';
                                      }
                                      if (!EmailValidator.validate(value)) {
                                        return "E-mail inválido!";
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: sizeCard * 0.01),
                                ),
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.only(top: sizeCard * 0.01),
                            ), // ----------------------------------------------------
                            Padding(
                              padding:
                                  EdgeInsets.only(right: sizeWidth * 0.500),
                              child: Text(
                                "SUA SENHA:",
                                style: TextStyle(
                                    fontFamily: 'Open Sans Extra Bold',
                                    color: Color.fromARGB(210, 48, 48, 48),
                                    fontSize: sizeWidth * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: sizeCard * 0.02),
                                  padding:
                                      EdgeInsets.only(left: sizeWidth * 0.020),
                                  height: sizeCard * 0.1,
                                  width: sizeWidth * 0.900,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textAlign: TextAlign.center,
                                    controller: senhaController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "             DIGITE AQUI",
                                        hintStyle: TextStyle(
                                            fontFamily: 'Open Sans',
                                            fontStyle: FontStyle.italic,
                                            fontSize: sizeWidth * 0.04,
                                            color: Color.fromARGB(
                                                180, 48, 48, 48)),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            _exibirSenha == false
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _exibirSenha = !_exibirSenha;
                                            });
                                          },
                                        )),
                                    obscureText:
                                        _exibirSenha == false ? true : false,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Insira a sua Senha!';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            //?BOTAO DE ENTRAR
                            //-----------------------------------
                            Container(
                                margin:
                                    EdgeInsets.only(top: sizeHeight * 0.025),
                                padding:
                                    EdgeInsets.only(right: sizeWidth * 0.020),
                                child: Container(
                                  height: sizeHeight * 0.072,
                                  width: sizeWidth * 0.900,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (_formKey1.currentState.validate()) {
                                        bool teste = await _recuperarDados();
                                        if (teste == true) {
                                          FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          auth
                                              .signInWithEmailAndPassword(
                                                  email: emailController.text,
                                                  password:
                                                      senhaController.text)
                                              .then((firebaseUser) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MenuInicial()));
                                          }).catchError((erro) {});
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (_) => janelaPopUp(
                                                  sizeWidth, sizeHeight));
                                        }
                                      }
                                    },
                                    textColor: Colors.white,
                                    splashColor: Color(0xfffab611),
                                    color: Color.fromARGB(255, 93, 30, 132),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side: BorderSide(color: Colors.black)),
                                    child: Text(
                                      "ENTRAR",
                                      style: TextStyle(
                                        fontFamily: 'Open Sans Extra Bold',
                                        fontSize: (sizeWidth * 0.35) * 0.18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),

                            // ESQUECI A MINHA SENHA
                            // ---------------------------------------------

                            Container(
                              child: Container(
                                height: sizeHeight * 0.08,
                                width: sizeWidth * 0.75,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.amber, width: 1.0))),
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EsqueceuSenha()));
                                  },
                                  color: Colors.white,
                                  splashColor: Color(0xfffab611),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.white)),
                                  child: Text(
                                    "ESQUECEU A SENHA?",
                                    style: TextStyle(
                                      fontFamily: 'Open Sans Extra Bold',
                                      color: Color.fromARGB(255, 93, 30, 132),
                                      fontSize: (sizeWidth * 0.75) * 0.07,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(top: sizeCard * 0.03),
                            ),
                          ],
                        )),
                  )
                ],
              )),

          // ? BOTÕES DE "VOLTAR" E "ENTRAR"
          //------------------------------------------------------------------------

          Row(
            children: <Widget>[
              //?BOTAO GOOGLE \/
              Container(
                child: Container(
                  height: sizeHeight * 0.08,
                  width: sizeWidth * 0.75,
                  child: RaisedButton.icon(
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      if (provider.isSigninIn) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return provider.login();
                      }
                    },
                    color: Color.fromARGB(255, 93, 30, 132),
                    splashColor: Color(0xfffab611),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.black)),
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.yellow),
                    label: Text(
                      "ENTRAR COM GOOGLE",
                      style: TextStyle(
                        fontFamily: 'Open Sans Extra Bold',
                        color: Colors.white,
                        fontSize: (sizeWidth * 0.65) * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    top: sizeCard * 0.01, left: sizeCard * 0.06),
              ),
            ],
          ),
        ],
      )),
    );
  }

  AlertDialog janelaPopUp(double sizeWidth, double sizeHeight) {
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
        "Usúario ou senha incorreto!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Row(
          children: [
            Container(
              height: sizeHeight * 0.062,
              width: sizeWidth * 0.28,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.11, bottom: sizeHeight * 0.01),
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
                  "Ok",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
