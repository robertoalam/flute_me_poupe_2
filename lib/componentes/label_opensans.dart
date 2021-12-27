import 'package:flutter/material.dart';

class LabelOpensans extends StatelessWidget {
  String texto;
  Color cor = new Color.fromRGBO(0,0,0,0);
  double tamanho = 14;
  bool bold = false;

  LabelOpensans(this.texto ,{cor , tamanho, bold });

  @override
  Widget build(BuildContext context) {

    Color cor = (this.cor != null) ?  this.cor : Colors.black;
    double size = (this.tamanho != null) ?  this.tamanho : 14;
    var negrito = (this.bold) ? FontWeight.bold : FontWeight.normal ;

    return Text( texto , style: TextStyle(
      fontFamily: "OpenSans",
      fontSize: size,
      fontWeight: negrito,
      color: cor
    ),);
  }
}



