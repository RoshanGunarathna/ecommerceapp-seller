import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../failure.dart';
import '../../type_defs.dart';
import '../../constants/constants.dart';
import 'package:http/http.dart' as http;

final commonGetDateAndTimeRepositoryProvider =
    Provider((ref) => CommonGetDateAndTimeRepository());

class CommonGetDateAndTimeRepository {
  FutureEither<String> getDateAndTime() async {
    try {
      final http.Response res = await http.get(Uri.parse(
          "$dateTimeUri/api/Time/current/zone?timeZone=Asia/Kolkata"));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        return right(data["dateTime"]);
      }
      throw res.statusCode;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
