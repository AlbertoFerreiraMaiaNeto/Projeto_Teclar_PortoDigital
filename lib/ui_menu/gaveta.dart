import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/meusCursos.dart';
import 'package:material_splash_screen/ui_menu/ranking.dart';

class GavetaMenu extends StatefulWidget {
  @override
  _GavetaMenuState createState() => _GavetaMenuState();
}

class _GavetaMenuState extends State<GavetaMenu> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String usuarioAtual;

  Stream<QuerySnapshot> _adicionarDados() {
    Firestore db = Firestore.instance;
    final stream = db
        .collection("usuarios")
        .orderBy("pontuacao", descending: true)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  String firstName(String n) {
    var sp = n.split(" ");

    if (sp[0].length >= 10) {
      var repart = sp[0].substring(0, 10);
      var repart2 = sp[0].substring(10, sp[0].length);
      return repart + "-" + "\n" + repart2;
    } else {
      return sp[0];
    }
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    usuarioAtual = usuarioLogado.email;

    _adicionarDados();
  }

  Future<String> usuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    return usuarioLogado.email;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
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
            onPressed: () {},
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
                  Navigator.pushNamed(context, "/Menu");
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
          SingleChildScrollView(
            child: Container(
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
                  StreamBuilder<QuerySnapshot>(
                      stream: _controller.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Container(
                              color: Colors.white,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Carregando Dados",
                                      style: TextStyle(
                                        fontFamily: 'Open Sans Extra Bold',
                                        color: Color.fromARGB(255, 48, 48, 48),
                                        fontStyle: FontStyle.italic,
                                        fontSize: sizeWidth * 0.07,
                                      ),
                                    ),
                                    CircularProgressIndicator()
                                  ],
                                ),
                              ),
                            );
                            break;
                          case ConnectionState.active:
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text("Erro ao carregar os dados!");
                            } else {
                              QuerySnapshot querySnapshot = snapshot.data;

                              if (querySnapshot.documents.length == 0) {
                                return Center(
                                  child: Text(
                                    "Sem Usuários!",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: querySnapshot.documents.length,
                                  itemBuilder: (context, indice) {
                                    List<DocumentSnapshot> usuarios =
                                        querySnapshot.documents.toList();
                                    DocumentSnapshot item = usuarios[indice];
                                    String cpf = item["cpf"];
                                    String email = item["email"];
                                    String nome = item["nome"];
                                    String senha = item["senha"];
                                    String urlImagem = item["urlImagemPerfil"];
                                    int pontuacao = item["pontuacao"];

                                    Usuario usuario = new Usuario(
                                        false,
                                        cpf,
                                        email,
                                        nome,
                                        pontuacao,
                                        senha,
                                        urlImagem);

                                    if (usuario.email == usuarioAtual) {
                                      return Row(
                                        children: [
                                          Container(
                                            height: sizeCard * 0.19,
                                            width: sizeWidth * 0.32,
                                            margin: EdgeInsets.only(
                                                top: sizeHeight * 0.024,
                                                left: sizeWidth * 0.017),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: sizeWidth * 0.005,
                                                  color: Color.fromARGB(
                                                      255, 93, 30, 132)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      usuario.urlImagemPerfil),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: sizeHeight * 0.024,
                                                left: sizeWidth * 0.05),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: sizeWidth * 0.16),
                                                  child: Text(
                                                    "Olá, " +
                                                        firstName(
                                                            usuario.nome) +
                                                        "!",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        color: Color.fromARGB(
                                                            255, 48, 48, 48),
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize:
                                                            sizeWidth * 0.059,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  height: sizeCard * 0.08,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/MeuPerfil");
                                                    },
                                                    color: Color.fromARGB(
                                                        255, 242, 178, 42),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Text(
                                                      "VER MEU PERFIL",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Open Sans Extra Bold',
                                                          color: Color.fromARGB(
                                                              255, 93, 30, 132),
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize:
                                                              sizeWidth * 0.052,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  });
                            }
                        }
                      }),
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.06),
                    height: 3,
                    width: sizeWidth * 0.87,
                    color: Color.fromARGB(50, 48, 48, 48),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.05),
                    child: FlatButton(
                      splashColor: Color(0xfffab611),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MeusCursos()));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: sizeCard * 0.14,
                            width: sizeWidth * 0.25,
                            margin: EdgeInsets.only(),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("images/MeusCursos.png"))),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: sizeWidth * 0.06),
                            height: sizeCard * 0.12,
                            alignment: Alignment.center,
                            child: Text(
                              "Meus Cursos",
                              style: TextStyle(
                                color: Color.fromARGB(255, 48, 48, 48),
                                fontFamily: 'Open Sans Extra Bold',
                                fontSize: sizeWidth * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.04),
                    child: FlatButton(
                      splashColor: Color(0xfffab611),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Ranking()));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: sizeCard * 0.14,
                            width: sizeWidth * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/ranking.png"))),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: sizeWidth * 0.06),
                            height: sizeWidth * 0.18,
                            alignment: Alignment.center,
                            child: Text(
                              "Ranking",
                              style: TextStyle(
                                color: Color.fromARGB(255, 48, 48, 48),
                                fontFamily: 'Open Sans Extra Bold',
                                fontSize: sizeWidth * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.06),
                    height: 3,
                    width: sizeWidth * 0.87,
                    color: Color.fromARGB(50, 48, 48, 48),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeCard * 0.05),
                    child: FlatButton(
                      splashColor: Color(0xfffab611),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => janelaPopUp(sizeWidth, sizeHeight));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: sizeCard * 0.14,
                            width: sizeWidth * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/sair.png"))),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: sizeWidth * 0.06),
                            height: sizeWidth * 0.18,
                            alignment: Alignment.center,
                            child: Text(
                              "Sair do APP",
                              style: TextStyle(
                                color: Color.fromARGB(255, 48, 48, 48),
                                fontFamily: 'Open Sans Extra Bold',
                                fontSize: sizeWidth * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
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
            ],
          ),
        ],
      ),
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
        "Aviso!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 93, 30, 132),
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.09,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Você tem certeza que deseja sair do APP?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 48, 48, 48),
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
                  "Não",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: sizeHeight * 0.062,
              width: sizeWidth * 0.28,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.04, bottom: sizeHeight * 0.01),
              child: RaisedButton(
                color: Color.fromARGB(255, 93, 30, 132),
                splashColor: Color(0xfffab611),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Sim",
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
