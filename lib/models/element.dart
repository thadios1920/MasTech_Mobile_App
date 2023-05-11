class Element {
  int? id;
  String? hauteur;
  String? designation;
  String? codeArticle;
  String? description;
  String? largeur;
  String? reference;
  String? surface;
  String? couleur;
  String? gamme;
  String? serie;
  String? vitrage;
  String? unite;
  String? qte;
  String? lot;
  String? phase;
  String? etat;
  bool? affecte;
  int? etageId;

  Element(
      {this.id,
      this.hauteur,
      this.designation,
      this.codeArticle,
      this.description,
      this.largeur,
      this.reference,
      this.surface,
      this.couleur,
      this.gamme,
      this.serie,
      this.vitrage,
      this.unite,
      this.qte,
      this.lot,
      this.phase,
      this.etat,
      this.affecte,
      this.etageId});

  Element.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hauteur = json['hauteur'];
    designation = json['designation'];
    codeArticle = json['code_Article'];
    description = json['description'];
    largeur = json['largeur'];
    reference = json['reference'];
    surface = json['surface'];
    couleur = json['couleur'];
    gamme = json['gamme'];
    serie = json['serie'];
    vitrage = json['vitrage'];
    unite = json['unite'];
    qte = json['qte'];
    lot = json['lot'];
    phase = json['phase'];
    etat = json['etat'];
    affecte = json['affecte'];
    etageId = json['EtageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['hauteur'] = hauteur;
    data['designation'] = designation;
    data['code_Article'] = codeArticle;
    data['description'] = description;
    data['largeur'] = largeur;
    data['reference'] = reference;
    data['surface'] = surface;
    data['couleur'] = couleur;
    data['gamme'] = gamme;
    data['serie'] = serie;
    data['vitrage'] = vitrage;
    data['unite'] = unite;
    data['qte'] = qte;
    data['lot'] = lot;
    data['phase'] = phase;
    data['etat'] = etat;
    data['affecte'] = affecte;
    data['EtageId'] = etageId;
    return data;
  }

  static List<Element> elementFromJSON(List elementJSON) {
    return elementJSON.map((data) {
      return Element.fromJson(data);
    }).toList();
  }
}
