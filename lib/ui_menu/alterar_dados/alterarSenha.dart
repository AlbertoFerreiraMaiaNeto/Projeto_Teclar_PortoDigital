import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/alterar_dados/dadosAlterados.dart';

// ignore: camel_case_types
class AlterarSenha extends StatefulWidget {
  @override
  _AlterarSenhaState createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  bool _exibirSenha = false;
  bool _exibirSenha2 = false;

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

  Future<Usuario> _recuperarDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .where("email", isEqualTo: usuarioAtual.email)
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      Usuario usuario = new Usuario(false, dados["cpf"], dados["email"],
          dados["nome"], 0, dados["senha"], dados["urlImagemPerfil"]);
      return usuario;
    }
  }

  Future<Usuario> resetSenha(value) async {
    var message;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();
    usuarioAtual
        .updatePassword(value)
        .then(
          (value) => message = 'Success',
        )
        .catchError((onError) => message = 'error');
    updateDados(value);
    return message;
  }

  void updateDados(String senha) async {
    Usuario usuario = await _recuperarDados();
    Map<String, dynamic> dadosAtualizar = {"senha": senha};
    Firestore db = Firestore.instance;
    db.collection("usuarios").document(usuario.cpf).updateData(dadosAtualizar);
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
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.05),
                    child: Text(
                      "Digite sua senha atual:",
                      style: TextStyle(
                          fontFamily: 'Open Sans Extra Bold',
                          color: Color.fromARGB(255, 48, 48, 48),
                          fontStyle: FontStyle.italic,
                          fontSize: sizeWidth * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.only(top: sizeCard * 0.02),
                      padding: EdgeInsets.only(
                          top: sizeCard * 0.01,
                          bottom: sizeCard * 0.01,
                          left: sizeWidth * 0.03),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: sizeCard * 0.12,
                            width: sizeWidth * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: senhaController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite aqui...",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontStyle: FontStyle.italic,
                                      fontSize: sizeWidth * 0.045,
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
                          Padding(
                            padding: EdgeInsets.only(top: sizeCard * 0.04),
                            child: Text(
                              "Digite uma NOVA senha:",
                              style: TextStyle(
                                  fontFamily: 'Open Sans Extra Bold',
                                  color: Color.fromARGB(255, 48, 48, 48),
                                  fontStyle: FontStyle.italic,
                                  fontSize: sizeWidth * 0.07,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: sizeCard * 0.02),
                            padding: EdgeInsets.only(top: sizeCard * 0.01),
                            height: sizeCard * 0.12,
                            width: sizeWidth * 0.9,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: senha2Controller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Digite aqui...",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: sizeWidth * 0.045,
                                    color: Color.fromARGB(180, 48, 48, 48),
                                    fontStyle: FontStyle.italic,
                                  ),
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
                                  return 'Insira uma senha!';
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
                          Navigator.of(context).pop();
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
                            if (_formKey.currentState.validate()) {
                              resetSenha(senha2Controller.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DadosAlterados(
                                          "Seu Email foi alterado"),
                                      settings: RouteSettings(
                                          name: "/DadosAlterados")));
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
