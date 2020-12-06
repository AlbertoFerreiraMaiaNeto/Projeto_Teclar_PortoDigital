import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/entity/usuario.dart';

class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = new ScrollController();
  String emailUsuario;
  final Firestore db = Firestore.instance;

  bool diario = false;
  bool semanal = false;
  bool geral = true;

  void testeCor(String text) {
    if (text == "DIÁRIO") {
      diario = true;
      semanal = false;
      geral = false;
    } else if (text == "SEMANAL") {
      diario = false;
      semanal = true;
      geral = false;
    } else {
      diario = false;
      semanal = false;
      geral = true;
    }
  }

  Stream<QuerySnapshot> _adicionarDados() {
    Firestore db = Firestore.instance;
    final stream = db
        .collection("usuarios")
        .orderBy("pontuacao", descending: true)
        .limit(10)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  String firstName(String n) {
    var sp = n.split(" ");
    return sp[0];
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    emailUsuario = usuarioLogado.email;

    _adicionarDados();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();

    /*_scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });*/
  }

  /*@override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.2588) - (sizeHeight * 0.10);
    var sizeCard2 = (sizeHeight * 0.5700);

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
          Container(
            height: sizeCard,
            width: sizeWidth,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "DIÁRIO",
                          style: TextStyle(
                            fontFamily:
                                diario ? 'Open Sans Extra Bold' : 'Open Sans',
                            fontSize: sizeWidth * 0.058,
                            color: diario
                                ? Color.fromARGB(255, 48, 48, 48)
                                : Color.fromARGB(170, 48, 48, 48),
                            decoration: TextDecoration.underline,
                            decorationColor:
                                diario ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: sizeWidth * 0.032,
                          right: sizeWidth * 0.032,
                          bottom: sizeCard * 0.12,
                        ),
                        child: Text(
                          ".",
                          style: TextStyle(
                              color: Color.fromARGB(255, 242, 178, 42),
                              fontFamily: 'Open Sans',
                              fontSize: sizeWidth * 0.1),
                        ),
                      ),
                      Container(
                        child: Text(
                          "SEMANAL",
                          style: TextStyle(
                            fontFamily:
                                semanal ? 'Open Sans Extra Bold' : 'Open Sans',
                            fontSize: sizeWidth * 0.058,
                            color: semanal
                                ? Color.fromARGB(255, 48, 48, 48)
                                : Color.fromARGB(170, 48, 48, 48),
                            decoration: TextDecoration.underline,
                            decorationColor:
                                semanal ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: sizeWidth * 0.032,
                          right: sizeWidth * 0.032,
                          bottom: sizeCard * 0.12,
                        ),
                        child: Text(
                          ".",
                          style: TextStyle(
                              color: Color.fromARGB(255, 242, 178, 42),
                              fontFamily: 'Open Sans',
                              fontSize: sizeWidth * 0.1),
                        ),
                      ),
                      Container(
                        child: Text(
                          "GERAL",
                          style: TextStyle(
                            fontFamily:
                                geral ? 'Open Sans Extra Bold' : 'Open Sans',
                            fontSize: sizeWidth * 0.058,
                            color: geral
                                ? Color.fromARGB(255, 48, 48, 48)
                                : Color.fromARGB(170, 48, 48, 48),
                            decoration: TextDecoration.underline,
                            decorationColor:
                                geral ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: sizeWidth * 0.04),
                        height: sizeCard * 0.03,
                        width: sizeWidth * 0.18,
                        color: Colors.black,
                      ),
                      Text(
                        "RANKING",
                        style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            color: Color.fromARGB(255, 48, 48, 48),
                            fontSize: sizeWidth * 0.075,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: sizeWidth * 0.04),
                        height: sizeCard * 0.03,
                        width: sizeWidth * 0.18,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      height: sizeCard2,
                      width: sizeWidth,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: sizeHeight * 0.04),
                            child: Text(
                              "Carregando Ranking",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Open Sans Extra Bold',
                                  fontSize: sizeWidth * 0.07,
                                  color: Color.fromARGB(255, 48, 48, 48),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white),
                            ),
                          ),
                          Container(
                              height: sizeHeight * 0.08,
                              width: sizeWidth * 0.2,
                              child: CircularProgressIndicator())
                        ],
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
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return Scrollbar(
                        isAlwaysShown: true,
                        thickness: sizeWidth * 0.02,
                        controller: _scrollController,
                        child: Container(
                          height: sizeCard2,
                          width: sizeWidth,
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: sizeCard2 * 0.01),
                          child: Container(
                              child: Column(children: [
                            Expanded(
                              child: ListView.builder(
                                  controller: _scrollController,
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

                                    if (usuario.email == emailUsuario) {
                                      return Container(
                                        child: buildRanking(
                                            context,
                                            urlImagem,
                                            (indice + 1).toString() + "º",
                                            firstName(nome),
                                            pontuacao.toString(),
                                            sizeWidth,
                                            sizeCard2,
                                            true),
                                      );
                                    } else {
                                      return Container(
                                        child: buildRanking(
                                            context,
                                            urlImagem,
                                            (indice + 1).toString() + "º",
                                            firstName(nome),
                                            pontuacao.toString(),
                                            sizeWidth,
                                            sizeCard2,
                                            false),
                                      );
                                    }
                                  }),
                            ),
                          ])),
                        ),
                      );
                    }
                }
              }),
          Container(
            height: sizeCard2 * 0.06,
            width: sizeWidth,
            decoration: BoxDecoration(
                border: Border.all(width: 01, color: Colors.transparent),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.white),
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
}

Widget buildRanking(context, String imagem, String pos, String firstName,
    String pontuacao, double sizeWidth, double sizeCard, bool foco) {
  bool testeT() {
    if (pos.length > 2) {
      return true;
    } else {
      return false;
    }
  }

  return Stack(
    children: [
      Column(
        children: [
          Container(
            height: sizeCard * 0.058,
            margin: EdgeInsets.only(
                left: sizeWidth * 0.05, right: sizeWidth * 0.05),
            padding: EdgeInsets.only(left: sizeWidth * 0.02),
            color: Color.fromARGB(255, 93, 30, 132),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  pos,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Open Sans Extra Bold',
                      fontSize: sizeCard * 0.043,
                      color: foco ? Colors.green : Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: testeT() ? (sizeWidth * 0.2) : (sizeWidth * 0.23)),
                  child: Text(
                    firstName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Open Sans Extra Bold',
                        fontSize: sizeCard * 0.043,
                        color: Color.fromARGB(255, 242, 178, 42)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: sizeCard * 0.058,
            margin: EdgeInsets.only(
                left: sizeWidth * 0.05, right: sizeWidth * 0.05),
            padding: EdgeInsets.only(right: sizeWidth * 0.02),
            color: foco ? Colors.green : Colors.white,
            alignment: Alignment.centerRight,
            child: Text(
              pontuacao,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Open Sans Extra Bold',
                fontSize: sizeCard * 0.043,
                color: Color.fromARGB(255, 48, 48, 48),
              ),
            ),
          )
        ],
      ),
      Container(
        height: sizeCard * 0.106,
        width: sizeWidth * 0.23,
        margin: EdgeInsets.only(top: sizeCard * 0.008, left: sizeWidth * 0.13),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image:
              DecorationImage(image: NetworkImage(imagem), fit: BoxFit.contain),
        ),
      ),
    ],
  );
}

/*
Scaffold(
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
                  Future.delayed(Duration(milliseconds: 200)).then((_) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MenuInicial()));
                  });
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
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                            child: Text(
                              "ASSISTIR",
                              style: TextStyle(
                                fontFamily: testeCor("ASSISTINDO")
                                    ? 'Open Sans Extra Bold'
                                    : 'Open Sans',
                                fontSize: sizeWidth * 0.07,
                                color: testeCor("ASSISTINDO")
                                    ? Color.fromARGB(255, 48, 48, 48)
                                    : Color.fromARGB(170, 48, 48, 48),
                                decoration: TextDecoration.underline,
                                decorationColor: testeCor("ASSISTINDO")
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: sizeWidth * 0.032,
                              right: sizeWidth * 0.032,
                              bottom: sizeCard * 0.03,
                            ),
                            child: Text(
                              ".",
                              style: TextStyle(
                                  color: Color(0xfffab611),
                                  fontFamily: 'Open Sans',
                                  fontSize: sizeWidth * 0.1),
                            ),
                          ),
                          Container(
                            child: Text(
                              "OUVIR",
                              style: TextStyle(
                                fontFamily: testeCor("OUVINDO")
                                    ? 'Open Sans Extra Bold'
                                    : 'Open Sans',
                                fontSize: sizeWidth * 0.07,
                                color: testeCor("OUVINDO")
                                    ? Color.fromARGB(255, 48, 48, 48)
                                    : Color.fromARGB(170, 48, 48, 48),
                                decoration: TextDecoration.underline,
                                decorationColor: testeCor("OUVINDO")
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: sizeWidth * 0.032,
                              right: sizeWidth * 0.032,
                              bottom: sizeCard * 0.03,
                            ),
                            child: Text(
                              ".",
                              style: TextStyle(
                                  color: Color(0xfffab611),
                                  fontFamily: 'Open Sans',
                                  fontSize: sizeWidth * 0.1),
                            ),
                          ),
                          Container(
                            child: Text(
                              "LER",
                              style: TextStyle(
                                fontFamily: testeCor("LENDO")
                                    ? 'Open Sans Extra Bold'
                                    : 'Open Sans',
                                fontSize: sizeWidth * 0.07,
                                color: testeCor("LENDO")
                                    ? Color.fromARGB(255, 48, 48, 48)
                                    : Color.fromARGB(170, 48, 48, 48),
                                decoration: TextDecoration.underline,
                                decorationColor: testeCor("LENDO")
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),

          Container(
            height: sizeCard,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: Colors.white),
            child: Scrollbar(
              thickness: sizeWidth * 0.02,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    
                    Container(
                      margin: EdgeInsets.only(top: sizeCard * 0.005),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: sizeWidth * 0.04),
                            height: 4,
                            width: sizeWidth * 0.2,
                            color: Colors.black,
                          ),
                          Text(
                            "IFOOD",
                            style: TextStyle(
                                fontFamily: 'Open Sans Extra Bold',
                                color: Color.fromARGB(255, 93, 30, 132),
                                fontStyle: FontStyle.italic,
                                fontSize: sizeWidth * 0.1,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: sizeWidth * 0.04),
                            height: 4,
                            width: sizeWidth * 0.2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: sizeCard * 0.005,
                          left: sizeWidth * 0.06,
                          right: sizeWidth * 0.06),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              buildRaiseButton(context, 1, verificarIcone(),
                                  "BAIXAR APP", sizeWidth, sizeCard),
                              buildRaiseButton(context, 2, verificarIcone(),
                                  "ENTRAR APP", sizeWidth, sizeCard),
                              buildRaiseButton(context, 3, verificarIcone(),
                                  "CADASTRO", sizeWidth, sizeCard),
                              buildRaiseButton(context, 4, verificarIcone(),
                                  "LOGIN", sizeWidth, sizeCard),
                              buildRaiseButton(context, 5, verificarIcone(),
                                  "PEDIR ALGO", sizeWidth, sizeCard),
                              Padding(
                                padding: EdgeInsets.only(top: sizeCard * 0.05),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
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
                              builder: (context) => TelaAprendizado()));
                        });
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

 */
