import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/datepicker_adaptavel.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/cad/cad_lancamento_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_pagamento_forma.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_model.dart';

class ModalTabLancamentoListaFiltroTela extends StatefulWidget {
  @override
  _ModalTabLancamentoListaFiltroTelaState createState() => _ModalTabLancamentoListaFiltroTelaState();
}

class _ModalTabLancamentoListaFiltroTelaState extends State<ModalTabLancamentoListaFiltroTela> {

  var body ;

  // TIPO LANCAMENTO
  bool _flagExibirContainerTipoLancamento = false;
  LancamentoTipoCadModel _tipoLancamento = new LancamentoTipoCadModel();
  List<LancamentoTipoCadModel> _tipoLancamentoLista = [];
  Map<String,bool> _retornoTipoLancamentoLista = Map();

  // FAIXA DE PRECO
  FrequenciaModel _frequencia = new FrequenciaModel();
  bool _flagExibirContainerPreco = false;
  double _valorMinimoInicial = 0.00;
  double _valorMaximoInicial = 0.00;
  var _selectRange ;
  RangeLabels labels = new RangeLabels('' ,'');
  Map<String,double> _retornoValoresFaixaPreco = Map();

  //  FORMAS DE PAGAMENTO
  bool _flagExibirContainerFormaPagamento = false;
  PagamentoFormaCadModel _pagamentoFormaCad = PagamentoFormaCadModel();
  List<PagamentoFormaCadModel> _pagamentoFormaLista = [];
  bool valorCheckBox = false;
  List<Map<String,bool>> _lista = [];
  Map<String,bool> _retornoFormaPagamentoLista = Map();

  // DATAS
  bool _flagExibirContainerData = false;
  DateTime _dataInicial = DateTime(DateTime.now().year , DateTime.now().month , 1) ;
  DateTime _dataInicialSelecionada = DateTime(DateTime.now().year , DateTime.now().month , 1) ;
  DateTime _dataFinal = DateTime(DateTime.now().year ,DateTime.now().month+1 , 0) ;
  DateTime _dataFinalSelecionada = DateTime(DateTime.now().year ,DateTime.now().month+1 , 0) ;
  Map<String,DateTime> _retornoDatas = Map();

  // CATEGORIAS
  bool _flagExibirContainerCategoria = false;
  CategoriaCadModel _categoria = CategoriaCadModel();
  List<CategoriaCadModel> _categoriaLista = [];
  Map<String,bool> _retornoCategoriaLista = Map();

  // CARREGAMENTOS
  bool _flagCarregamentoConcluido = false;


  @override
  void initState() {
    _inicar();
  }

  _inicar() async {
    await _buscarTipoLancamento();
    await _buscarValoresFaixaPreco();
    await _buscarFormaPagamento();
    await _buscarCategorias();
    setState(() {
      _flagCarregamentoConcluido = true;
    });
  }

  _buscarTipoLancamento() async {
    _tipoLancamentoLista = await _tipoLancamento.fetchByAll();
    // SETANDO O VALOR FALSE COMO INICIAL
    _tipoLancamentoLista.map((e) {
      var index =  e.id.toString();
      _retornoTipoLancamentoLista[index] = false;
    }).toList();
    setState(() { _retornoTipoLancamentoLista; });
  }

  _buscarFormaPagamento() async {
    _pagamentoFormaLista = await _pagamentoFormaCad.fetchByAll();
    _pagamentoFormaLista.map((e) {
      _retornoFormaPagamentoLista[ e.id.toString() ] = false;
    }).toList();
     setState(() { _retornoFormaPagamentoLista; });
  }


  _buscarValoresFaixaPreco() async {
    var lista = await _frequencia.buscarValores();
    _valorMinimoInicial = 0.00;
    _valorMaximoInicial = lista['vl_integral_max'];
    setState(() {
      _selectRange = RangeValues( _valorMinimoInicial , _valorMaximoInicial );
    });
  }

  _buscarCategorias() async {
    _categoriaLista = await _categoria.fetchByAll();
    // ELIMINANDO O PRIMEIRO ITEM
    _categoriaLista = _categoriaLista.where((element) => element.id! > 1).toList();
    _categoriaLista.map((e) {
      _retornoCategoriaLista[ e.id.toString() ] = false;
    }).toList();
    // ORDEM ALFABETICA
    _categoriaLista.sort( (item1,item2)=> item1.descricao.toString().compareTo(item2.descricao.toString()));
    setState(() { _categoriaLista; _retornoCategoriaLista;});
  }
  @override
  Widget build(BuildContext context) {
    if(_flagCarregamentoConcluido){
      body = Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // TIPO DESPESA
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelQuicksand('TIPO:',bold: true,tamanho: 18,),
                        InkWell(
                          child: (_flagExibirContainerTipoLancamento)? Icon(MdiIcons.arrowUpDropCircleOutline) : Icon(MdiIcons.arrowDownDropCircleOutline),
                          onTap: () => setState(() {
                            _flagExibirContainerTipoLancamento = !_flagExibirContainerTipoLancamento;
                          }),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _flagExibirContainerTipoLancamento,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ..._tipoLancamentoLista.map((e){
                            var index = e.id.toString();
                            bool flag = _retornoTipoLancamentoLista[index] as bool;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    CheckboxListTile(
                                      selected: flag,
                                      title: Text(e.descricao.toString() , style: TextStyle(
                                          fontWeight: flag
                                            ? FontWeight.bold 
                                            : FontWeight.normal 
                                          ),
                                      ),
                                      value: _retornoTipoLancamentoLista[e.id.toString()],
                                      onChanged: (_){
                                        setState(() {
                                          _retornoTipoLancamentoLista[index] = flag;
                                        });
                                      } ,
                                    ),
                                    Visibility(
                                      visible: e.id != _tipoLancamentoLista.last.id,
                                      child: Divider( color:  Colors.black,),
                                    ) ,
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox( height: 20,),

              // FAIXA DE PRECO
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelQuicksand('FAIXA DE PREÇO: ${_selectRange.start.toInt().toString()} - ${_selectRange.end.toInt().toString()}',bold: true,tamanho: 18,),
                        InkWell(
                          child: (_flagExibirContainerPreco)?Icon(MdiIcons.arrowUpDropCircleOutline) : Icon(MdiIcons.arrowDownDropCircleOutline),
                          onTap: () { setState(() { _flagExibirContainerPreco = !_flagExibirContainerPreco; }); },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _flagExibirContainerPreco,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          RangeSlider(
                            divisions: 100,
                            min: _valorMinimoInicial,
                            max: _valorMaximoInicial,
                            values: _selectRange,
                            onChanged: (RangeValues newRange){
                              setState(() {
                                _selectRange = newRange;
                                labels = RangeLabels("${_selectRange.start.toInt().toString()}", "${_selectRange.end.toInt().toString()}");
                              });
                            },
                            labels: labels,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              // FORMA DE PAGAMENTO
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelQuicksand('FORMAS DE PAGAMENTO:',bold: true,tamanho: 18,),
                        InkWell(
                          child: (_flagExibirContainerFormaPagamento)? Icon(MdiIcons.arrowUpDropCircleOutline) : Icon(MdiIcons.arrowDownDropCircleOutline),
                          onTap: () => setState(() { _flagExibirContainerFormaPagamento = !_flagExibirContainerFormaPagamento; }),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _flagExibirContainerFormaPagamento,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ..._pagamentoFormaLista.map((e){
//                            _retornoFormaPagamentoLista[ e.id.toString() ] = false ;
                            var flag = _retornoFormaPagamentoLista[e.id.toString()] as bool;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    CheckboxListTile(
                                      selected:flag,
                                      title: Text(e.descricao.toString() , style: TextStyle(
                                        fontWeight: flag ? FontWeight.bold : FontWeight.normal ),
                                      ),
                                      value: _retornoFormaPagamentoLista[e.id.toString()],
                                      onChanged: (_){
                                        setState(() {
                                          _retornoFormaPagamentoLista[e.id.toString()] = !flag;
                                        });
                                      } ,
                                    ),
                                    Visibility(
                                      visible: e.id != _pagamentoFormaLista.last.id,
                                      child: Divider( color:  Colors.black,),
                                    ) ,
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              // DATAS
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelQuicksand('DATAS: ${Funcoes.converterDataEUAParaBR(_dataInicialSelecionada.toString() )} - ${Funcoes.converterDataEUAParaBR(_dataFinalSelecionada.toString())}',bold: true,tamanho: 18,),
                        InkWell(
                          child: (_flagExibirContainerData)?Icon(MdiIcons.arrowUpDropCircleOutline) : Icon(MdiIcons.arrowDownDropCircleOutline),
                          onTap: () { setState(() { _flagExibirContainerData = !_flagExibirContainerData; }); },
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Visibility(
                      visible: _flagExibirContainerData,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                width: MediaQuery.of(context).size.width * .3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all( color: Colors.white , )
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: 
                                  DatepickerAdaptative(
                                    _dataInicialSelecionada,
                                    (newDate){
                                      setState(() {
                                        _dataInicialSelecionada = newDate;
                                      });
                                    },
                                  ),
                                )
                              ),
                              SizedBox( width: 20,),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  width: MediaQuery.of(context).size.width * .3,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all( color: Colors.white , )
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: DatepickerAdaptative(
                                      _dataFinalSelecionada,
                                      (newDate) {
                                        setState(() {
                                          _dataFinalSelecionada = newDate;
                                        });
                                      },
                                    ),
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),

              // CATEGORIA
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelQuicksand('CATEGORIAS: ',bold: true,tamanho: 18,),
                        Container(
                          width: MediaQuery.of(context).size.width * .3,
                          child:TextField(
                            decoration: InputDecoration(
                                hintText: 'Categoria'
                            ),
                          ),
                        ),
                        InkWell(
                            child: (_flagExibirContainerCategoria)?Icon(MdiIcons.arrowUpDropCircleOutline) : Icon(MdiIcons.arrowDownDropCircleOutline),
                          onTap: () { setState(() { _flagExibirContainerCategoria = !_flagExibirContainerCategoria; }); },
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Visibility(
                      visible: _flagExibirContainerCategoria,
                      child: Container(
                        height: 200,
                        child: ListView(
                          children: [
                            ..._categoriaLista.map((item) {
//                              _retornoCategoriaLista[ item.id.toString() ] = false ;
                                var flag = _retornoCategoriaLista[item.id.toString()] as bool;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      children: [
                                        CheckboxListTile(
                                          selected: flag,
                                          title: Text(item.descricao.toString() , style: TextStyle(
                                            fontWeight: flag ? FontWeight.bold : FontWeight.normal ),
                                          ),
                                          value: _retornoCategoriaLista[item.id.toString()],
                                          onChanged: (_){
                                            setState(() {
                                              _retornoCategoriaLista[item.id.toString()] = !flag;
                                            });
                                          } ,
                                        ),
                                        Visibility(
                                          visible: ( item.id != _categoriaLista.last.id ),
                                          child: Divider(color: Colors.black,),
                                        )
                                      ],
                                    );
                                  }
                                );
                            }),
                          ],
                        ),
                      ),

                    )
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  OutlineButton(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor ,
                      width: 3,
                    ),
                    child: Text('cancelar' , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Theme.of(context).primaryColor),),
                    onPressed: (){ Navigator.pop(context);}
                  ),
                  SizedBox( width: 20,),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('FILTRAR' , style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                       var retorno = await filtrar();
                       Navigator.pop(context , retorno);
                      }
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );
    }else{
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Filtro"),
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }

  filtrar() async {

    Map<String,dynamic> retorno = Map();
    // SE LISTA CONTER ALGUM VALOR VERDADEIRO RETORNA
    if( _retornoTipoLancamentoLista.containsValue(true) ){

      List retornoTipoLancamentoListaVarrida = [];
      _retornoTipoLancamentoLista.forEach((key, value) {
        if(value) retornoTipoLancamentoListaVarrida.add(key);
      });
      retorno['id_lancamento_tipo'] = retornoTipoLancamentoListaVarrida;
    }

    // VALOR
    if(_selectRange.start > _valorMinimoInicial || _selectRange.end < _valorMaximoInicial){
      _retornoValoresFaixaPreco['vl_minimo'] = _selectRange.start;
      _retornoValoresFaixaPreco['vl_maximo'] = _selectRange.end;
      retorno['vl_integral'] = _retornoValoresFaixaPreco;
    }

    // FORMA DE PAGAMENTO
    if( _retornoFormaPagamentoLista.containsValue(true) ){
      List retornoFormaPagamentoListaVarrida = [];
      _retornoFormaPagamentoLista.forEach((key, value) {
        if(value) retornoFormaPagamentoListaVarrida.add(key);
      });
      retorno['id_pagamento_forma'] = retornoFormaPagamentoListaVarrida;
    }

    // DATAS
    if(_dataInicialSelecionada != _dataInicial || _dataFinalSelecionada != _dataFinal){
      _retornoDatas['dt_inicial'] = _dataInicial;
      _retornoDatas['dt_final'] = _dataFinal;
      retorno['dt_detalhe'] = _retornoDatas;
    }

    // CATEGORIAS
    if( _retornoCategoriaLista.containsValue(true) ){
      List retornoCategoriaListaVarrida = [];
      _retornoCategoriaLista.forEach((key, value) {
        if(value) retornoCategoriaListaVarrida.add(key);
      });
      retorno['id_categoria'] = retornoCategoriaListaVarrida;
    }
    return retorno;
  }
}
