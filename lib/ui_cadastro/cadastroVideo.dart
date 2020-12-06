import 'package:flutter/material.dart';
import 'package:material_splash_screen/ui_cadastro/2_cadastroNome.dart';
import 'package:material_splash_screen/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Cadastrar1 extends StatefulWidget {
  @override
  _Cadastrar1State createState() => _Cadastrar1State();
}

class _Cadastrar1State extends State<Cadastrar1> {
  String videoURL = "https://www.youtube.com/watch?v=HryFL3RjM_I";
  YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoURL),
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    var sizecard = sizeHeight * 0.867;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 178, 42),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: sizecard,
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
                          top: sizecard * 0.12, bottom: sizecard * 0.001),
                      child: Center(
                        child: Image.asset(
                          "images/LOGOTIPO.png",
                          fit: BoxFit.contain,
                          height: sizeHeight * 0.15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: sizecard * 0.04, bottom: sizecard * 0.01),
                      child: Text(
                        "Assista abaixo\ncomo se CADASTRAR:",
                        style: TextStyle(
                            fontFamily: 'Open Sans Extra Bold',
                            color: Color.fromARGB(255, 48, 48, 48),
                            fontSize: sizeWidth * 0.07,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        height: sizecard * 0.43,
                        width: sizeWidth,
                        child: YoutubePlayer(
                          controller: _controller,
                        )),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: sizeWidth * 0.06, top: sizeHeight * 0.025),
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
                          Navigator.of(context).pop(MaterialPageRoute(
                              builder: (context) => Splash()));
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
                Padding(
                    padding: EdgeInsets.only(
                        left: sizeWidth * 0.086, top: sizeHeight * 0.025),
                    child: Container(
                      height: sizeHeight * 0.085,
                      width: sizeWidth * 0.4,
                      child: RaisedButton(
                        onPressed: () {
                          _controller.pause();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CadastrarNome()));
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
                              "FAZER\nCADASTRO",
                              textAlign: TextAlign.center,
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
      ),
    );
  }
}
