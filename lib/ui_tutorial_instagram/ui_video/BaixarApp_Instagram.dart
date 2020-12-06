import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/entity/curso.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/1_Menu.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BaixarAPP_Video_Instagram extends StatefulWidget {
  int cont;
  String nome;
  String link;

  BaixarAPP_Video_Instagram(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  @override
  _BaixarAPP_Video_InstagramState createState() =>
      _BaixarAPP_Video_InstagramState(cont, nome, link);
}

// ignore: camel_case_types
class _BaixarAPP_Video_InstagramState extends State<BaixarAPP_Video_Instagram> {
  int cont;
  String nome;
  String link;

  _BaixarAPP_Video_InstagramState(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  YoutubePlayerController _controller;
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(link),
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
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

  Future<Curso> _recuperarCurso(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot = await db
        .collection("cursos")
        .document("Instagram" + "_" + nome + "_" + usuario.cpf)
        .get();
    var dados = snapshot.data;
    if (dados != null) {
      Curso curso = new Curso(dados["cpf"], dados["pontuacao"], dados["audio"],
          dados["video"], dados["texto"]);
      return curso;
    } else {
      return null;
    }
  }

  Future<int> totalPontos(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();
    Firestore db = Firestore.instance;
    int soma = 0;

    QuerySnapshot querySnapshot = await db
        .collection("cursos")
        .where("cpf", isEqualTo: usuario.cpf)
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      soma += dados["pontuacao"];
    }
    return soma;
  }

  void updateDados(int pontuacao) async {
    Usuario usuario = await _recuperarDados();
    Map<String, dynamic> dadosAtualizar = {"pontuacao": pontuacao};
    Firestore db = Firestore.instance;
    db.collection("usuarios").document(usuario.cpf).updateData(dadosAtualizar);
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.867) - (sizeHeight * 0.105);

    return FutureBuilder<Usuario>(
        future: _recuperarDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()],
                  ),
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              Usuario usuario = snapshot.data;
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(sizeHeight * 0.08),
                  child: AppBar(
                    elevation: 6,
                    backgroundColor: Color.fromARGB(255, 93, 30, 132),
                    title: Text(
                      "MENU",
                      style: TextStyle(
                          fontFamily: 'Open Sans', fontSize: sizeWidth * 0.08),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.dehaze,
                        color: Colors.white,
                      ),
                      iconSize: sizeWidth * 0.10,
                      splashColor: Color(0xfffab611),
                      onPressed: () {
                        _controller.pause();
                        Navigator.pushNamed(context, "/Gaveta");
                      },
                    ),
                    actions: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black38),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(30)),
                            color: Colors.white),
                        margin: EdgeInsets.only(
                            right: sizeWidth * 0.03,
                            top: sizeHeight * 0.008,
                            bottom: sizeHeight * 0.005),
                        child: IconButton(
                          onPressed: () {
                            _controller.pause();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MenuInicial()));
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
                                  "O APP INSTAGRAM:",
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
                              height: sizeCard * 0.45,
                              width: sizeWidth,
                              margin: EdgeInsets.only(top: sizeCard * 0.05),
                              child: YoutubePlayer(
                                controller: _controller,
                                onEnded: (data) async {
                                  Curso curso = await _recuperarCurso(usuario);

                                  Map<String, dynamic> toMapNull() {
                                    Map<String, dynamic> map = {
                                      "cpf": usuario.cpf,
                                      "pontuacao": 20,
                                      "audio": false,
                                      "texto": false,
                                      "video": true,
                                      "curso": "instagram"
                                    };
                                    return map;
                                  }

                                  Map<String, dynamic> toMapNotNull() {
                                    Map<String, dynamic> map = {"video": true};
                                    return map;
                                  }

                                  salvar() async {
                                    Firestore db = Firestore.instance;
                                    if (curso == null) {
                                      await db
                                          .collection("cursos")
                                          .document("Instagram" +
                                              "_" +
                                              nome +
                                              "_" +
                                              usuario.cpf)
                                          .setData(toMapNull());
                                    } else {
                                      Firestore db = Firestore.instance;
                                      await db
                                          .collection("cursos")
                                          .document("Instagram" +
                                              "_" +
                                              nome +
                                              "_" +
                                              usuario.cpf)
                                          .updateData(toMapNotNull());
                                    }
                                  }

                                  salvar();
                                  int total = await totalPontos(usuario);
                                  updateDados(total);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: sizeWidth * 0.06,
                                top: sizeHeight * 0.0165),
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
                                  _controller.pause();
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
        });
  }
}
