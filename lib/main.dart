import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { // state of app, can notify other widgets of changes
  var current = WordPair.random(); // sets current pair to new word

  void getNext() {
    current = WordPair.random(); // sets current pair to new word
    notifyListeners(); // notifies anything that checks MyAppState
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // build method, must return a widget
    var appState = context.watch<MyAppState>(); // checks the app's state with watch() method
    var pair = appState.current; // stores current word in pair

    return Scaffold( // widget to be returned, usually nested
      body: Center( // centers all elements
        child: Column( // column is the most common widget, take child elements and puts them in a column from top to bottom
        mainAxisAlignment: MainAxisAlignment.center, // alings items in center, note that does not center column
          children: [
            Text('A random idea:'),
            //Text(appState.current.asLowerCase), // uses appState to access class MyAppState, to access the variable current, and displays result asLowerCase
            BigCard(pair: pair), // displays pair variable in lower case
            ElevatedButton( // creates a button
              onPressed: () {
                //print('button pressed!'); // displays button pressed on click in debug console
                appState.getNext(); // access appState to call getNext() method
              },
              child: Text('next'), // text for the button
            )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget { // class for random word styling
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // requests app's current theme
    final style = theme.textTheme.displayMedium!.copyWith( // textTheme allows to change font of text. copyWith copies the result
      color: theme.colorScheme.onPrimary, // changes the color of the text that fits with primary
    );
    return Card( // widget card
      color: theme.colorScheme.primary, // sets color of widget of the primary color, as according to app theme
      child: Padding( // padding must be wrapped with widget
        padding: const EdgeInsets.all(20.0), // adds padding, can be added by right clicking text and selecting refractor, then padding
        child: Text(pair.asLowerCase, style: style), // text of pair varaiable, styles it with style variable
      ),
    );
  }
}