class Player {
  final int id;
  String name;
  int money;
  int? betHorse;
  int? betAmount;
  int assignedCards;

  Player(
      this.id, {
        this.name = '',
        this.money = 100,
        this.assignedCards = 0,
      });

  bool get readyBet => betHorse != null && betAmount != null;
  bool get finishedCards => assignedCards >= 3;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'money': money,
    'betHorse': betHorse,
    'betAmount': betAmount,
    'assignedCards': assignedCards,
  };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(json['id'])
      ..name = json['name'] ?? ''
      ..money = json['money'] ?? 100
      ..betHorse = json['betHorse']
      ..betAmount = json['betAmount']
      ..assignedCards = json['assignedCards'] ?? 0;
  }
}