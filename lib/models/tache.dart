class Tache {
  int? id;
  String? titre;
  String? description;
  String? type;
  bool? etat;
  bool? statut;
  String? dateFin;
  String? imageURL;
  int? chantierId;
  int? chefChantierId;

  Tache(
      {this.id,
      this.titre,
      this.description,
      this.type,
      this.etat,
      this.imageURL,
      this.dateFin,
      this.statut,
      this.chantierId,
      this.chefChantierId});

  Tache.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titre = json['titre'];
    description = json['description'];
    type = json['type'];
    imageURL = json['imageURL'];
    etat = json['etat'];
    statut = json['statut'];
    dateFin = json['dateFin'];
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
    data['imageURL'] = imageURL;
    data['dateFin'] = dateFin;
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
