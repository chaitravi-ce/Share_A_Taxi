import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper{

  String getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      print("$b\_$a");
      return "$b\_$a";
    }else{
      print("$a\_$b");
      return "$a\_$b";
    }
  }

  createChatRoom(String chatRoomId, Map<String,dynamic> chatRoomMap){
    Firestore.instance.collection('chatRoom').document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, Map<String,dynamic> messageMap){
    print(chatRoomId);
    Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  deleteCoversationMessgae(String chatRoomId, Map<String,dynamic> messageMap){
    print(chatRoomId);
    dynamic msg = Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").document();   
    print(msg);
  }

  getConversationMessages(String chatRoomId){
    return Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").orderBy("time", descending: false).snapshots();
  }

  getChatRooms(String username){
    return Firestore.instance.collection("chatRoom").where("users", arrayContains: username).snapshots();
  }

  //void createChatRoomAndStart(String id, String myName, String oName)async{
  //  List<String> users = [myName, oName];
  //  final url = 'https://samelocationsametaxi.firebaseio.com/chats/$id.json';
  //  try {
  //    final response = await http.post(
  //      url,
  //      body: json.encode({
  //        'users' : users,
  //        'id' : id,
  //      }),
  //    );
  //    print(json.decode(response.body)['name']);
  //  } 
  //  catch (error) {
  //    print(error);
  //    throw error;
  //  }
  //}

  //void addMessage(String message, String id, String sentBy)async{
  //  final url = 'https://samelocationsametaxi.firebaseio.com/chats/$id/chatMsgs.json';
  //  try {
  //    final response = await http.post(
  //      url,
  //      body: json.encode({
  //        'message' : message,
  //        'sentBy' : sentBy,
  //      }),
  //    );
  //    print(json.decode(response.body)['name']);
  //  } 
  //  catch (error) {
  //    print(error);
  //    throw error;
  //  }
  //}

  //List<Map<String,String>> messages;

  //dynamic getMessages(String id)async{
  //  final url = 'https://samelocationsametaxi.firebaseio.com/chats/$id/chatMsgs.json';
  //  final response = await http.get(url);
  //  final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //  print(extractedData);
  //  extractedData.forEach((userID, userData){
  //    messages.add(userData);
  //  });
  //  return messages;
  //}

  //Stream getStream(String id)async*{
  //  yield await getMessages(id);
  //}
  
}