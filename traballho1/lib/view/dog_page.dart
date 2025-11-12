import 'package:flutter/material.dart';

class DogPage extends StatelessWidget {
  final Map dog;

  const DogPage(this.dog, {Key? key}) : super(key: key);

  Widget _buildInfoRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.purple[700],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var breeds = dog["breeds"] != null && dog["breeds"].isNotEmpty
        ? dog["breeds"][0]
        : {};
    String imageUrl = dog["url"];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Imagem principal
          Positioned.fill(
            child: Image.network(
              imageUrl,
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
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.pets, color: Colors.purple, size: 50),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 16, 24, 10),
                        child: Center(
                          child: Text(
                            breeds["name"] ?? "Raça desconhecida",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                        ),
                      ),

                      if (breeds["temperament"] != null)
                        _buildInfoRow("Temperamento", breeds["temperament"]),
                      if (breeds["life_span"] != null)
                        _buildInfoRow(
                          "Expectativa de Vida",
                          breeds["life_span"],
                        ),
                      if (breeds["bred_for"] != null)
                        _buildInfoRow("Função Original", breeds["bred_for"]),
                      if (breeds["origin"] != null)
                        _buildInfoRow("Origem", breeds["origin"]),
                      if (breeds["weight"] != null &&
                          breeds["weight"]["metric"] != null)
                        _buildInfoRow(
                          "Peso",
                          "${breeds["weight"]["metric"]} kg",
                        ),
                      if (breeds["height"] != null &&
                          breeds["height"]["metric"] != null)
                        _buildInfoRow(
                          "Altura",
                          "${breeds["height"]["metric"]} cm",
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),

          // Nome da raça no topo (sobre imagem)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                breeds["name"] ?? "",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: Offset(1, 1),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
