import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/Anotacaohelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper ();

  _exibirTelaCadastro(){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text ('Adicionar anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,// para usar o espaco minimo
              children: <Widget>[
                TextField(
                  controller: _tituloController ,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Titulo",
                    hintText: "Digite título...",
                  ),
                ),
                TextField(
                  controller: _descricaoController ,
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite descrição...",
                  ),
                )
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){

                    _salvarAnotacao();

                    Navigator.pop(context);
                  },
                  child: Text ("Salvar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context) ,
                child: Text ("Cancelar"),
              ),

            ],
          );

        }
    );

  }
  _recuperarAnotacoes(){

  }

  _salvarAnotacao() async{

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    
    //print("data atual: " + DateTime.now().toString());
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print("salvar anotacao: " + resultado.toString());

    _descricaoController.clear();
    _tituloController.clear();

        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.black26,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          onPressed: (){
            _exibirTelaCadastro();
          },
      ),
    );
  }
}
