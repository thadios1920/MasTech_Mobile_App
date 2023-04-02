import 'package:pfe_mobile_app/models/plan.dart';

class Etage {
  int? id;
  String? numero;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? chantierId;
  Plan? plan;

  Etage(
      {this.id,
      this.numero,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.chantierId,
      this.plan});

  Etage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numero = json['numero'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    chantierId = json['ChantierId'];
    plan = json['Plan'] != null ? Plan.fromJson(json['Plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numero'] = numero;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['ChantierId'] = chantierId;
    if (plan != null) {
      data['Plan'] = plan!.toJson();
    }
    return data;
  }

  static List<Etage> etageFromJSON(List etageJSON) {
    return etageJSON.map((data) {
      return Etage.fromJson(data);
    }).toList();
  }
}
