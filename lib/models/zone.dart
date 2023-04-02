class Zone {
  int? id;
  int? x;
  int? y;
  int? width;
  int? height;
  String? createdAt;
  String? updatedAt;
  int? elementId;

  Zone(
      {this.id,
      this.x,
      this.y,
      this.width,
      this.height,
      this.createdAt,
      this.updatedAt,
      this.elementId});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    x = json['x'];
    y = json['y'];
    width = json['width'];
    height = json['height'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    elementId = json['ElementId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['x'] = x;
    data['y'] = y;
    data['width'] = width;
    data['height'] = height;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['ElementId'] = elementId;
    return data;
  }

  static Zone zoneFromJSON(zoneJSON) {
    return Zone.fromJson(zoneJSON);
  }
}
