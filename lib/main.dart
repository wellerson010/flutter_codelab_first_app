import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords>{
  final List<WordPair> _suggestion = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestion(){
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
        //  print(i);
          if (i.isOdd){
            return Divider();
          }

          final int index = i ~/ 2;

         // print('length ' + _suggestion.length.toString());
          if (index >= _suggestion.length){
            _suggestion.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestion[index]);
        });
  }

  Widget _buildRow(WordPair word){
    final bool alreadySaved = _saved.contains(word);

    return ListTile(
      title: Text(
        word.asPascalCase,
        style: _biggerFont
      ),
      trailing: Icon((alreadySaved)?Icons.favorite:Icons.favorite_border, color: alreadySaved ? Colors.red:null),
      onTap: (){
        setState((){
          if (alreadySaved){
            _saved.remove(word);
          }
          else {
            _saved.add(word);
          }
        });
      },
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          final List<ListTile> tile = _saved.map((word) => ListTile(
            title: Text(
              word.asPascalCase, style: _biggerFont
            )
          )).toList();

          final List<Widget> divided = ListTile.divideTiles(tiles: tile, context: context).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(
              children: divided,
            )
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestion()
    );
  }
}