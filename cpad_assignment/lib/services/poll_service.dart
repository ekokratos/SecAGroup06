import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpad_assignment/models/poll.dart';
import 'package:uuid/uuid.dart';

class PollService {
  static CollectionReference pollCollectionReference =
      FirebaseFirestore.instance.collection('poll');

  static Future<Polls> fetchPolls() async {
    Polls _pollList = Polls();
    try {
      List<Map<String, dynamic>> _consolidatedDocs = [];

      await pollCollectionReference.get().then((docs) {
        if (docs.size > 0) {
          docs.docs.forEach((doc) {
            _consolidatedDocs.add(doc.data() as Map<String, dynamic>);
          });
          _consolidatedDocs
              .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
          _pollList = Polls.fromJson(_consolidatedDocs);
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
    return _pollList;
  }

  static Future<Poll> savePoll({required Poll poll}) async {
    var uuid = Uuid();
    String id = uuid.v1();
    poll.id = id;

    try {
      await pollCollectionReference.doc(id).set(poll.toJson(id: id));
    } catch (e) {
      print(e);
      throw e;
    }
    return poll;
  }

  static Future<void> updatePollOption(
      {required Poll poll, required int choice, required String userId}) async {
    try {
      await pollCollectionReference.doc(poll.id).get().then((doc) async {
        Poll _poll = Poll.fromJson(doc.data() as Map<String, dynamic>);

        late int _optionIndex;
        _poll.options!.forEach((option) {
          if (option.id == choice) {
            _optionIndex = _poll.options!.indexOf(option);
          }
        });
        _poll.options![_optionIndex].votedUserIds!.add(userId);

        await pollCollectionReference
            .doc(poll.id)
            .set(
              _poll.toJson(id: poll.id!),
              SetOptions(merge: true),
            )
            .then((_) {});
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<void> deletePoll({required Poll poll}) async {
    try {
      await pollCollectionReference.doc(poll.id).delete();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
