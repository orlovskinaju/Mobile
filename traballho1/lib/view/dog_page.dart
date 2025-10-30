import 'package:flutter/material.dart';

class DogPage extends StatelessWidget {
  final Map _dogData;

  DogPage(this._dogData);

  @override
  Widget build(BuildContext context) {
    final breeds = _dogData["breeds"] != null && _dogData["breeds"].isNotEmpty 
        ? _dogData["breeds"][0] 
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          breeds?["name"] ?? "Dog Fofinho",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              width: double.infinity,
              child: ClipRRect(
                child: Image.network(
                  _dogData["url"],
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
                ),
              ),
            ),
            
            if (breeds != null) 
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sobre a raça",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    if (breeds["temperament"] != null)
                      _buildInfoRow("Temperamento", breeds["temperament"]),
                    
                    if (breeds["life_span"] != null)
                      _buildInfoRow("Expectativa de Vida", breeds["life_span"]),
                    
                    if (breeds["bred_for"] != null)
                      _buildInfoRow("Função Original", breeds["bred_for"]),
                    
                    if (breeds["origin"] != null)
                      _buildInfoRow("Origem", breeds["origin"]),
                    
                    if (breeds["weight"] != null && breeds["weight"]["metric"] != null)
                      _buildInfoRow("Peso", "${breeds["weight"]["metric"]} kg"),
                    
                    if (breeds["height"] != null && breeds["height"]["metric"] != null)
                      _buildInfoRow("Altura", "${breeds["height"]["metric"]} cm"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}