class Static {
  String type;
  dynamic value;

  Static({
    required this.type,
    required this.value,
  });

  factory Static.fromMap(Map<String, dynamic> map) {
    return Static(
      type: map['type'], // استخراج النوع من الخريطة
      value: map['value'], // استخراج القيمة من الخريطة
    );
  }
}
