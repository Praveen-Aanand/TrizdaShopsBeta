import 'package:cloud_firestore/cloud_firestore.dart';

class ProductEntry {
  final String cato;
  final String title;
  final String s_dis;
  final String f_dis;
  final String price;
  final String s_price;
  final String image;
  final String documentId;
  ProductEntry(
      {this.cato,
      this.title,
      this.s_dis,
      this.f_dis,
      this.s_price,
      this.documentId,
      this.price,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'cato': cato,
      'title': title,
      's_dis': s_dis,
      'f_dis': f_dis,
      "price": price,
      "s_price": s_price,
      "docid": documentId,
      "image": image
    };
  }

  static ProductEntry fromDoc(DocumentSnapshot doc) {
    if (doc == null) return null;

    return ProductEntry(
      cato: doc.data['cato'],
      title: doc.data['title'],
      s_dis: doc.data['s_dis'],
      f_dis: doc.data['f_dis'],
      price: doc.data['price'],
      s_price: doc.data['s_price'],
      documentId: doc.documentID,
      image: doc.data['image'],
    );
  }

  // @override
  // String toString() => 'Entry name: $, title: $title, body: $body';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductEntry &&
        o.cato == cato &&
        o.title == title &&
        o.s_dis == s_dis;
  }

  @override
  int get hashCode => title.hashCode ^ title.hashCode ^ cato.hashCode;
}
