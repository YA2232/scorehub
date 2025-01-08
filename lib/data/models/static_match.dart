class StaticMatch {
  List<dynamic> list;

  StaticMatch({
    required this.list,
  });

  factory StaticMatch.fromMap(Map<String, dynamic> map) {
    return StaticMatch(
      list: map['statistics'], // استخراج الإحصائيات من الخريطة
    );
  }
}
