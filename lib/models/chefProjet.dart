class ChefProjet {
  int? id;
  String? nom;
  String? prenom;
  String? imageURL;
  String? numTel;
  String? passwordHash;
  String? email;
  String? cin;
  String? createdAt;
  String? updatedAt;

  ChefProjet(
      {this.id,
      this.nom,
      this.prenom,
      this.imageURL,
      this.numTel,
      this.passwordHash,
      this.email,
      this.cin,
      this.createdAt,
      this.updatedAt});

  ChefProjet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    imageURL = json['imageURL'];
    numTel = json['numTel'];
    passwordHash = json['passwordHash'];
    email = json['email'];
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
    data['passwordHash'] = passwordHash;
    data['email'] = email;
    data['cin'] = cin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  static ChefProjet chefFromJSON(chefJSON) {
    return ChefProjet.fromJson(chefJSON);
  }
}
