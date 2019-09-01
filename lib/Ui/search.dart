import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends State<SearchList> {


  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) =>
  Firestore.instance
      .collection('books')
      .orderBy("book author searchkey")
      .startAt([suggestion])
      .endAt([suggestion + '\uf8ff'])
      .getDocuments()
      .then((snapshot) {
        return snapshot.documents;
      });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('جست و جو'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'جست و جوی کتاب،ناشر،نویسنده'),
            ),
            suggestionsCallback: (pattern) async {
              return await getSuggestion(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['book name']),
              );
            }, onSuggestionSelected: (suggestion) {},
           
          ),)
        ]));
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(
        data['book name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ))));
}
