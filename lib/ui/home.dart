import '../root/file.dart';
import '../models/anotacao.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Anotacao> anotacoes = [];
  String texto = "";

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    List<String> linhas = (await GerenciarArquivo.abrir()).split('\n');
    setState(() {
      anotacoes = linhas.map((linha) => Anotacao.fromCSV(linha)).toList();
    });
  }

  void salvarDados() {
    String conteudo = anotacoes.map((anotacao) => anotacao.toCSV()).join('\n');
    GerenciarArquivo.salvar(conteudo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        actions: [
          GestureDetector(
            onTap: () {
              cadastrar();
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Icon(Icons.add, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, i) => ListTile(
            title: Text(anotacoes[i].data),
            subtitle: Text(anotacoes[i].texto),
            trailing: GestureDetector(
              onTap: () => excluir(i),
              child: Icon(Icons.delete),
            ),
          ),
          separatorBuilder: (_, _) => Divider(),
          itemCount: anotacoes.length,
        ),
      ),
    );
  }

  void cadastrar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova anotação'),
        content: TextField(
          decoration: InputDecoration(hintText: "Digite sua anotação"),
          onChanged: (value) => setState(() {
            texto = value;
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              String data = DateTime.now().toString().substring(0, 16);
              setState(() {
                anotacoes.add(Anotacao(data: data, texto: texto));
              });
              salvarDados();
            },
            child: Text("Cadastrar"),
          ),
        ],
      ),
    );
  }

  void excluir(int indice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir anotação'),
        content: Text('Confirma a exclusão desta anotação'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                anotacoes.removeAt(indice);
              });
              salvarDados();
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}