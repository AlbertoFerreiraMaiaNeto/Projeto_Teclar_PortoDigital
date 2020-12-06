import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/ui_cadastro/4_cadastroEmail.dart';
import 'package:material_splash_screen/ui_cadastro/6_UltimaTelaCadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastrarSenha extends StatefulWidget {
  String nome;
  String cpf;
  String email;

  CadastrarSenha(String nome, String cpf, String email) {
    this.nome = nome;
    this.cpf = cpf;
    this.email = email;
  }
  @override
  _CadastrarSenhaState createState() => _CadastrarSenhaState(nome, cpf, email);
}

class _CadastrarSenhaState extends State<CadastrarSenha> {
  bool _exibirSenha = false;
  bool _exibirSenha2 = false;
  String nome;
  String cpf;
  String email;
  String senha;

  _CadastrarSenhaState(String nome, String cpf, String email) {
    this.nome = nome;
    this.cpf = cpf;
    this.email = email;
  }

  TextEditingController senhaController = TextEditingController();
  TextEditingController senha2Controller = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool teste() {
    if (senhaController.text == senha2Controller.text &&
        (!senhaController.text.isEmpty && !senha2Controller.text.isEmpty)) {
      return true;
    } else {
      return false;
    }
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
                        "Digite uma senha",
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
                      "2 vezes",
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
                      child: Column(
                        children: <Widget>[
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
                                  hintText: "Digite aqui",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontStyle: FontStyle.italic,
                                      fontSize: sizeWidth * 0.046,
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
                                  return 'Insira uma senha!';
                                } else if (value.length < 6) {
                                  return 'Senha muito curta!';
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: sizeCard * 0.015),
                            height: sizeCard * 0.12,
                            width: sizeWidth * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              controller: senha2Controller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite aqui",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: sizeWidth * 0.046,
                                      color: Color.fromARGB(180, 48, 48, 48),
                                      fontStyle: FontStyle.italic),
                                  suffixIcon: GestureDetector(
                                    child: Icon(
                                      _exibirSenha2 == false
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _exibirSenha2 = !_exibirSenha2;
                                      });
                                    },
                                  )),
                              obscureText:
                                  _exibirSenha2 == false ? true : false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Insira o seu cpf!';
                                } else if (teste() == false) {
                                  return 'As senhas não correspondem!';
                                } else if (value.length < 6) {
                                  return 'Senha muito curta!';
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
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => CadastroEmail(nome, cpf)));
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            auth
                                .createUserWithEmailAndPassword(
                                    email: email,
                                    password: senhaController.text)
                                .then((firebaseUser) {
                              print("Novo usuário: sucesso! email:" +
                                  firebaseUser.email);
                            }).catchError((erro) {
                              print("Novo usuário: erro " + erro.toString());
                            });

                            Firestore db = Firestore.instance;
                            db // ? O DocumentReferences foi utilizado nesse caso para obter o doc
                                .collection("usuarios")
                                .document(cpf)
                                .setData({
                              "cpf": cpf,
                              "nome": nome,
                              "email": email,
                              "senha": senhaController.text,
                              "urlImagemPerfil":
                                  "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fna.jpg?alt=media&token=de0a506e-6878-4e3e-ad64-91710a8ebf40",
                              "pontuacao": 0
                            });

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UltimaTelaCadastro()));
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
