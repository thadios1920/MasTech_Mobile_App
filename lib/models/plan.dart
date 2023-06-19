class Plan {
  int? id;
  String? imageUrl;
  int? etageId;

  Plan({this.id, this.imageUrl, this.etageId});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    etageId = json['EtageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
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
