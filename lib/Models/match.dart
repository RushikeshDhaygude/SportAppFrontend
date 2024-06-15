class Match {
  final String id;
  final String team1Name;
  final String team2Name;
  final String matchResult;
  final String team1Score;
  final String team2Score;
  final String location;
  final String matchDetails;

  Match({
    required this.id,
    required this.team1Name,
    required this.team2Name,
    required this.matchResult,
    required this.team1Score,
    required this.team2Score,
    required this.location,
    required this.matchDetails,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] ?? '',
      team1Name: json['team1Name'] ?? '',
      team2Name: json['team2Name'] ?? '',
      matchResult: json['matchResult'] ?? '',
      team1Score: json['team1Score'] ?? '',
      team2Score: json['team2Score'] ?? '',
      location: json['location'] ?? '',
      matchDetails: json['matchDetails'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team1Name': team1Name,
      'team2Name': team2Name,
      'matchResult': matchResult,
      'team1Score': team1Score,
      'team2Score': team2Score,
      'location': location,
      'matchDetails': matchDetails,
    };
  }
}
