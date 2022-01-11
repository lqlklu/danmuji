import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;

int randomRange(int min, int max) {
  final random = Random();
  return random.nextInt(max - min) + min;
}

Future<Map<String, dynamic>> get(String url) async {
  final res = await http.get(Uri.parse(url));
  final str = utf8.decode(res.bodyBytes);
  return json.decode(str);
}

Future<List<dynamic>> getInfo(int roomId) async {
  // get real roomId
  final roomInfoUrl =
      "https://api.live.bilibili.com/room/v1/Room/get_info_by_id?ids[]=$roomId";
  final roomInfoData = (await get(roomInfoUrl))["data"].values.first;
  final uid = int.parse(roomInfoData["uid"]);
  final realRoomId = int.parse(roomInfoData["roomid"]);

  // get danmu server
  final danmuInfoUrl =
      "https://api.live.bilibili.com/xlive/web-room/v1/index/getDanmuInfo?id=$realRoomId";
  final danmuInfoData = await get(danmuInfoUrl);
  String token = danmuInfoData["data"]["token"];
  List<dynamic> danmuServerList = danmuInfoData["data"]["host_list"];
  final danmuServer = danmuServerList[randomRange(0, danmuServerList.length)];
  final wssUrl = "wss://${danmuServer["host"]}:${danmuServer["wss_port"]}/sub";

  return [wssUrl, token, realRoomId, uid];
}
