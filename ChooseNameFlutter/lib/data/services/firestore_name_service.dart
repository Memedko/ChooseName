import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/name_api_model.dart';
import '../../domain/models/gender_type.dart';

class FirestoreNameService {
  FirestoreNameService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _namesCollection(
    GenderType gender,
  ) {
    return _firestore.collection(gender.isMale ? 'maleNames' : 'femaleNames');
  }

  Future<List<NameApiModel>> fetchNames(GenderType gender) async {
    final snapshot = await _namesCollection(gender).limit(400).get();
    return snapshot.docs
        .map((doc) => NameApiModel.fromJson(doc.data(), nameId: doc.id))
        .toList();
  }

  Stream<List<NameApiModel>> watchNames(GenderType gender) {
    return _namesCollection(gender).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => NameApiModel.fromJson(doc.data(), nameId: doc.id))
          .toList();
    });
  }

  Future<void> saveCustomName(String name, GenderType gender) {
    return _firestore.collection('customNames').add(<String, Object?>{
      'name': name,
      'isMale': gender.isMale,
    });
  }

  Future<void> saveFavoriteName(String name, GenderType gender) {
    return _firestore.collection('favoriteNames').add(<String, Object?>{
      'name': name,
      'isMale': gender.isMale,
    });
  }
}
