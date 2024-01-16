import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ws_game/player_state_controller.dart';
import 'package:ws_game/websocket_controller.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int x = 50;
  int y = 50;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameStream = ref.watch(gameStreamProvider);
    ref.listen(gameStreamProvider, (previous, next) {
      next.whenOrNull(data: (data) {
        if (data.clientsPosition != null) {
          if (data.messageType == 'welcome') {
            ref.read(playersStateControllerProvider.notifier).feed(data.clientsPosition!);
          } else if (data.messageType == 'someone_joined') {
            if (ref.read(playersStateControllerProvider).length <= data.clientCount!) {
              if (data.myId != ref.read(myIdProvider)) {
                ref.read(playersStateControllerProvider.notifier).add();
              }
            }
          }
        } else {
          if (data.messageType == 'someone_left') {
            ref.read(playersStateControllerProvider.notifier).remove(data.senderId!);
          }
          ref.read(playersStateControllerProvider.notifier).setPosition(
                id: data.senderId ?? -1,
                x: data.position?.x ?? 0,
                y: data.position?.y ?? 0,
              );
        }
      });
    });

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (RawKeyEvent event) async {
        if (event is RawKeyDownEvent && event.data.logicalKey == LogicalKeyboardKey.arrowRight) {
          x += 60;
          setState(() {});

          ref.read(channelProvider).sink.add(jsonEncode({
                'position': {'x': x, 'y': y}
              }));
        } else if (event is RawKeyDownEvent && event.data.logicalKey == LogicalKeyboardKey.arrowLeft) {
          x -= 60;
          setState(() {});

          ref.read(channelProvider).sink.add(jsonEncode({
                'position': {'x': x, 'y': y}
              }));
        } else if (event is RawKeyDownEvent && event.data.logicalKey == LogicalKeyboardKey.arrowUp) {
          y -= 60;
          setState(() {});

          ref.read(channelProvider).sink.add(jsonEncode({
                'position': {'x': x, 'y': y}
              }));
        } else if (event is RawKeyDownEvent && event.data.logicalKey == LogicalKeyboardKey.arrowDown) {
          y += 60;
          setState(() {});

          ref.read(channelProvider).sink.add(jsonEncode({
                'position': {'x': x, 'y': y}
              }));
        }
      },
      child: FocusScope(
        node: FocusScopeNode(),
        child: Scaffold(
          body: gameStream.when(
            data: (data) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        for (final i in ref.watch(playersStateControllerProvider))
                          AnimatedPositioned(
                            left: i.x.toDouble(),
                            top: i.y.toDouble(),
                            duration: const Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ref.watch(myIdProvider) == i.playerId ? Colors.black : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Text(
                                  i.playerId.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 30,
                          right: 30,
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  y -= 60;
                                  setState(() {});

                                  ref.read(channelProvider).sink.add(jsonEncode({
                                        'position': {'x': x, 'y': y}
                                      }));
                                },
                                icon: const Icon(Icons.arrow_upward),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      x -= 60;
                                      setState(() {});

                                      ref.read(channelProvider).sink.add(jsonEncode({
                                            'position': {'x': x, 'y': y}
                                          }));
                                    },
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      x += 60;
                                      setState(() {});

                                      ref.read(channelProvider).sink.add(jsonEncode({
                                            'position': {'x': x, 'y': y}
                                          }));
                                    },
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  y += 60;
                                  setState(() {});

                                  ref.read(channelProvider).sink.add(jsonEncode({
                                        'position': {'x': x, 'y': y}
                                      }));
                                },
                                icon: const Icon(Icons.arrow_downward),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (e, st) {
              log('$e $st');
              return Center(child: Text('$e $st'));
            },
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
