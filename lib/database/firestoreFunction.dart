import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFunction {
  static addUserinCollection(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  static Future<QuerySnapshot> getUsers(
      String city, String state, String service) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("city", isEqualTo: city)
        .where("state", isEqualTo: state)
        .where("service", isEqualTo: service)
        .get();
  }
}
