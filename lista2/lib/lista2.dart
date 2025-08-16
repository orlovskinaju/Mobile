
void exe1() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga"];
  print(frutas);
}


void exe2() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga"];
  print("Terceira fruta: ${frutas[2]}");
}


void exe3() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga"];
  frutas.add("laranja");
  print("Após adicionar laranja: $frutas");
  frutas.remove("maçã");
  print("Após remover maçã: $frutas");
}


void exe4() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga"];
  for (int i = 0; i < frutas.length; i++) {
    print(frutas[i].toUpperCase());
  }
}


void exe5() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga"];
  frutas.forEach((f) => print(f.toLowerCase()));
}


void exe6() {
  List<String> frutas = ["maçã", "banana", "uva", "pera", "manga", "abacaxi", "ameixa"];
  List<String> frutasComA = frutas.where((f) => f.startsWith("a")).toList();
  print("Frutas com A: $frutasComA");
}


void exe7() {
  Map<String, double> precosFrutas = {
    "maçã": 3.50,
    "banana": 2.00,
    "uva": 5.00,
    "pera": 4.00,
    "manga": 3.00,
  };
  print(precosFrutas);
}


void exe8() {
  Map<String, double> precosFrutas = {
    "maçã": 3.50,
    "banana": 2.00,
    "uva": 5.00,
    "pera": 4.00,
    "manga": 3.00,
  };

  for (var entry in precosFrutas.entries) {
    print("${entry.key} custa R\$${entry.value}");
  }
}


void exe9() {
  var filtrarPares = (List<int> numeros) {
    return numeros.where((n) => n % 2 == 0).toList();
  };

  List<int> lista = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  print("Números pares: ${filtrarPares(lista)}");
}


enum Pessoas { brenda, julia, pedro, ana, lucas }

class Pessoa {
  String nome;
  int idade;
  Pessoa(this.nome, this.idade);
}

void exe10() {
  List<Pessoa> pessoas = [
    Pessoa("brenda", 17),
    Pessoa("julia", 20),
    Pessoa("pedro", 15),
    Pessoa("ana", 22),
    Pessoa("lucas", 18),
  ];

  print("Maiores de idade:");
  pessoas.where((p) => p.idade >= 18).forEach((p) => print(p.nome));
}


