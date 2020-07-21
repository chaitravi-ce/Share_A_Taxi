import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_app/models/chatbox_helper.dart';

import '../models/profilemodel.dart';

class ChatScreen extends StatefulWidget {

  final String chatId;
  final String oName;
  ChatScreen(this.chatId, this.oName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController message = TextEditingController();
  ChatHelper chatHelper = new ChatHelper();
  Stream<QuerySnapshot> chats;

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            //return Text(snapshot.data.documents[index].data["message"]);
            return MessageTile(
              snapshot.data.documents[index].data["message"], 
              snapshot.data.documents[index].data["sentBy"] == Profilee.mydefineduser['name'] ? true : false,               
            );
          }
        ) : Container(color: Colors.black,);
      },
    );
  }


  @override
  void initState() {
    chats = Firestore.instance.collection("chatRoom").document(widget.chatId).collection("chats").orderBy("time", descending: false).snapshots();
    print(chats);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.oName, style: GoogleFonts.grenze(fontSize: 28),),),
      body: Stack(children: <Widget>[
        chatMessages(),
        Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(247, 202, 201, 1),
                        Theme.of(context).accentColor
                      ]),
                      borderRadius: BorderRadius.circular(30)
                    ),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: GoogleFonts.fondamento(color: Color.fromRGBO(51, 0, 50, 1)),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).primaryColor,
                          Color.fromRGBO(51, 0, 50, 1),
                        ]),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send,color: Colors.white,),
                        onPressed: () {
                          print('==============================');
                          Map<String,dynamic> messageMap = {
                            'message' : message.text,
                            'sentBy' : Profilee.mydefineduser['name'],
                            'time' : DateTime.now().millisecondsSinceEpoch
                          };
                          message.text = '';
                          if(message.text != ''){
                            chatHelper.addConversationMessages(widget.chatId, messageMap);
                          }                        
                        },
                      ),
                    ),
                  ],
              ),
                ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSentByMe;
  MessageTile(this.message,this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: isSentByMe ? 0 : 24,
        right: isSentByMe ? 24 : 0
      ),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isSentByMe
          ? EdgeInsets.only(left: 30)
          : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: isSentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) : 
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          gradient: LinearGradient(
            colors: isSentByMe ? 
            [
              Theme.of(context).primaryColor,
              Color.fromRGBO(51, 0, 50, 1),
            ]
          : [
              Color.fromRGBO(247, 202, 201, 1),
              Theme.of(context).accentColor
            ],
            )
          ),
          child: Text(
            message, 
            textAlign: TextAlign.start,
            style: GoogleFonts.fondamento(
            color: isSentByMe ? Colors.white : Colors.black,
            fontSize: 18
          ),),
      ),
    );
  }
}