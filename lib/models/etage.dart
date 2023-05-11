import 'package:mastech/models/plan.dart';

class Etage {
  int? id;
  String? numero;
  String? description;
  int? chantierId;
  Plan? plan;

  Etage({this.id, this.numero, this.description, this.chantierId, this.plan});

  Etage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numero = json['numero'];
    description = json['description'];
    chantierId = json['ChantierId'];
    plan = json['Plan'] != null ? Plan.fromJson(json['Plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['numero'] = numero;
    data['description'] = description;
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
