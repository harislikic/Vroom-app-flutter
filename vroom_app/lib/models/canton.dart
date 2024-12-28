class Canton {
  final int id;
  final String title;

  Canton({required this.id, required this.title});

  factory Canton.fromJson(Map<String, dynamic> json) {
    return Canton(
      id: json['id'],
      title: json['title'],
    );
  }
}
