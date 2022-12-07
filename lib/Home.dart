import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/Anotacaohelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper ();
   List<Anotacao?> _anotacoes = [];


  _exibirTelaCadastro({Anotacao? anotacao}){

    String textoSalvarAtualizar = "" ;
    if ( anotacao == null){//salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else{//atualizar
      _descricaoController.text = anotacao.titulo;
      _tituloController.text =  anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";

    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text ('$textoSalvarAtualizar anotação'),
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

                    _salvarAtualizrAnotacao(anotacaoSelecionada: anotacao);

                    Navigator.pop(context);
                  },
                  child: Text (textoSalvarAtualizar),
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
  _recuperarAnotacoes() async{

    List ?anotacoesRecuperadas = await _db.recuperarAnotacoes();


    List<Anotacao>? listaTemporaria = [];
    for (var item in anotacoesRecuperadas!){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add( anotacao );


    }
    setState(() {
      _anotacoes = listaTemporaria!;
    });
    listaTemporaria = null;



  }

  _salvarAtualizrAnotacao({Anotacao? anotacaoSelecionada}) async{

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if( anotacaoSelecionada == null){//salvar
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);

    }else{//Atualizar
      anotacaoSelecionada.titulo    = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data      = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _descricaoController.clear();
    _tituloController.clear();

    _recuperarAnotacoes();

  }

  _formatarData(String data){

    initializeDateFormatting("pt_BR");
    //Hour -> H minute -> m second -> s
    //Year -> y Month -> M Day -> d
    // var formatador = DateFormat("dd/MMM/y H:m:s");
    var formatador = DateFormat.yMMMEd("pt_Br");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;

  }
  _removerAnotacao(int? id) async{

    await _db.removerAnotacao( id );

    _recuperarAnotacoes();

  }

        @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {

    _recuperarAnotacoes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children:<Widget> [
          Expanded(
              child: ListView.builder(
                itemCount: _anotacoes.length,
                  itemBuilder: (context, index){

                  final anotacao = _anotacoes [index];

                  return Card(
                    child: ListTile(
                      title: Text (anotacao!.titulo),
                      subtitle: Text ("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              _exibirTelaCadastro(anotacao: anotacao);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _removerAnotacao( anotacao.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );

                  }
              ),
          )
        ],
      ),
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
