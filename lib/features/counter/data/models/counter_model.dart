class Counter {
  final int value;

  Counter({required this.value});

  factory Counter.fromJson(Map<String, dynamic> json) => Counter(value: json['value'] as int);

  Map<String, dynamic> toJson() => {'value': value};
}
