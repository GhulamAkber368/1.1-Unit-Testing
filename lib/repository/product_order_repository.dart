import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unit_testing_counter/model/product_order.dart';

class ProductOrderRepository {
  final FirebaseFirestore firebaseFirestore;

  ProductOrderRepository(this.firebaseFirestore);

  CollectionReference get _ordersCollection =>
      firebaseFirestore.collection('orders');

  setProductOrder(String docID, ProductOrder productOrder) async {
    try {
      await _ordersCollection.doc(docID).set(productOrder.toJson());
    } on FirebaseException catch (e) {
      // throw Exception(e.message);
      throw FirebaseException(plugin: "firestore", message: e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  getProductOrder(String productOrderId) async {
    DocumentSnapshot snapshot =
        await _ordersCollection.doc(productOrderId).get();
    if (!snapshot.exists) {
      throw Exception("Document not exists");
    } else {
      return ProductOrder.fromJson(snapshot.data() as Map<String, dynamic>);
    }
  }

  updateProductOrder(ProductOrder productOrder) async {
    await _ordersCollection.doc("1").update(productOrder.toJson());
  }

  deleteProductOrder(String productOrderId) async {
    await _ordersCollection.doc(productOrderId).delete();
  }

  Future<List<Map<String, dynamic>>> getAliOrders() async {
    final querySnapshot = await firebaseFirestore
        .collection('orders')
        .where('user', isEqualTo: 'Ali')
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
