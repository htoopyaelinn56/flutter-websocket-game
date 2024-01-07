class PlayerModel {
  final int playerId;
  final int x;
  final int y;
  PlayerModel({
    required this.playerId,
    required this.x,
    required this.y,
  });

  PlayerModel copyWith({
    int? playerId,
    int? x,
    int? y,
  }) {
    return PlayerModel(
      playerId: playerId ?? this.playerId,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
