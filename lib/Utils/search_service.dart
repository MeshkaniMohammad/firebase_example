import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByBookName(String searchField) {
    return Firestore.instance
        .collection('books')
        .where('book name searchkey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
  searchByAuthor(String searchField) {
    return Firestore.instance
        .collection('books')
        .where('book author searchkey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
  searchByPublisher(String searchField) {
    return Firestore.instance
        .collection('books')
        .where('book publisher searchkey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}