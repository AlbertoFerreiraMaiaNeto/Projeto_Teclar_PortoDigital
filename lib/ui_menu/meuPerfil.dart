import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/autentication.dart';

class MeuPerfil extends StatefulWidget {
  @override
  _MeuPerfilState createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
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

    if (sp[0].length >= 12) {
      var repart = sp[0].substring(0, 11);
      var repart2 = sp[0].substring(11, sp[0].length);
      return repart + "-" + "\n" + repart2;
    } else {
      return sp[0];
    }
  }

  String nomeCompletoAlt(String name) {
    if (name.length > 27) {
      var repart = name.substring(0, 27);
      var repart2 = name.substring(27, name.length);
      return repart + " -" + "\n" + repart2;
    } else {
      return name;
    }
  }

  bool spaceName(String name) {
    if (name.length > 27) {
      return true;
    } else {
      return false;
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
                          children: <Widget>[CircularProgressIndicator()],
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
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        child: Container(
                          height: sizeCard,
                          width: sizeWidth,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              color: Colors.white),
                          child: Column(
                            children: [
                              ListView.builder(
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
                                      return Column(
                                        children: [
                                          Container(
                                            width: sizeWidth,
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: sizeCard * 0.23,
                                                  width: sizeWidth * 0.33,
                                                  margin: EdgeInsets.only(
                                                      top: sizeHeight * 0.024,
                                                      left: sizeWidth * 0.04),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            usuario
                                                                .urlImagemPerfil),
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: sizeHeight * 0.024,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: sizeWidth *
                                                                0.04),
                                                        child: Text(
                                                          "Olá, " +
                                                              firstName(usuario
                                                                  .nome) +
                                                              "!",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Open Sans Extra Bold',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      48,
                                                                      48,
                                                                      48),
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize:
                                                                  sizeWidth *
                                                                      0.063,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: sizeWidth *
                                                                0.04),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                "MEU RANKING: ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Open Sans Extra Bold',
                                                                    color: Color
                                                                        .fromARGB(
                                                                            170,
                                                                            48,
                                                                            48,
                                                                            48),
                                                                    fontSize:
                                                                        sizeWidth *
                                                                            0.045,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Text(
                                                              (indice + 1)
                                                                      .toString() +
                                                                  "º",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Open Sans Extra Bold',
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          93,
                                                                          30,
                                                                          132),
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize:
                                                                      sizeWidth *
                                                                          0.048,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: sizeCard * 0.04),
                                            height: 3,
                                            width: sizeWidth * 0.87,
                                            color:
                                                Color.fromARGB(50, 48, 48, 48),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: sizeCard * 0.03),
                                            padding: EdgeInsets.only(
                                                left: sizeWidth * 0.06),
                                            height: spaceName(usuario.nome)
                                                ? sizeCard * 0.16
                                                : sizeCard * 0.14,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "NOME COMPLETO",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 30, 132),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.07),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      nomeCompletoAlt(
                                                          usuario.nome),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 48, 48, 48),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            sizeWidth * 0.058,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: sizeWidth * 0.06),
                                            height: spaceName(usuario.email)
                                                ? sizeCard * 0.16
                                                : sizeCard * 0.14,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "E-MAIL",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 30, 132),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.07),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      nomeCompletoAlt(
                                                          usuario.email),
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 48, 48, 48),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.058),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: sizeWidth * 0.06),
                                            height: sizeCard * 0.14,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "CPF",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 30, 132),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.07),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      usuario.cpf,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 48, 48, 48),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.058),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: sizeWidth * 0.06),
                                            height: sizeCard * 0.14,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "PONTUAÇÃO",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 30, 132),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.07),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      usuario.pontuacaoTotal
                                                              .toString() +
                                                          " pontos",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 48, 48, 48),
                                                        fontFamily:
                                                            'Open Sans Extra Bold',
                                                        fontSize:
                                                            (sizeWidth * 0.058),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                            ],
                          ),
                        ),
                      );
                    }
                }
              }),
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      left: sizeWidth * 0.06, top: sizeHeight * 0.0135),
                  child: Container(
                    height: sizeHeight * 0.085,
                    width: sizeWidth * 0.4,
                    child: RaisedButton(
                      textColor: Colors.white,
                      splashColor: Color(0xfffab611),
                      color: Color.fromARGB(255, 93, 30, 132),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName("/Gaveta"));
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
              Container(
                  margin: EdgeInsets.only(
                      left: sizeWidth * 0.086, top: sizeHeight * 0.0135),
                  child: Container(
                    height: sizeHeight * 0.085,
                    width: sizeWidth * 0.4,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/AlterarDados");
                      },
                      textColor: Colors.white,
                      splashColor: Color(0xfffab611),
                      color: Color.fromARGB(255, 93, 30, 132),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.black)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ALTERAR",
                            style: TextStyle(
                              fontFamily: 'Open Sans Extra Bold',
                              fontSize: (sizeWidth * 0.35) * 0.14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "DADOS",
                            style: TextStyle(
                              fontFamily: 'Open Sans Extra Bold',
                              fontSize: (sizeWidth * 0.35) * 0.14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
