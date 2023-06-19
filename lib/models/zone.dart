class Zone {
  int? id;
  int? x;
  int? y;
  int? width;
  int? height;
  int? elementId;

  Zone({this.id, this.x, this.y, this.width, this.height, this.elementId});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    x = int.tryParse(json['x'] ?? '');
    y = int.tryParse(json['y'] ?? '');
    width = int.tryParse(json['width'] ?? '');
    height = int.tryParse(json['height'] ?? '');
    elementId = json['ElementId'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['x'] = x;
    data['y'] = y;
    data['width'] = width;
    data['height'] = height;
    data['ElementId'] = elementId;
    return data;
  }

  static Zone zoneFromJSON(dynamic zoneJSON) {
    return Zone.fromJson(zoneJSON as Map<String, dynamic>);
  }
}
