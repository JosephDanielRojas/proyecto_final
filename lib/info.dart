class Info {
  int? api;
  String? name;
  String? tarea;

  Info({
    this.api,
    this.name,
    this.tarea,
  });

  Info.newInfo({
    this.api,
    this.name,
    this.tarea,
  });

  factory Info.fromJSON(Map<dynamic, dynamic> json) {
    return Info(
      api: json['personId'] as int?,
      name: json['name'] as String?,
      tarea: json['tarea'] as String?,
    );
  }
}
