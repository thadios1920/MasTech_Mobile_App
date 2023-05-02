import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:pfe_mobile_app/models/chefProjet.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var iskeyExist = await APICacheManager().isAPICacheKeyExist("user_details");
    return iskeyExist;
  }

  static Future<dynamic> userDetails() async {
    var iskeyExist = await APICacheManager().isAPICacheKeyExist("user_details");
    if (iskeyExist) {
      var cacheData = await APICacheManager().getCacheData("user_details");
      // return ChefProjet.chefFromJSON(cacheData.syncData);
      return cacheData.syncData;
    }
    return null;
  }

  static setUserDetails(dynamic user) async {
    APICacheDBModel cacheDBModel =
        APICacheDBModel(key: "user_details", syncData: jsonEncode(user));

    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> deleteUserDetails() async {
    await APICacheManager().deleteCache("user_details");
  }
}
