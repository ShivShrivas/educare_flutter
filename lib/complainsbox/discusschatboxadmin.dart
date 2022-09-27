

import 'dart:async';

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/chatbox.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/discussdata.dart';
import 'package:educareadmin/models/studentlistdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


enum ConfirmAction { Cancel, Accept}


class DiscussChatBoxAdmin extends StatefulWidget {

  DiscussChatBoxAdmin(this.studentData) : super();

  final StudentListData studentData;


  @override
  State<StatefulWidget> createState() {
    return DiscussChatBoxAdminBoxState();
  }
}

class DiscussChatBoxAdminBoxState extends State<DiscussChatBoxAdmin> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var saveuseId,empCode;
  var FYIDId,_classCode,_sectionCode;
  TextEditingController messageController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  late Timer timer;
  List<DiscussData> chatList = <DiscussData>[];





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


    Future<String> classData = sfdata.getCurrentClass(context);
    classData.then((data) {
      print("classData " + data.toString());
      setState(() {
        _classCode=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<String> sectionData = sfdata.getCurrentSection(context);
    sectionData.then((data) {
      print("classData " + data.toString());
      setState(() {
        _sectionCode=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
        print("empCode " + empCode);
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
    return await api.sendMessageDiscussion("1",empCode,widget.studentData.id,messageController.text,relationshipId,sessionID,userID,_classCode,_sectionCode,fyID)
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
        .getDiscussChatBox("9",empCode,_classCode,saveuseId,widget.studentData.id,relationshipId,sessionId,FYIDId)
        .then((result) {
     // print(result);
      setState(() {
        if(result.isNotEmpty){
          chatList=result.toList();
         // print(chatList[0].senderId);
          _scrollController.animateTo(_scrollController.position.maxScrollExtent ,curve: const Cubic(0.0, 0.0,0.0, 0.0), duration: const Duration());
        }else{
          chatList=[];
        }

      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
      });

      print(error);
    });
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
             padding: const EdgeInsets.only(right: 16),
             child: Row(
               children: <Widget>[
                 IconButton(
                   onPressed: (){
                     Navigator.pop(context);
                   },
                   icon: const Icon(Icons.arrow_back,color: Colors.black,),
                 ),

                 const SizedBox(width: 2,),
                 ClipOval(
                   child: FadeInImage(
                     image: NetworkImage("${colors.imageUrl}${(widget.studentData.studentPhoto) != null ? (widget.studentData.studentPhoto).replaceAll("..", "") : ""}"),
                     placeholder: const AssetImage("assets/profileblank.png"),
                     imageErrorBuilder:
                         (context, error, stackTrace) {
                       return Image.asset(
                           'assets/profileblank.png',
                           fit: BoxFit.fitWidth);
                     },
                     width: 30,
                     height: 30,
                     fit: BoxFit.cover,
                   ),
                 ),

                 const SizedBox(width: 12,),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Text(widget.studentData.name,style: const TextStyle(color: Colors.white, fontSize: 16 ,fontFamily: 'Montserrat',
                           fontWeight: FontWeight.w700),),

                       Text(widget.studentData.fatherName,style: const TextStyle(color: Colors.white60, fontSize: 12 ,fontFamily: 'Montserrat',
                           fontWeight: FontWeight.w700),),

                     ],
                   ),
                 ),

               ],
             ),
           ),
         ),
       ),

      body: Builder(
            builder: (context) =>
            GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
             },
             child: Stack(
                children: <Widget>[
               ListView.builder(
                 controller: _scrollController,
                 itemCount: chatList.length,
                 reverse: true,
                 //dragStartBehavior: ,
                 shrinkWrap: true,
                 padding: const EdgeInsets.only(top: 10,bottom: 80),
                 //physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context, index){
                   return Container(
                     padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                     child: Align(
                       alignment: (chatList[index].senderId==saveuseId?Alignment.topRight:Alignment.topLeft),
                       //alignment: Alignment.topLeft,
                       child: Container(
                         // width: MediaQuery.of(context).size.height * 0.4,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           color: (chatList[index].senderId==saveuseId?Colors.blue[200]:Colors.grey.shade200),
                         ),
                         padding: const EdgeInsets.all(16),
                         child: Column(
                           crossAxisAlignment: (chatList[index].senderId==saveuseId?CrossAxisAlignment.end:CrossAxisAlignment.start),
                           children: [
                             Text(chatList[index].complain, style: const TextStyle(fontSize: 15,color: Colors.black,fontFamily: 'Montserrat',
                                 fontWeight: FontWeight.w400),),
                             const SizedBox(height: 15,),
                             Text("${chatList[index].createdDate} ${chatList[index].createdTime}",style: const TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                 fontWeight: FontWeight.w400),textAlign: TextAlign.end),
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
                 visible: true,
                child: Container(
                 padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10,right: 10),
                 //height: 65,
                 width: double.infinity,
                 color: Colors.grey.shade300,
                 child: Row(
                   children: <Widget>[
                     const SizedBox(width: 15,),
                     Expanded(
                       child: TextField(
                         controller: messageController,
                         keyboardType: TextInputType.multiline,
                         minLines: 1,
                         maxLines: 4,
                         decoration: const InputDecoration(
                             hintText: "Write message...",
                             hintStyle: TextStyle(color: Colors.black54),
                             border: InputBorder.none
                         ),
                       ),
                     ),
                     const SizedBox(width: 15,),
                     FloatingActionButton(
                       onPressed: (){
                         if(messageController.text.isNotEmpty){
                           sendMessage(context,relationshipId.toString(),sessionId,FYIDId,saveuseId.toString());
                           FocusScope.of(context).requestFocus(FocusNode());
                         }
                       },
                       child: const Icon(Icons.send,color: Colors.white,size:18),
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
         )
     );

  }



}