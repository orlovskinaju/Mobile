import 'package:flutter/material.dart';
import 'package:traballho1/service/dog_service.dart';
import 'package:traballho1/view/dog_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  bool _loadingMore = false;
  bool _isSearching = false;
  List _dogData = [];
  final TextEditingController _searchController = TextEditingController();

  final DogService dogService = DogService();

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  void _loadDogs() async {
    setState(() {
      _loadingMore = true;
    });
    
    try {
      List<dynamic> newDogs = await dogService.getDogs(_search, _offset);
      setState(() {
        _loadingMore = false;
        if (_offset == 0) {
          _dogData = newDogs;
        } else {
          _dogData.addAll(newDogs);
        }
      });
    } catch (e) {
      setState(() {
        _loadingMore = false;
      });
      print('Erro ao carregar dogs: $e');
    }
  }

  void _loadMoreDogs() {
    setState(() {
      _offset += 20;
    });
    _loadDogs();
  }

  void _clearSearch() {
    setState(() {
      _search = "";
      _searchController.clear();
      _offset = 0;
      _dogData.clear();
      _isSearching = false;
    });
    _loadDogs();
  }

  void _performSearch(String value) {
    setState(() {
      _search = value;
      _offset = 0;
      _dogData.clear();
      _isSearching = true;
    });
    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple,
                  Colors.deepPurple,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Título centralizado
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets, color: Colors.white, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "DogGallery",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Encontre seu dog ideal!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Pesquise por raça aqui",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.purple),
                      suffixIcon: _search.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.purple),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    onSubmitted: _performSearch,
                  ),
                ),
              ],
            ),
          ),

          if (_isSearching && _search.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.purple, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "\"$_search\"",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${_dogData.length} dogs encontrados",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
   
          Expanded(
            child: _dogData.isEmpty && !_loadingMore && !_isSearching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                          strokeWidth: 4.0,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Carregando dogs...",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : _createDogTable(),
          ),
        ],
      ),
    );
  }

  Widget _createDogTable() {
    bool hasMoreDogs = _dogData.length >= 20; 
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: _dogData.length + (hasMoreDogs ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _dogData.length) {
          var dog = _dogData[index];
          var dogUrl = dog["url"];
          
          return _buildDogCard(dog, dogUrl);
        } else {
          return _buildLoadMoreCard();
        }
      },
    );
  }

  Widget _buildDogCard(Map dog, String dogUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.purple,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                dogUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, color: Colors.purple, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Erro ao carregar',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            
              if (dog["breeds"] != null && dog["breeds"].isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      dog["breeds"][0]["name"] ?? "Raça desconhecida",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DogPage(dog))
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: _loadingMore ? null : _loadMoreDogs,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              color: Colors.purple,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loadingMore)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                )
              else
                Icon(
                  Icons.add,
                  color: Colors.purple,
                  size: 40,
                ),
              SizedBox(height: 10),
              Text(
                _loadingMore ? "Carregando..." : "Carregar mais",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}