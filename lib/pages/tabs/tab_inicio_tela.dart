import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/botao_adaptavel_widget.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/balancete_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';


class TabInicioTela extends StatefulWidget {
  const TabInicioTela();
  @override
  _TabInicioTelaState createState() => _TabInicioTelaState();
}

class _TabInicioTelaState extends State<TabInicioTela> {

	BalanceteModel _balancete = new BalanceteModel();
  ContaModel _conta = new ContaModel();
  List<ContaModel> _contaLista = [];
	CartaoModel _cartao = new CartaoModel();
	List<CartaoModel> _cartaoLista = [];

	Widget ?_widgetTopo;
  Widget ?_widgetConta;
  late Widget _widgetSaldo;
  Widget ?_widgetCartoes;

	// CORES TELA
	String _modo = "normal";
	String _background = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

	String _imagem = "";
	var _dados = null;
	// SALDO
	String _saldoGeral ="";
	bool _flagExibirSaldo = false;
	IconData _iconeExibirSaldo = Icons.remove_red_eye;
	int _saldoGeralNumeroCaracteres = 4;

    @override
    void initState() {
      _start();
      super.initState();
    }

  _start() async {
      await _getDataConfig();
      await _setDataConfig();
      await _getBalanceteGeral();
      // await _getConta();
      // await _getCartao();
    }


	_getBalanceteGeral() async {
		_balancete = await _balancete.balancoGeral(periodo: null);
    if( _balancete != null ){
		// if( _balancete.receita != null && _balancete.despesa != null && _balancete.diferenca != null ){
      setState(() {
        _saldoGeralNumeroCaracteres = _balancete.diferenca!.toStringAsFixed(2).length;
        _flagExibirSaldo = (_dados['exibir_saldo'] == "true")?true : false;
        _saldoGeral = (_dados['exibir_saldo'] == "true")? _balancete.diferenca!.toStringAsFixed(2) :"------";
      });
    }

	}


	_setDataConfig() async {
		setState(() {
			_modo = _dados['modo'].toString();
      String temp = "";
      temp = Configuracoes.cores[_modo]?['background'] as String;
			_background = Funcoes.converterCorStringColor( temp );
      temp = Configuracoes.cores[_modo]?['containerFundo'] as String;
			_colorContainerFundo = Funcoes.converterCorStringColor( temp );
      temp = Configuracoes?.cores[_modo]?['containerBorda'] as String;
			_colorContainerBorda = Funcoes.converterCorStringColor( temp );
      temp = Configuracoes?.cores[_modo]?['textoPrimaria'] as String;
			_colorLetra = Funcoes.converterCorStringColor( temp );
		});
	}

	_getDataConfig() async {
		_dados = await ConfiguracaoModel.getConfiguracoes().then( (list) {
			return list;
		});
		return ;
	}

  @override
  Widget build(BuildContext context) {

    // TOPO
    // _widgetTopo = Container(
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //     ),
    //     child: Padding(
    //         padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
    //         child: Column(
    //           children: [
    //             Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //                 Row(
    //                     children: [
    //                         Text("Boa noite" , style: TextStyle(color: Colors.black),),
    //                         SizedBox(width: 5,),
    //                         LabelOpensans("Roberto !" , cor: Colors.black, tamanho: 20 ,bold: true,),
    //                     ],
    //                 ),
    //                 Row(
    //                     children: [
    //                         InkWell(
    //                             onTap: ( ) { _clicFlagMostrarSaldo();},
    //                             child: Icon( _iconeExibirSaldo, size: 45, ) ,
    //                         ),
    //                         SizedBox(width:5),
    //                         GestureDetector(
    //                             onTap: (){
    //                                 Navigator.push( context , MaterialPageRoute( builder: (context) => ConfiguracoesIndexTela() ) );
    //                             },
    //                             child: Column(
    //                                 children: [
    //                                     SizedBox(
    //                                         height: 50,
    //                                         width: 50,
    //                                         child: Icon(MdiIcons.applicationCog, size: 45,)
    //                                     ),
    //                                 ],
    //                             )
    //                         ),
    //                     ],
    //                 ),
    //             ],
    //           ),
    //           SizedBox( height: 30, ),
    //         ]
    //       )
    //     )
    //   );
    
    // SALDOS
    // if( _balancete.receita == null || _balancete.despesa == null || _balancete.diferenca == null ){
    if( _balancete == null){
      _widgetSaldo = Text('');
    }else{
      _widgetSaldo = Container(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:  Color(int.parse(_colorContainerFundo)),
              border: Border.all(color: Color(int.parse(_colorContainerBorda)))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Saldo Atual "),
                  LabelOpensans(" R\$ ${_saldoGeral}",bold: true,),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: LabelOpensans("Balancete",bold: true,tamanho: 25),
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(int.parse(_colorLetra)),
                    child: Icon(Icons.person, color: Color(int.parse(_colorContainerFundo)),),
                  ),
                  title: LabelOpensans("Conta padrão"),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Geral"),
                      Text("R\$ ${_saldoGeral}")
                    ],
                  )
              ),
              Divider(),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(int.parse(_colorLetra)),
                    child: Icon(Icons.person, color: Color(int.parse(_colorContainerFundo)),),
                  ),
                  title: Text("Poupança"),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Banco do Brasil"),
                      Text("R\$ 2.500,00")
                    ],
                  )
              ),
              Divider(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: ElevatedButton(
                  onPressed: null,
                  child: Text("Ajustar Balanço"),
                ),
              ),

            ],
          ),
        ),
      );
    }

    if(_dados != null){
      return Container(
        color: Color(int.parse(_background)),
        child: Column(
          children: [
            // _widgetTopo,
            _widgetSaldo,
          ],
        ),
      );
    }else{
      return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

	_clicFlagMostrarSaldo() async {
		_flagExibirSaldo = !_flagExibirSaldo;
		if(_flagExibirSaldo){
			_iconeExibirSaldo = Icons.visibility;
			_saldoGeral = _balancete.diferenca!.toStringAsFixed(2);
			// _saldoGeral = (_dados['exibir_saldo'] == "true")? _balancete.diferenca.toStringAsFixed(2) :"------";
		}else{
			_iconeExibirSaldo = Icons.visibility_off;
			String regex = "[^\W_]";
			_saldoGeral = _balancete.diferenca!.toStringAsFixed(2).replaceAll(RegExp(regex),"-");
		}
		await ConfiguracaoModel.alterarExibirSaldo( _flagExibirSaldo );
		setState(() {
		  _iconeExibirSaldo;
		  _saldoGeral;
		});
	}

 

  _contaAdicionar(){
    // Navigator.push( context , MaterialPageRoute( builder: (context) => BancoDestaqueTela() ) );
    // #000000
    // Navigator.push( context , MaterialPageRoute( builder: (context) => ContaListTela() ) );
  }

  _cartaoAdicionar(){
    // #000000
    // Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoIndexTela() ) );
  }
}
