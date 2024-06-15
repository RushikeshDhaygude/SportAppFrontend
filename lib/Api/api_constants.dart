class ApiConstants {
  static const String ip = '192.168.106.73';
  static const String port = '8080';

  //Socket
  static const String socketAddress= 'ws://$ip:$port/ws';


  //apis
  static const String eventApiUrl = 'http://$ip:$port/api/events';
  static const String UpcomingMatchesApiUrl = 'http://$ip:$port/api/fixtures';
}
