import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/helper/helperFunctions.dart';

//Handles interaction with database

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future setUserData(String username) async {
    return await userCollection.document(uid).setData({
      'username': username
    });
  }

  Future updateUserData(String username) async {
    return await userCollection.document(uid).updateData({
      'username': username
    });
  }

  Future updateUserEmail(String email) async {
    return await userCollection.document(uid).updateData({
      'email': email
    });
  }

  Stream<QuerySnapshot> get user {
    return userCollection.snapshots();
  }

  createEmailDoc(String email) async {
    await DatabaseService(uid: uid).updateUserEmail(email);
  }

  createNewDocument() async {
    await DatabaseService(uid: uid).setUserData('Your username');
    await HelperFunctions.saveUsername('Your username');
  }

  getUserIdByUsername(String username) async {
    print(username);
    QuerySnapshot qs = await Firestore.instance.collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    return qs.documents[0].documentID;
  }

  getUsernameByUserEmail(String userEmail) async {
     QuerySnapshot qs = await userCollection
        .where('email', isEqualTo: userEmail)
         .getDocuments();
     return qs.documents[0]['username'];
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    Firestore.instance.collection('chatRoom')
        .document(charRoomId).setData(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}


