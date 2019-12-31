import 'dart:convert';

import 'package:enjurus_gifis/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String _procurar;
  int _offset = 0;

  Future<Map> _getGifs() async{
    http.Response response;
    
    if(_procurar == null)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=xe7vlgRRULcoCtRmoQhmQafDraBtuCuL&limit=20&rating=G");
    else
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=xe7vlgRRULcoCtRmoQhmQafDraBtuCuL&q=$_procurar&limit=19&offset=$_offset&rating=G&lang=en");

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _procurar = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:

                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _criarTabelaDeGif(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_procurar == null)
      return data.length;
    else
      return data.length+1;
  }

  Widget _criarTabelaDeGif(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if(_procurar == null || index < snapshot.data["data"].length)
            /* GestureDetector para clicar na imagem */
            return GestureDetector(
              child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
                  fit:BoxFit.cover,),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
            else
              return Container(
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white, size: 70.0,),
                      Text(
                        "Carregar mais...",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )
                    ],
                  ),
                  onTap: (){
                    setState(() {
                      _offset+=19;
                    });
                  },
                ),
              );
        }
    );
  }
}
