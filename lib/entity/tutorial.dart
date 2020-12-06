class Tutorial {
  String _nome;
  String _link;
  int _pontuacao;
  bool _visualizado;
  int _idTutorial;

  Tutorial(this._link, this._pontuacao, this._visualizado, this._idTutorial,
      this._nome);

  bool get visualizado => _visualizado;

  set visualizado(bool value) {
    _visualizado = value;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get pontuacao => _pontuacao;

  set pontuacao(int value) {
    _pontuacao = value;
  }

  int get idTutorial => _idTutorial;

  set idTutorial(int value) {
    _idTutorial = value;
  }
}
