import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<ResultContributor> getData() async {
  final response = await http.get('https://api.github.com/repos/square/retrofit/contributors');
  if(response.statusCode == 200){
    return fromJson(json.decode(response.body));
  }else{
    throw Exception('Failed to load post');
  }
}

class Contributor{
  final String login;
  final String avatarUrl;
  final String type;

  Contributor({this.login, this.avatarUrl, this.type});
}

class ResultContributor{
  final List<Contributor> result;
  ResultContributor({this.result});
}

ResultContributor fromJson(List<dynamic> json){
    List<Contributor> listContributor = List<Contributor>();
    json.forEach((jsonContributor) {
      Contributor contrib =  new Contributor(
        login: jsonContributor['login'],
        avatarUrl: jsonContributor['avatar_url'],
        type: jsonContributor['type'],
      );
      listContributor.add(contrib);
    });
    
    return new ResultContributor(result : listContributor);
  }


void main() => runApp(MyApp(contributor: getData()));

class MyApp extends StatelessWidget {

  final Future<ResultContributor> contributor;

  MyApp({Key key, this.contributor}): super(key:key);

  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Fetch data'),
          ),
          body: Center(
            child: FutureBuilder<ResultContributor>(
              future: contributor,
              builder: (context, fetchData){
                if(fetchData.hasData){
                  return ListView.builder(
                    itemCount: fetchData.data.result.length,
                    itemBuilder: (context, index){
                      final contrib = fetchData.data.result[index];

                      return ListTile(
                        leading: new Container(
                    width: 46.0,
                    height: 46.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                contrib.avatarUrl)
                        )
                    )),
                        title: new Row(
                          children: <Widget>[
                            new Text(contrib.login)
                          ],
                        ),
                      );

                    }
                  );
                }else if(fetchData.hasError){
                  return Text("${fetchData.error}");
                }

                return CircularProgressIndicator();
              }
            ),
          ),
        ),
      );
    }

}