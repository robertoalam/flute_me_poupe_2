import 'package:flutter/material.dart';
import '/model/configuracoes/icone_cad_model.dart';

class IconeGambiarra extends StatelessWidget {

  final IconeCadModel icone;
  final Color cor;
  final double tamanho;

  IconeGambiarra(this.icone,this.cor,this.tamanho);

  @override
  Widget build(BuildContext context) {

    Color colorir = (cor != null)? cor : Colors.white;
    double dimensionar = (tamanho != null)? tamanho : 14.0;

    return Icon(
      IconData( 
        int.parse( icone.codigo.toString() ), 
        fontFamily: icone.familia , 
        fontPackage: icone.pacote 
      ),
      color: colorir,
      size: dimensionar,
    );
  }


}
