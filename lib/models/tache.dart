class Tache {
  int? id;
  String? titre;
  String? description;
  String? type;
  bool? etat;
  bool? statut;
  String? createdAt;
  String? updatedAt;
  int? chantierId;
  int? chefChantierId;

  Tache(
      {this.id,
      this.titre,
      this.description,
      this.type,
      this.etat,
      this.statut,
      this.createdAt,
      this.updatedAt,
      this.chantierId,
      this.chefChantierId});

  Tache.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titre = json['titre'];
    description = json['description'];
    type = json['type'];
    etat = json['etat'];
    statut = json['statut'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chantierId = json['ChantierId'];
    chefChantierId = json['chefChantierId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['titre'] = titre;
    data['description'] = description;
    data['type'] = type;
    data['etat'] = etat;
    data['statut'] = statut;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['ChantierId'] = chantierId;
    data['chefChantierId'] = chefChantierId;
    return data;
  }

  static List<Tache> tacheFromJSON(List tacheJSON) {
    return tacheJSON.map((data) {
      return Tache.fromJson(data);
    }).toList();
  }
}
