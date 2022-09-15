class ProfileModel {
  ProfileModel({
    this.name,
    this.bio,
    this.public_repos,
    this.avatar_url,
    this.url,
  });

  String name;
  String bio;
  String public_repos;
  String avatar_url;
  String url;

  ProfileModel.fromJson(Map<String, dynamic> json)
      : name = json["name"] == null ? "NA" : json["name"],
        bio = json["bio"] == null ? "NA" : json["bio"],
        avatar_url = json["avatar_url"] == null ? "NA" : json["avatar_url"],
        url = json["html_url"] == null ? "NA" : json["html_url"],
        public_repos = json["public_repos"] == null ? "NA" : json["public_repos"].toString();
}
