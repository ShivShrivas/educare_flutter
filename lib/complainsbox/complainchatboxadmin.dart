

import 'dart:async';

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/chatbox.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


enum ConfirmAction { Cancel, Accept}


class ComplainChatBoxAdmin extends StatefulWidget {

  ComplainChatBoxAdmin(this.complainData) : super();

  final ComplainData complainData;


  @override
  State<StatefulWidget> createState() {
    return ComplainChatBoxAdminBoxState();
  }
}

class ComplainChatBoxAdminBoxState extends State<ComplainChatBoxAdmin> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var saveuseId;
  var FYIDId;
  TextEditingController messageController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  late Timer timer;
  List<ChatBox> chatList = <ChatBox>[];





  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getSavedData() async{

    Future<int> fyidIdData = sfdata.getFyID(context);
    fyidIdData.then((data) {
      print("authToken " + data.toString());
      setState(() {
        FYIDId=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<int> sessionIdData = sfdata.getSessionId(context);
    sessionIdData.then((data) {
      print("authToken " + data.toString());
      setState(() {
        sessionId=data;
      });
    },onError: (e) {
      print(e);
    });
    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
      print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
      });
    },onError: (e) {
      print(e);
    });
    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      print("useIdData " + data.toString());
      setState(() {
        saveuseId=data;
      });
    },onError: (e) {
      print(e);
    });
    getChatList();
    timer = Timer.periodic(Duration(seconds: 20), (Timer t) => getChatList());
  }

  @override
  void initState() {
    super.initState();
    getSavedData();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /////////////////////////// Send Message //////////////////////////////////////////////////
  Future<void> sendMessage(BuildContext context,String relationshipId,int sessionID,int fyID,String userID) async {
    final api = Provider.of<ApiService>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await api.sendMessage("1",userID,widget.complainData.receivedById,widget.complainData.transId,messageController.text,relationshipId,sessionID,fyID,userID)
        .then((result) {
      if(result.isNotEmpty){
        print("Exception ${result}");
        messageController.text='';
        getChatList();
      }

    }).catchError((error) {
      print("Exception");
      print(error);
    });
  }

  //////////////////  getChatbox API //////////////////////
  Future<Null> getChatList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getChatBox("4",widget.complainData.transId,relationshipId,sessionId,FYIDId)
        .then((result) {
     // print(result);
      setState(() {
        if(result.isNotEmpty){
          chatList=result.toList();
          print(chatList[0].senderId);
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Cubic(0.0, 0.0,0.0, 0.0), duration: new Duration());
        }else{
          this.chatList=[];
        }

      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
      });

      print(error);
    });
  }

  ///////////////////////////////////////Update Status ///////////////////
  Future<void> updateStatus(BuildContext context,String relationshipId,int sessionID,int fyID,String userID,String status) async {
    final api = Provider.of<ApiService>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await api.updateStatus("2",widget.complainData.transId,status,relationshipId,sessionID,fyID,userID)
        .then((result) {
      if(result.isNotEmpty){
        print("Exception ${result}");
        Navigator.pop(context);
      }

    }).catchError((error) {
      print("Exception");
      print(error);
    });
  }



//////////////Logout dialog//////
  Future<Future<ConfirmAction?>> _dialogConfirmation(BuildContext context) async {
    SFData sfdata= SFData();
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Send to Closed'),
          content: const Text(
              'Do you really want to close that complain.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Yes',style: TextStyle(color: Colors.red)),
              onPressed: () {
                updateStatus(context,relationshipId.toString(),sessionId,FYIDId,saveuseId.toString(),"Closed");
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            )
          ],
        );
      },
    );
  }

  //////////////Logout dialog//////
  Future<Future<ConfirmAction?>> _dialogConfirmationOpen(BuildContext context) async {
    SFData sfdata= SFData();
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Send to In-Process'),
          content: const Text(
              'Do you really want to Re-Open that complain.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Yes',style: TextStyle(color: Colors.red)),
              onPressed: () {
                updateStatus(context,relationshipId.toString(),sessionId,FYIDId,saveuseId.toString(),"In-Process");
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         elevation: 0,
         automaticallyImplyLeading: false,
         backgroundColor: colors.redtheme,
         flexibleSpace: SafeArea(
           child: Container(
             padding: EdgeInsets.only(right: 16),
             child: Row(
               children: <Widget>[
                 IconButton(
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   icon: Icon(Icons.arrow_back,color: Colors.black,),
                 ),
                 SizedBox(width: 2,),
                 CircleAvatar(
                   backgroundImage: AssetImage('assets/profileblank.png'),
                   backgroundColor: Colors.transparent,
                   maxRadius: 20,
                 ),
                 SizedBox(width: 12,),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text(widget.complainData.createdByName,style: TextStyle(color: Colors.white, fontSize: 16 ,fontFamily: 'Montserrat',
                           fontWeight: FontWeight.w700),),
                       SizedBox(height: 6,),
                       //Text(widget.complainData.complainTo,style: TextStyle(color: Colors.white70, fontSize: 13),),
                     ],
                   ),
                 ),
                 SizedBox(width: 10,),
                 FlatButton(
                   color: Colors.white,
                   child: Text(widget.complainData.status, style: TextStyle(fontSize: 14.0,fontFamily: 'Montserrat',
                       fontWeight: FontWeight.w700),),
                  // highlightedBorderColor: Colors.white,

                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(18)

                   ),
                   onPressed: () {
                     if(widget.complainData.status == 'In-Process'){
                       _dialogConfirmation(context);
                     }else{
                       _dialogConfirmationOpen(context);
                     }


                   },
                 ),
                 SizedBox(width: 10,),
                 Visibility(
                   maintainSize: false,
                   maintainAnimation: true,
                   maintainState: true,
                   visible:widget.complainData.attachmentPath == null ? false : true,
                   child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children:<Widget>[
                         IconButton(icon: Icon(Icons.attach_file_sharp,color: colors.white), onPressed:() {
                           String path=colors.imageUrl+("/"+widget.complainData.attachmentPath).replaceAll('..', '');
                           print(path);
                           final url = Uri.encodeFull(path);
                           _launchInWebViewOrVC(url);
                         })
                       ]),
                 ),
               ],
             ),
           ),
         ),
       ),

         body:
           new GestureDetector(
           onTap: () {
           FocusScope.of(context).requestFocus(new FocusNode());
           },
            child: Stack(
             children: <Widget>[
               ListView.builder(
                 controller: _scrollController,
                 itemCount: chatList.length,
                 reverse: true,
                 //dragStartBehavior: ,
                 shrinkWrap: true,
                 padding: EdgeInsets.only(top: 10,bottom: 80),
                 //physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context, index){
                   return Container(
                     padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                     child: Align(
                       alignment: (chatList[index].senderId==saveuseId?Alignment.topRight:Alignment.topLeft),
                       //alignment: Alignment.topLeft,
                       child: Container(
                         // width: MediaQuery.of(context).size.height * 0.4,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           color: (chatList[index].senderId==saveuseId?Colors.blue[200]:Colors.grey.shade200),
                         ),
                         padding: EdgeInsets.all(16),
                         child: Column(
                           crossAxisAlignment: (chatList[index].senderId==saveuseId?CrossAxisAlignment.end:CrossAxisAlignment.start),
                           children: [
                             Text(chatList[index].message, style: TextStyle(fontSize: 15,color: Colors.black,fontFamily: 'Montserrat',
                                 fontWeight: FontWeight.w400),),
                             SizedBox(height: 15,),
                             Text("${chatList[index].date}  ${chatList[index].time}", style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                 fontWeight: FontWeight.w400),textAlign: TextAlign.end,),
                           ],
                         ),
                       ),
                     ),
                   );
                 },
               ),



             Align(
               alignment: Alignment.bottomLeft,
               child: Visibility(
                 maintainSize: false,
                 maintainAnimation: false,
                 maintainState: false,
                 visible: widget.complainData.status == 'Closed' ? false : true,
               child: Container(
                 padding: EdgeInsets.only(left: 10,bottom: 10,top: 10,right: 10),
                // height: 65,
                 width: double.infinity,
                 color: Colors.grey.shade300,
                 child: Row(
                   children: <Widget>[
                     /*GestureDetector(
                       onTap: (){
                       },
                       child: Container(
                         height: 30,
                         width: 30,
                        *//* decoration: BoxDecoration(
                           color: Colors.lightBlue,
                           borderRadius: BorderRadius.circular(30),
                         ),*//*
                         //child: Icon(Icons.add, color: Colors.white, size: 20, ),
                       ),
                     ),*/
                     SizedBox(width: 15,),
                     Expanded(
                       child: TextField(
                         controller: messageController,
                         keyboardType: TextInputType.multiline,
                         minLines: 1,
                         maxLines: 4,
                         decoration: InputDecoration(
                             hintText: "Write message...",
                             hintStyle: TextStyle(color: Colors.black54),
                             border: InputBorder.none
                         ),
                       ),
                     ),
                     SizedBox(width: 15,),
                     FloatingActionButton(
                       onPressed: (){
                         if(messageController.text.isNotEmpty){
                           sendMessage(context,relationshipId.toString(),sessionId,FYIDId,saveuseId.toString());
                           FocusScope.of(context).requestFocus(new FocusNode());
                         }
                       },
                       child: Icon(Icons.send,color: Colors.white,size: 18,),
                       backgroundColor: colors.redtheme,
                       elevation: 0,
                     ),
                   ],

                 ),
               ),
               ),
             ),
           ],
         ),
       ),
     );

  }



}