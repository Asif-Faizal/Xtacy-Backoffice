import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xtacy_backoffice/core/constants/app_constants.dart';
import 'package:xtacy_backoffice/core/errors/failures.dart';

/// Generates sequential product codes like XT000001.
class ProductCodeService {
  ProductCodeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String> generateNextCode() async {
    try {
      final counterRef = _firestore
          .collection(AppConstants.metadataCollection)
          .doc(AppConstants.productCounterDoc);

      return _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);
        int currentCount = 0;

        if (snapshot.exists) {
          currentCount = snapshot.data()?['count'] as int? ?? 0;
        }

        final nextCount = currentCount + 1;
        transaction.set(counterRef, {'count': nextCount}, SetOptions(merge: true));

        return '${AppConstants.productCodePrefix}${nextCount.toString().padLeft(6, '0')}';
      });
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to generate product code');
    }
  }
}
