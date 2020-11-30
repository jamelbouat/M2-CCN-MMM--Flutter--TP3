import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twistic/services/Database.dart';

import 'TweetListScreen.dart';

class NewTweetScreen extends StatefulWidget {
  NewTweetScreen(this.user);

  final User user;

  @override
  _NewTweetScreenState createState() => _NewTweetScreenState(user);
}

class _NewTweetScreenState extends State<NewTweetScreen> {
  _NewTweetScreenState(this.user);

  final User user;
  final TextEditingController textController = TextEditingController();
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.only(top: 40.0),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL),
                  radius: 40,
                ),
                title: Text(user.displayName,
                    style: TextStyle(color: Colors.green, fontSize: 30)),
                subtitle: Form(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(hintText: 'Write here !'),
                    )
                )),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                database.uploadTweet(user.displayName, textController.text, user.photoURL);
                _navigateToTweetListScreen(context, user);
              },
              child: Text('Post tweet'),
            ),
          ),
        ],
      ),
    );
  }
}

void _navigateToTweetListScreen(BuildContext context, User user) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => TweetListScreen(user)),
  );
}