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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var liked = <WordPair>[];

  var icon = Icons.favorite_border;


  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void like(){
    if (liked.contains(current)) {
      liked.remove(current);
    } else {
      liked.add(current);
    }
    notifyListeners();
  }
  
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = AdorePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home sweet home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Adorés'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
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

class AdorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.liked.isEmpty) {
      return Center(
        child: Text('Aucun mot adoré'),
      );
    }

    return Center(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Vous avez ${appState.liked.length} mots adorés :', style: Theme.of(context).textTheme.titleLarge)
          ),
          for (var randommot in appState.liked)
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(randommot.asLowerCase),
            ),
          
        ],
      ),
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RandomCard(randommot: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LikeButton(appState: appState),
              SizedBox(width: 10),
              RandomButton(appState: appState)
            ],
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.appState,
  });

  final MyAppState appState;
  

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    IconData icon = appState.liked.contains(appState.current) ? Icons.favorite : Icons.favorite_border;

    return ElevatedButton.icon(onPressed: ()  {
      appState.like();
    }, icon: Icon(icon) ,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      label: Text('Like'),
    );
  }
}

class RandomButton extends StatelessWidget {
  const RandomButton({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ElevatedButton(onPressed: ()  {
      appState.getNext();
    }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text('Cliquez ici'),
    );
  }
}



class RandomCard extends StatelessWidget {
  const RandomCard({
    super.key,
    required this.randommot,
  });

  final WordPair randommot;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      shadowColor: theme.colorScheme.primary,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(randommot.asLowerCase, style: style),
      ),
    );
  }
}