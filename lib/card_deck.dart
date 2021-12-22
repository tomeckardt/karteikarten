import 'package:hive/hive.dart';

part 'card_deck.g.dart';

@HiveType(typeId: 0, adapterName: "DeckAdapter")
class Deck extends HiveObject {

  Deck(this.name);

  @HiveField(0)
  List<IndexCard> _cards = [];
  @HiveField(1)
  String name;
  @HiveField(2)
  int index = 0;

  addIndexCard(String q, String a) => _cards.add(IndexCard(q, a));

  removeIndexCard(int index) => _cards.removeAt(index);

  List<IndexCard> getIndexCards() => _cards;

  int length() => _cards.length;

  IndexCard? next() {
    index %= length();
    if (_cards.isNotEmpty) {
      return _cards.elementAt(index++);
    }
  }

  Map<String, dynamic> toJson() => {
    "IndexCards": _cards,
    "name": name
  };

  Deck.fromJson(Map<String, dynamic> json) : _cards = json["IndexCards"], name = json["name"];
}

@HiveType(typeId: 1, adapterName: "IndexCardAdapter")
class IndexCard extends HiveObject {

  IndexCard(this._q, this._a);

  @HiveField(0)
  final String _q;
  @HiveField(1)
  final String _a;

  String getQuestion() {
    return _q;
  }

  String getAnswer() {
    return _a;
  }

  Map<String, dynamic> toJson() => {
    "q": _q,
    "a": _a
  };

  IndexCard.fromJson(Map<String, dynamic> json): _q = json["q"], _a = json["a"];
}
