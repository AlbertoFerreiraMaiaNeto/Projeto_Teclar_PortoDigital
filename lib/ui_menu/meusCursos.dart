import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/2_Aprendizado.dart';

class MeusCursos extends StatefulWidget {
  @override
  _MeusCursosState createState() => _MeusCursosState();
}

class _MeusCursosState extends State<MeusCursos> {
  final _scrollController = ScrollController();
  int contIfood = 0;
  int contFacebook = 0;
  int contInstagram = 0;
  int contUber = 0;
  int contWhatsapp = 0;

  void verificarTela(context, int cont) {
    if (cont == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaAprendizado(
                page: 1,
              )));
    } else if (cont == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaAprendizado(
                page: 4,
              )));
    } else if (cont == 3) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaAprendizado(
                page: 3,
              )));
    } else if (cont == 4) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaAprendizado(
                page: 2,
              )));
    } else if (cont == 5) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TelaAprendizado(
                page: 5,
              )));
    } else {
      return null;
    }
  }

  Future<Usuario> _recuperarDadosUsuario() async {
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

  Future _recuperarDados() async {
    Firestore db = Firestore.instance;

    Usuario usuario = await _recuperarDadosUsuario();

    QuerySnapshot querySnapshot = await db
        .collection("cursos")
        .where("cpf", isEqualTo: usuario.cpf)
        .getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados["curso"] == "ifood") {
        contIfood++;
      } else if (dados["curso"] == "facebook") {
        contFacebook++;
      } else if (dados["curso"] == "instagram") {
        contInstagram++;
      } else if (dados["curso"] == "whatsapp") {
        contWhatsapp++;
      } else if (dados["curso"] == "uber") {
        contUber++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.2148) - (sizeHeight * 0.10);
    var sizeCard2 = (sizeHeight * 0.5942);

    return FutureBuilder(
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
                      onPressed: () {},
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
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: sizeCard * 0.400),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(right: sizeWidth * 0.04),
                                  height: 4,
                                  width: sizeWidth * 0.13,
                                  color: Colors.black,
                                ),
                                Text(
                                  "MEUS CURSOS",
                                  style: TextStyle(
                                      fontFamily: 'Open Sans Extra Bold',
                                      color: Color.fromARGB(255, 48, 48, 48),
                                      fontSize: sizeWidth * 0.08,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: sizeWidth * 0.04),
                                  height: 2,
                                  width: sizeWidth * 0.13,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: sizeCard2,
                      width: sizeWidth,
                      color: Colors.white,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        thickness: sizeWidth * 0.02,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: sizeWidth * 0.06,
                                          top: sizeCard2 * 0.04),
                                      padding: EdgeInsets.only(
                                          top: sizeCard2 * 0.01,
                                          bottom: sizeCard2 * 0.01,
                                          left: sizeWidth * 0.03,
                                          right: sizeWidth * 0.03),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 242, 178,
                                              42), // set border width
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10.0)), // set rounded corner radius
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Color.fromARGB(
                                                    255, 242, 178, 42),
                                                offset: Offset(1, 3))
                                          ] // make rounded corner of border
                                          ),
                                      child: Text("EM ANDAMENTO",
                                          style: TextStyle(
                                              fontFamily:
                                                  'Open Sans Extra Bold',
                                              color: Color.fromARGB(
                                                  255, 28, 28, 28),
                                              fontSize: sizeWidth * 0.06)),
                                    ),
                                  ],
                                ),
                                _testeCursoEmAndamento(
                                    "Ifood",
                                    "images/ifood.png",
                                    "IFOOD",
                                    sizeWidth,
                                    sizeCard2,
                                    contIfood),
                                _testeCursoEmAndamento(
                                    "Instagram",
                                    "images/instagram.png",
                                    "INSTAGRAM",
                                    sizeWidth,
                                    sizeCard2,
                                    contInstagram),
                                _testeCursoEmAndamento(
                                    "Facebook",
                                    "images/facebook.png",
                                    "FACEBOOK",
                                    sizeWidth,
                                    sizeCard2,
                                    contFacebook),
                                _testeCursoEmAndamento(
                                    "Whatsapp",
                                    "images/whatsapp.png",
                                    "WHATSAPP",
                                    sizeWidth,
                                    sizeCard2,
                                    contWhatsapp),
                                _testeCursoEmAndamento(
                                    "Uber",
                                    "images/uber.png",
                                    "UBER",
                                    sizeWidth,
                                    sizeCard2,
                                    contUber),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: sizeWidth * 0.06,
                                          top: sizeCard2 * 0.1),
                                      padding: EdgeInsets.only(
                                          top: sizeCard2 * 0.01,
                                          bottom: sizeCard2 * 0.01,
                                          left: sizeWidth * 0.03,
                                          right: sizeWidth * 0.03),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 0, 189,
                                              0), // set border width
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10.0)), // set rounded corner radius
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Color.fromARGB(
                                                    255, 0, 189, 0),
                                                offset: Offset(1, 3))
                                          ] // make rounded corner of border
                                          ),
                                      child: Text("CONCLUÍDOS",
                                          style: TextStyle(
                                              fontFamily:
                                                  'Open Sans Extra Bold',
                                              color: Color.fromARGB(
                                                  255, 28, 28, 28),
                                              fontSize: sizeWidth * 0.06)),
                                    ),
                                  ],
                                ),
                                _testeCursoConcluido(
                                    "Ifood",
                                    "images/ifood.png",
                                    "IFOOD",
                                    sizeWidth,
                                    sizeCard2,
                                    contIfood),
                                _testeCursoConcluido(
                                    "Instagram",
                                    "images/instagram.png",
                                    "INSTAGRAM",
                                    sizeWidth,
                                    sizeCard2,
                                    contInstagram),
                                _testeCursoConcluido(
                                    "Facebook",
                                    "images/facebook.png",
                                    "FACEBOOK",
                                    sizeWidth,
                                    sizeCard2,
                                    contFacebook),
                                _testeCursoConcluido(
                                    "Whatsapp",
                                    "images/whatsapp.png",
                                    "WHATSAPP",
                                    sizeWidth,
                                    sizeCard2,
                                    contWhatsapp),
                                _testeCursoConcluido("Uber", "images/uber.png",
                                    "UBER", sizeWidth, sizeCard2, contUber),
                              ],
                            )),
                      ),
                    ),
                    Container(
                      height: sizeCard2 * 0.09,
                      width: sizeWidth,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.transparent),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.white),
                    ),
                    Row(
                      children: [
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

  Widget buildRaiseButton(String imagem, String nome, int cont,
      double sizeWidth, double sizeHeight, String percentual) {
    return Row(
      children: [
        Container(
          height: sizeWidth * 0.15,
          width: sizeWidth * 0.15,
          margin: EdgeInsets.only(top: sizeHeight * 0.024),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagem)),
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: sizeHeight * 0.024),
            padding: EdgeInsets.only(left: sizeWidth * 0.02),
            height: sizeWidth * 0.15,
            child: RaisedButton(
                textColor: Colors.white,
                splashColor: Color(0xfffab611),
                color: Color.fromARGB(255, 93, 30, 132),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  verificarTela(context, cont);
                },
                child: Text(
                  nome,
                  style: TextStyle(
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: (sizeWidth * 0.35) * 0.18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(left: sizeWidth * 0.024, top: sizeHeight * 0.017),
          child: Text(
            percentual,
            style: TextStyle(
              fontFamily: 'Open Sans Extra Bold',
              fontSize: (sizeWidth * 0.35) * 0.16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _testeCursoEmAndamento(String curso, String imagem, String nome,
      double sizeWidth, double sizeHeight, int nomeContador) {
    double porcentagem = (nomeContador * 100) / 5;
    if (curso == "Ifood") {
      if (contIfood != 0 && contIfood < 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 1, sizeWidth, sizeHeight,
              porcentagem.toString() + "%"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Whatsapp") {
      if (contWhatsapp != 0 && contWhatsapp < 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 3, sizeWidth, sizeHeight,
              porcentagem.toString() + "%"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Instagram") {
      if (contInstagram != 0 && contInstagram < 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 5, sizeWidth, sizeHeight,
              porcentagem.toString() + "%"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Uber") {
      if (contUber != 0 && contUber < 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 4, sizeWidth, sizeHeight,
              porcentagem.toString() + "%"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Facebook") {
      if (contFacebook != 0 && contFacebook < 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 2, sizeWidth, sizeHeight,
              porcentagem.toString() + "%"),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget _testeCursoConcluido(String curso, String imagem, String nome,
      double sizeWidth, double sizeHeight, int nomeContador) {
    double porcentagem = (nomeContador * 100) / 5;
    if (curso == "Ifood") {
      if (contIfood == 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 1, sizeWidth, sizeHeight, "✔️"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Whatsapp") {
      if (contWhatsapp == 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 3, sizeWidth, sizeHeight, "✔️"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Instagram") {
      if (contInstagram == 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 5, sizeWidth, sizeHeight, "✔️"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Uber") {
      if (contUber == 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 4, sizeWidth, sizeHeight, "✔️"),
        );
      } else {
        return Container();
      }
    } else if (curso == "Facebook") {
      if (contFacebook == 5) {
        return Container(
          padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
              left: sizeWidth * 0.06,
              right: sizeWidth * 0.06),
          child: buildRaiseButton(imagem, nome, 2, sizeWidth, sizeHeight, "✔️"),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
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
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: sizeWidth * 0.04),
                        height: 4,
                        width: sizeWidth * 0.13,
                        color: Colors.black,
                      ),
                      Text(
                        "MEUS CURSOS",
                        style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            color: Color.fromARGB(255, 48, 48, 48),
                            fontSize: sizeWidth * 0.08,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: sizeWidth * 0.04),
                        height: 4,
                        width: sizeWidth * 0.13,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: sizeCard2,
            width: sizeWidth,
            color: Colors.white,
            child: Scrollbar(
              isAlwaysShown: true,
              thickness: sizeWidth * 0.02,
              controller: _scrollController,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: sizeWidth * 0.06, top: sizeCard2 * 0.07),
                            padding: EdgeInsets.only(
                                top: sizeCard2 * 0.01,
                                bottom: sizeCard2 * 0.01,
                                left: sizeWidth * 0.03,
                                right: sizeWidth * 0.03),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    80, 48, 48, 48), // set border width
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Color.fromARGB(80, 48, 48, 48),
                                      offset: Offset(1, 3))
                                ] // make rounded corner of border
                                ),
                            child: Text("EM ANDAMENTO",
                                style: TextStyle(
                                    fontFamily: 'Open Sans Extra Bold',
                                    color: Color.fromARGB(255, 28, 28, 28),
                                    fontSize: sizeWidth * 0.06)),
                          ),
                        ],
                      ),
                      _testeCursoEmAndamento("Ifood", "images/ifood.png",
                          "IFOOD", sizeWidth, sizeCard3, contIfood),
                      _testeCursoEmAndamento(
                          "Instagram",
                          "images/instagram.png",
                          "INSTAGRAM",
                          sizeWidth,
                          sizeCard3,
                          contInstagram),
                      _testeCursoEmAndamento("Facebook", "images/facebook.png",
                          "FACEBOOK", sizeWidth, sizeCard3, contFacebook),
                      _testeCursoEmAndamento("Whatsapp", "images/whatsapp.png",
                          "WHATSAPP", sizeWidth, sizeCard3, contWhatsapp),
                      _testeCursoEmAndamento("Uber", "images/uber.png", "UBER",
                          sizeWidth, sizeCard3, contUber),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: sizeWidth * 0.06, top: sizeCard2 * 0.1),
                            padding: EdgeInsets.only(
                                top: sizeCard2 * 0.01,
                                bottom: sizeCard2 * 0.01,
                                left: sizeWidth * 0.03,
                                right: sizeWidth * 0.03),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    80, 48, 48, 48), // set border width
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Color.fromARGB(80, 48, 48, 48),
                                      offset: Offset(1, 3))
                                ] // make rounded corner of border
                                ),
                            child: Text("JÁ CONCLUÍDOS",
                                style: TextStyle(
                                    fontFamily: 'Open Sans Extra Bold',
                                    color: Color.fromARGB(255, 28, 28, 28),
                                    fontSize: sizeWidth * 0.06)),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: sizeHeight * 0.01,
                            left: sizeWidth * 0.06,
                            right: sizeWidth * 0.06),
                        child: buildRaiseButton("images/whatsapp.png",
                            "WHATSAPP", 3, sizeWidth, sizeCard3, "✔️"),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: sizeHeight * 0.01,
                            left: sizeWidth * 0.06,
                            right: sizeWidth * 0.06),
                        child: buildRaiseButton("images/uber.png", "UBER", 4,
                            sizeWidth, sizeCard3, "✔️"),
                      ),
                    ],
                  )),
            ),
          ),
          Container(
            height: sizeCard2 * 0.09,
            width: sizeWidth,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.transparent),
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
 */
