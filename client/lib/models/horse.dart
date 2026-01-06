class Horse {
  final int id;
  double position;
  double speedModifier;

  Horse({
    required this.id,
    this.position = 0,
    this.speedModifier = 1.0,
  });

  double calculateStep() {
    final baseStep = 2.0;
    return baseStep + speedModifier;
  }

  void applyCard(String cardImage) {
    if (cardImage.startsWith('b')) {
      speedModifier += int.parse(cardImage[1]);
    } else if (cardImage.startsWith('m')) {
      speedModifier -= int.parse(cardImage[1]);
    }
  }

  void reset() {
    position = 0;
    speedModifier = 1.0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
    'speedModifier': speedModifier,
  };

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      id: json['id'],
      position: (json['position'] ?? 0).toDouble(),
      speedModifier: (json['speedModifier'] ?? 1.0).toDouble(),
    );
  }
}