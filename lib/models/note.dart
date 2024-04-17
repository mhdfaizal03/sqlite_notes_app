class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Convert a Note object to a Map object for storage in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Convert a Map object from SQLite to a Note object
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
