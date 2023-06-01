import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const host = kDebugMode
    ? 'https://753c-2405-9800-bc10-9d79-4cb-92a6-d279-e37e.ngrok-free.app/api/v1/ctc' // 'https://staging-console-backend.graffity.tech/api/v1/ctc'
    : 'https://console-backend.graffity.tech/api/v1/ctc';

const key =
    'YTA4Yjc4NWUtMjgxYi00ZTRmLWFlNjAtNTQ5NmJjZmVlNjdmLTUxNWUxMDE3LWYzNDktNDdlMi05MjBhLTMzODBlMTNhNGQ5YQ==';

class CtcUser {
  String qrId;
  List<String>? collection;
  bool? isRedeem;
  String? lastCoinId;

  CtcUser({
    required this.qrId,
    this.collection,
    this.isRedeem,
    this.lastCoinId,
  });

  factory CtcUser.fromJson(Map<String, dynamic> json) {
    List<String> collection = [];
    for (var e in json['collection']) {
      collection.add(e.toString());
    }
    return CtcUser(
      qrId: json['qrId'],
      collection: collection,
      isRedeem: json['isRedeem'],
      lastCoinId: json['lastCoinId'],
    );
  }
}

Future<http.Response> createUser(String qrId) async {
  return http.post(
    Uri.parse('$host/update-user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-graff-console': key,
    },
    body: jsonEncode(<String, dynamic>{
      'qrId': qrId,
    }),
  );
}

Future<CtcUser?> getUser(String qrId) async {
  final response = await http.post(
    Uri.parse('$host/get-user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-graff-console': key,
    },
    body: jsonEncode(<String, dynamic>{
      'qrId': qrId,
    }),
  );

  if (response.statusCode == 200 && response.body != "") {
    // print(response.body);
    return CtcUser.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<http.Response> collectCoin(String qrId, String coinId) async {
  return http.post(
    Uri.parse('$host/collect-coin'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-graff-console': key,
    },
    body: jsonEncode(<String, dynamic>{'qrId': qrId, 'lastCoinId': coinId}),
  );
}

Future<http.Response> redeemReward(String qrId) async {
  return http.post(
    Uri.parse('$host/update-user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-graff-console': key,
    },
    body: jsonEncode(<String, dynamic>{
      'qrId': qrId,
      'isRedeem': true,
    }),
  );
}
