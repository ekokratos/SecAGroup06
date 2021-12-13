import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpad_assignment/models/mom.dart';
import 'package:uuid/uuid.dart';

class MOMService {
  static CollectionReference momsCollectionReference =
      FirebaseFirestore.instance.collection('mom');

  static Future<MOMs> fetchMOMs() async {
    MOMs _momList = MOMs();
    try {
      List<Map<String, dynamic>> _consolidatedDocs = [];

      await momsCollectionReference.get().then((docs) {
        if (docs.size > 0) {
          docs.docs.forEach((doc) {
            _consolidatedDocs.add(doc.data() as Map<String, dynamic>);
          });
          _momList = MOMs.fromJson(_consolidatedDocs);
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
    return _momList;
  }

  static Future<MOM> saveMOM({required MOM mom}) async {
    var uuid = Uuid();
    String id = uuid.v1();
    mom.id = id;

    try {
      await momsCollectionReference.doc(id).set(mom.toJson(id: id));
    } catch (e) {
      print(e);
      throw e;
    }
    return mom;
  }

  static Future<void> deleteMOMById({required String id}) async {
    try {
      momsCollectionReference.doc(id).delete();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
