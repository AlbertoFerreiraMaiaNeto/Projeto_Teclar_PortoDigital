import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:material_splash_screen/ui_menu/alterarDados.dart';

class Autentication extends StatefulWidget {
  String email;
  String senha;
  @override
  _AutenticationState createState() => _AutenticationState();
}

class _AutenticationState extends State<Autentication> {
  bool _exibirSenha = false;
  String _email;
  String _senha;

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
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
                      "Digite seu e-mail",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontStyle: FontStyle.italic,
                          fontSize: sizeWidth * 0.060,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: sizeCard * 0.06,
                        bottom: sizeCard * 0.01,
                        left: sizeWidth * 0.03),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: sizeCard * 0.015),
                          height: sizeCard * 0.12,
                          width: sizeWidth * 0.9,
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
                                    color: Color.fromARGB(180, 48, 48, 48))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Insira o seu e-mail!';
                              }
                              if (!EmailValidator.validate(value)) {
                                return "Email inválido!";
                              }
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: sizeCard * 0.04),
                            child: Text(
                              "Digite sua senha",
                              style: TextStyle(
                                  fontFamily: 'Open Sans Extra Bold',
                                  color: Color.fromARGB(255, 48, 48, 48),
                                  fontStyle: FontStyle.italic,
                                  fontSize: sizeWidth * 0.060,
                                  fontWeight: FontWeight.bold),
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
                            controller: senhaController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "             DIGITE AQUI",
                                hintStyle: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontStyle: FontStyle.italic,
                                    fontSize: sizeWidth * 0.04,
                                    color: Color.fromARGB(180, 48, 48, 48)),
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
                            obscureText: _exibirSenha == false ? true : false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Insira a sua Senha!';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.0165),
                  child: Container(
                    height: sizeHeight * 0.082,
                    width: sizeWidth * 0.6,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          email = emailController.text;
                          senha = senhaController.text;
                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: senhaController.text)
                              .then((firebaseUser) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AlterarDados()));
                          }).catchError((erro) {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    janelaPopUp(sizeWidth, sizeHeight));
                          });
                        }
                      },
                      textColor: Colors.white,
                      splashColor: Color(0xfffab611),
                      color: Color.fromARGB(255, 93, 30, 132),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
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
                  ))
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
