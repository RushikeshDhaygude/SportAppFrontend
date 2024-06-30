class ApiConstants {
  static const String ip = '192.168.43.56'; //192.168.106.73
  static const String port = '8080';
  static const String signalPort = '3000';

  //ZegoCloud Creds
  static const String appSign='6dd0a7f8f7758856d7d2134f906ce251d73d615e6e545215458d1e5643ac8772';
   static const String appId= '1543817899';

  //Socket
  static const String socketAddress = 'ws://$ip:$port/ws';

  //apis
  static const String signalingServer = 'http://$ip:$signalPort';
  static const String eventApiUrl = 'http://$ip:$port/api/events';
  static const String UpcomingMatchesApiUrl = 'http://$ip:$port/api/fixtures';
  static const String Locations = "http://$ip:$port/api/locations";
  static const String pools = "http://$ip:$port/api/pools";
  static const String leaderboard = "http://$ip:$port/api/leaderboard";
  // static const String galleryApi = "http://$ip:$port/api/galleries";
  static const String finalScorecards =
      "http://$ip:$port/api/scorecards/status/final";
  static const String baseUrl = 'http://$ip:$port/api';
}
//7350060355