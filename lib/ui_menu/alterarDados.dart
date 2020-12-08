import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_splash_screen/entity/usuario.dart';
import 'package:material_splash_screen/ui_menu/autentication.dart';

class AlterarDados extends StatefulWidget {
  @override
  _AlterarDadosState createState() => _AlterarDadosState();
}

class _AlterarDadosState extends State<AlterarDados> {
  final ImagePicker picker = ImagePicker();
  final _scrollController = ScrollController();
  int page;

  void verificarTela(context, int cont, sizeWidth, double sizeHeight) {
    if (cont == 1) {
      showDialog(
          context: context,
          builder: (_) => janelaPopUp(context, sizeWidth, sizeHeight));
    } else if (cont == 2) {
      Navigator.pushNamed(context, "/AlterarNome");
    } else if (cont == 4) {
      showDialog(
          context: context,
          builder: (_) => janelaPopUp3(sizeWidth, sizeHeight, true));
    } else if (cont == 5) {
      showDialog(
          context: context,
          builder: (_) => janelaPopUp3(sizeWidth, sizeHeight, false));
    }
  }

  File _imagem;
  String _urlImagemRecuperada;

  Future _recuperarImagem(BuildContext context, bool daCamera) async {
    File imagemSelecionada;
    if (daCamera) {
      // ? Da câmera
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imagemSelecionada = File(pickedFile.path);
      }
    } else {
      // ? Da galeria
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagemSelecionada = File(pickedFile.path);
      }
    }

    if (imagemSelecionada != null) {
      setState(() {
        _imagem = imagemSelecionada;
      });

      _uploadImagem();
    }
  }

  Future _uploadImagem() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioAtual = await auth.currentUser();

    // ! Referenciar arquivo]
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("fotos_perfil").child(usuarioAtual.email + "jpg");

    // ? Fazer upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    // ? Controlar progresso do Upload
    /*task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _statusUpload = "Em progresso...";
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          _statusUpload = "Upload realizado com sucesso!";
        });
      }
    });*/

    // ? Recuperar url da imagem
    task.onComplete.then(
        (StorageTaskSnapshot snapshot) => {_recuperarUrlImagem(snapshot)});
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    setState(() {
      _urlImagemRecuperada = url;
    });

    updateDados();
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
      Usuario usuario = new Usuario(
          false,
          dados["cpf"],
          dados["email"],
          dados["nome"],
          dados["pontuacao"],
          dados["senha"],
          dados["urlImagemPerfil"]);
      return usuario;
    }
  }

  void updateDados() async {
    Usuario usuario = await _recuperarDados();
    Map<String, dynamic> dadosAtualizar = {
      "cpf": usuario.cpf,
      "nome": usuario.nome,
      "email": usuario.email,
      "senha": usuario.senha,
      "urlImagemPerfil": _urlImagemRecuperada
    };
    Firestore db = Firestore.instance;
    db.collection("usuarios").document(usuario.cpf).updateData(dadosAtualizar);
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
            onPressed: () {
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
                    Padding(
                      padding: EdgeInsets.only(top: sizeHeight * 0.05),
                      child: Center(
                        child: Text(
                          "O que você gostaria\nde alterar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Open Sans Extra Bold',
                              color: Color.fromARGB(255, 48, 48, 48),
                              fontStyle: FontStyle.italic,
                              fontSize: sizeWidth * 0.08,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: sizeWidth * 0.06, right: sizeWidth * 0.06),
                          child: buildRaiseButton(
                              "FOTO DO PERFIL", 1, sizeWidth, sizeHeight),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: sizeWidth * 0.06, right: sizeWidth * 0.06),
                          child: buildRaiseButton(
                              "MEU NOME", 2, sizeWidth, sizeHeight),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: sizeWidth * 0.06, right: sizeWidth * 0.06),
                          child: buildRaiseButton(
                              "MEU E-MAIL", 4, sizeWidth, sizeHeight),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: sizeWidth * 0.06, right: sizeWidth * 0.06),
                          child: buildRaiseButton(
                              "MINHA SENHA", 5, sizeWidth, sizeHeight),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sizeCard * 0.05),
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
                        Navigator.pushNamed(context, "/Menu");
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

  Widget buildRaiseButton(
      String nome, int cont, double sizeWidth, double sizeHeight) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: sizeHeight * 0.024),
            padding: EdgeInsets.fromLTRB(
                sizeWidth * 0.05, 0.0, sizeWidth * 0.05, 0.0),
            height: sizeWidth * 0.15,
            child: RaisedButton(
                textColor: Colors.white,
                splashColor: Color(0xfffab611),
                color: Color.fromARGB(255, 93, 30, 132),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  verificarTela(context, cont, sizeWidth, sizeHeight);
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
        )
      ],
    );
  }

  AlertDialog janelaPopUp(context, double sizeWidth, double sizeHeight) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 24,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black)),
      title: Text(
        "Pergunta",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 93, 30, 132),
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.09,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Você deseja adicionar uma foto sua ou algum dos nossos avatares?",
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
              height: sizeHeight * 0.08,
              width: sizeWidth * 0.3,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.075, bottom: sizeHeight * 0.01),
              child: RaisedButton(
                splashColor: Color(0xfffab611),
                color: Color.fromARGB(255, 93, 30, 132),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          janelaPopUp2(context, sizeWidth, sizeHeight));
                },
                child: Text(
                  "Minha foto",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: sizeHeight * 0.08,
              width: sizeWidth * 0.3,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.04, bottom: sizeHeight * 0.01),
              child: RaisedButton(
                color: Color.fromARGB(255, 93, 30, 132),
                splashColor: Color(0xfffab611),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  Navigator.pushNamed(context, "/AlterarFotoPerfil");
                },
                child: Text(
                  "Imagens do App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.05,
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

  AlertDialog janelaPopUp2(context, double sizeWidth, double sizeHeight) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 24,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black)),
      title: Text(
        "Pergunta",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 93, 30, 132),
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.09,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Você deseja tirar uma foto sua ou pegar uma foto na sua galeria?",
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
              height: sizeHeight * 0.08,
              width: sizeWidth * 0.3,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.075, bottom: sizeHeight * 0.01),
              child: RaisedButton(
                splashColor: Color(0xfffab611),
                color: Color.fromARGB(255, 93, 30, 132),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () async {
                  _recuperarImagem(context, true);
                  Navigator.pushNamed(context, "/Menu");
                },
                child: Text(
                  "Câmera",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: sizeHeight * 0.08,
              width: sizeWidth * 0.3,
              margin: EdgeInsets.only(
                  right: sizeWidth * 0.04, bottom: sizeHeight * 0.01),
              child: RaisedButton(
                color: Color.fromARGB(255, 93, 30, 132),
                splashColor: Color(0xfffab611),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  _recuperarImagem(context, false);
                  Navigator.pushNamed(context, "/Menu");
                },
                child: Text(
                  "Galeria",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans Extra Bold',
                    fontSize: sizeWidth * 0.05,
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

  AlertDialog janelaPopUp3(double sizeWidth, double sizeHeight, bool x) {
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
        "Para alterar os dados, você terá que relizar login novamente\n você tem certeza?",
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
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Autentication(x)));
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
