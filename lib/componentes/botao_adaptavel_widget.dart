import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';

class BotaoAdptavelWidget extends StatelessWidget {
    final String label;
    final Function onPressed;
    final Color cor;

    BotaoAdptavelWidget( 
      String this.label , 
      Function this.onPressed , 
      Color this.cor
    );

  @override
  Widget build(BuildContext context) {
    // Color corBotao = new Color.fromRGBO(100, 100, 100, 0);
    Color corBotao = (this.cor != null)
      ? Color( Funcoes.converterCorStringColor(this.cor.toString())) 
      : Theme.of(context).primaryColor;

    return (Platform.isIOS)
      ? CupertinoButton(
          child: Text( label.toString() ),
          onPressed: this.onPressed() ,
          color: corBotao,
        )
      :TextButton(
        child: Text( label.toString() ),
        onPressed: this.onPressed() ,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>( corBotao ),
          // color: Theme.of(context).primaryColor,
          // textColor: corBotao ,
        )
      );
    }
}
