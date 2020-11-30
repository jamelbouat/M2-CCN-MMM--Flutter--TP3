import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twistic/services/Authentication.dart';
import 'package:twistic/services/Database.dart';

import 'NewTweetScreen.dart';

class TweetListScreen extends StatelessWidget {
  final User user;
  TweetListScreen(this.user);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Twistic tweets', user: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final User user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Authentication authentication = Authentication(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff2c89ac), Color(0xff2c70ac)],
                    stops: [0.2, 0.8])),
            child: Column(
              children: [
                  UserAccountsDrawerHeader(
                    decoration:
                          BoxDecoration(color: Colors.lightBlue),
                    accountEmail: widget.user.email != null
                        ? Text(widget.user.email)
                        : Text("Email empty"),
                    accountName: widget.user.displayName != null
                        ? Text(widget.user.displayName)
                        : Text("Pseudo empty"),
                    currentAccountPicture: widget.user.photoURL != null
                        ? Image.network(widget.user.photoURL)
                        : widget.user.displayName != null
                            ? CircleAvatar(
                              child: Text(widget.user.displayName[0].toUpperCase()))
                            : CircleAvatar(),
                  ),
                  ButtonTheme(
                    height: 56,
                    child: RaisedButton(
                      child: Text('Logout', style: TextStyle(color: Colors.white, fontSize: 20)),
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      onPressed: () => {
                        authentication.signOut()
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff2c89ac), Color(0xff2c70ac)],
                  stops: [0.2, 0.8])),
          child: _ListView(widget.user),
          constraints: BoxConstraints.expand(),
        )));
  }
}

class _ListView extends StatefulWidget {
  final User user;
  _ListView(this.user);

  @override
  __ListViewState createState() => __ListViewState();
}

class __ListViewState extends State<_ListView> {
  bool loading = false;
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: database.getTweetsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }
          return Stack(
            children: [
              ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return _BuildCard(document);
                  }).toList()
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Icons.message),
                  backgroundColor: Colors.lightGreen,
                  onPressed: () {
                    _navigateToNewTweetScreen(context, widget.user);
                  },
                ),
              )
            ]
          );
        });
  }

  Widget _BuildCard(DocumentSnapshot document) {
    return Card(
      color: Colors.white70,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(document.data()["urlPhoto"] != null ? document.data()["urlPhoto"] : "https://i.pinimg.com/originals/00/53/0f/00530fff41ac74d921cdce6b98d5b4a3.jpg"),
        ),
        title:
            Text(document.data()["pseudo"] != null ? document.data()["pseudo"] : 'Empty Content', style: TextStyle(color: Colors.white, fontSize: 20)),
        subtitle: Text(document.data()["contenu"] != null ? document.data()["contenu"] : 'Empty Content'),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )
      ),
    );
  }
}

void _navigateToNewTweetScreen(BuildContext context, User user) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => NewTweetScreen(user)),
  );
}