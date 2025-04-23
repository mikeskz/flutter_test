import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  var history = <WordPair>[];
  void getNext() {
    current = WordPair.random(); // sets current pair to new word
    notifyListeners(); // notifies anything that checks MyAppState
    history.add(current); // adds word to the history
  }

  var favorites = <WordPair>[]; // creates a list that can only store WordPair

  void toggleFavorite() {
    if (favorites.contains(current)) { // check if word is already in favorites
      favorites.remove(current); // removes it if so
    } else {
      favorites.add(current); // adds if not
    }
    //favorites.add(current); // adds the current word to the favorites list
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { // turn stateless 
  var selectedIndex = 0; // sets the default selected icon
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = HistoryPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder( // layout builder allows child elements to wrap when necessary
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea( // SafeArea makes sure that child elements are not blocked by notch or status bar
                child: NavigationRail( // navigation rail
                  extended: constraints.maxWidth >= 600, // displays labels if device width is at least 600px
                  destinations: [
                    NavigationRailDestination( // home destination
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination( // favorite destination
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.access_time),
                      label: Text('History'),
                    ),
                  ],
                  selectedIndex: selectedIndex, // selects which page to view
                  onDestinationSelected: (value) { // what happens when destination is selected
                    setState(() { // sets the highlighted page on rail to user selected
                      selectedIndex = value;
                    }
                    ); 
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // build method, must return a widget
    var appState = context.watch<MyAppState>(); // checks the app's state with watch() method
    var pair = appState.current; // stores current word in pair
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold( // widget to be returned, usually nested
      body: Center( // centers all elements
        child: Column( // column is the most common widget, take child elements and puts them in a column from top to bottom
        mainAxisAlignment: MainAxisAlignment.center, // alings items in center, note that does not center column
          children: [
            Text('A random idea:'),
            //Text(appState.current.asLowerCase), // uses appState to access class MyAppState, to access the variable current, and displays result asLowerCase
            BigCard(pair: pair), // displays pair variable in lower case
            Row( // creates a row, allow like and next to be side by side
            mainAxisSize: MainAxisSize.min, // items will not be alling by default when in row, this fixes that
              children: [
                ElevatedButton.icon( // like button with icon
                  onPressed: () {
                    appState.toggleFavorite(); // calls toggle favorite from appState class
                  },
                  icon: Icon(icon), // sets the icon
                  label: Text('like'), // text for button
                ),
                ElevatedButton( // creates a button
                  onPressed: () {
                    //print('button pressed!'); // displays button pressed on click in debug console
                    appState.getNext(); // access appState to call getNext() method
                  },
                  child: Text('next'), // text for the button
                ),
              ],
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); // gets current state of app

    if (appState.favorites.isEmpty) { // checks if favorites is empty
      return Center(
        child: Text('No Favorites Yet'), // if so, return text
      );
    }

    return ListView(
      children: [ // children of ListView
        Padding(
          padding: const EdgeInsets.all(20), // adds padding
          child: Text('You Have ${appState.favorites.length} favorites'), // displays the number of favorites
        ),
        for (var pair in appState.favorites) // for loop looping for total amount of favorites
          ListTile(
            leading: Icon(Icons.favorite), // icon next to word pair
            title: Text(pair.asLowerCase), // display word pair
          )
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.history.isEmpty) {
      return Center(
        child: Text('no history yet')
      );
    }
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('generated ${appState.history.length} so far'),
        ),
        for (var history in appState.history)
          ListTile(
            title: Text(history.asLowerCase)
          )
      ],
    );
  }
}