class Chantier {
  int? id;
  String? codeChantier;
  String? nom;
  String? lieu;
  String? type;
  int? percentAvancement;
  int? percentElaboration;
  int? percentEstimation;
  int? percentFabrication;
  String? categorie;
  bool? etat;
  String? description;
  DateTime? dateDebut;
  DateTime? dateFin;
  int? chefProjetId;

  Chantier(
      {this.id,
      this.codeChantier,
      this.nom,
      this.lieu,
      this.type,
      this.percentAvancement,
      this.percentElaboration,
      this.percentEstimation,
      this.percentFabrication,
      this.categorie,
      this.etat,
      this.description,
      this.dateDebut,
      this.dateFin,
      this.chefProjetId});

  Chantier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codeChantier = json['codeChantier'];
    nom = json['nom'];
    lieu = json['lieu'];
    type = json['type'];
    percentAvancement = json['percentAvancement'];
    percentElaboration = json['percentElaboration'];
    percentEstimation = json['percentEstimation'];
    percentFabrication = json['percentFabrication'];
    categorie = json['categorie'];
    etat = json['etat'];
    description = json['description'];
    dateDebut = DateTime.tryParse(json['date_debut'] ?? '');
    dateFin = DateTime.tryParse(json['date_fin'] ?? '');
    chefProjetId = json['chefProjetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['codeChantier'] = codeChantier;
    data['nom'] = nom;
    data['lieu'] = lieu;
    data['type'] = type;
    data['percentAvancement'] = percentAvancement;
    data['percentElaboration'] = percentElaboration;
    data['percentEstimation'] = percentEstimation;
    data['percentFabrication'] = percentFabrication;
    data['categorie'] = categorie;
    data['etat'] = etat;
    data['description'] = description;
    data['date_debut'] = dateDebut?.toIso8601String();
    data['date_fin'] = dateFin?.toIso8601String();
    data['chefProjetId'] = chefProjetId;
    return data;
  }

  static List<Chantier> chantierFromJSON(List projetJSON) {
    return projetJSON.map((data) {
      return Chantier.fromJson(data);
    }).toList();
  }
}
