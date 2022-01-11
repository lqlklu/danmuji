import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

typedef BliveOp = int;

class BliveOps {
  static const BliveOp invalid = 0;
  static const BliveOp heartbeat = 2;
  static const BliveOp hearbeatReply = 3;
  static const BliveOp message = 5;
  static const BliveOp userAuth = 7;
  static const BliveOp connectSucc = 8;
}

void writeInt32(Uint8List buf, int value, int byteOffset) {
  buf.buffer.asByteData().setInt32(byteOffset, value, Endian.big);
}

void writeInt16(Uint8List buf, int value, int byteOffset) {
  buf.buffer.asByteData().setInt16(byteOffset, value, Endian.big);
}

void writeBody(Uint8List buf, List<int> value, int byteOffset) {
  final bodyLen = value.length;
  for (int i = 0; i < bodyLen; ++i) {
    buf.buffer.asByteData().setUint8(byteOffset + i, value[i]);
  }
}

Uint8List encode(BliveOp op, String content) {
  var body = utf8.encode(content);
  var packetLen = 16 + body.length;
  final buf = Uint8List(packetLen);
  writeInt32(buf, packetLen, 0);
  writeInt16(buf, 16, 4);
  writeInt16(buf, 1, 6);
  writeInt32(buf, op, 8);
  writeInt32(buf, 1, 12);
  writeBody(buf, body, 16);
  return buf;
}

Uint8List encodeUserAuth(int realRoomId, String token) {
  return encode(
      BliveOps.userAuth,
      jsonEncode({
        "roomid": realRoomId,
        "key": token,
      }));
}

class BliveMessage {
  final BliveOp op;
  final String body;

  const BliveMessage(this.op, this.body);

  @override
  String toString() {
    return "BliveMessage{$op, $body}";
  }
}

int readInt32(Uint8List buf, int byteOffset) {
  final x = buf.sublist(byteOffset, byteOffset + 4);
  return x.buffer.asByteData().getInt32(0);
  // final bf = buf.buffer;
  // final bd = bf.asByteData();
  // final s = bd.getInt32(byteOffset);
  // return s;
}

int readInt16(Uint8List buf, int byteOffset) {
  final x = buf.sublist(byteOffset, byteOffset + 2);
  return x.buffer.asByteData().getInt16(0);
}

Uint8List readBody(Uint8List buf, int byteOffset, int end) {
  return buf.sublist(byteOffset, end);
}

List<BliveMessage> decode(Uint8List buf) {
  final List<BliveMessage> ret = [];
  final packetLen = readInt32(buf, 0);
  final headerLen = readInt16(buf, 4);
  assert(headerLen == 16);
  final sub = readInt16(buf, 6);
  final op = readInt32(buf, 8);
  final _ = readInt32(buf, 12);
  final body = readBody(buf, headerLen, packetLen);
  if (sub == 0) {
    // json
    final s = utf8.decode(body);
    ret.add(BliveMessage(op, s));
  } else if (sub == 1) {
    // int32
    var i = readInt32(buf, headerLen).toString();
    ret.add(BliveMessage(op, i));
  } else if (sub == 2) {
    // zlib
    var u = Uint8List.fromList(zlib.decode(body));
    return decode(u);
  } else {
    // brotli
  }
  assert(packetLen <= buf.length);
  if (packetLen < buf.length) {
    ret.addAll(decode(buf.sublist(packetLen)));
  }
  return ret;
}
