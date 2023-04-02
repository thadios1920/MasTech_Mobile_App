class ChefChantier {
  int? id;
  String? nom;
  String? prenom;
  Null? imageURL;
  String? numTel;
  Null? password;
  String? cin;
  String? createdAt;
  String? updatedAt;

  ChefChantier(
      {id, nom, prenom, imageURL, numTel, password, cin, createdAt, updatedAt});

  ChefChantier.fromJson(Map<String, dynamic> json) {
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

  static List<ChefChantier> chefChnatierFromJSON(List chefChnatierJSON) {
    return chefChnatierJSON.map((data) {
      return ChefChantier.fromJson(data);
    }).toList();
  }
}
