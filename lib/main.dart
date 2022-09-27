import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'conts/colors.dart';
import 'conts/common.dart';
import 'conts/local_notification_service.dart';
import 'dashboardnew.dart';
import 'network/api_service.dart';
import 'schoolcode.dart';
import 'storedata/sfdata.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // print(message.data.toString());
  // print(message.notification.title);
  print('Handlingabackgroundmessage ${message.messageId}');
}
void main() {
  //runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(
    Phoenix(
      child: MyApp(),
    ),

  );
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  static const colors= AppColors();

 // const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
      create: (context) => ApiService.create(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: colors.redtheme,
          accentColor: colors.redtheme,
          accentColorBrightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHome(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<MyHome> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  CommonAction commonAlert= CommonAction();
  SFData sfdata= SFData();
  var communicationPermit=false,academicsPermit=false,assessmentPermit=false,feesPermit=false;
  var noticePerm=false,circularPerm=false;
  late String _token;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> myAsyncStuff() async {
    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        _incrementCounter();
        final routeFromMessage = message.data["title"];
        Navigator.of(context).pushNamed(routeFromMessage);
        LocalNotificationService.display(message);
        print("getInitialMessage-     ${message}");

      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        _incrementCounter();
        print(message.notification?.body);
        print(message.notification?.title);
        print("forground-     ${message.notification?.title}");
        // print("MESSAGE_onMessage-     ${message.data["message"]}");

      }
      LocalNotificationService.display(message);

    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["data"];
      _incrementCounter();
      // Navigator.of(context).pushNamed(routeFromMessage);
      // LocalNotificationService.display(message);
      // print("background_OpenedApp-     ${message.notification?.title}");


    });


  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('counter', 1);
    print("UpdateNotification-    ");
    MyApp();
    /*Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyApp()));*/

  }

  /*_saveNotification(){
    print("UpdateNotification-    ");
    if (mounted) setState(() {
      sfdata.saveNotification(context, 1);
    });
  }*/


  @override
  void initState() {
    super.initState();
    // sfdata.saveNotification(context, 0);
    myAsyncStuff();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userTypeId=prefs.getInt('UserTypeId')?? 0;
    var sessionId=prefs.getInt('ActiveAcademicYearId')?? 0;
    var relationshipId=prefs.getInt('RelationshipId')?? 0;

    Future<int> authToken = sfdata.getUseId(context);
    authToken.then((data) {
      print("authToken " + data.toString());
      setState(() {
        if(data == 0){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SchoolCode(0)));
        }else{
          if(userTypeId==1){
            sfdata.saveMenuCommunication(context,true,true,true,true,true,true,true,true);
            sfdata.saveMenuAcademics(context,true,true,true,true,true,true,true,true,true);
            sfdata.saveModules(context,true,true,true,true);
            //Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop(); NEW

            Navigator.pushReplacement(context,new MaterialPageRoute(
                builder:(context) => DashBoardNew(true,true,true,true)));

          }else{
            menuPermissionList(context,relationshipId,sessionId,userTypeId,data);
          }
        }

      });
    },onError: (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SchoolCode(0)));
      print(e);
    });
  }



  //////////////////  User Permissions API //////////////////////
  Future<Null> menuPermissionList(BuildContext context,int relationshipID,int session,int userTypeId,int userid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    ///isLoader = true;
    var menuNotice;
    var menuCircular;
    var menuDiary;
    var menuNotification;
    var menuThoughts,menuComplaints,menuFeedback,menuDiscussion;
    var menuTimeTable,menuAssignment,menuHomeWork,menuLessonPlan,menuFee;
    var menuSyllabus,menuAttendance,menuLeave,menuLeaveApprova,menuODApprova;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listmenupermission("7",relationshipID,session,userid)
        .then((result) {
      EasyLoading.dismiss();
      if(result.isNotEmpty) {
        //var jsondata=jsonEncode(result);
        // print(jsondata);
        // final body = json.decode(result) as List;

        if(userTypeId==4){
          // var parsed = json.decode(result) as List<dynamic>;
          //var listModule = parsed.map((i) => PermissionData.fromJson(i)).toList();
          if(result[0].menu =="Communication"){
            communicationPermit=result[0].isActive;
            // var parsed2 = json.decode(result[0].subMenu) as List<dynamic>;
            // var listSubmenu = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            // print("MENU NAME-  "+listSubmenu[0].subMenuName);
            if(result[0].subMenu[0].subMenuName=='Notice'){
              menuNotice=result[0].subMenu[0].isActive;
            }
            if(result[0].subMenu[1].subMenuName=='Circular'){
              menuCircular=result[0].subMenu[1].isActive;
            }
            if(result[0].subMenu[2].subMenuName=='Diary'){
              menuDiary=result[0].subMenu[2].isActive;
            }
            if(result[0].subMenu[3].subMenuName=='Notification'){
              menuNotification=result[0].subMenu[3].isActive;
            }
            if(result[0].subMenu[4].subMenuName=='Thoughts'){
              menuThoughts=result[0].subMenu[4].isActive;
            }

            if(result[0].subMenu[5].subMenuName=='Complaints'){
              menuComplaints=result[0].subMenu[5].isActive;
            }
            if(result[0].subMenu[6].subMenuName=='Feedback'){
              menuFeedback=result[0].subMenu[6].isActive;
            }
            if(result[0].subMenu[7].subMenuName=='Discussion'){
              menuDiscussion=result[0].subMenu[7].isActive;
            }

            sfdata.saveMenuCommunication(context,menuNotice,menuCircular,menuDiary,menuNotification,menuThoughts,menuComplaints,menuFeedback,menuDiscussion);

            //noticePerm=listSubmenu[0].isAdd;
          }

          if(result[1].menu =="Academics"){
            academicsPermit=result[1].isActive;
            // var parsed2 = json.decode(listModule[1].subMenu) as List<dynamic>;
            // var listSubmenuAcd = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            if(result[1].subMenu[0].subMenuName=='TimeTable'){
              menuTimeTable=result[1].subMenu[0].isActive;
            }
            if(result[1].subMenu[1].subMenuName=='Assignment'){
              menuAssignment=result[1].subMenu[1].isActive;
            }
            if(result[1].subMenu[2].subMenuName=='HomeWork'){
              menuHomeWork=result[1].subMenu[2].isActive;
            }
            if(result[1].subMenu[3].subMenuName=='LessonPlan'){
              menuLessonPlan=result[1].subMenu[3].isActive;
            }
            if(result[1].subMenu[4].subMenuName=='Syllabus'){
              menuSyllabus=result[1].subMenu[4].isActive;
            }
            if(result[1].subMenu[7].subMenuName=='Attendance'){
              menuAttendance=result[1].subMenu[7].isActive;
            }
            if(result[1].subMenu[8].subMenuName=='Leave'){
              menuLeave=result[1].subMenu[8].isActive;
            }
            if(result[1].subMenu[9].subMenuName=='Leave Approval'){
              menuLeaveApprova=result[1].subMenu[9].isActive;
            }
            if(result[1].subMenu[10].subMenuName=='OD Approval'){
              menuODApprova=result[1].subMenu[10].isActive;
            }

            sfdata.saveMenuAcademics(context,menuTimeTable,menuAssignment,menuHomeWork,menuLessonPlan,menuSyllabus,menuAttendance,menuLeave,menuLeaveApprova,menuODApprova);
          }


          if(result[2].menu =="Assessment"){
            assessmentPermit=result[2].isActive;
            // var parsed2 = json.decode(listModule[2].subMenu) as List<dynamic>;
            // var listSubmenu = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
          }
          sfdata.saveModules(context,communicationPermit,academicsPermit,assessmentPermit,true);

        }else{

          if(result[0].menu =="Communication"){
            communicationPermit=result[0].isActive;
            // var parsed2 = json.decode(result[0].subMenu) as List<dynamic>;
            // var listSubmenu = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            // print("MENU NAME-  "+listSubmenu[0].subMenuName);
            if(result[0].subMenu[0].subMenuName=='Notice'){
              menuNotice=result[0].subMenu[0].isActive;
            }
            if(result[0].subMenu[1].subMenuName=='Circular'){
              menuCircular=result[0].subMenu[1].isActive;
            }
            if(result[0].subMenu[2].subMenuName=='Diary'){
              menuDiary=result[0].subMenu[2].isActive;
            }
            if(result[0].subMenu[3].subMenuName=='Notification'){
              menuNotification=result[0].subMenu[3].isActive;
            }
            if(result[0].subMenu[4].subMenuName=='Thoughts'){
              menuThoughts=result[0].subMenu[4].isActive;
            }
            if(result[0].subMenu[5].subMenuName=='Complaints'){
              menuComplaints=result[0].subMenu[5].isActive;
            }
            if(result[0].subMenu[6].subMenuName=='Feedback'){
              menuFeedback=result[0].subMenu[6].isActive;
            }
            if(result[0].subMenu[7].subMenuName=='Discussion'){
              menuDiscussion=result[0].subMenu[7].isActive;
            }

            sfdata.saveMenuCommunication(context,menuNotice,menuCircular,menuDiary,menuNotification,menuThoughts,menuComplaints,menuFeedback,menuDiscussion);

            //noticePerm=listSubmenu[0].isAdd;
          }

          if(result[1].menu =="Academics"){
            academicsPermit=result[1].isActive;
            // var parsed2 = json.decode(listModule[1].subMenu) as List<dynamic>;
            // var listSubmenuAcd = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            if(result[1].subMenu[0].subMenuName=='TimeTable'){
              menuTimeTable=result[1].subMenu[0].isActive;
            }
            if(result[1].subMenu[1].subMenuName=='Assignment'){
              menuAssignment=result[1].subMenu[1].isActive;
            }
            if(result[1].subMenu[2].subMenuName=='HomeWork'){
              menuHomeWork=result[1].subMenu[2].isActive;
            }
            if(result[1].subMenu[3].subMenuName=='LessonPlan'){
              menuLessonPlan=result[1].subMenu[3].isActive;
            }
            if(result[1].subMenu[4].subMenuName=='Syllabus'){
              menuSyllabus=result[1].subMenu[4].isActive;
            }
            if(result[1].subMenu[7].subMenuName=='Attendance'){
              menuAttendance=result[1].subMenu[7].isActive;
            }
            if(result[1].subMenu[8].subMenuName=='Leave'){
              menuLeave=result[1].subMenu[8].isActive;
            }
            if(result[1].subMenu[9].subMenuName=='Leave Approval'){
              menuLeaveApprova=result[1].subMenu[9].isActive;
            }
            if(result[1].subMenu[10].subMenuName=='OD Approval'){
              menuODApprova=result[1].subMenu[10].isActive;
            }

            sfdata.saveMenuAcademics(context,menuTimeTable,menuAssignment,menuHomeWork,menuLessonPlan,menuSyllabus,menuAttendance,menuLeave,menuLeaveApprova,menuODApprova);

          }


          if(result[2].menu =="Assessment"){
            assessmentPermit=result[2].isActive;
            // var parsed2 = json.decode(listModule[2].subMenu) as List<dynamic>;
            // var listSubmenu = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
          }

          if(result[4].menu =="Fee"){
            feesPermit=result[4].isActive;
            //  var parsed2 = json.decode(listModule[4].subMenu) as List<dynamic>;
            // var listSubmenuFee = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            if(result[4].subMenu[0].subMenuName=='FeeCard'){
              menuFee=result[4].subMenu[0].isActive;
            }
            sfdata.saveMenuFee(context,menuFee);
          }
          sfdata.saveModules(context,communicationPermit,academicsPermit,assessmentPermit,feesPermit);

        }

        EasyLoading.dismiss();

        if(userTypeId==6){
       /*  Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
       */ }else if(userTypeId==5){
        /*  Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
       */ }else{
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new DashBoardNew(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
        }
        //EasyLoading.show(status: 'loading...');
        //EasyLoading.dismiss();
      }else{
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SchoolCode(0)));
      }
    }).catchError((error) {
      print(error);
      EasyLoading.dismiss();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SchoolCode(0)));
    });
  }


}