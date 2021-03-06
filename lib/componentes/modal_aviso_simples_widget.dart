import 'package:flutter/material.dart';

class ModalAvisoSimplesWidget extends StatelessWidget {
  final BuildContext context;
  final String titulo;
  final String mensagem;
  final String ?textoBotao;
  // final String action;
  final void Function(bool) onSubmit;
  final bool exibirBotaoCancelar;

  ModalAvisoSimplesWidget(
    this.context, 
    this.titulo,
    this.mensagem,
    this.onSubmit,
    {this.textoBotao , this.exibirBotaoCancelar = false}
  );

  @override
  Widget build(BuildContext context) {

    String botaoTexto = (this.textoBotao != null) ? "OK":this.textoBotao.toString();
    bool botaoCancelar = (this.exibirBotaoCancelar != null) ? this.exibirBotaoCancelar : false;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            height: MediaQuery.of(this.context).size.height * .3,
            width: MediaQuery.of(this.context).size.width * .7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${this.titulo}" , style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                Text(
                  "${this.mensagem} " ,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: ( botaoCancelar ) ,
                        child: RaisedButton(
                          onPressed: (){
                            this.onSubmit(false);
                            Navigator.pop(this.context , false);
                          },
                          child: Text("cancelar" , style: TextStyle(color: Theme.of(context).primaryColor , fontWeight: FontWeight.bold),),
                        ),
                      ),

                      SizedBox(width: 20,),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          this.onSubmit(true);
                          Navigator.pop(this.context , true);
                        } ,
                        child: Text("${botaoTexto}" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
