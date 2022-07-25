class Video {
  Video({
    this.id,
    this.title,
    this.url,
    this.userId,
    this.userNick,
    this.userPhoto,
    this.tribeNick,
    this.tribePhoto,
    this.claps,
    this.views,
    this.userName,
    this.uploaded,
    this.userCompany,
    this.userIsVerified,
    this.userRole,
    this.userClapped,
    this.userBookmarked,
    this.userSeen,
    this.userSeenScore,
  });

  String? id;
  String? title;
  String? url;
  String? userId;
  String? userNick;
  String? userPhoto;
  String? tribeNick;
  String? tribePhoto;
  int? claps;
  int? views;
  String? userName;
  String? uploaded;
  String? userCompany;
  bool? userIsVerified;
  String? userRole;
  bool? userClapped;
  bool? userBookmarked;
  bool? userSeen;
  double? userSeenScore;

  factory Video.fromMap(Map<String, dynamic> json) => Video(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        userId: json["user_id"],
        userNick: json["user_nick"],
        userPhoto: json["user_photo"],
        tribeNick: json["tribe_nick"],
        tribePhoto: json["tribe_photo"],
        claps: json["claps"],
        views: json["views"],
        userName: json["user_name"],
        uploaded: json["uploaded"],
        userCompany: json["user_company"],
        userIsVerified: json["user_is_verified"],
        userRole: json["user_role"],
        userClapped: json["user_clapped"],
        userBookmarked: json["user_bookmarked"],
        userSeen: json["user_seen"],
        userSeenScore: json["user_seen_score"],
      );
}
