import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/forgotpassword.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/schoolcode.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboardnew.dart';
import 'databaseschools/clientmodel.dart';
import 'databaseschools/database.dart';




class Login extends StatefulWidget {

  //const Login({required Key key}) : super(key: key);
  Login(this.ifLogin) : super();

  final int ifLogin;

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {

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
  String? _token="";
  String? _tokenSave="";

  var communicationPermit=false,academicsPermit=false,assessmentPermit=false,feesPermit=false;
  var noticePerm=false,circularPerm=false;

  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController userIDController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      schoolName=prefs.getString('SchoolName')?? "";
      displayCode=prefs.getString('DisplayCode')?? "";
      groupCode=prefs.getString('GroupCode')?? "";
      societyCode=prefs.getString('SocietyCode')?? "";
      schoolCode=prefs.getString('SchoolCode')?? "";
      branchCode=prefs.getString('BranchCode')?? "";
      String logo=prefs.getString('BranchLogo')?? "";
      if(logo != "0"){
        schoolLogo="${colors.imageUrl}${logo.replaceAll("..", '')}";
      }else{
        schoolLogo=logo;
      }
     // print("schoolName"+schoolName+"displayCode"+displayCode);
      print("schoolLogo_INIT  "+schoolLogo);

      Future<int> userIdData = sfdata.getUseId(context);
      userIdData.then((data) {
        setState(() {
          userID=data.toString();
          print("sessionID " + userID);
        });
      },onError: (e) {
        print(e);
      });

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
    if(_tokenSave=="0"){
      if(defaultTargetPlatform == TargetPlatform.iOS){
        _token = await FirebaseMessaging.instance.getAPNSToken();
        print("TOKENNNN--IOS      $_token");
      }else{
        _token = await FirebaseMessaging.instance.getToken();
        print("TOKENNNN--ANDROID      $_token");
      }
      sfdata.saveToken(context, _token!);
    }else{
      _token=_tokenSave!;
    }
    print("TOKENNNN--FINAL      $_token");
    //eSCOZmcuQ3SZc1RRHzsSqf:APA91bG_1rWRfHAP6ZWRwJK6qmDtS-znhGwQ321QwrGhzoUpOXSW7sokYzYJ-EVIO2x-4QCBLd9rFcE2mM62JFElwCs66Kfc21WnrnEqoXffUdgHXfTbjCUrkQ4LqhwKTS352l7iy2W_
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  //////////////////  User Permissions API //////////////////////
  Future<Null> menuPermissionList(BuildContext context,int relationshipID,int session,int userTypeId,int userid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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


        Navigator.of(context,rootNavigator: true).pop();

        if(userTypeId==6){
        /*  Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
      */  }else if(userTypeId==5){

        /*  Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => DashBoardParent(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
       */
        }else{
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => DashBoardNew(communicationPermit,academicsPermit,assessmentPermit,feesPermit)));
        }
        // EasyLoading.show(status: 'loading...');
        //  EasyLoading.dismiss();
      }else{
        commonAlert.showAlertDialog(context, "","You don't not have any menu permission. Please contact to Administrator","Okay");
      }
    }).catchError((error) {
      print(error);
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.showAlertDialog(context, "","You don't not have any menu permission. Please contact to Administrator","Okay");
    });
  }

  //////////////////  Login API //////////////////////
  Future<Null> loginRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var displayCode=prefs.getString('DisplayCode')?? "";
    var groupCode=prefs.getString('GroupCode')?? "";
    var societyCode=prefs.getString('SocietyCode')?? "";
    var schoolCode=prefs.getString('SchoolCode')?? "";
    var branchCode=prefs.getString('BranchCode')?? "";
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getLogin(userIDController.text.trim(),passwordController.text.trim(),displayCode,groupCode,societyCode,schoolCode,branchCode,_token,"M")
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


          int dd=await DBProvider.db.getClient(displayCode,userIDController.text.trim());
          int tableCount=await DBProvider.db.getClientAll();
          if(tableCount>0){
            DBProvider.db.updateIsActiveAll();
          }
          if(dd== 0){
            if(widget.ifLogin==1){
              Client client=new Client(id: 1, school_code: displayCode, user_id: result[0].userId.toString(), user_code: schoolCode, school_name: schoolName, user_name: result[0].userName, designation: result[0].loginAs, type: result[0].schoolAddress, relationship_id: groupCode, session_id: societyCode, fyId: branchCode, loginAs: userIDController.text.trim(), mobileNo: passwordController.text.trim(),isActive: "1");
              DBProvider.db.newClient(client);
            }

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
            if(widget.ifLogin==1){
              Navigator.of(context,rootNavigator: true).pop();
              commonAlert.messageAlertError(context,"Account already added.","Error");
            }else{

              int tableCount=await DBProvider.db.getClientAll();
              if(tableCount>0){
                DBProvider.db.updateIsActiveAll();
                DBProvider.db.updateClient(displayCode,userIDController.text.trim());
              }


          if(result[0].userTypeId==1){
            sfdata.saveMenuCommunication(context,true,true,true,true,true,true,true,true);
            sfdata.saveMenuAcademics(context,true,true,true,true,true,true,true,true,true);
            sfdata.saveModules(context,true,true,true,true);

            // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
           /* Navigator.pushReplacement(context,new MaterialPageRoute(
                builder:(context) => new DashBoardNew(true,true,true,true)));*/

          }else{
            menuPermissionList(context,result[0].relationshipId,result[0].activeAcademicYearId,result[0].userTypeId,result[0].userId);
          }

          if(userID !=result[0].userId){
            String datesave= "1980,01,20";
            sfdata.saveAttendanceUser(context, datesave, true);
          }




            }

          }

        }else{
          Navigator.of(context,rootNavigator: true).pop();
           if(result[0].state ==0){
             commonAlert.showAlertDialog(context, "Error",result[0].response,"Try again");
           }else if(result[0].state ==2){
             commonAlert.showAlertDialog(context, "Error",result[0].response,"Try again");
           }else if(result[0].state ==3){
             commonAlert.showAlertDialog(context, "Error",result[0].response,"Try again");
           }else{
             commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
           }
        }




      }else{
        Navigator.of(context,rootNavigator: true).pop();
        commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
      }
      setState(() {
      });
    }).catchError((error) {
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.showAlertDialog(context, "Error","User does not exist. Try again","Try again");
      print(error);
    });



  }

  @override
  Widget build(BuildContext context) {

    print("schoolLogo_build  "+schoolLogo);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final emailField = TextField(
      controller: userIDController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter user ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: new BorderSide(color: colors.redtheme),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
          color: colors.redtheme,
            width: 2.0,
         ),
        ),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
          color: colors.redtheme,
          width: 2.0,
         ),
         ),

        suffixIcon: IconButton(
          onPressed: (){},
          icon: Icon(Icons.person_rounded,color: colors.redtheme),
        ),

      ),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: _isObscure,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "******",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: new BorderSide(color: colors.redtheme)

          ),
        enabled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: colors.redtheme,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: colors.redtheme,
            width: 2.0,
          ),
        ),

          suffixIcon: IconButton(
              icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,color: colors.redtheme),
              onPressed: () {

                setState(() {
                  _isObscure = !_isObscure;
                });
              }),
        /*suffixIcon: IconButton(
          onPressed: (){},
          icon: Icon(Icons.remove_red_eye,color: colors.redtheme),
        ),*/

      ),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: colors.redtheme,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(userIDController.text.length == 0){
            commonAlert.showToast(context,"Enter UserId");
          }else if(passwordController.text.length == 0){
            this.commonAlert.showToast(context,"Enter Password");
          }else {
            this.commonAlert.showLoadingDialog(context, _keyLoader);
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: Builder(
         builder: (context) =>
         new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
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

                          /////// AppBar  ////////////////
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: 20.0,
                            right: 20.0,
                            child: AppBar(
                              title: Text(""),
                              leading: new IconButton(
                                //icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                                  icon: Icon(Icons.arrow_back),
                                  color: Colors.black,
                                  onPressed:() {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SchoolCode(widget.ifLogin)));
                                       // Navigator.of(context).pop();
                                  }),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.help_outlined),
                                  color: Colors.black,
                                  onPressed: () {},
                                  tooltip: 'Help',
                                ),
                              ],
                            ),
                          ),
                          new Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                                    new Container(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 100.0,
                                                      width: 180.0,
                                                      child: Image.network(schoolLogo,
                                                      errorBuilder:   (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                        return Image.asset( "assets/logo.png", fit: BoxFit.contain);
                                                      }

                                                   ),
                                                      /*FadeInImage(
                                                        image: NetworkImage(schoolLogo),
                                                        placeholder: AssetImage("assets/logo.png"),
                                                        imageErrorBuilder:
                                                            (context, error, stackTrace) {
                                                          return Image.asset(
                                                              'assets/logo.png',
                                                              fit: BoxFit.fitWidth);
                                                        },
                                                        //fit: BoxFit.fitWidth,
                                                      ),*/
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                              Text("Welcome to",
                                                  style: new TextStyle(color: colors.redtheme,fontSize: 20.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                              Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        text: schoolName==""?'':schoolName,
                                                        style: new TextStyle(color: colors.blue,fontSize: 16.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700),
                                                        /* children: <TextSpan>[
                                                           TextSpan(text: 'Allen Kids KakaDeo', style: TextStyle(color: colors.redtheme,fontSize: 15.0,fontFamily: 'Montserrat',
                                                           fontWeight: FontWeight.w700)),
                                                        ],*/
                                                      ),
                                                    ),
                                                  ]),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                              Text("Sign into your account",
                                                  style: new TextStyle(color: colors.grey,fontSize: 16.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                              Container(
                                                  child: Card(
                                                    clipBehavior: Clip.antiAlias,
                                                    semanticContainer: true,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    elevation: 5,
                                                    margin: EdgeInsets.all(20),
                                                    child: Padding(
                                                        padding: new EdgeInsets.all(20.0),
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child:Text("User ID",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),
                                                              emailField,
                                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                              Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Text("Password",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),
                                                              passwordField,  ////password
                                                              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Expanded(
                                                                      child: Padding(padding: const EdgeInsets.all(10.0),
                                                                          child:  GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.pushReplacement(
                                                                                  context, MaterialPageRoute(builder: (context) => SchoolCode(widget.ifLogin)));
                                                                            },
                                                                            child: Text("Change School Code?",
                                                                                textAlign: TextAlign.start,
                                                                                style: new TextStyle(color: colors.grey,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          )

                                                                      )
                                                                  ),

                                                                  Expanded(
                                                                      child: Padding(padding: const EdgeInsets.all(10.0),
                                                                          child:  GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.push(
                                                                                  context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                                                            },
                                                                            child: Text("Forgot your Password?",
                                                                                textAlign: TextAlign.end,
                                                                                style: new TextStyle(color: colors.grey,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          )
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                                              Container(
                                                                margin: const EdgeInsets.symmetric(horizontal: 60),
                                                                child: Material(
                                                                  elevation: 5.0,
                                                                  borderRadius: BorderRadius.circular(30.0),
                                                                  color: colors.redtheme,
                                                                  child: MaterialButton(
                                                                    minWidth: MediaQuery.of(context).size.width,
                                                                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                                    onPressed: () {
                                                                      if(userIDController.text.length == 0){
                                                                        commonAlert.showToast(context,"Enter User Id");
                                                                      }else if(passwordController.text.length == 0){
                                                                        this.commonAlert.showToast(context,"Enter Password");
                                                                      }else {
                                                                        this.commonAlert.showLoadingDialog(context,_keyLoader);
                                                                        loginRequest();

                                                                        /*if(userIDController.text == "parent"){
                                                                          sfdata.saveLoginDataToSF(context,40,"Parents",0,"PP",1,
                                                                              "",1,"",4,"",true,"","","");
                                                                          Navigator.pushReplacement(
                                                                              context, MaterialPageRoute(builder: (context) => DashBoardParent()));
                                                                        }else{

                                                                        }*/

                                                                      }
                                                                    },
                                                                    child: Text("Login",
                                                                        textAlign: TextAlign.center,
                                                                        style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                  ),
                                                                )
                                                              ),


                                                            ])


                                                    ),

                                                  )


                                              )






                                            ]
                                        ))


                                  ]
                              ))




                        ]
                    )
                )

            )
        )

        ),

    );
  }



}