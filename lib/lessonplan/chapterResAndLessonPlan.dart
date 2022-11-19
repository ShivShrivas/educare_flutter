import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/lessonplan/lessonplaninnerlistpage.dart';
import 'package:educareadmin/main.dart';
import 'package:educareadmin/models/AcademicSession.dart';
import 'package:educareadmin/models/BookDataList.dart';
import 'package:educareadmin/models/ChapterListBookWise.dart';
import 'package:educareadmin/models/LessonPlan.dart';
import 'package:educareadmin/models/ResourcesTypeView.dart';
import 'package:educareadmin/models/SubjectList.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lessonPlanPdfViewerPage.dart';
import 'openfileinwebview.dart';

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
  var listTitle = "";
  var viewTypeValue = "";
  final RefreshController _refreshController = RefreshController();
  var empCode, fyID, saveuseId;
  CommonAction commonAlert = CommonAction();

  List<ClassDataList> classlist = <ClassDataList>[];
  ClassDataList? selectedClassCode;
  String _classCode="0";

  List<AcademicSessionDataList> academicSessionList =
      <AcademicSessionDataList>[];
  AcademicSessionDataList? selectedAcademicSessionCode = null;
  String _academicSessionListCode = "0";

  List<SubjectDataList> subjectList = <SubjectDataList>[];
  SubjectDataList? selectSubjectCode = null;
  String _subjectCode = "0";

  List<BookList> bookList = <BookList>[];
  BookList? selectBookCode = null;
  String _bookCode = "0";

  List<ChapterListBookWise> chapterList = <ChapterListBookWise>[];
  ChapterListBookWise? selectChapterCode = null;
  String _chapterCode = "0";

  List<String> listOfViewType = <String>["Resource", "Lesson Plan"];
  String dropdownvalue = 'Resource';

  List<ResourcesTypeViewList> resourceTypeList = <ResourcesTypeViewList>[];
  ResourcesTypeViewList? selectResourceCode = null;
  String _resouceCode = "0";


  List<LessonPlanList> lessonPlanList = <LessonPlanList>[];
  LessonPlanList? selectLessonPlanCode = null;
  String _LessonPlanCode = "0";



  /////////Get Reaource////////////////////////////////
  Future<Null> getLessonPlan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;

    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getLessonPlanView("2", _classCode, _subjectCode, sessionid, fyID, _bookCode,
            _chapterCode, "2")
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].ChapterName != null) {
            lessonPlanList = result;
            selectLessonPlanCode= result[0];
            _LessonPlanCode= result[0].Code;
            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _LessonPlanCode= "0";
            this.lessonPlanList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _LessonPlanCode = "0";
          this.lessonPlanList = [];
        });
      }
    });
  }


  /////////Get Reaource////////////////////////////////
  Future<Null> getResources() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;

    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getResourceTypeView("1", _classCode, _subjectCode, sessionid, fyID, _bookCode,
            _chapterCode, "1")
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].FileName != null) {
            resourceTypeList = result;
            selectResourceCode= result[0];
            _resouceCode = result[0].ResourceCategoryCode;
            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _resouceCode = "0";
            this.resourceTypeList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _resouceCode = "0";
          this.resourceTypeList = [];
        });
      }
    });
  }

  //////////////////  Chapter API //////////////////////
  Future<Null> getChapterList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getChapterListBookWise("3", sessionid, fyID, _bookCode)
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].ChapterName != null) {
            chapterList = result;
            selectChapterCode= result[0];
            _chapterCode = result[0].Code;
            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _chapterCode = "0";
            this.chapterList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _chapterCode = "0";
          this.chapterList = [];
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Book API //////////////////////
  Future<Null> getBookList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getBookListClassWise("2", relationshipid, sessionid, saveuseId, fyID,
            _classCode, _subjectCode)
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].bookName != null) {
            bookList = result;
            selectBookCode= result[0];
            _bookCode = result[0].bookCode;
            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _bookCode = "0";
            this.bookList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _bookCode = "0";
          this.bookList = [];
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

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
            selectSubjectCode= result[0];
            _subjectCode = result[0].subjectCode;
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
          selectedAcademicSessionCode= result[0];
          _academicSessionListCode = result[0].sessionId.toString();
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
    classlist = <ClassDataList>[];
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
          selectedClassCode= result[0];
          _classCode = result[0].classCode;
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
                decoration: const BoxDecoration(
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
                  title: const Text("Chapter Resource and Lesson Plan View",
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                      color: colors.transparentmy,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Academic Session",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
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
                                    color: colors.greylight3,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<AcademicSessionDataList>(
                                  isExpanded: true,
                                  value: selectedAcademicSessionCode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
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
                                  hint: const Text(
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
                                          style: TextStyle(
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
                                      color: colors.greylight3,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButton<ClassDataList>(
                                    isExpanded: true,
                                    value: selectedClassCode,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    underline: SizedBox(),
                                    onChanged: (ClassDataList? data) {
                                      setState(() {
                                        selectedClassCode = data!;
                                        _classCode =
                                            selectedClassCode!.classCode;
                                        subjectList.clear();
                                        getSubjectList();
                                      });
                                    },
                                    items: classlist
                                        .map((ClassDataList data) {
                                      return DropdownMenuItem<ClassDataList>(
                                        child: Text("  " + data.className,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                        value: data,
                                      );
                                    }).toList(),
                                    hint: const Text(
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
                      color: colors.transparentmy,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Subject",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
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
                                    color: colors.greylight3,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<SubjectDataList>(
                                  isExpanded: true,
                                  value: selectSubjectCode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  underline: SizedBox(),
                                  onChanged: (SubjectDataList? data) {
                                    setState(() {
                                      selectSubjectCode = data!;
                                      _subjectCode =
                                          selectSubjectCode!.subjectCode;
                                      getBookList();
                                    });
                                  },
                                  items: subjectList
                                      .map((SubjectDataList data) {
                                    return DropdownMenuItem<SubjectDataList>(
                                      child: Text("  " + data.subjectName,
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                      value: data,
                                    );
                                  }).toList(),
                                  hint: const Text(
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
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Book",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
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
                                      color: colors.greylight3,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButton<BookList>(
                                    isExpanded: true,
                                    value: selectBookCode,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    underline: SizedBox(),
                                    onChanged: (BookList? data) {
                                      setState(() {
                                        selectBookCode = data!;
                                        _bookCode = selectBookCode!.bookCode;
                                        getChapterList();
                                      });
                                    },
                                    items: this.bookList.map((BookList data) {
                                      return DropdownMenuItem<BookList>(
                                        child: Text("  " + data.bookName,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                        value: data,
                                      );
                                    }).toList(),
                                    hint: const Text(
                                      "Select Book",
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
                      color: colors.transparentmy,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Chapter",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
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
                                    color: colors.greylight3,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<ChapterListBookWise>(
                                  isExpanded: true,
                                  value: selectChapterCode,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  underline: SizedBox(),
                                  onChanged: (ChapterListBookWise? data) {
                                    setState(() {
                                      selectChapterCode = data!;
                                      _chapterCode = selectChapterCode!.Code;
                                    });
                                  },
                                  items: chapterList
                                      .map((ChapterListBookWise data) {
                                    return DropdownMenuItem<
                                        ChapterListBookWise>(
                                      child: Text("  " + data.ChapterName,
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                      value: data,
                                    );
                                  }).toList(),
                                  hint: const Text(
                                    "Select Chapter",
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
                                      child: Text("View Type",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
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
                                      color: colors.greylight3,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButton<String>(
                                    value: dropdownvalue,
                                    isExpanded: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    underline: SizedBox(),
                                    onChanged: (data) {
                                      if(_classCode=="0" || _academicSessionListCode=="0" ||_subjectCode=="0" || _bookCode=="0"|| _chapterCode=="0"){
                                        commonAlert.showAlertDialog(context, "Alert", "Please Select All Privious Fields", "Ok");


                                      }else{
                                        if (data == "Resource") {
                                          setState(() {
                                            lessonPlanList.clear();
                                            getResources();
                                            dropdownvalue=data!;
                                            listTitle = "Resources List";
                                          });
                                        } else {
                                          setState(() {

                                            resourceTypeList.clear();
                                            listTitle = "Lesson Plan List";
                                            dropdownvalue=data!;
                                            getLessonPlan();
                                          });
                                        }
                                      }

                                    },
                                    items: <String>['Resource', 'Lesson Plan']
                                        .map((String data) {
                                      return DropdownMenuItem<String>(
                                        child: Text(data,
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                        value: data,
                                      );
                                    }).toList(),
                                    hint: const Text(
                                      "Select View Type",
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text("$listTitle",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700)),
                    Expanded(
                      child: Container(
                        height: double.maxFinite,
                        child: _lessonAndPlanList(lessonPlanList,resourceTypeList),
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
  _lessonAndPlanList(List<LessonPlanList> lessonPlanTypeList,List<ResourcesTypeViewList> resourceTypeList) {
    if(resourceTypeList.isEmpty){
      return ListView.builder(
        itemCount: lessonPlanTypeList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            child: ListTile(
              leading: Container(
                  height: double.infinity,
                  child: Icon(
                    Icons.cloud_circle_rounded,
                    size: 18,
                  )),
              trailing: Icon(Icons.arrow_right),
              title: Text("${lessonPlanTypeList[index].ChapterName} (Period- ${lessonPlanTypeList[index].PeriodCode})",style: TextStyle(color: Colors.red,fontWeight:FontWeight.bold)),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPlanInnerListPage(lessonPlanTypeList[index].Code)));
               // Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPlanPdfViewerPage("https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")));


              },
            ),
          );
        },
      );
    }else{
      return ListView.builder(
        itemCount: resourceTypeList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 4,
          shadowColor: Colors.grey,
            child: ListTile(
              leading: Container(
                  height: double.infinity,
                  child: const Icon(
                    Icons.cloud_circle_rounded,
                    size: 18,
                  )),
              trailing: Icon(Icons.arrow_right),
              title: Text(resourceTypeList[index].FileName,style: TextStyle(color: Colors.red,fontWeight:FontWeight.bold),),
              subtitle: Text(resourceTypeList[index].ResourceCategoryName),
              onTap: () {
                // _launchInBrowser(resourceTyspeList[index].FilePath.toString());
                if((resourceTypeList[index].FilePath).endsWith(".pdf")){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPlanPdfViewerPage(MyApp.colors.imageUrl+resourceTypeList[index].FilePath,resourceTypeList[index].FileName)));

                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OpenWebView(MyApp.colors.imageUrl+resourceTypeList[index].FilePath,resourceTypeList[index].FileName)));
                }

              },
            ),
          );
        },
      );
    }

  }
  _resourceList(List<ResourcesTypeViewList> resourceTypeList) {
    return ListView.builder(
      itemCount: resourceTypeList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          child: ListTile(
            leading: Container(
                height: double.infinity,
                child: const Icon(
                  Icons.cloud_circle_rounded,
                  size: 18,
                )),
            trailing: Icon(Icons.arrow_right),
            title: Text(resourceTypeList[index].FileName),
            subtitle: Text(resourceTypeList[index].ResourceCategoryName),
            onTap: () {
              _launchInBrowser(resourceTypeList[index].FilePath.toString());
            },
          ),
        );
      },
    );
  }

  Future<void> _launchInBrowser(String url) async {
    url = MyApp.colors.imageUrl + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
