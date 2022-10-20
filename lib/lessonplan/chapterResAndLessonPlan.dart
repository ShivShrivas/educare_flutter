import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/AcademicSession.dart';
import 'package:educareadmin/models/AcademicSession.dart';
import 'package:educareadmin/models/AcademicSession.dart';
import 'package:educareadmin/models/SubjectList.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/subjectdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterResAndLessonPlan extends StatefulWidget {
  const ChapterResAndLessonPlan({Key? key}) : super(key: key);

  @override
  State<ChapterResAndLessonPlan> createState() =>
      _ChapterResAndLessonPlanState();
}

class _ChapterResAndLessonPlanState extends State<ChapterResAndLessonPlan> {
  SFData sfdata = SFData();
  var sessionId;
  var relationshipId;
  var classCode;
  final RefreshController _refreshController = RefreshController();
  var empCode, fyID, saveuseId;
  CommonAction commonAlert = CommonAction();

  List<ClassDataList> classlist = <ClassDataList>[];
  ClassDataList? selectedClassCode;
  String _classCode = "0";

  List<AcademicSessionDataList> academicSessionList =
      <AcademicSessionDataList>[];
  AcademicSessionDataList? selectedAcademicSessionCode = null;
  String _academicSessionListCode = "0";

  List<SubjectDataList> subjectList = <SubjectDataList>[];
  SubjectDataList? selectSubjectCode = null;
  String _subjectCode = "0";

  //////////////////  Subject API //////////////////////
  Future<Null> getSubjectList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getSubjectListClassWise(
            "1", relationshipid, sessionid, saveuseId, fyID, _classCode)
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].subjectCode != null) {
            subjectList = result;

            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _subjectCode = "0";
            this.subjectList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _subjectCode = "0";
          this.subjectList = [];
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Class API //////////////////////
  Future<Null> AcademicSessionList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getAcademicSessionList("6", relationshipid, sessionid, saveuseId, fyID)
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          academicSessionList = result;
        });
      } else {
        this.academicSessionList = [];
        commonAlert.messageAlertError(
            context,
            "Class not assigned for mark Attendance. Contact to administrator department",
            "Error");
      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Class API //////////////////////
  Future<Null> classList() async {
    classlist=<ClassDataList>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    print(
        "$relationshipid,sessionid $sessionid,saveuseId $saveuseId,fyID $fyID");
    return await api
        .getClassListEmployeeWise(
            "9", relationshipid, sessionid, saveuseId, fyID)
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          classlist = result;
        });
      } else {
        this.classlist = [];
        commonAlert.messageAlertError(
            context,
            "Class not assigned for mark Attendance. Contact to administrator department",
            "Error");
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
        sessionId = data;
      });
    }, onError: (e) {
      print(e);
    });
    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
      print("relationshipId " + data.toString());
      setState(() {
        relationshipId = data.toString();
      });
    }, onError: (e) {
      print(e);
    });
    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode = data.toString();
        print("empCode " + empCode);
      });
    }, onError: (e) {
      print(e);
    });
    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID = data.toString();
        print("fyID " + fyID);
      });
    }, onError: (e) {
      print(e);
    });

    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      print("useIdData " + data.toString());
      setState(() {
        saveuseId = data.toString();
      });
    }, onError: (e) {
      print(e);
    });
    /*for(int i=0;i<6;i++){
      ChapterData chapterData=new ChapterData(chapter: "A Letter to God",book: "General English",period: "10",topic: "Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things, ideas, or events, etc. Nouns encompass",status: _status[i]);
      chapterlist.add(chapterData);
    }*/

    AcademicSessionList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colors = AppColors();
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
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
                left: 10.0,
                right: 10.0,
                child: AppBar(
                  title: Text("Chapter Resource and Lesson Plan View",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700)),
                  leading: new IconButton(
                      // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              Container(
                child: Column(
                  children: [
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
                                  Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: Text("Academic Session",
                                        textAlign: TextAlign.start,
                                        style: new TextStyle(
                                            color: colors.black,
                                            fontSize: 12.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              Container(
                                height: 45.0,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: colors.greylight,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<AcademicSessionDataList>(
                                  isExpanded: true,
                                  value: selectedAcademicSessionCode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  underline: SizedBox(),
                                  onChanged: (AcademicSessionDataList? data) {
                                    setState(() {
                                      selectedAcademicSessionCode = data!;
                                      _academicSessionListCode =
                                          selectedAcademicSessionCode!
                                              .sessionName;
                                      classlist.clear();
                                      classList();
                                    });
                                  },
                                  items: this
                                      .academicSessionList
                                      .map((AcademicSessionDataList data) {
                                    return DropdownMenuItem<
                                        AcademicSessionDataList>(
                                      child: Text("  " + data.sessionName,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                      value: data,
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Select Acedamic Session",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(5.0),
                                      child: Text("Class",
                                          textAlign: TextAlign.start,
                                          style: new TextStyle(
                                              color: colors.black,
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                new Container(
                                  height: 45.0,
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: colors.greylight,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButton<ClassDataList>(
                                    isExpanded: true,
                                    value: selectedClassCode,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    underline: SizedBox(),
                                    onChanged: (ClassDataList? data) {

                                        setState(() {
                                          selectedClassCode = data!;
                                          _classCode = selectedClassCode!.classCode;
                                          subjectList.clear();
                                          getSubjectList();
                                        });


                                    },
                                    items: this
                                        .classlist
                                        .map((ClassDataList data) {
                                      return DropdownMenuItem<ClassDataList>(
                                        child: Text("  " + data.className,
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                        value: data,
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Select Class",
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
                        ],
                      ),
                    ),
                    Container(
                      color: colors.greylight3,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: Text("Subject",
                                        textAlign: TextAlign.start,
                                        style: new TextStyle(
                                            color: colors.black,
                                            fontSize: 12.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              new Container(
                                height: 45.0,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: colors.greylight,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<SubjectDataList>(
                                  isExpanded: true,
                                  value: selectSubjectCode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  underline: SizedBox(),
                                  onChanged: (SubjectDataList? data) {
                                    setState(() {
                                      selectSubjectCode = data!;
                                      _subjectCode =
                                          selectSubjectCode!.subjectCode;
                                    });
                                  },
                                  items: this
                                      .subjectList
                                      .map((SubjectDataList data) {
                                    return DropdownMenuItem<SubjectDataList>(
                                      child: Text("  " + data.subjectName,
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                      value: data,
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Select Subject",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          )),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(5.0),
                                      child: Text("Book",
                                          textAlign: TextAlign.start,
                                          style: new TextStyle(
                                              color: colors.black,
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                new Container(
                                  height: 45.0,
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: colors.greylight,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButton<SubjectDataList>(
                                    isExpanded: true,
                                    value: selectSubjectCode,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    underline: SizedBox(),
                                    onChanged: (SubjectDataList? data) {
                                      setState(() {
                                        selectSubjectCode = data!;
                                        _subjectCode =
                                            selectSubjectCode!.subjectCode;
                                      });
                                    },
                                    items: this
                                        .subjectList
                                        .map((SubjectDataList data) {
                                      return DropdownMenuItem<SubjectDataList>(
                                        child: Text("  " + data.subjectName,
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                        value: data,
                                      );
                                    }).toList(),
                                    hint: Text(
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
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: colors.greylight3,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: Text("Chapter",
                                        textAlign: TextAlign.start,
                                        style: new TextStyle(
                                            color: colors.black,
                                            fontSize: 12.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              new Container(
                                height: 45.0,
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: colors.greylight,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                              )
                            ],
                          )),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: new EdgeInsets.all(5.0),
                                      child: Text("ViewType",
                                          textAlign: TextAlign.start,
                                          style: new TextStyle(
                                              color: colors.black,
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                new Container(
                                  height: 45.0,
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: colors.greylight,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
