import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ws_game/game_response.dart';

final channelProvider = Provider<WebSocketChannel>((ref) {
  final url = kIsWeb
      ? 'ws://127.0.0.1:3000/ws'
      : Platform.isAndroid
          ? 'ws://10.0.2.2:3000/ws'
          : 'ws://127.0.0.1:3000/ws';
  return WebSocketChannel.connect(Uri.parse(url));
});

final gameStreamProvider = StreamProvider<GameResponse>((ref) async* {
  await ref.watch(channelProvider).ready;

  ref.listenSelf((previous, next) {
    next.whenData((value) {
      if (ref.read(myIdProvider) == null) {
        ref.read(myIdProvider.notifier).state = value.myId;
      }
      if (value.clientCount != null) {
        ref.read(totalPlayersProvider.notifier).state = value.clientCount;
      }
    });
  });

  await for (final i in ref.watch(channelProvider).stream) {
    log('response -> $i');
    yield GameResponse.fromJson(jsonDecode(i.toString()));
  }
});

final myIdProvider = StateProvider<int?>((ref) {});

final totalPlayersProvider = StateProvider<int?>((ref) {});
