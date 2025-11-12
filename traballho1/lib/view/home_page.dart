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
  bool _isLoading = true;
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
        _isLoading = false;
        if (_offset == 0) {
          _dogData = newDogs;
        } else {
          _dogData.addAll(newDogs);
        }
      });
    } catch (e) {
      setState(() {
        _loadingMore = false;
        _isLoading = false;
      });
      print('Erro ao carregar dogs: $e');
    }
  }

  void _loadMoreDogs() {
    setState(() => _offset += 20);
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
      _isLoading = true;
    });
    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _buildHeader(),
              if (_isSearching && _search.isNotEmpty) _buildSearchInfo(),
              Expanded(
                child: _dogData.isEmpty && !_loadingMore && !_isLoading
                    ? const Center(
                        child: Text(
                          "Dados não cadastrados",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : _createDogTable(),
              ),
            ],
          ),

          // Loading overlay discreto
          if (_isLoading || _loadingMore)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
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
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
          const SizedBox(height: 20),
          const Text(
            "Encontre seu dog ideal!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Pesquise por raça aqui",
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search, color: Colors.purple),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.purple),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 16),
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildSearchInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.purple, size: 16),
                const SizedBox(width: 4),
                Text(
                  "\"$_search\"",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            "${_dogData.length} dogs encontrados",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _createDogTable() {
    bool hasMoreDogs = _dogData.length >= 20;
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.purple,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.network(
              dogUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.purple),
                    ),
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.pets, color: Colors.purple, size: 40),
              ),
            ),
            if (dog["breeds"] != null && dog["breeds"].isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    dog["breeds"][0]["name"] ?? "Raça desconhecida",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DogPage(dog)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreCard() => const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
    ),
  );
}
