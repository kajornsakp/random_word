import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:random_word/components/big_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var word = WordPair.random();
  var favorites = <WordPair>[];
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = RandomPage(
            word: word,
            onAddFavorite: () {
              setState(() {
                favorites.contains(word)
                    ? favorites.remove(word)
                    : favorites.add(word);
              });
            },
            onNext: () {
              setState(() {
                word = WordPair.random();
              });
            },
            isFavorite: favorites.contains(word));
        break;
      case 1:
        page = buildFavoritePage();
        break;
      default:
        throw UnimplementedError("selectedIndex: $selectedIndex");
    }
    return Scaffold(
      body: Row(children: [
        NavigationRail(
            extended: false,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("Home"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text("Favorite"),
              ),
            ],
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            selectedIndex: selectedIndex),
        Expanded(
            child: IndexedStack(
          index: selectedIndex,
          children: [
            buildRandomPage(),
            buildFavoritePage(),
          ],
        ))
      ]),
    );
  }

  Widget buildRandomPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Random word program"),
          const SizedBox(height: 16),
          BigCard(word: word),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      favorites.contains(word)
                          ? favorites.remove(word)
                          : favorites.add(word);
                    });
                  },
                  child: favorites.contains(word)
                      ? const Text("Remove")
                      : const Text("Add to favorite")),
              const SizedBox(width: 16),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      word = WordPair.random();
                    });
                  },
                  child: const Text("Next")),
            ],
          )
        ],
      ),
    );
  }

  Widget buildFavoritePage() {
    return Center(
      child: ListView(
          children: favorites
              .map((e) => ListTile(title: Text(e.asPascalCase)))
              .toList()),
    );
  }
}

class RandomPage extends StatelessWidget {
  RandomPage(
      {super.key,
      required this.word,
      required this.onAddFavorite,
      required this.onNext,
      required this.isFavorite});

  WordPair word;
  VoidCallback onAddFavorite;
  VoidCallback onNext;
  bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Random word program"),
          const SizedBox(height: 16),
          BigCard(word: word),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: onAddFavorite,
                  child: isFavorite
                      ? const Text("Remove")
                      : const Text("Add to favorite")),
              const SizedBox(width: 16),
              ElevatedButton(onPressed: onNext, child: const Text("Next")),
            ],
          ),

        ],
      ),
    );
  }
}
