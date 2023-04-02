class Projet {
  int? id;
  String? nom;
  String? description;
  String? startDate;
  String? endDate;
  String? lieu;
  String? createdAt;
  String? updatedAt;
  int? chefProjetId;

  Projet(
      {this.id,
      this.nom,
      this.description,
      this.startDate,
      this.endDate,
      this.lieu,
      this.createdAt,
      this.updatedAt,
      this.chefProjetId});

  Projet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    lieu = json['lieu'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chefProjetId = json['chefProjetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nom'] = nom;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['lieu'] = lieu;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['chefProjetId'] = chefProjetId;
    return data;
  }

  static List<Projet> projetFromJSON(List projetJSON) {
    return projetJSON.map((data) {
      return Projet.fromJson(data);
    }).toList();
  }
}
