import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final CollectionReference TweetCollection = FirebaseFirestore.instance.collection("Tweets");

  Stream<QuerySnapshot> getTweetsStream() {
    return TweetCollection.orderBy("writtenDate", descending: true).snapshots();
  }

  Future<void> uploadTweet(String pseudo, String content, String url) {
    return TweetCollection.add({
      'pseudo': pseudo,
      'contenu': content,
      'urlPhoto': url,
      'writtenDate': Timestamp.now().toDate()
    }).then((value) => print("Tweet uploaded"))
        .catchError((error) => print("Error while uploading " + error));
  }
}


