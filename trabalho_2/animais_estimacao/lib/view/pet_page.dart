import 'dart:io';
import 'package:animais_estimacao/database/model/pet_model.dart';
import 'package:animais_estimacao/database/helper/pet_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetPage extends StatefulWidget {
  final Pet? pet;
  const PetPage({Key? key, this.pet}) : super(key: key);

  @override
  _PetPageState createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  final PetHelper helper = PetHelper();
  final _nameController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String? _selectedEspecie;
  String? _selectedSexo;
  String? _imagePath;

  bool _isSaving = false;
  Pet? _editPet;

  final List<String> _especies = ["Cachorro", "Gato", "Pássaro", "Peixe"];
  final List<String> _sexos = ["Macho", "Fêmea"];

  @override
  void initState() {
    super.initState();
    if (widget.pet == null) {
      _editPet = Pet(nome: "", especie: "", raca: "", idade: "", sexo: "");
    } else {
      _editPet = Pet.fromMap(widget.pet!.toMap());
      _nameController.text = _editPet!.nome;
      _racaController.text = _editPet!.raca;
      _idadeController.text = _editPet!.idade;
      _selectedEspecie = _editPet!.especie;
      _selectedSexo = _editPet!.sexo;
      _imagePath = _editPet!.foto;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _savePet() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      _editPet!
        ..nome = _nameController.text
        ..raca = _racaController.text
        ..idade = _idadeController.text
        ..especie = _selectedEspecie ?? ""
        ..sexo = _selectedSexo ?? ""
        ..foto = _imagePath;

      if (_editPet!.id != null) {
        await helper.updatePet(_editPet!);
      } else {
        await helper.savePet(_editPet!);
      }

      setState(() => _isSaving = false);
      Navigator.pop(context, _editPet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _editPet!.id == null ? "Novo Pet" : "Editar Pet",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
            ),
          
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isSaving
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.purple.shade100,
                        backgroundImage: _imagePath != null
                            ? FileImage(File(_imagePath!))
                            : null,
                        child: _imagePath == null
                            ? Icon(
                                Icons.add_a_photo,
                                color: Colors.purple.shade700,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(_nameController, "Nome", Icons.pets),
                    const SizedBox(height: 15),
                    _buildDropdown("Espécie", _especies, _selectedEspecie, (
                      val,
                    ) {
                      setState(() => _selectedEspecie = val);
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(_racaController, "Raça", Icons.badge),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _idadeController,
                      "Idade",
                      Icons.cake_outlined,
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown("Sexo", _sexos, _selectedSexo, (val) {
                      setState(() => _selectedSexo = val);
                    }),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _savePet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Salvar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Preencha o campo $label" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.purple),
        labelText: label,
        labelStyle: TextStyle(color: Colors.purple.shade700),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.purple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.purple, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      alignment: Alignment.center,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: false, 
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(20),
        validator: (val) =>
            val == null || val.isEmpty ? "Selecione $label" : null,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(e, style: const TextStyle(fontSize: 16)),
                ),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.purple,
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.purple.shade700),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.purple.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
        ),
      ),
    );
  }
}
