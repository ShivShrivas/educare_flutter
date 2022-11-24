import 'package:educareadmin/main.dart';
import 'package:educareadmin/models/LessonPlanInnerData.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lessonPlanPdfViewerPage.dart';

class LessonPlanInnerListPage extends StatefulWidget {
  final String lessonPlanCode;
  LessonPlanInnerListPage(this.lessonPlanCode);

  @override
  State<LessonPlanInnerListPage> createState() => _LessonPlanInnerListPageState();
}

class _LessonPlanInnerListPageState extends State<LessonPlanInnerListPage> {
  SFData sfdata = SFData();
  var sessionId;
  var fyID;
  List<LessonPlanInnerDataList> lessonPlanInnerList = <LessonPlanInnerDataList>[];
  LessonPlanInnerDataList? selectLessonPlanCode = null;
  String _LessonPlanCode = "0";


  /////////Get List////////////////////////////////
  Future<Null> getLessonPlan() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid = preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;

    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getLessonPlanInnerList("3", sessionid, fyID,widget.lessonPlanCode, "2")
        .then((result) {
      if (result.isNotEmpty) {
        setState(() {
          if (result[0].ChapterName != null) {
            lessonPlanInnerList = result;

            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          } else {
            _LessonPlanCode= "0";
            this.lessonPlanInnerList = [];
          }
          //  getStudentList();
        });
      } else {
        setState(() {
          _LessonPlanCode = "0";
          this.lessonPlanInnerList = [];
        });
      }
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
    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID = data.toString();
        print("fyID " + fyID);
      });
    }, onError: (e) {
      print(e);
    });

    getLessonPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/backappbar.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Lesson Plan Content List",
            textAlign: TextAlign.center,
            style:  TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700)),
        leading:  IconButton(

            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: ListView.builder(
        itemCount: lessonPlanInnerList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    width:double.maxFinite,
                    color: MyApp.colors.redthemenew,
                    child: Text(lessonPlanInnerList[index].ChapterName
                    ,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: MyApp.colors.white,fontFamily: "fonts/Poppins-SemiBold"),),),
                  ListTile(
                     title: Text(lessonPlanInnerList[index].CategoryName ,),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPlanPdfViewerPage(lessonPlanInnerList[index].LessonPlanComponentPdf,lessonPlanInnerList[index].CategoryName)));


                    },
                  ),
                ],

              ),
            ),
          );
        },
      ),
    );
  }
}
