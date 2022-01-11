import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:danmuji/blive/codec.dart';
import 'package:danmuji/blive/entity.dart';
import 'package:danmuji/blive/info.dart';

part 'store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  int roomId = 22696653;
  int realRoomId = 0;
  int uid = 0;
  String wssUrl = "";
  String token = "";

  WebSocketChannel? ws;
  Timer? heartbeater;

  @observable
  ObservableList<Danmu> danmus = ObservableList();
  @action
  void addDanmu(Danmu m) {
    danmus.add(m);
  }

  @observable
  ObservableList<SuperChat> superChats = ObservableList();
  @action
  void addSuperChat(SuperChat sc) {
    superChats.add(sc);
  }

  void onMessage(BliveMessage m) {
    switch (m.op) {
      case BliveOps.message:
        {
          final j = json.decode(m.body);
          switch (j["cmd"]) {
            case "DANMU_MSG":
              if (kDebugMode) {
                print(m.body);
              }
              final String content = j["info"][1];
              final String userName = j["info"][2][1];
              final String brand = j["info"][3][1];
              final int brandLev = j["info"][3][0];
              addDanmu(Danmu(content, userName, brand, brandLev));
              break;
            default:
              break;
          }
          break;
        }
      default:
        break;
    }
  }

  Future<void> connect() async {
    final res = await getInfo(roomId);
    wssUrl = res[0];
    token = res[1];
    realRoomId = res[2];
    uid = res[3];
    ws = WebSocketChannel.connect(Uri.parse(wssUrl));
    ws?.stream.listen((event) {
      final ms = decode(event);
      for (BliveMessage m in ms) {
        onMessage(m);
      }
    });
    // send enter
    ws?.sink.add(encodeUserAuth(realRoomId, token));
    if (kDebugMode) {
      print("");
      print("Enter room ${DateTime.now()}");
    }
    // set heartbeat timer
    heartbeater = Timer.periodic(const Duration(seconds: 30), (timer) {
      ws?.sink.add(encode(BliveOps.heartbeat, ""));
      if (kDebugMode) {
        print("Heartbeat ${DateTime.now()}");
      }
    });
  }

  void close() {
    heartbeater?.cancel();
    heartbeater = null;
    ws?.sink.close();
    ws = null;
    danmus.clear();
    superChats.clear();
  }
}
