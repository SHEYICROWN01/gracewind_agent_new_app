// ignore_for_file: unnecessary_type_check

import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:http/http.dart' as http;

class AllMemberService {
  List<dynamic> data = [];

  Future<List<Member>?> getAllMember({bool deleteCache = false}) async {
    if (deleteCache) {
      await APICacheManager().deleteCache('Member');
    }

    var isCacheExist = await APICacheManager().isAPICacheKeyExist('Member');
    if (!isCacheExist) {
      try {
        final response = await http.get(Uri.parse(AppUrl.allMemberEndPoint));
        if (response.statusCode == 200) {
          APICacheDBModel memberModel =
              APICacheDBModel(key: 'Member', syncData: response.body);
          await APICacheManager().addCacheData(memberModel);

          List<dynamic> getData = json.decode(response.body);
          return getData.map((e) => Member.fromJson(e)).toList();
        } else {
          throw Exception('Failed to load members');
        }
      } on SocketException {
        Utils.toastMessage('No connectivity');

        return null; // Return null here
      }
    } else {
      var memberData = await APICacheManager().getCacheData('Member');
      List<dynamic> getData = json.decode(memberData.syncData);
      if (getData is List<dynamic>) {
        return getData.map((e) => Member.fromJson(e)).toList();
      } else {
        throw Exception('Invalid data in cache');
      }
    }
  }

  Future<void> deleteMemberCache() async {
    await APICacheManager().deleteCache('Member');
  }
}
