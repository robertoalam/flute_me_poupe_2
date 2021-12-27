// import 'package:flutter/material.dart';
// import 'package:me_poupe/helper/configuracoes_helper.dart';
// import 'package:me_poupe/helper/database_helper.dart';

import '../../helper/configuracoes_helper.dart';
import '../../helper/database_helper.dart';

class IconeCadModel {
  String ?icone;
  int ?codigo;
  String ?familia;
  String ?pacote;
  String ?tag;

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "icone_cad";

  IconeCadModel({this.icone, this.codigo, this.familia,this.pacote, this.tag });

  List<IconeCadModel> get buscarLista {
    var listaBugada = Configuracoes.icones;
    List<IconeCadModel> lista = [];
    listaBugada.forEach((el) {
      lista.add(
        new IconeCadModel(
          icone: el['icone'].toString() , 
          codigo: int.parse(el['codigo'].toString()) , 
          familia: el['familia'].toString() , 
          pacote: el['pacote'].toString()
        )
      );
    });
    return lista;
  }

  factory IconeCadModel.find(String label) {
    var listaBugada = Configuracoes.icones;
    var lista1 = listaBugada.where( (item) => item['icone'] == label).toList();
    IconeCadModel icone = new IconeCadModel();
    if(lista1.length > 0){
      var el = lista1[0];
      icone.icone = el['icone'].toString();
      icone.codigo = int.parse(el['codigo'].toString());
      icone.familia = el['familia'].toString();
      icone.pacote = el['pacote'].toString();
      // return new IconeCadModel(
      //     icone: el['icone'].toString() , 
      //     codigo: int.parse(el['codigo'].toString()) , 
      //     familia: el['familia'].toString() , 
      //     pacote: el['pacote'].toString()
      // );
    }
    return icone;
  }

  factory IconeCadModel.fromJson(Map<String, dynamic> json) {
    return IconeCadModel(
      icone: json['icone'],
      codigo: json['codigo'],
      familia: json['familia'],
      pacote: json['pacote'],
      tag: json['tags'],
    );
  }

  factory IconeCadModel.getDestaque(int destaque) {
    final dbHelper = DatabaseHelper.instance;
    var linha;
    if( destaque != null || destaque.toString() != "" ) {
      linha = dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque],orderBy: " ORDER BY ordem_destaque DESC");
      linha = linha.isNotEmpty ? IconeCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByDestaque(int destaque) async {
    var linhas;
    List<IconeCadModel> lista = [];
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque]);
      for(int i=0;i < linhas.length ; i++){
        IconeCadModel objeto = new IconeCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchByIcone(String pesquisa) async {
    var linhas;
    List<IconeCadModel> lista = [];
    if( pesquisa != null || pesquisa.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "icone = ?", whereArgs: [pesquisa]);
      for(int i=0;i < linhas.length ; i++){
        IconeCadModel objeto = new IconeCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchBySearch(String pesquisa) async {
    var linhas;
    List<IconeCadModel> lista = [];
    if( pesquisa != null || pesquisa.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "tags LIKE ?", whereArgs: [pesquisa]);
      for(int i=0;i < linhas.length ; i++){
        IconeCadModel objeto = new IconeCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? IconeCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<IconeCadModel> lista = [];
    for(int i=0;i < linhas.length ; i++){
      IconeCadModel objeto = new IconeCadModel.fromJson(linhas[i]);
      lista.add(objeto);
    }
    return lista;
  }
}