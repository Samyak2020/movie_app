class TrailerList {
  int id;
  List<Trailer> results;

  TrailerList({this.id, this.results});

  TrailerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['results'] != null) {
      results = new List<Trailer>();
      json['results'].forEach((v) {
        results.add(new Trailer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trailer {
  String id;
  String key;
  String site;

  Trailer({this.id, this.key, this.site});

  Trailer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['site'] = this.site;
    return data;
  }
}
