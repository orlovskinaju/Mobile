String idColumn = "idColumn";
String nameColumn = "nameColumn";
String especieColumn = "especieColumn";
String racaColumn = "racaColumn";
String idadeColumn = "idadeColumn";
String sexoColumn = "sexoColumn";
String fotoColumn = "fotoColumn";
String petTable = "petTable";

class Pet {
  Pet({
    this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idade,
    required this.sexo,
    this.foto,
  });

  int? id;
  String nome;
  String especie;
  String raca;
  String idade;
  String sexo;
  String? foto;

  Pet.fromMap(Map<String, dynamic> map)
    : id = map[idColumn],
      nome = map[nameColumn],
      especie = map[especieColumn],
      raca = map[racaColumn],
      idade = map[idadeColumn],
      sexo = map[sexoColumn],
      foto = map[fotoColumn];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: nome,
      especieColumn: especie,
      racaColumn: raca,
      idadeColumn: idade,
      sexoColumn: sexo,
      fotoColumn: foto,
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Pet(id: $id, nome: $nome, especie: $especie, raça: $raca, idade: $idade, sexo: $sexo, foto: $foto)";
  }
}
