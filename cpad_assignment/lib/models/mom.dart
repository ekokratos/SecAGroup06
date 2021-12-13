class MOMs {
  List<MOM>? momList;

  MOMs({this.momList});

  factory MOMs.fromJson(List<Map<String, dynamic>> jsonList) => MOMs(
        momList: List<MOM>.from(jsonList.map((e) => MOM.fromJson(e))),
      );
}

class MOM {
  String? id;
  String? title;
  String? content;
  String? date;

  MOM({this.title, this.content, this.date, this.id});

  @override
  String toString() {
    return 'MOM{id: $id, title: $title, content: $content, date: $date}';
  }

  factory MOM.fromJson(Map<String, dynamic> json) => MOM(
      id: json['id'] == null ? '' : json['id'],
      title: json['title'] == null ? '' : json['title'],
      content: json['content'] == null ? '' : json['content'],
      date: json['date'] == null ? '' : json['date']);

  Map<String, dynamic> toJson({required String id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;

    return data;
  }
}
