import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ws_game/game_response.dart';
import 'package:ws_game/player_model.dart';

class PlayersStateController extends Notifier<List<PlayerModel>> {
  PlayersStateController();

  @override
  List<PlayerModel> build() {
    return [];
  }

  void feed(List<ClientsPosition> clients) {
    for (final i in clients) {
      state.add(PlayerModel(playerId: i.clientId!, x: i.position!.x!, y: i.position!.y!));
    }
    state = [...state];
  }

  void add() {
    state.add(PlayerModel(playerId: state.length + 1, x: 50, y: 50));
    state = [...state];
  }

  void setPosition({required int id, required int x, required int y}) {
    final index = state.map((e) => e.playerId).toList().indexOf(id);

    print('set $id $x $y');
    if (index != -1) {
      state[index] = state[index].copyWith(x: x, y: y);
      state = [...state];
    }
  }
}

final playersStateControllerProvider = NotifierProvider<PlayersStateController, List<PlayerModel>>(() {
  return PlayersStateController();
});
