import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Map _data;
List _features;

void main() async {
  _data = await showEarthquake();
  _features = _data['features'];

  runApp(new MaterialApp(
    home: Earthquake(),
  ));
}

class Earthquake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Earthquake',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500),
        ),centerTitle: true,
      ),//appbar
      body: Center(
        child: ListView.builder(
            itemCount: _features.length,
            padding: EdgeInsets.all(15.5),
            itemBuilder: (BuildContext context, int position){
              initializeDateFormatting('pt_BR', null);
              var format = new DateFormat.yMMMMd('pt_BR');

              var date = format.format(
                  new DateTime.fromMicrosecondsSinceEpoch(
                      _features[position]['properties']['time'] * 1000));

              return Column(
                children: <Widget>[
                  Divider(
                    height: 5.5,
                  ),
                  ListTile(
                    title: Text(
                      '$date',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.6,
                      ),
                    ),//Text
                    subtitle: Text(
                      '${_features[position]['properties']['place']}'
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Text(
                        '${_features[position]['properties']['mag']}',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),//leading
                    onTap: (){
                      showMsg(context, '${_features[position]['properties']['title']}');
                  },
                  ),//ListTitle
                ],//widget
              );//Column
            })),//Center, LitView, ItemBuilder
    );//scaffold
  }//Widget Build
}//Stateless

void showMsg(BuildContext context, String msg){
  var alert = new AlertDialog(
    title: Text('Earthquake'),
    content: Text (msg),
    actions: <Widget>[
      FlatButton(onPressed: () => Navigator.pop(context),
      child: Text('X'),)
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}


Future<Map> showEarthquake() async {
  String url =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson';
  http.Response response = await http.get(url);

  return json.decode(response.body);
}

