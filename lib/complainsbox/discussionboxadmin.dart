import 'package:educareadmin/complainsBox/discusschatboxadmin.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/studentlistdata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/parentmodule/createcomplain.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscussBoxAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiscussBoxAdminState();
  }
}

class DiscussBoxAdminState extends State<DiscussBoxAdmin> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  late List<StudentListData> studentsdataList;
  late List<StudentListData> newdataList=<StudentListData>[];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var fyID;
  var saveuseId;
  List<ComplainData> complainlist = <ComplainData>[];
  String selectdesign="",selectImage="",selectName="";





  List<ClassDataList> classlist = <ClassDataList>[];
  ClassDataList? selectedClassCode;
  String _classCode="0";

  List<SectionDataList> sectionlist = <SectionDataList>[];
  SectionDataList? selectedsectionCode;
  String _sectionCode="0";


  List<UserType> userlist = <UserType>[];
  UserType? selectedUserCode;
  late String userCode;
  var sendusertypeId=1,empCode;
  TextEditingController _textController = TextEditingController();



  onRefresh() async {
    this.getStudentList();
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


    classList();
    getStudentList();

    /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/
  }

  //////////////////  Class API //////////////////////
  Future<Null> classList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getClassListdiscussion("6",relationshipid,sessionid,saveuseId,fyID)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          classlist=result;
         // selectedClassCode = result[0];
         // _classCode = result[0].classCode.toString();
        //  print("OutputrelationshipId2 "+ classlist[0].className);
         // sectionList();
        });

      }else{
        this.classlist = [];
      }

    }).catchError((error) {

      print(error);
    });
  }

  //////////////////  Sections API //////////////////////
  Future<Null> sectionList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getSectionListdiscussion("6",relationshipid,sessionid,saveuseId,fyID,_classCode)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
           if(result[0].code != null){
              sectionlist=result;
              selectedsectionCode= result[0];
             _sectionCode = result[0].code.toString();
             //print("OutputrelationshipId2 "+ classlist[0].className);
           }else{
             _sectionCode="0";
             this.sectionlist = [];
           }
           getStudentList();
        });
      }else{
        this.sectionlist = [];
      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  StudentList API //////////////////////
  Future<Null> getStudentList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context,listen: false);
    return await api
        .getStudentList("9",relationshipId,sessionId,_classCode,_sectionCode,fyID)
        .then((result) {
      print(result.length);
      setState(() {
        isLoader = false;
          if(result.isNotEmpty){
           // studentsdataList=result.toList();
            newdataList=result.toList();
          }else{
            newdataList=[];
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
    newdataList =<StudentListData>[];
    setState(() {
      if(_query.isNotEmpty){
        for (int i = 0; i < studentsdataList.length; i++) {
          var item = studentsdataList[i];
          if (item.name.toLowerCase().contains(_query.toLowerCase())) {
            newdataList.add(item);
          }
        }
      }else{
        newdataList=studentsdataList;
      }
    });
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateComplain()),
    );
    this.getSavedData();
    print("BACKRESULT-- "+ result);
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
                        padding: new EdgeInsets.all(1.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                                Container(
                                  color: colors.greylight3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(padding:  new EdgeInsets.all(5.0),
                                                    child: Text("Class",textAlign: TextAlign.start,
                                                        style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                ],
                                              ),
                                              new Container(
                                                height: 45.0,
                                                margin: const EdgeInsets.all(5.0),
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color:colors.greylight ,
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    border: Border.all(color: Colors.grey)
                                                ),
                                                child: DropdownButton<ClassDataList>(
                                                  isExpanded: true,
                                                  value: selectedClassCode,
                                                  icon: Icon(Icons.arrow_drop_down),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                                  underline: SizedBox(),
                                                  /*underline: Container(
                                                  height: 2,
                                                  color: Colors.deepPurpleAccent,
                                                ),*/
                                                  onChanged: (ClassDataList? data) {
                                                    setState(() {
                                                      selectedClassCode = data!;
                                                      _classCode=selectedClassCode!.classCode;
                                                      // print(selectedClassCode.classCode);
                                                      sectionList();
                                                    });
                                                  },
                                                  items: this.classlist.map((ClassDataList data) {
                                                    return DropdownMenuItem<ClassDataList>(
                                                      child: Text("  "+data.className,style: new TextStyle(fontSize: 14.0,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                      value: data,
                                                    );
                                                  }).toList(),

                                                  hint:Text(
                                                    "Select Class",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )

                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(padding:  new EdgeInsets.all(5.0),
                                                  child: Text("Section",textAlign: TextAlign.start,
                                                      style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ),
                                              ],
                                            ),
                                            new Container(
                                              height: 45.0,
                                              margin: const EdgeInsets.all(5.0),
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  color:colors.greylight ,
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  border: Border.all(color: Colors.grey)
                                              ),
                                              child: DropdownButton<SectionDataList>(
                                                isExpanded: true,
                                                value: selectedsectionCode,
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                underline: SizedBox(),
                                                /*underline: Container(
                                                   height: 2,
                                                   color: Colors.deepPurpleAccent,
                                                 ),*/
                                                onChanged: (SectionDataList? data) {
                                                  setState(() {
                                                    selectedsectionCode = data!;
                                                    _sectionCode=selectedsectionCode!.code;
                                                    //print(sendusertypeId);
                                                    getStudentList();
                                                  });
                                                },
                                                items: this.sectionlist.map((SectionDataList data) {
                                                  return DropdownMenuItem<SectionDataList>(
                                                    child: Text("  "+data.sectionName,style: new TextStyle(fontSize: 14.0,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                    value: data,
                                                  );
                                                }).toList(),

                                                hint:Text(
                                                  "Select Section",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),

                                            )
                                          ],
                                        ),

                                      ),
                                    ],
                                  ),
                                ),

                               /* Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextField(
                                    controller: _textController,
                                    decoration: InputDecoration(
                                      hintText: 'Search ...',
                                    ),
                                    onChanged: onItemChanged,
                                  ),
                                ),*/
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
                                       child: Text(""),
                                 ),


                               ),

                              ]
                          )),

                    ]
                )
            )
        ),
        ),

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
    sfdata.selectClassSectionToSF(context, _classCode, _sectionCode);
    var rowData = this.newdataList[index];
       final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussChatBoxAdmin(rowData)),);
       // print("BACKRESULT-- "+ result);
  }

  Widget _buildRow(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      margin: EdgeInsets.all(5),
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
                                            //child: FadeInImage(image: NetworkImage(""), placeholder: AssetImage('assets/profileblank.png'),
                                            child: FadeInImage(image: NetworkImage("${colors.imageUrl}${(newdataList[index].studentPhoto) != null ? (newdataList[index].studentPhoto).replaceAll("..", "") : ""}"),
                                              placeholder: AssetImage('assets/profileblank.png'),
                                              width: 45,
                                              height: 45,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (context, url, error) => Image.asset('assets/profileblank.png',width: 45,
                                                height: 45,),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  newdataList[index].name != null
                                                      ? newdataList [index].name
                                                      : '',
                                                  style:  TextStyle(color: Colors.black,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w600),textAlign: TextAlign.left),
                                              Text(
                                                newdataList [index].fatherName != null
                                                    ? newdataList [index].fatherName
                                                    : '',
                                                style:  TextStyle(color: Colors.black54,fontSize: 10.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
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