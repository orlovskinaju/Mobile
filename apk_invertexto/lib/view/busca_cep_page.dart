import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class BuscaCepPage extends StatefulWidget {
  const BuscaCepPage({super.key});

  @override
  State<BuscaCepPage> createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Digite um CEP",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.buscaCEP(campo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return exibeErro(snapshot.error);
                      } else {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          return exibeResultado(context, snapshot);
                        }
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String enderecoCompleto = '';
    if (snapshot.data != null) {
      enderecoCompleto += snapshot.data['street'] ?? "Rua não disponível";
      enderecoCompleto += '/n';
      enderecoCompleto +=
          snapshot.data['neighborhood'] ?? "Bairro não disponível";
      enderecoCompleto += '/n';
      enderecoCompleto += snapshot.data['city'] ?? "Cidade não disponível";
      enderecoCompleto += '/n';
      enderecoCompleto += snapshot.data['state'] ?? "Estado não disponível";
      enderecoCompleto += '/n';
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        enderecoCompleto,
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }

  Widget exibeErro(Object? erro) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "Ocorreu um erro: $erro",
        style: TextStyle(color: Colors.red, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
