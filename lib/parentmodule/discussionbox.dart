import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/teacherdatalist.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'discussionchatbox.dart';

class DiscussBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiscussBoxState();
  }
}

class DiscussBoxState extends State<DiscussBox> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  List<TeacherDataList> studentsdataList = [];
  List<TeacherDataList> newdataList = [];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var fyID;
  var saveuseId;
  List<ComplainData> complainlist = <ComplainData>[];
  String selectdesign="",selectImage="",selectName="";



  List<ClassDataList> classlist = <ClassDataList>[];
  late ClassDataList selectedClassCode;
  String _classCode="0";

  List<SectionDataList> sectionlist = <SectionDataList>[];
  late SectionDataList selectedsectionCode;
  String _sectionCode="0";


  List<UserType> userlist = <UserType>[];
  late UserType selectedUserCode;
  late String userCode;
  var sendusertypeId=1,empCode;
  TextEditingController _textController = TextEditingController();



  onRefresh() async {
    this.getTeacherList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }


  Future<void> getSavedData() async{

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

    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
        print("fyID " + fyID);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      print("useIdData " + data.toString());
      setState(() {
        saveuseId=data.toString();
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

    Future<String> classCodeData = sfdata.getStudentClassCode(context);
    classCodeData.then((data) {
      setState(() {
        _classCode=data.toString();
        print("empCode " + _classCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> sectionCodeData = sfdata.getStudentSectionCode(context);
    sectionCodeData.then((data) {
      setState(() {
        _sectionCode=data.toString();
        print("empCode " + _sectionCode);
      });
    },onError: (e) {
      print(e);
    });


    getTeacherList();

    /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/
  }


  //////////////////  TeacherList API //////////////////////
  Future<Null> getTeacherList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context,listen: false);
    return await api
        .getTeacherDiscussionList("9",relationshipId,sessionId,_classCode,fyID)
        .then((result) {
      //print(result.length);
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          studentsdataList=result.toList();
          newdataList=result.toList();
        }else{
          this.studentsdataList=[];
        }

      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
      });

      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    getSavedData();
  }

  onItemChanged(String _query) {
    newdataList=<TeacherDataList>[];
    setState(() {
      if(_query.isNotEmpty){
        for (int i = 0; i < studentsdataList.length; i++) {
          var item = studentsdataList[i];
          if (item.teacher.toLowerCase().contains(_query.toLowerCase())) {
            newdataList.add(item);
          }
        }
      }else{
        newdataList=studentsdataList;
      }
    });
  }



  Color selectedColorStatus(String status) {
    Color c;
    if (status == 'In-Process'){
      c = Colors.green;
    }else{
      c = Colors.red;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
        builder: (context) =>
          new GestureDetector(
             onTap: () {
             FocusScope.of(context).requestFocus(new FocusNode());
           },
            child: Container(
              //height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: <Widget>[
                      Container(
                        // height: double.infinity,
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loginbottom.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      ///////AppBar/////////////////////////
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Discussion Box",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700)),
                          leading: new IconButton(
                            // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                              icon: Icon(Icons.arrow_back),
                              color: Colors.black,
                              onPressed:() {
                                Navigator.of(context).pop();
                              }),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                      new Container(
                          padding: new EdgeInsets.all(10.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: _textController,
                                    decoration: InputDecoration(
                                      hintText: 'Search ...',
                                    ),
                                    onChanged: onItemChanged,
                                  ),
                                ),
                                // _myListView(),
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: newdataList.isNotEmpty
                                      ? Container(
                                    child: Expanded(
                                      child: ListView.builder(
                                        itemCount: newdataList.length,
                                        itemBuilder: _buildRow,
                                      ),
                                    ),
                                  )
                                      : isLoader == true
                                      ? Container(
                                      margin: const EdgeInsets.all(180.0),
                                      child: Center(child: CircularProgressIndicator()))
                                      : Container(
                                    margin: const EdgeInsets.all(150.0),
                                    child: Text("No transaction"),
                                  ),


                                ),

                              ]
                          )),

                    ]
                )
            )
        ),
        )

    );

  }


  Widget _myListView(){
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Expanded(
          child: ListView.builder(
            itemCount: newdataList.length,
            itemBuilder: _buildRow,
          )
      ),

    );
  }



  onEdit(index) async {
    var rowData = this.newdataList[index];
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussChatBox(rowData)),);
    print("BACKRESULT-- "+ result);


  }

  Widget _buildRow(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5,
      //margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => onEdit(index),
        child:Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        // height: 100.0,
                          padding: new EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Padding(padding:  new EdgeInsets.all(2.0),
                                  child:   Container(
                                    child:  Column(children: [
                                      Row(
                                        children: [
                                          ClipOval(
                                            child: FadeInImage(image: NetworkImage("${colors.imageUrl}${(newdataList[index].photo) != null ? (newdataList[index].photo).replaceAll("..", "") : ""}"), placeholder: AssetImage('assets/profileblank.png'),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  newdataList[index].teacher != null
                                                      ? newdataList [index].teacher
                                                      : '',
                                                  style:  TextStyle(color: Colors.black,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w600),textAlign: TextAlign.left),
                                             /* Text(
                                                newdataList [index].fatherName != null
                                                    ? newdataList [index].fatherName
                                                    : '',
                                                style:  TextStyle(color: Colors.black54,fontSize: 12.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500),textAlign: TextAlign.left,),*/
                                            ],),

                                        ],
                                      ),
                                    ],),

                                  ),
                                ),

                              ])
                      )
                  ),
                  /*Visibility(
                    maintainSize: false,
                    maintainAnimation: false,
                    maintainState: false,
                    // visible: complainlist[index].status == 'Closed' ? false : true,
                    visible: true,
                    child: Container(
                        width: 50.0,
                        padding: new EdgeInsets.all(5.0),
                        child: new Center(
                            child: IconButton(icon: Icon(Icons.mark_email_unread_rounded,color: colors.redtheme))
                        )

                    ),
                  ),*/

                ]),


          ],
        ),






      ),
    );



  }
}