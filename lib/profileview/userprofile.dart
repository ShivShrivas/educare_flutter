import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/empattendance/employeattendance.dart';
import 'package:educareadmin/models/employeedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:educareadmin/timetablemodule/timetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}



class UserProfileState extends State<UserProfile>{


  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  late String societyCode,fyID,sessionID,relationshipId;
  late String groupCode,schoolCode,branchCode,userID;
  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var colors= AppColors();
  var profilePicUrl,usernameName,loginAs,empCode,imageserverUrl;
  bool _statusMark=true,_attendanceStatus=false;
  var _attDateTime;
  final EmpData leaveData=new EmpData();




  @override
  void initState() {
    super.initState();
    getSFData();
  }

  Future<void> getSFData() async{
    Future<String?> branchCodedata = sfdata.getBranchCode(context);
    branchCodedata.then((data) {
      setState(() {
        branchCode=data.toString();
        print("branchCode " +branchCode);
      });
    },onError: (e) {
      print(e);
    });
    Future<String?> schoolCodedata = sfdata.getSchoolCode(context);
    schoolCodedata.then((data) {
      setState(() {
        schoolCode=data.toString();
        print("schoolCode " +schoolCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> groupCodedata = sfdata.getGroupCode(context);
    groupCodedata.then((data) {
      setState(() {
        groupCode=data.toString();
        print("groupCode " +groupCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> societyCodedata = sfdata.getSocietyCode(context);
    societyCodedata.then((data) {
      setState(() {
        societyCode=data.toString();
        print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIddata = sfdata.getRelationshipId(context);
    relationshipIddata.then((data) {
      // print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
        print("relationshipId2 "+ relationshipId);
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
    Future<int> session = sfdata.getSessionId(context);
    session.then((data) {
      setState(() {
        sessionID=data.toString();
        print("sessionID " + sessionID);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> userIdData = sfdata.getUseId(context);
    userIdData.then((data) {
      setState(() {
        userID=data.toString();
        print("sessionID " + sessionID);
      });
    },onError: (e) {
      print(e);
    });


    Future<String> profileData = sfdata.getProfilePic(context);
    profileData.then((data) {
      print("profileData " + data.toString());
      setState(() {
        profilePicUrl=data.replaceAll("..", "");
        imageserverUrl=profilePicUrl;
        String baseUrl=colors.imageUrl;
        profilePicUrl='$baseUrl$profilePicUrl';

        print("IMAGEURL " + profilePicUrl);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> authToken = sfdata.getUseName(context);
    authToken.then((data) {
      print("authToken " + data.toString());
      setState(() {
        usernameName=data.toString();
      });
    },onError: (e) {
      print(e);
    });

    Future<String> loginAsdata = sfdata.getloginAs(context);
    loginAsdata.then((data) {
      print("authToken " + data.toString());
      setState(() {
        loginAs=data.toString();
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

    Future<String> userAttaendance = sfdata.getAttendanceTime(context);
    userAttaendance.then((data) {
      setState(() {
        _attDateTime=data.toString();
        final split = _attDateTime.split(',');
        final Map<int, String> values = {
          for (int i = 0; i < split.length; i++)
            i: split[i]
        };
        print("_attendanceStatus " + _attDateTime);
        var one=values[0];
        var two=values[0];
        var three=values[0];
        final DateTime now = DateTime.now();
        DateTime date = new DateTime(now.year, now.month, now.day);
        final birthday = DateTime(int.parse(one!),int.parse(two!),int.parse(three!));
        final difference = date
            .difference(birthday)
            .inDays;
        if(difference == 0){
          _statusMark = false;
        }else{
          _statusMark = true;
        }
       // print("balanceDay " + difference.toString());
       // print("Date---- " + birthday.toString());
       // print("now---- " + now.toString());



      });
    },onError: (e) {
      print(e);
    });
  }

  Future<void>  _markAttendance() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);
    final api = Provider.of<ApiService>(context, listen: false);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return await api.markAttendance("2",empCode,sessionID,relationshipId,fyID,currentDate,"010010001010000",userID)
          .then((result) {
        if(result.isNotEmpty){
         // Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
          if(result.toString() == '"1"'){
             setState(() {
               final DateTime now = DateTime.now();
                 String datesave= "${now.year},${now.month},${now.day}";
               _statusMark = false;
               sfdata.saveAttendanceUser(context, datesave, true);
             });
          }else{
            _statusMark = true;
            commonAlert.messageAlertError(context,result.toString(),"Done!");
          }

        }
      }).catchError((error) {
        print("Exception");
        print(error);
      //  Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        //commonAlert.messageAlertSuccess(context,"Leave application not submitted","Error");
      });


  }



  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/backappbar.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        title: Text("".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700)),
        leading: new IconButton(
          // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed:() {
              Navigator.pop(context, 'Yep!');
              // Navigator.of(context).pop();
            }),
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:Builder(
        builder: (context) =>
        GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                    child: Stack(
                        children: <Widget>[
                          Image.asset("assets/profileback.png",
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                                new Container(
                                  //color: Colors.redAccent,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                           // height: 200.0,
                                            child:Column(children: [
                                             //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                              SizedBox(
                                                  height: 130.0,
                                                  width: 130.0,
                                                child: Hero(
                                                    tag: 'image',
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    radius: 100,
                                                    child: CircleAvatar(
                                                        backgroundImage: AssetImage('assets/profileblank.png'),
                                                        foregroundImage: NetworkImage(imageserverUrl == "no" ? "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png":profilePicUrl),
                                                       /*onBackgroundImageError: (exception, stackTrace) {
                                                          setState(() {
                                                             this.profilePicUrl = null;
                                                             print("IMAGE EXP");
                                                          });
                                                        },*/
                                                        radius: 70,
                                                        backgroundColor: Colors.white), //'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'
                                                  )
                                            ),
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                              Text(usernameName != null ? usernameName:"",
                                                  style: new TextStyle(color: colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                              Text(loginAs != null ? loginAs:"",
                                                  style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                            ],)

                                          ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                        Container(
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            border: Border.all(color: Colors.grey)
                                         ),
                                           margin: EdgeInsets.all(15),
                                           child: Column(
                                             //mainAxisAlignment: MainAxisAlignment.center,
                                               children:<Widget>[
                                                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                                 Container(
                                                     child:Row(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                       children: [
                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                               Navigator.push(
                                                                   context, MaterialPageRoute(builder: (context) => EmployeeAttendance()));
                                                               print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/calendar.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("My Attendance",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),
                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),

                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                                Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => TimeTableAdmin(leaveData)));
                                                                // print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/clock.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("My Time Table",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),
                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),
                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                               /* Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => Notices()));*/
                                                               print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/location.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("Transport",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),

                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),


                                                       ],
                                                     )
                                                 ),

                                                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                                 Container(
                                                     child:Row(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                       children: [
                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                               /* Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => Notices()));*/
                                                               print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/medal.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("My Achievement",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),
                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),
                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                               /* Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => Notices()));*/
                                                               print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/mail.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("Message",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),
                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),

                                                         Expanded(
                                                           child: GestureDetector(
                                                             onTap: () {
                                                               /* Navigator.push(
                                                        context, MaterialPageRoute(builder: (context) => Notices()));*/
                                                               print("Notice");
                                                             },
                                                             child:Container(
                                                                 child: Padding(
                                                                     padding: new EdgeInsets.all(11.0),
                                                                     child: Column(
                                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                                         children: <Widget>[
                                                                           SizedBox(
                                                                             height: 50.0,
                                                                             child: Image.asset( "assets/money.png",
                                                                               fit: BoxFit.contain,
                                                                             ),
                                                                           ),
                                                                           SizedBox(height: 11.0),
                                                                           Text("Finance",
                                                                               textAlign: TextAlign.center,
                                                                               style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                   fontWeight: FontWeight.w700)),

                                                                         ])
                                                                 )
                                                             ),
                                                           ),
                                                         ),

                                                       ],
                                                     )
                                                 ),

                                               ])
                                             ),

                                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                                          Container(
                                            child:Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("----------- Mark Daily Attendance ------------",
                                                          textAlign: TextAlign.center,
                                                          style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                Visibility(
                                                  visible: _statusMark == true ? true : false,
                                                  child: Column(
                                                    children: [
                                                      Text("Long Press for mark Attendance",
                                                          textAlign: TextAlign.center,
                                                          style: new TextStyle(color: colors.redtheme,fontSize: 10.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                      GestureDetector(
                                                        onLongPress: _markAttendance,
                                                        child: Image.asset('assets/fingprint.gif', gaplessPlayback: false, width: 300.0, height: 250.0),
                                                      ),
                                                  ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _statusMark == false ? true : false,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                       // _statusMark=true;
                                                      });
                                                      /* Navigator.push(
                                                        context, MaterialPageRoute(builder: (context) => Notices()));*/
                                                     // print("_statusMark");
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Image.asset('assets/done.gif', gaplessPlayback: false, width: 100.0, height: 150.0),
                                                        Text("Thanks! Today Attendance Marked",
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(color: colors.metirialgreen,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ],
                                                    ),


                                                  ),
                                                ),

                                                /*SizedBox(
                                                  height: 300.0,
                                                  child: GifImage(
                                                    controller: controller,
                                                    image: AssetImage("assets/fingprint.gif",
                                                    ),
                                                    //fetchGif(AssetImage("images/animate.gif"));
                                                  ),
                                                ),*/





                                                /*Image.asset(
                                                  "images/fingprint.gif",
                                                  height: 125.0,
                                                  width: 125.0,
                                                )*/



                                              ],
                                            ),



                                          ),


                                        ]
                                    ))


                              ]
                              )
                          // )
                          // ),





                        ]
                    )
                )







            )

        ),
      ),
    );


  }




}