import 'dart:convert';
import 'dart:io';
import 'package:gracewind_agent_new_app/model/instantMemberModel.dart';
import 'package:gracewind_agent_new_app/service/app_url.dart';
import 'package:gracewind_agent_new_app/utils/app_url.dart';

import 'package:http/http.dart' as http;

class InstantMemberRecordService {
  Future<List<InstantMemberData>> getAllMember() async {
    try {
      final response =
          await http.get(Uri.parse(AppUrl.instantMemberRecordEndPoint));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((e) => InstantMemberData.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load members');
      }
    } on SocketException catch (_) {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to load members');
    }
  }
}
