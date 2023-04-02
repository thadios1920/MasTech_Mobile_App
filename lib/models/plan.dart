class Plan {
  int? id;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  int? etageId;

  Plan({this.id, this.imageUrl, this.createdAt, this.updatedAt, this.etageId});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    etageId = json['EtageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['EtageId'] = etageId;
    return data;
  }

  // static List<Plan> planFromJSON(List planJSON) {
  //   return planJSON.map((data) {
  //     return Plan.fromJson(data);
  //   }).toList();
  // }
  static Plan planFromJSON(planJSON) {
    return Plan.fromJson(planJSON);
  }
}
