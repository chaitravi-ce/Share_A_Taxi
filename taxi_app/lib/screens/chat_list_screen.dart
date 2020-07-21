import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_app/models/app_drawer.dart';
import 'package:taxi_app/models/profilemodel.dart';
import 'package:taxi_app/screens/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chatList';
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ChatRoomsTile(
              userName: snapshot.data.documents[index].data['chatId'].toString().replaceAll("_", "").replaceAll(Profilee.mydefineduser['name'], ""),
              chatRoomId: snapshot.data.documents[index].data["chatId"],
            );
          })
        : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    chatRooms = Firestore.instance.collection("chatRoom").where("users", arrayContains: Profilee.mydefineduser['name']).snapshots();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Section', style: GoogleFonts.grenze(fontSize: 25),),),
      drawer: AppDrawer(),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatRoomId,
            userName
          )
        ));
      },
      child: Card(
        elevation: 6,
        child: Container(      
          margin: EdgeInsets.symmetric(vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    fontSize: 25,
                  )
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Text(userName,
                textAlign: TextAlign.start,
                style: GoogleFonts.dancingScript(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}