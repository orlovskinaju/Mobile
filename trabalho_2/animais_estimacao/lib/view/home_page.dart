import 'dart:io';
import 'package:animais_estimacao/database/model/pet_model.dart';
import 'package:animais_estimacao/database/helper/pet_helper.dart';
import 'package:animais_estimacao/view/pet_details_page.dart';
import 'package:flutter/material.dart';
import 'pet_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PetHelper helper = PetHelper();
  List<Pet> pets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    setState(() => _isLoading = true);
    try {
      List<Pet> list = await helper.getAllPets();
      setState(() {
        pets = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Erro ao carregar pets: $e");
    }
  }

  void _openPetDetails(Pet pet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailsPage(pet: pet)),
    );

    if (result != null) {
      _loadPets(); 
    }
  }

  void _showPetPage({Pet? pet}) async {
    final updatedPet = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetPage(pet: pet)),
    );
    if (updatedPet != null) {
      _loadPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add
        , color: Colors.white),
        onPressed: () => _showPetPage(),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.pets, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "PetGallery",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Gerencie seus animais de estimação",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.purple,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Carregando pets...",
                          style: TextStyle(color: Colors.purple, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : pets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.pets, color: Colors.purple, size: 60),
                        SizedBox(height: 15),
                        Text(
                          "Nenhum pet cadastrado ainda!",
                          style: TextStyle(color: Colors.purple, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      return _buildPetCard(pets[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return GestureDetector(
      onTap: () => _openPetDetails(pet),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.purple,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              pet.foto != null && pet.foto!.isNotEmpty
                  ? Image.file(
                      File(pet.foto!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.pets,
                          color: Colors.purple.shade300,
                          size: 50,
                        ),
                      ),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Text(
                    pet.nome,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.white,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
