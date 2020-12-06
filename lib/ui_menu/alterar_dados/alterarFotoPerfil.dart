import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_splash_screen/entity/usuario.dart';

class AlterarFotoPerfil extends StatefulWidget {
  @override
  _AlterarFotoPerfilState createState() => _AlterarFotoPerfilState();
}

class _AlterarFotoPerfilState extends State<AlterarFotoPerfil> {
  final _scrollController = ScrollController();

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

  void updateDados(String url) async {
    Usuario usuario = await _recuperarDados();
    Map<String, dynamic> dadosAtualizar = {
      "cpf": usuario.cpf,
      "nome": usuario.nome,
      "email": usuario.email,
      "senha": usuario.senha,
      "urlImagemPerfil": url
    };
    Firestore db = Firestore.instance;
    db.collection("usuarios").document(usuario.cpf).updateData(dadosAtualizar);
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizeCard = (sizeHeight * 0.2548) - (sizeHeight * 0.14);
    var sizeCard2 = (sizeHeight * 0.5622);

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
            width: sizeWidth,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: sizeCard * 0.005),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: sizeCard * 0.35,
                      left: sizeWidth * 0.01,
                      right: sizeWidth * 0.01),
                  child: Text(
                    "Escolha o seu avatar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Open Sans Extra Bold',
                        color: Color.fromARGB(255, 48, 48, 48),
                        fontSize: sizeCard * 0.35,
                        fontWeight: FontWeight.bold),
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
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F001-old%20man.png?alt=media&token=3d12a7da-d7ab-4b4f-9b60-6d88ca4b1b20",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F002-old%20woman.png?alt=media&token=fb0a5fc4-2aba-4896-ac37-d77372df6e43",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F003-old%20man.png?alt=media&token=1c65705d-8800-47b5-b43d-6151e8759003",
                            sizeWidth,
                            sizeCard2),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F004-old%20woman.png?alt=media&token=3d4ebb31-bee0-40c8-9054-d9f8cf08449f",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F005-old%20man.png?alt=media&token=a1d5d24d-a4e7-4dc8-bdd6-f060867e0563",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F006-old%20woman.png?alt=media&token=eb705c23-926c-4db5-989d-78a447aa8e92",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 6
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F007-old%20man.png?alt=media&token=d4d542ea-d819-470e-a5ac-2bc8c1ba0169",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F008-old%20woman.png?alt=media&token=40a5300f-4fdf-4a29-98a7-bb3f61c5b1a6",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F009-old%20man.png?alt=media&token=3e6adcdc-d1a8-44bf-8198-f416fd52df58",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 9
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F010-old%20woman.png?alt=media&token=c1f91a31-7911-49e3-8d8f-c4f738112427",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F011-old%20man.png?alt=media&token=71fd40d0-4710-465a-87cf-f1a63685309d",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F012-old%20woman.png?alt=media&token=4e753761-104d-4f36-8927-02a0c039d125",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 12
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F013-old%20man.png?alt=media&token=f0b9640e-ddf0-4a06-a829-5646df276f5e",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F014-old%20woman.png?alt=media&token=00be587f-d374-4b43-a4ae-f98020750e04",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F015-old%20man.png?alt=media&token=71015da7-5006-43f1-bd88-dc759c25b522",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 15
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F016-old%20woman.png?alt=media&token=fdaa7b6c-ae9e-4ff8-9d61-46e26448bf8c",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F017-old%20man.png?alt=media&token=8d5a4399-ba60-45eb-8528-5ec585516420",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F018-old%20woman.png?alt=media&token=4f875491-86fa-4ba3-8cee-a0f0623a2f1e",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 18
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F019-old%20man.png?alt=media&token=b65ae585-d977-4157-991a-ba1d92817f85",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F020-old%20woman.png?alt=media&token=e6a18043-27bf-4598-a4be-234a743737c5",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F021-old%20man.png?alt=media&token=cbf303d9-5db0-4136-aaa0-64d4e5073ecc",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 21
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F022-old%20woman.png?alt=media&token=118cc7f7-7604-4623-8e0b-4f073702f570",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F023-old%20man.png?alt=media&token=b8bf4a53-9722-40d1-aefb-5203089fa5fa",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F024-old%20woman.png?alt=media&token=006b9eba-ade2-4d53-b815-701b8dddc0b8",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 24
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F025-old%20man.png?alt=media&token=22b9abb6-a1a1-4802-a436-3f2bcb3f2dc2",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F026-old%20woman.png?alt=media&token=60bb3b6d-dfc6-4b67-a2b7-56f4b74d44ae",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F027-old%20man.png?alt=media&token=19701325-6b73-4b91-973a-b0d43c90ccaf",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 27
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F028-old%20woman.png?alt=media&token=c852f69f-c55a-4c1a-b8d5-65bc5095a338",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F029-old%20man.png?alt=media&token=a469c8c0-48a9-40b7-a421-3dd41837b5f3",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F030-old%20woman.png?alt=media&token=e8138428-ce41-40fb-90d5-7db64e418963",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 30
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F030-old%20woman.png?alt=media&token=e8138428-ce41-40fb-90d5-7db64e418963",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F032-old%20woman.png?alt=media&token=0bcaed23-d75b-42db-a01a-d638bca038aa",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F033-old%20man.png?alt=media&token=807bdbc4-4464-40a1-9866-4659f7af9391",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 33
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F034-old%20woman.png?alt=media&token=30a2c86e-a6af-4a23-b9f0-c3bb2b8bc821",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F035-old%20man.png?alt=media&token=83188b59-fe6a-4013-a52d-ce0d964b34a9",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F036-old%20woman.png?alt=media&token=9bbbce55-dd38-4c9b-bcab-9d5110839332",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 36
                      Container(
                        margin: EdgeInsets.only(top: sizeCard2 * 0.04),
                        child: buildImages(
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F037-old%20man.png?alt=media&token=4d323178-eb12-47e9-a50d-cf20ed2fc51a",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F038-old%20woman.png?alt=media&token=f4a6530e-aad8-4a48-b7df-c774c98da6e9",
                            "https://firebasestorage.googleapis.com/v0/b/teclarflutter-e3cc9.appspot.com/o/avatares%2Fidosos_pack%2F039-old%20man.png?alt=media&token=972a539e-8182-4886-b505-dc6c24266e2b",
                            sizeWidth,
                            sizeCard2),
                      ), // ! 39
                    ],
                  )),
            ),
          ),
          Container(
            height: sizeCard2 * 0.098,
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
              Container(
                  margin: EdgeInsets.only(
                      left: sizeWidth * 0.06, top: sizeHeight * 0.0145),
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
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/AlterarDados',
                            ModalRoute.withName('/AlterarFotoPerfil'));
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

  Widget buildImages(String imagem1, String imagem2, String imagem3,
      double sizeWidth, double sizeCard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => janelaPopUp(context, sizeWidth, sizeCard));
            updateDados(imagem1);
          },
          child: Container(
            height: sizeCard * 0.3,
            width: sizeWidth * 0.3,
            margin: EdgeInsets.only(top: sizeCard * 0.024),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imagem1), fit: BoxFit.fill),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => janelaPopUp(context, sizeWidth, sizeCard));
            updateDados(imagem2);
          },
          child: Container(
            height: sizeCard * 0.3,
            width: sizeWidth * 0.3,
            margin: EdgeInsets.only(
                top: sizeCard * 0.024,
                left: sizeWidth * 0.02,
                right: sizeWidth * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imagem2), fit: BoxFit.fill),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => janelaPopUp(context, sizeWidth, sizeCard));
            updateDados(imagem3);
          },
          child: Container(
            height: sizeCard * 0.3,
            width: sizeWidth * 0.3,
            margin: EdgeInsets.only(top: sizeCard * 0.024),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imagem3), fit: BoxFit.fill),
            ),
          ),
        ),
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
      content: Text(
        "Foto alterada com sucesso!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 48, 48, 48),
          fontFamily: 'Open Sans Extra Bold',
          fontSize: sizeWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          height: sizeHeight * 0.15,
          width: sizeWidth * 0.35,
          margin: EdgeInsets.only(
              right: sizeWidth * 0.195, bottom: sizeHeight * 0.05),
          child: RaisedButton(
            splashColor: Color(0xfffab611),
            color: Color.fromARGB(255, 93, 30, 132),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.black)),
            onPressed: () async {
              Navigator.popUntil(
                  context, ModalRoute.withName("/AlterarFotoPerfil"));
            },
            child: Text(
              "Continuar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Open Sans Extra Bold',
                fontSize: sizeWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
