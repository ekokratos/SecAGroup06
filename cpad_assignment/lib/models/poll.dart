class Polls {
  List<Poll>? pollList;

  Polls({this.pollList});

  factory Polls.fromJson(List<Map<String, dynamic>> jsonList) => Polls(
        pollList: List<Poll>.from(jsonList.map((e) => Poll.fromJson(e))),
      );
}

class Poll {
  String? id;
  String? question;
  String? timestamp;
  List<Option>? options;

  Poll({this.id, this.question, this.timestamp, this.options});

  @override
  String toString() {
    return 'Poll{id: $id, question: $question, timestamp: $timestamp, options: $options}';
  }

  Poll.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? null : json['id'];
    question = json['question'] == null ? null : json['question'];
    timestamp = json['timestamp'] == null ? null : json['timestamp'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson({required String id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['question'] = this.question;
    data['timestamp'] = this.timestamp;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  int? id;
  String? name;
  List<String>? votedUserIds;

  Option({this.id, this.name, this.votedUserIds});

  @override
  String toString() {
    return 'Option{id: $id, name: $name, votedUserIds: $votedUserIds}';
  }

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    votedUserIds = json['voted_user_ids'] == null
        ? null
        : json['voted_user_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['voted_user_ids'] = this.votedUserIds == null ? [] : this.votedUserIds;
    return data;
  }
}
