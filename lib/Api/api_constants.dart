class ApiConstants {
  // static const String ip = '192.168.106.73'; //192.168.106.73
  // static const String port = '8080';
  // static const String signalPort = '3000';

  // //ZegoCloud Creds
  // static const String appSign =
  //     '6dd0a7f8f7758856d7d2134f906ce251d73d615e6e545215458d1e5643ac8772';
  // static const String appId = '1543817899';

  // //Socket
  // static const String socketAddress = 'ws://$ip:$port/ws';

  // //apis
  // static const String signalingServer = 'http://$ip:$signalPort';
  // static const String eventApiUrl = 'http://$ip:$port/api/events';
  // static const String UpcomingMatchesApiUrl = 'http://$ip:$port/api/fixtures';
  // static const String Locations = "http://$ip:$port/api/locations";
  // static const String pools = "http://$ip:$port/api/pools";
  // static const String leaderboard = "http://$ip:$port/api/leaderboard";
  // // static const String galleryApi = "http://$ip:$port/api/galleries";
  // static const String finalScorecards =
  //     "http://$ip:$port/api/scorecards/status/final";

  // static const String addScoreCards="http://$ip:$port/api/scorecards";
  
  // static const String baseUrl = 'http://$ip:$port/api';

  // //Org Apis

  // static const String RegisterApi = "http://$ip:$port/auth/register";
  // static const String LoginApi = "http://$ip:$port/auth/login";

  // //Event
  // static const String AddEvent = "http://$ip:$port/api/events";
  // static const String DeleteEvent = "http://$ip:$port/api/events";
  // static const String UpdateEvent = "http://$ip:$port/api/events";

  // //Fixtures
  // static const String AddFixture = "http://$ip:$port/api/fixtures";
  // // static const String DeleteFixture = "http://$ip:$port/api/fixtures";
  // // static const String UpdateFixture = "http://$ip:$port/api/fixtures";

  // //Announcements
  // static const String AddAnnouncementTopic =
  //     "http://$ip:$port/notification/topic";

  // //Pools
  // static const String Pools = "http://$ip:$port/api/pools";

  // //teams
  // static const String Teams = "http://$ip:$port/api/teams";

    static const String ip = 'sportappapi-production.up.railway.app'; //192.168.106.73
  // static const String port = '8080';


  //ZegoCloud Creds
  static const String appSign =
      '6dd0a7f8f7758856d7d2134f906ce251d73d615e6e545215458d1e5643ac8772';
  static const String appId = '1543817899';
  static const String socketAddress = 'wss://$ip/ws';


  //Socket


  //apis
  static const String eventApiUrl = 'https://$ip/api/events';
  static const String UpcomingMatchesApiUrl = 'https://$ip/api/fixtures';
  static const String Locations = "https://$ip/api/locations";
  static const String pools = "https://$ip/api/pools";
  static const String leaderboard = "https://$ip/api/leaderboards";
  // static const String galleryApi = "http://$ip:$port/api/galleries";
  static const String finalScorecards =
      "https://$ip/api/scorecards/status/final";

  static const String addScoreCards="https://$ip/api/scorecards";
  
  static const String baseUrl = 'https://$ip/api';

  //Org Apis

  static const String RegisterApi = "https://$ip/auth/register";
  static const String LoginApi = "https://$ip/auth/login";

  //Event
  static const String AddEvent = "https://$ip/api/events";
  static const String DeleteEvent = "https://$ip/api/events";
  static const String UpdateEvent = "https://$ip/api/events";

  //Fixtures
  static const String AddFixture = "https://$ip:/api/fixtures";
  // static const String DeleteFixture = "http://$ip:$port/api/fixtures";
  // static const String UpdateFixture = "http://$ip:$port/api/fixtures";

  //Announcements
  static const String AddAnnouncementTopic =
      "https://$ip:/notification/topic";

  //Pools
  static const String Pools = "https://$ip/api/pools";

  //teams
  static const String Teams = "https://$ip/api/teams";

  static const String locationsApi = 'https://$ip/api/locations';
}
