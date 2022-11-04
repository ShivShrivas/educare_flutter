import 'package:educareadmin/models/LessonPlanInnerData.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonPlanInnerListPage extends StatefulWidget {
  const LessonPlanInnerListPage({Key? key}) : super(key: key);

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
        .getLessonPlanInnerList("3", "2", "2","AB20000001", "2")
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
          return Card(
            elevation: 3,
            child: ListTile(
              leading: Container(
                  height: double.infinity,
                  child: const Icon(
                    Icons.cloud_circle_rounded,
                    size: 18,
                  )),
              title: Text(lessonPlanInnerList[index].TextContent),
              subtitle: Text(lessonPlanInnerList[index].ChapterName
              ),
              onTap: () {
                // _launchInBrowser(resourceTypeList[index].FilePath.toString());

              },
            ),
          );
        },
      ),
    );
  }
}
