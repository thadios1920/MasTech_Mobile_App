class ChefProjet {
  int? id;
  String? nom;
  String? prenom;
  String? imageURL;
  String? numTel;
  String? password;
  String? cin;
  String? createdAt;
  String? updatedAt;

  ChefProjet(
      {this.id,
      this.nom,
      this.prenom,
      this.imageURL,
      this.numTel,
      this.password,
      this.cin,
      this.createdAt,
      this.updatedAt});

  ChefProjet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    imageURL = json['imageURL'];
    numTel = json['numTel'];
    password = json['password'];
    cin = json['cin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['imageURL'] = imageURL;
    data['numTel'] = numTel;
    data['password'] = password;
    data['cin'] = cin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
