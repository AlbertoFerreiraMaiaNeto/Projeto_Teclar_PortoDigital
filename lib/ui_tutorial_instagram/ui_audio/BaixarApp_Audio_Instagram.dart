import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/AudioPlayerObjeto.dart';
import 'package:material_splash_screen/AudioPlayerController.dart';
import 'package:material_splash_screen/entity/curso.dart';
import 'package:material_splash_screen/entity/usuario.dart';

class BaixarAPP_Audio_Instagram extends StatefulWidget {
  int cont;
  String nome;
  String link;

  BaixarAPP_Audio_Instagram(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  @override
  _BaixarAPP_Audio_InstagramState createState() =>
      _BaixarAPP_Audio_InstagramState(cont, nome, link);
}

// ignore: camel_case_types
class _BaixarAPP_Audio_InstagramState extends State<BaixarAPP_Audio_Instagram> {
  int cont;
  String nome;
  String link;

  _BaixarAPP_Audio_InstagramState(int cont, String nome, String link) {
    this.cont = cont;
    this.nome = nome;
    this.link = link;
  }

  void teste(bool x, String i) {
    if (i != null && x == false) {
      audioC.botaoPlayPause();
    } else if (i == null) {
      audioC.botaoPlayPause();
    }
  }

  void _alterandoPontuacaoAudio(String nome) async {
    Usuario usuario = await _recuperarDados();
    Curso curso = await _recuperarCurso(usuario, nome);

    Map<String, dynamic> toMap() {
      if (curso == null) {
        Map<String, dynamic> map = {
          "cpf": usuario.cpf,
          "pontuacao": 20,
          "audio": true,
          "texto": false,
          "video": false,
          "curso": "instagram"
        };
        return map;
      } else {
        Map<String, dynamic> map = {
          "cpf": usuario.cpf,
          "pontuacao": 20,
          "audio": true,
          "texto": curso.texto,
          "video": curso.video,
          "curso": "instagram"
        };
        return map;
      }
    }

    salvar() async {
      Firestore db = Firestore.instance;
      await db
          .collection("cursos")
          .document("Instagram" + "_" + nome + "_" + usuario.cpf)
          .setData(toMap());
    }

    salvar();
    int total = await totalPontos(usuario);
    updateDados(total);
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.867) - (sizeHeight * 0.105);
    bool x;
    _alterandoPontuacaoAudio(nome);
    Widget _retornarTempoMusica(Duration position) {
      String segundos = (position.inMinutes >= 1
              ? ((position.inSeconds - position.inMinutes * 60))
              : position.inSeconds)
          .toString();

      if (position.inSeconds < 10) {
        segundos = "0" + segundos;
      }
      String tempoMusica = position.inMinutes.toString() + ":" + segundos;
      return Text(tempoMusica);
    }

    Widget acoes(AudioPlayerObjeto objeto) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            iconSize: sizeCard * .17,
            icon: Icon(objeto.play == true
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled),
            onPressed: () {
              x = objeto.play;
              teste(x, null);
            },
          ),
        ],
      );
    }

    Widget _tab(List<Widget> children) {
      return Container(
          child: Column(
        children: children
            .map((c) => Container(
                  child: c,
                  padding: EdgeInsets.all(6),
                ))
            .toList(),
      ));
    }

    Widget _slider(AudioPlayerObjeto objeto) {
      return Slider(
        activeColor: Colors.amber,
        value: objeto.position.inSeconds.toDouble(),
        min: 0.0,
        max: objeto.duration.inSeconds.toDouble(),
        onChanged: (newVal) {
          audioC.tempoMusica(newVal);
          print(objeto.position.inSeconds.toDouble());
        },
      );
    }

    Widget _player() {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: audioC.outPlayer,
                builder: (context, AsyncSnapshot<AudioPlayerObjeto> snapshot) {
                  return _tab([
                    _slider(snapshot.data),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: sizeWidth * 0.07),
                          child: Text("00:00"),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: sizeWidth * 0.07),
                          child: Text(snapshot.data.duration.inMinutes
                                  .toString() +
                              ":" +
                              (snapshot.data.duration.inSeconds -
                                      (snapshot.data.duration.inMinutes * 60))
                                  .toString()),
                        ),
                      ],
                    ),
                    _retornarTempoMusica(snapshot.data.position),
                    acoes(snapshot.data),
                  ]);
                })
          ],
        ),
      );
    }

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
            onPressed: () {
              setState(() {
                teste(x, 'gdsg');
              });
              Navigator.pushNamed(context, "/Gaveta");
            },
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
                  setState(() {
                    teste(x, 'gdsg');
                  });
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
                      cont.toString() + ". COMO BAIXAR\nO APP INSTAGRAM",
                      textAlign: TextAlign.center,
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
                    margin: EdgeInsets.only(top: sizeCard * 0.13),
                    child: _player()),
              ],
            ),
          ),
          Row(
            children: <Widget>[
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
                        setState(() {
                          teste(x, 'gdsg');
                        });

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

  Future<Curso> _recuperarCurso(Usuario usuario, String nome) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot = await db
        .collection("cursos")
        .document("Ifood" + "_" + nome + "_" + usuario.cpf)
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
}
