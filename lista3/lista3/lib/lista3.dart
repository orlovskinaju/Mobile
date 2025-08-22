import 'dart:math';


enum Naipe { copas, ouro, espadas, paus }

enum Valor {
  as,
  dois,
  tres,
  quatro,
  cinco,
  seis,
  sete,
  oito,
  nove,
  dez,
  valete,
  dama,
  rei
}

class Carta {
  final Naipe naipe;
  final Valor valor;

  Carta(this.naipe, this.valor);

  @override
  String toString() {

    String valorStr = valor.toString().split('.').last.toUpperCase();
    String naipeStr = naipe.toString().split('.').last.toUpperCase();
    return "$valorStr DE $naipeStr";
  }
}

class Baralho {
  final List<Carta> _cartas = [];

  Baralho() {
    for (var naipe in Naipe.values) {
      for (var valor in Valor.values) {
        _cartas.add(Carta(naipe, valor));
      }
    }
  }

  void embaralhar() {
    _cartas.shuffle(Random());
  }

  Carta comprar() {
    return _cartas.removeAt(0);
  }


  int cartasRestantes() => _cartas.length;
}