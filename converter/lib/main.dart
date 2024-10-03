import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=API_KEY';

void main() async {
  await getData();
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> formKey = GlobalKey();

  late double dolar;
  late double euro;

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  void _realChanged(String text) {
    if (text.isNotEmpty) {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsPrecision(2);
      euroController.text = (real / euro).toStringAsPrecision(2);
    } else {
      _resetCampos();
    }
  }

  void _dolarChanged(String text) {
    if (text.isNotEmpty) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsPrecision(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsPrecision(2);
    } else {
      _resetCampos();
    }
  }

  void _euroChanged(String text) {
    if (text.isNotEmpty) {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsPrecision(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsPrecision(2);
    } else {
      _resetCampos();
    }
  }

  void _resetCampos() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          '\$ Conversor \$',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text(
                    'Carregando dados',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar dados',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data?['results']['currencies']['USD']['buy'];
                  euro = snapshot.data?['results']['currencies']['EUR']['buy'];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15),
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 120,
                        ),
                        const SizedBox(height: 15),
                        buildTextField(
                            'Reais', 'R\$ ', realController, _realChanged),
                        const SizedBox(height: 15),
                        buildTextField(
                            'Dólar', 'US\$ ', dolarController, _dolarChanged),
                        const SizedBox(height: 15),
                        buildTextField(
                            'Euro', '€ ', euroController, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function(String) function) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber, fontSize: 25),
      border: OutlineInputBorder(),
      prefix: Text(prefix),
    ),
    style: const TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: function,
  );
}
