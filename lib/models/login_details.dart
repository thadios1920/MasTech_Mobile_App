import 'package:mastech/models/utilisateur.dart';

class LoginDetails {
  String? message;
  Utilisateur? user;
  String? token;

  LoginDetails({this.message, this.user, this.token});

  LoginDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? Utilisateur.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? nom;
  String? prenom;
  String? email;
  String? imageURL;
  String? numTel;
  String? cin;
  String? role;

  User(
      {this.id,
      this.nom,
      this.prenom,
      this.email,
      this.imageURL,
      this.numTel,
      this.cin,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
    imageURL = json['imageURL'];
    numTel = json['numTel'];
    cin = json['cin'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    data['imageURL'] = imageURL;
    data['numTel'] = numTel;
    data['cin'] = cin;
    data['role'] = role;
    return data;
  }

  static LoginDetails detailsFromJSON(detailsJSON) {
    return LoginDetails.fromJson(detailsJSON);
  }
}
