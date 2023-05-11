class Utilisateur {
  int? id;
  String? nom;
  String? prenom;
  String? imageURL;
  String? numTel;
  String? passwordHash;
  String? email;
  String? cin;
  String? role;

  Utilisateur(
      {this.id,
      this.nom,
      this.prenom,
      this.imageURL,
      this.numTel,
      this.passwordHash,
      this.email,
      this.cin,
      this.role});

  Utilisateur.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    imageURL = json['imageURL'];
    numTel = json['numTel'];
    passwordHash = json['passwordHash'];
    email = json['email'];
    cin = json['cin'];
    role = json['role'];
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
    data['role'] = role;
    return data;
  }

  static Utilisateur chefFromJSON(chefJSON) {
    return Utilisateur.fromJson(chefJSON);
  }
}
