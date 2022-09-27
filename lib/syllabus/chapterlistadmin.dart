import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/chapterdata.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/subjectdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:educareadmin/syllabus/chapterstatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum ConfirmAction { Cancel, Accept}

class ChapterListAdmin extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return ChapterListAdminState();
  }
}


class ChapterListAdminState extends State<ChapterListAdmin> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<ChapterData> chapterlist = <ChapterData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID,saveuseId;
  CommonAction commonAlert= CommonAction();

  List<ClassDataList> classlist = <ClassDataList>[];
  ClassDataList? selectedClassCode;
  String _classCode="0";

  List<SubjectData> subjectlist = <SubjectData>[];
  SubjectData? selectedsubjectCode;
  String _subjectCode="0";

  List<SectionDataList> sectionlist = <SectionDataList>[];
  SectionDataList? selectedsectionCode;
  String _sectionCode="0";

  //////////////////  Chapter Api //////////////////////
  Future<Null> chapterList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listChapter(_classCode,_sectionCode,_subjectCode,"10",sessionId,relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          chapterlist=result.toList();
        }else{
          this.chapterlist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
      });
      print(error);
    });
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
        });

      }else{
        this.classlist = [];
        commonAlert.messageAlertError(context,"Class not assigned for mark Attendance. Contact to administrator department","Error");
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
            _sectionCode = result[0].code;
            //print("OutputrelationshipId2 "+ classlist[0].className);
          }else{
            _sectionCode="0";
            this.sectionlist = [];
          }
          // subjectList();
        });
      }else{
        setState(() {
          _sectionCode="0";
          this.sectionlist = [];
          // subjectList();
        });

      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Subject API //////////////////////
  Future<Null> subjectList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getSubjectList("7",relationshipid,sessionid,saveuseId,fyID,_classCode,_sectionCode)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          if(result[0].code != null){
            subjectlist=result;
            selectedsubjectCode=result[0];
            _subjectCode=result[0].code;
            chapterList();
          }else{
            _subjectCode="0";
            this.subjectlist = [];
          }
          //  getStudentList();
        });
      }else{
        setState(() {
          _subjectCode="0";
          this.subjectlist = [];
        });

      }
    }).catchError((error) {
      print(error);
    });
  }


  @override
  void initState() {
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
    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
        print("empCode " + empCode);
      });
    },onError: (e) {
      print(e);
    });
    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
        print("fyID " + fyID);
        chapterList();
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
    /*for(int i=0;i<6;i++){
      ChapterData chapterData=new ChapterData(chapter: "A Letter to God",book: "General English",period: "10",topic: "Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things, ideas, or events, etc. Nouns encompass",status: _status[i]);
      chapterlist.add(chapterData);
    }*/
    classList();
    super.initState();
  }


  onRefresh() async {
    this.chapterList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }


  @override
  Widget build(BuildContext context) {
    // setState(() => context = context);
    var colors= AppColors();
    return Scaffold(
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () => onRefresh(),
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loginbottom.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),

                      ////////////   ---AppBar--- ////////////////////
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Chapter List",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                                Container(
                                  color: colors.greylight3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(padding:  new EdgeInsets.all(5.0),
                                                    child: Text("Class",textAlign: TextAlign.start,
                                                        style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
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
                                                  onChanged: (ClassDataList? data) {
                                                    setState(() {
                                                      selectedClassCode = data!;
                                                      _classCode=selectedClassCode!.classCode;
                                                      sectionList();
                                                      chapterList();

                                                    });
                                                  },
                                                  items: this.classlist.map((ClassDataList data) {
                                                    return DropdownMenuItem<ClassDataList>(
                                                      child: Text("  "+data.className,style: new TextStyle(fontSize: 12.0,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                      value: data,
                                                    );
                                                  }).toList(),

                                                  hint:Text(
                                                    "Select Class",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
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
                                                      style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
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
                                                onChanged:(SectionDataList? data) {
                                                  setState(() {
                                                    selectedsectionCode = data!;
                                                    _sectionCode=selectedsectionCode!.code;
                                                    //print(sendusertypeId);
                                                    subjectList();

                                                  });
                                                },
                                                items: this.sectionlist.map((SectionDataList data) {
                                                  return DropdownMenuItem<SectionDataList>(
                                                    child: Text("  "+data.sectionName,style: new TextStyle(fontSize: 12.0,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                    value: data,
                                                  );
                                                }).toList(),
                                                hint:Text(
                                                  "Select Section",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(padding:  new EdgeInsets.all(5.0),
                                                  child: Text("Subject",textAlign: TextAlign.start,
                                                      style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
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
                                              child: DropdownButton<SubjectData>(
                                                isExpanded: true,
                                                value: selectedsubjectCode,
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                underline: SizedBox(),
                                                /*underline: Container(
                                                                      height: 2,
                                                                      color: Colors.deepPurpleAccent,
                                                                    ),*/
                                                onChanged: (SubjectData? data) {
                                                  setState(() {
                                                    selectedsubjectCode = data!;
                                                    _subjectCode=selectedsubjectCode!.code;
                                                    chapterList();

                                                  });
                                                },
                                                items: this.subjectlist.map((SubjectData data) {
                                                  return DropdownMenuItem<SubjectData>(
                                                    child: Text("  "+data.subjectName,style: new TextStyle(fontSize: 10.0,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                    value: data,
                                                  );
                                                }).toList(),

                                                hint:Text(
                                                  "Select Subject",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),

                                            )
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),

                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child:
                                  chapterlist.isNotEmpty
                                      ? Container(
                                       child: Expanded(
                                        child: ListView.builder(
                                        itemCount: chapterlist.length,
                                        itemBuilder: _buildRow,
                                      ),
                                    ),
                                  )
                                      : isLoader == true
                                      ? Container(
                                       margin: const EdgeInsets.all(200.0),
                                        child: Center(child: CircularProgressIndicator()))
                                      : Container(
                                        margin: const EdgeInsets.all(160.0),
                                        child: Text("",style: TextStyle(color: colors.redtheme),),
                                    // )
                                  ),
                                ),

                              ]
                          )),

                    ]
                )
            )
        )
    );

  }


  _navigateAndDisplaySelection(BuildContext context, index) async {
    var rowData = this.chapterlist[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChapterStatus(rowData,_sectionCode)),
    );
    this.chapterList();
    print("BACKRESULT-- "+ result);
  }

  Widget _buildRow(BuildContext context, int index) {

    Color getMyColor(int moneyCounter) {
      if (moneyCounter == 0){
        return colors.rednotcomplete;
      }else if (moneyCounter == 1){
        return colors.listorange;
      }else{
        return colors.greennotcomplete;
      }
    }

    Color getMyColorStatus(int moneyCounter) {
      if (moneyCounter == 0){
        return colors.redtlight;
      }else if (moneyCounter == 1){
        return colors.yellow;
      }else{
        return colors.green;
      }
    }

    String getStatusName(int moneyCounter) {
      if (moneyCounter == 0){
        return "Not Started";
      }else if (moneyCounter == 1){
        return "In-Progress";
      }else{
        return "Complete";
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () => _navigateAndDisplaySelection(context,index),
        child: Container(
          color: getMyColor(chapterlist[index].status),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      color: getMyColorStatus(chapterlist[index].status),
                      width: 20.0,
                      height: 100.0,
                      child: new Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: RichText(
                              text: TextSpan(
                                text: getStatusName(chapterlist[index].status),
                                style: new TextStyle(color: colors.white,fontSize: 10.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:Padding(padding: const EdgeInsets.all(1.0),
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:<Widget>[
                                Text("${chapterlist[index].nameOfBook}", maxLines: 2, textAlign: TextAlign.center,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Text('Book',maxLines: 1,
                                    style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                /*ImageIcon(
                                  AssetImage("assets/openbook.png"),
                                  color: colors.blue,
                                  size: 18,
                                ),*/

                              ])
                      ),
                    ),

                    Container(height: 90.0, child: VerticalDivider(color: Colors.grey,)),
                    Expanded(
                      flex: 4,
                      child:Padding(padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text(chapterlist[index].chapterName != null
                                    ? chapterlist[index].chapterName!
                                    : '', maxLines: 2,
                                    style: new TextStyle(color: colors.blue,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),

                                SizedBox(height: 10.0),
                                Text('Topic',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),

                                Text(chapterlist[index].topic != null
                                    ? chapterlist[index].topic!
                                    : '--',maxLines: 2,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text("Assign Lect. - ",maxLines: 1,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                          Text("${chapterlist[index].noOfPeriod}",maxLines: 2,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("Taken Lect. - ",maxLines: 1,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                          Text("${chapterlist[index].total_TransID}",maxLines: 2,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),


                              ])
                      ),



                    ),
                    Container(
                        width: 30.0,
                        child: new Center(
                            child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist,size: 18.0), onPressed: () {

                            },)

                        )
                    ),

                  ])

            ],
          ),
        ),
      ),
    );
  }

}