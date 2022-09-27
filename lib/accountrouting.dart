import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/dashboardnew.dart';
import 'package:educareadmin/main.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'databaseschools/clientmodel.dart';
import 'databaseschools/database.dart';
import 'login.dart';



enum ConfirmAction { Cancel, Accept}

class LoginRouting extends StatefulWidget {

  //const Login({required Key key}) : super(key: key);
  LoginRouting(this.schoolCode,this.loginId) : super();

  final String schoolCode;
  final String loginId;

  @override
  State<StatefulWidget> createState() {
    return LoginRoutingState();
  }
}

class LoginRoutingState extends State<LoginRouting> {

  var colors= AppColors();
  SFData sfdata= SFData();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  bool _isObscure = true;
  var schoolName;
  var displayCode;
  var groupCode;
  var societyCode;
  var schoolCode;
  var branchCode;
  var schoolLogo='';
  var profilepicUrl;
  var userID;
  var password;
  var _token;
  var _tokenSave="0";
  List<Client> accountList = <Client>[];

  var communicationPermit=false,academicsPermit=false,assessmentPermit=false,feesPermit=false;
  var noticePerm=false,circularPerm=false;

  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController userIDController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      Future<String> token = sfdata.getToken(context);
      token.then((data) {
        setState(() {
          _tokenSave=data.toString();
          _getToken();
        });
      },onError: (e) {
        print(e);
      });


    });

  }

  _getToken() async{
    print("TOKENNNN--FINAL      $_tokenSave");
    //eSCOZmcuQ3SZc1RRHzsSqf:APA91bG_1rWRfHAP6ZWRwJK6qmDtS-znhGwQ321QwrGhzoUpOXSW7sokYzYJ-EVIO2x-4QCBLd9rFcE2mM62JFElwCs66Kfc21WnrnEqoXffUdgHXfTbjCUrkQ4LqhwKTS352l7iy2W_
    accountList=await DBProvider.db.getSchoolData(widget.schoolCode,widget.loginId);
    userID=accountList[0].loginAs;
    password=accountList[0].mobileNo;
    displayCode=accountList[0].school_code;
    groupCode=accountList[0].relationship_id;
    societyCode=accountList[0].session_id;
    schoolCode=accountList[0].user_code;
    branchCode=accountList[0].fyId;

   // print("USERID      $userID ,$password");
    loginRequest();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
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
            // var parsed2 = json.decode(listModule[4].subMenu) as List<dynamic>;
            // var listSubmenuFee = parsed2.map((i) => SubmenuData.fromJson(i)).toList();
            if(result[4].subMenu[0].subMenuName=='FeeCard'){
              menuFee=result[4].subMenu[0].isActive;
            }
            sfdata.saveMenuFee(context,menuFee);
          }
          sfdata.saveModules(context,communicationPermit,academicsPermit,assessmentPermit,feesPermit);

        }

        EasyLoading.dismiss();
        DBProvider.db.updateIsActiveAll();
        DBProvider.db.updateClient(widget.schoolCode,widget.loginId);

        if(userTypeId==6){
      /*    Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
      */  }else if(userTypeId==5){
       /*   Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
       */ }else{
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => new DashBoardNew(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
        }
      }else{
        _asyncConfirmDialognew(context,"You don't not have any menu permission. Please contact to Administrator");
      }

    }).catchError((error) {
      print(error);
      EasyLoading.dismiss();
      _asyncConfirmDialognew(context,"You don't not have any menu permission. Please contact to Administrator");
    });
  }



  //////////////Logout dialog//////
  Future<Future<ConfirmAction?>> _asyncConfirmDialognew(BuildContext context,String msg) async {
    SFData sfdata= SFData();
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: const Text('Reset'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MyApp()),
                  ModalRoute.withName('/'),
                );
              },
            ),
            FlatButton(
              child: const Text('Login again'),
              onPressed: () {
                //sfdata.removeAll(context);
                sfdata.removeUserid(context);
                Navigator.of(context).pop(ConfirmAction.Accept);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Login(0)),
                  ModalRoute.withName('/'),
                );
              },
            )
          ],
        );
      },
    );
  }




  //////////////////  Login API //////////////////////
  Future<Null> loginRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getLogin(userID,password,displayCode,groupCode,societyCode,schoolCode,branchCode,_tokenSave,"M")
        .then((result) async {
      //print(result.length);
      if(result.length==1){
        if(result[0].state ==1){
          if(result[0].profilePic == null){
            profilepicUrl="no";
          }else{
            profilepicUrl=result[0].profilePic;
          }
          sfdata.saveLoginDataToSF(context,result[0].userId,result[0].userName,result[0].userTypeId,result[0].loginAs,result[0].activeAcademicYearId,
              result[0].activeAcademicYear,result[0].activeFinancialYearId,result[0].activeFinancialYear,result[0].relationshipId,result[0].lastLogin,result[0].isHo,
              profilepicUrl,result[0].mobileNo?? '',result[0].code,result[0].departmentCode,result[0].designationCode,result[0].emailId?? '',result[0].schoolAddress);

          if(result[0].userTypeId==1){
            sfdata.saveMenuCommunication(context,true,true,true,true,true,true,true,true);
            sfdata.saveMenuAcademics(context,true,true,true,true,true,true,true,true,true);
            sfdata.saveModules(context,true,true,true,true);
            // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
            Navigator.pushReplacement(context,new MaterialPageRoute(
                builder:(context) => new DashBoardNew(true,true,true,true)));
          }else{
            menuPermissionList(context,result[0].relationshipId,result[0].activeAcademicYearId,result[0].userTypeId,result[0].userId);
          }

          if(userID !=result[0].userId){
            String datesave= "1980,01,20";
            sfdata.saveAttendanceUser(context, datesave, true);
          }

        }else{
         // Navigator.of(context,rootNavigator: true).pop();
          if(result[0].state ==0){
            _asyncConfirmDialognew(context,result[0].response);
          }else if(result[0].state ==2){
            _asyncConfirmDialognew(context,result[0].response);
          }else if(result[0].state ==3){
            _asyncConfirmDialognew(context,result[0].response);
          }else{
            _asyncConfirmDialognew(context,"User does not exist. Contact to Administrator");
            //commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
          }
        }

      }else{
       // Navigator.of(context,rootNavigator: true).pop();
        //commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
        _asyncConfirmDialognew(context,"User does not exist. Contact to Administrator");
      }
      setState(() {
      });
    }).catchError((error) {
     // Navigator.of(context,rootNavigator: true).pop();
     // commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
      _asyncConfirmDialognew(context,"User does not exist. Contact to Administrator");
      print(error);
    });



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



}