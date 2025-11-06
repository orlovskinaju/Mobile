import 'dart:io';
import 'package:animais_estimacao/database/model/pet_model.dart';
import 'package:animais_estimacao/database/helper/pet_helper.dart';
import 'package:animais_estimacao/view/pet_page.dart';
import 'package:flutter/material.dart';

class PetDetailsPage extends StatelessWidget {
  final Pet pet;
  final PetHelper helper = PetHelper();

  PetDetailsPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pet.nome),
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.purple.shade100,
              backgroundImage: pet.foto != null && pet.foto!.isNotEmpty
                  ? FileImage(File(pet.foto!))
                  : null,
              child: pet.foto == null || pet.foto!.isEmpty
                  ? Icon(Icons.pets, color: Colors.purple, size: 60)
                  : null,
            ),
            const SizedBox(height: 25),

            Text(
              pet.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            _buildInfoTile(Icons.pets, "Espécie", pet.especie),
            _buildInfoTile(Icons.badge, "Raça", pet.raca),
            _buildInfoTile(Icons.cake, "Idade", "${pet.idade} anos"),
            _buildInfoTile(Icons.wc, "Sexo", pet.sexo),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final updatedPet = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetPage(pet: pet),
                      ),
                    );
                    if (updatedPet != null) {
                      Navigator.pop(context, updatedPet);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "Editar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Excluir Pet"),
                        content: Text(
                          "Tem certeza que deseja excluir ${pet.nome}?",
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: const Text(
                              "Excluir",
                              style: TextStyle(color: Colors.purple),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await helper.deletePet(pet.id!);
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Excluir",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 10),
          Text(
            "$label:",
            style: TextStyle(
              color: Colors.purple.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
