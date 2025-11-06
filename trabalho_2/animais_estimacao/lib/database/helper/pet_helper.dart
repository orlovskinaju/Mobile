import 'package:animais_estimacao/database/model/pet_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PetHelper {
  static final PetHelper _instance = PetHelper.internal();
  factory PetHelper() => _instance;
  PetHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "petsDB.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $petTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $especieColumn TEXT, $racaColumn TEXT, $idadeColumn TEXT, $sexoColumn TEXT, $fotoColumn TEXT)");
    });
  }

  Future<Pet> savePet(Pet pet) async {
    Database dbPet = await db;
    pet.id = await dbPet.insert(petTable, pet.toMap());
    return pet;
  }

  Future<Pet?> getPet(int id) async {
    Database dbPet = await db;
    List<Map<String, dynamic>> maps = await dbPet.query(
      petTable,
      columns: [
        idColumn,
        nameColumn,
        especieColumn,
        racaColumn,
        idadeColumn,
        sexoColumn,
        fotoColumn
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Pet.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Pet>> getAllPets() async {
    Database dbPet = await db;
    List<Map<String, dynamic>> listMap = await dbPet.query(petTable);
    List<Pet> listPet = [];
    for (Map<String, dynamic> m in listMap) {
      listPet.add(Pet.fromMap(m));
    }
    return listPet;
  }

  Future<int> deletePet(int id) async {
    Database dbPet = await db;
    return await dbPet.delete(
      petTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updatePet(Pet pet) async {
    Database dbPet = await db;
    return await dbPet.update(
      petTable,
      pet.toMap(),
      where: "$idColumn = ?",
      whereArgs: [pet.id],
    );
  }
}
