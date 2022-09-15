

class RepositoryModel {
  RepositoryModel({this.repository});

  List<ModelClassData> repository = [];

  RepositoryModel.fromJson(json):
        repository = ModelClassData.convertToList(json);

}

class ModelClassData {
  ModelClassData({
    this.name,
    this.full_name,
    this.avatar_url,
    this.html_url,
  });


  String name;
  String full_name;
  String avatar_url;
  String html_url;


  ModelClassData.fromJson(repository) :
        name = repository["name"],
        full_name = repository["full_name"],
        avatar_url = repository["owner"]["avatar_url"],
        html_url = repository["html_url"];


  static List<ModelClassData> convertToList(dynamic list){
    List<ModelClassData> repository =[];

    list.forEach((element){
      repository.add(ModelClassData.fromJson(element));
    });

    return repository;
  }

}