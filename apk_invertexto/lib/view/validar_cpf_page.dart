import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class ValidarCpfPage extends StatefulWidget {
  const ValidarCpfPage({super.key});

  @override
  State<ValidarCpfPage> createState() => _ValidarCpfPageState();
}

class _ValidarCpfPageState extends State<ValidarCpfPage> {
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
                labelText: "Digite seu CPF",
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
                future: apiService.validaCPF(campo),
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
    if (snapshot.data["valid"] == true) {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          "CPF válido",
          style: TextStyle(color: Colors.white, fontSize: 18),
          softWrap: true,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          "CPF inválido",
          style: TextStyle(color: Colors.white, fontSize: 18),
          softWrap: true,
        ),
      );
    }
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
