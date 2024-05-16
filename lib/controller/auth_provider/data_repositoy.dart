import 'package:gracewind_agent_new_app/app_export.dart';
class DataRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      return await _apiService.getPostApiResponse(
          AppUrl.loginApiEndPoint, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> dashboardApi(dynamic data) async {
    try {
      return await _apiService.getPostApiResponse(
          AppUrl.dashboardApiEndPoint, data);
    } catch (e) {
      rethrow;
    }
  }
}
