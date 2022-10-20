import 'dart:async';
import 'package:badges/badges.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/lessonplan/chapterResAndLessonPlan.dart';
import 'package:educareadmin/login.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accountrouting.dart';
import 'assignment/assignmentlist.dart';
import 'circular/circularlist.dart';
import 'complainsbox/complainadmin.dart';
import 'complainsbox/discussionboxadmin.dart';
import 'createnotices/notice.dart';
import 'diary/diarylist.dart';
import 'homework/homeworklist.dart';
import 'leavemanagment/leaveapprovals.dart';
import 'leavemanagment/leavestatus.dart';
import 'notifications.dart';
import 'parentmodule/thoughts.dart';
import 'profileview/userprofile.dart';
import 'studentattenmodule/attendancemenu.dart';
import 'syllabus/chapterlistadmin.dart';
import 'timetablemodule/classtimetable.dart';
import 'databaseschools/clientmodel.dart';
import 'databaseschools/database.dart';


enum ConfirmAction { Cancel, Accept}


enum Mode {
  defaultTheme,
  customTheme,
  advancedTheme,
}

/*class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}*/

class DashBoardNew extends StatefulWidget {
  static const routeName = '/passArguments';
  DashBoardNew(
    this.comm,
    this.acadmincs,
    this.assessment,
    this.fee,
  );

  final bool comm;
  final bool acadmincs;
  final bool assessment;
  final bool fee;


  /*@override
  DashBoardNewState createState() => DashBoardNewState(
    mode: mode,
  );*/
  @override
  State<StatefulWidget> createState() {
    return DashBoardNewState();
  }
}



class DashBoardNewState extends State<DashBoardNew>  with WidgetsBindingObserver{


  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var colors= AppColors();
  int _curr=0;
  SFData sfdata= SFData();
  var usernameName,loginAs;
  var sessionID;
  var userID;
  int isNotifyTrue=0;
  List<NoticeData> noticelist = <NoticeData>[];
  bool isLoader = false;
  var relationshipId,profilePicUrl,imageServerdata=null;
  var bottomNotification=0;
  var modulesCommStatus=false;
  var modulesAcademicsStatus=false;
  var modulesAssessmentStatus=false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Intro intro;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

  List<Client> accountList = <Client>[];

  var page1 = Pages();

  void _introLayout() {

    print("start the intro");

    intro = Intro(
      stepCount: 2,
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Hello, I\'m Flutter Intro.',
          'I can help you quickly implement the Step By Step guide in the Flutter project.',
          'My usage is also very simple, you can quickly learn and use it through example and api documentation.',
          'In order to quickly implement the guidance, I also provide a set of out-of-the-box themes, I wish you all a happy use, goodbye!',
        ],
        buttonTextBuilder: (currPage, totalPage) {
          return currPage < totalPage - 1 ? 'Next' : 'Finish';
        },
      ),
    );

    Container(
      key: intro.keys[0],
    );
    Text(
      'need focus widget',
      key: intro.keys[1],
    );

    intro.start(context);

  }



  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
    // Colors.red,
    // Colors.amber,
    //Colors.brown,
    //Colors.yellow,
    //Colors.blue,
  ];
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 400.0;

  /*List<Widget> _list=<Widget>[
    new Center(child:new Pages(text: "Page 1",)),
   // new Center(child:new Pages2(text: "Page 2",)),
   // new Center(child:new Pages3(text: "Page 3",)),
   // new Center(child:new Pages(text: "Page 4",))
  ];*/

  late List<Widget> _list= <Widget>[];



  final List<Widget> introWidgetsList = <Widget>[
    new Center(child:new PagesMessage(text: "Page 1",)),
    new Center(child:new PagesMessage2(text: "Page 1",)),
    new Center(child:new PagesMessage3(text: "Page 1",)),
    new Center(child:new PagesMessage4(text: "Page 1",)),
  ];




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state)async {
    if (state == AppLifecycleState.resumed) {
      print("RESUME");
    //_asyncConfirmDialogRestart(context);
      final SharedPreferences prefs = await _prefs;
      setState(() {
        isNotifyTrue= prefs.getInt('counter') ?? 0;
        print("NOTIFICATION $isNotifyTrue");
      });
    }
  }

  Future<void> getSFData() async{
    Future<bool> modulesComm = sfdata.getModulesCommStatus(context);
    modulesComm.then((data) {
      print("profileDataComm " + data.toString());
      setState(() {
        modulesCommStatus=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<bool> modulesAcademics= sfdata.getModulesAcademicsStatus(context);
    modulesAcademics.then((data) {
      print("Academics " + data.toString());
      setState(() {
        modulesAcademicsStatus=data;

      });
    },onError: (e) {
      print(e);
    });

    Future<bool> modulesAssessment= sfdata.getModulesAssessmentStatus(context);
    modulesAssessment.then((data) {
      print("Assessment " + data.toString());
      setState(() {
        modulesAssessmentStatus=data;
      });
     // print("AssessmentNEWSETUP_UBNDER" + modulesAssessmentStatus.toString()+" --  "+_list.length.toString());
    },onError: (e) {
      print(e);
    });


    Future<int> userIdData = sfdata.getUseId(context);
    userIdData.then((data) {
      setState(() {
        userID=data.toString();
      });
    },onError: (e) {
      print(e);
    });

    Future<String> authToken = sfdata.getUseName(context);
    authToken.then((data) {
     // print("authToken " + data.toString());
      setState(() {
        usernameName=data.toString();
      });
    },onError: (e) {
      print(e);
    });
    Future<String> loginAsdata = sfdata.getloginAs(context);
    loginAsdata.then((data) {
      //print("authToken " + data.toString());
      setState(() {
        loginAs=data.toString();
      });
    },onError: (e) {
      print(e);
    });

    Future<int> sessionIdData = sfdata.getSessionId(context);
    sessionIdData.then((data) {
      print("authToken " + data.toString());
      setState(() {
        sessionID=data;
       // print("SESSION"+sessionID.toString());
        this.sessionMinMax(context,sessionID);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
     // print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data;
        noticesList(context,relationshipId,sessionID);

      });
    },onError: (e) {
      print(e);
    });

    Future<String> profileData = sfdata.getProfilePic(context);
    profileData.then((data) {
      print("profileData " + data.toString());
      setState(() {
        imageServerdata=data.replaceAll("..", "");
        String baseUrl=colors.imageUrl;
        profilePicUrl='$baseUrl$imageServerdata';
       // print("IMAGEURL " + imageServerdata);
      });
    },onError: (e) {
      print(e);
    });

    final SharedPreferences prefs = await _prefs;
    setState(() {
      isNotifyTrue= prefs.getInt('counter') ?? 0;
     // print("NOTIFICATION $isNotifyTrue");
    });

    Future<int> noti = sfdata.getIsNotification(context);
    noti.then((data) {
      setState(() {
       // isNotifyTrue=data;
       // print("NOTIFICATION $isNotifyTrue");
        /*if(isNotifyTrue==1){
          final result = Navigator.push(
            context, MaterialPageRoute(builder: (context) => Notifications()),
          );
          sfdata.saveNotification(context, 0);
          setState(() {
            Future<int> noti = sfdata.getIsNotification(context);
            noti.then((data) {
              setState(() {
                isNotifyTrue=data;
                print("NOTIFICATION $isNotifyTrue");
              });
            },onError: (e) {
              print(e);
            });
          });
        }*/

      });
    },onError: (e) {
      print(e);
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) => _animateSlider());
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    print("TITLE-- " + widget.comm.toString());
    if(widget.comm==true){
        _list.add(new Center(child:new Pages(text: "false",)));
    }
    if(widget.acadmincs==true){
      _list.add(new Center(child:new Pages2(text: "false",)));
    }
    if(widget.acadmincs==true){
      //_list.add(new Center(child:new Pages3(text: "false",)));
    }
     //_list.add(new Center(child:new Pages(text: "false",)));
    // _list.add(new Center(child:new Pages2(text: "false",)));
    getSFData();



    /*for(int i=0;i<10;i++){
      EmpleaveData chapterData=new EmpleaveData(dateData: "27/12/2021",abbrTypeIdFirst: "Remarks given by teacher Remarks given by teacher Remarks given by teacher",firstIsApproved: "In-Progress",abbrTypeIdSecond: "",secondIsApproved: "",leaveTypeName: "",secondLeaveTypeName: "");
      statusDropdownList.add(chapterData);
    }*/



    super.initState();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }
  route() async {
  }


  //////////////////  Notices API //////////////////////
  Future<Null> noticesList(BuildContext context,int relationshipID,int session) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listNotice("4",relationshipID,session)
        .then((result) {
      //print(result.length);
      isLoader = false;
      if(result.isNotEmpty){
        noticelist=result.toList();
        if(noticelist.length>5){
          bottomNotification=5;
        }else{
          bottomNotification=noticelist.length;
        }
        print(noticelist[0].transId);
      }else{
        this.noticelist=[];
       // _list.add(new Center(child:new Pages2(text: "Page 2",)));
      }
      setState(() {
      });
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Session MinMax Date API //////////////////////
  Future<Null> sessionMinMax(BuildContext context,int sessionId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .sessionMinMax("9",sessionId)
        .then((result) {
      sfdata.saveMinMAxDateToSF(context,result[0].fromDate,result[0].toDate);
      setState(() {
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _animateSlider() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      int? nextPage = _pageController.page?.round();
      nextPage=nextPage!+1;
      if (nextPage == bottomNotification) {
        nextPage = 0;
      }
      if(nextPage > 0){
        _pageController
            .animateToPage(nextPage, duration: Duration(seconds: 1), curve: Curves.linear)
            .then((_) => _animateSlider());
      }else{
        _pageController.jumpToPage(nextPage);//.then((_) => _animateSlider());
        _animateSlider();
      }

    });
  }

  displayBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(20)
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: AnimatedContainer(
             // curve: Curves.fastOutSlowIn,
              duration: Duration(seconds: 10),
             // child: new Center(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                    Padding(
                     padding:EdgeInsets.all(15),
                     child:Text(accountList.length==0?"":'Switch Accounts',style: new TextStyle(color: colors.blue,fontSize: 18.0,fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700))
                   ),
                    MediaQuery.removePadding(
                     context: context,
                     removeTop: true,
                     child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:accountList.length,
                          itemBuilder: _buildAccountRow
                      ),
                   ),

                      Container(
                          margin: const EdgeInsets.symmetric(vertical:50,horizontal: 80),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: colors.redtheme,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () async {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => Login(1)),
                                  ModalRoute.withName('/'),
                                );
                              },

                              child: Text("Add Account  +".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          )
                      ),

                    ],
                  ),
                ),


             //),
            ),
          );
        });
  }

  onClickAccount(int index) {
    if(userID.toString()==accountList[index].user_id){
      commonAlert.messageAlertError(context,"Selected Account already active.","Account Active");
    }else{
      ///  Comment //////
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginRouting(accountList[index].school_code,accountList[index].loginAs)),
        ModalRoute.withName('/'),
      );

    }
  }

  Widget _buildAccountRow(BuildContext context, int index) {
    var colors= AppColors();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      margin: EdgeInsets.all(5),
      child: InkWell(
          onTap: () => onClickAccount(index),
          child: Padding(
            padding:EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          //child: FadeInImage(image: NetworkImage(""), placeholder: AssetImage('assets/profileblank.png'),
                          child: FadeInImage(image: NetworkImage("https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png"),
                            placeholder: AssetImage('assets/profileblank.png'),
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, url, error) => Image.asset('assets/profileblank.png',width: 45,
                              height: 45,),
                          ),
                        ),

                      ],
                    ),
                ),
                Container(height: 40.0, child: VerticalDivider(color: Colors.grey,)),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child:Text("${accountList[index].user_name} (${accountList[index].designation})",textAlign: TextAlign.left,
                                style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                          ),

                          Visibility(
                              visible: accountList[index].isActive=="1"?true:false,
                              child: Expanded(
                                flex: 1,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      color: colors.greenactive,
                                      child:Padding(
                                        padding:EdgeInsets.fromLTRB(4, 1, 4, 1),
                                        child:Text("ACTIVE",textAlign: TextAlign.left,
                                            style: new TextStyle(color: colors.green,fontSize: 9.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:Text("${accountList[index].school_name}",textAlign: TextAlign.left,
                                style: new TextStyle(color: colors.grey,fontSize: 11.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Expanded(
                            child:Text("${accountList[index].type}",textAlign: TextAlign.left,
                                style: new TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Container(
                    width: 35.0,
                    child: new Center(
                        child: IconButton(icon: Icon(Icons.delete_forever,color: colors.redtheme,size: 25.0), onPressed: () {
                          if(userID.toString()==accountList[index].user_id){
                            commonAlert.messageAlertError(context,"This Account already Login.Switch account and try again.","Error");
                          }else{
                            _accountDeleteDialog(context,accountList[index].school_code,accountList[index].loginAs);
                          }

                        },)
                    )
                ),

              ],
            ),
          )

      ),
    );
  }

  //////////////Delete Account dialog//////
  Future<Future<ConfirmAction?>> _accountDeleteDialog(BuildContext context, String schoolCode,String userId) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete account'),
          content: const Text(
              'Do you really want to delete account?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Yes',style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(context);
                DBProvider.db.deleteClient(schoolCode,userId);
                Navigator.of(context).pop(ConfirmAction.Accept);
                accountList=await DBProvider.db.getAllClients();
               // displayBottomSheet(context);
                /*setState((){
                });*/
                displayBottomSheet(_keyLoader.currentContext!);

              },
            )
          ],
        );
      },
    );
  }




  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      isNotifyTrue= prefs.getInt('counter') ?? 0;
    });
  }

  Widget _notificationBadge() {
    return Badge(
        badgeColor: isNotifyTrue==1?Colors.lightBlueAccent:colors.redthemenew,
        position: BadgePosition.topEnd(top: 0, end: 16),
       // animationDuration: Duration(milliseconds: 100),
        //animationType: BadgeAnimationType.slide,
        elevation: isNotifyTrue==1?5.0:0.0,
        badgeContent:Text("",
          style: TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(icon: Icon(Icons.notifications_on_outlined), onPressed: () {
            _navigateAndDisplaySelection(context);
          }),
        )
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    ///  Comment //////
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notifications()),
    );
    if(result =='Yep'){
      _incrementCounter();
    }

    //print(result);
  }



  Widget _logoutBadge() {
    return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(icon: Icon(Icons.power_settings_new), onPressed: () async {
         _asyncConfirmDialognew(context);
         }
      )
    );
  }

  Widget _complainBadge() {
    return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(icon: Icon(Icons.messenger_outline), onPressed: () {

        }
        )
    );
  }

  /* _buildPageViewMenu() {
    return Column(
      mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        PageView(
          children: _list,
          scrollDirection: Axis.horizontal,
          //controller: _pageController,
          onPageChanged: (num){
            setState(() {
              _curr=num;
            });
          },

        ),
      ]
      //height: MediaQuery.of(context).size.height,

    );
  }*/
  _buildPageViewMenu() {
    return Container(
        height: 390.0,
        // height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: PageView(
                  children: _list,
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  //controller: _pageController,
                  onPageChanged: (num){
                    setState(() {
                     // _curr=num;
                    });
                  },

                ),
              )

            ])

    );
  }

  onTapdetails(index) {
    ///  Comment //////
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Notices(),
      ),
    );

  }

  Color selectedColour(int position) {
    Color c;
    if (position % 2 == 0){
      c = colors.reddark;
    }else{
      c = colors.lightgreen;
    }
    return c;
  }

  Color selectedColourback(int position) {
    Color c;
    if (position % 2 == 0){
      c = Colors.red;
    }else{
      c = Colors.green;
    }
    return c;
  }

  Widget _buildRowNotices(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => onTapdetails(index),
        child:Container(
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        color: selectedColour(index),
                        width: 30.0,
                        height: 115.0,
                        child: new Center(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: RichText(
                                text: TextSpan(
                                  text: noticelist[index].noticeBy!= null
                                      ? noticelist[index].noticeBy.toUpperCase()
                                      : '',
                                  style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                        )
                    ),
                  ),

                  Expanded(
                      flex: 11,
                      child: Container(
                          height: 115.0,
                          padding: new EdgeInsets.all(5.0),
                          color:  selectedColourback(index),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(noticelist[index].noticeHeadline.toUpperCase() != null
                                    ? noticelist[index].noticeHeadline.toUpperCase()
                                    : '',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                //SizedBox(height: 5.0),
                                Text(noticelist[index].description != null
                                    ? noticelist[index].description
                                    : '',
                                    maxLines: 2,
                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 20.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Time: "+noticelist[index].time,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),

                                      Expanded(
                                        child: Text("Date: "+noticelist[index].date,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )

                                    ])

                              ])


                      )
                  ),

                ])


        ),
      ),
    );
  }


  _buildPageViewMessage() {
    return Container(
      height: 135.0,
      child: PageView.builder(
          itemCount: bottomNotification,
          controller: _pageController,
          itemBuilder: _buildRowNotices,
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: CirclePageIndicator(
          selectedDotColor: colors.redtheme,
          dotColor: colors.lightgrey,
          itemCount: bottomNotification,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }



  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }
  double screenWidth(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) / dividedBy;
  }


  _drawerMenus(){
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Text(usernameName != null ? usernameName : "",textAlign: TextAlign.center,style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                   fontWeight: FontWeight.w700)),
                             ]
                  ),

                  accountEmail: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                            child: Padding(padding: const EdgeInsets.all(0.0),
                                child:  GestureDetector(
                                  onTap: () {

                                  },
                                  child: Text(loginAs !=null ? loginAs:"",
                                      textAlign: TextAlign.start,
                                      style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                )
                            )
                        ),
                        Expanded(
                            child: Padding(padding: const EdgeInsets.all(10.0),
                                child:  GestureDetector(
                                  onTap: () async {
                                    print("CLICK");
                                    Navigator.of(context).pop();
                                    accountList=await DBProvider.db.getAllClients();
                                    displayBottomSheet(context);
                                  },
                                  child: Text("All Accounts",
                                      textAlign: TextAlign.end,
                                      style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                )
                            )
                        ),
                      ]),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 110,
                    child: CircleAvatar(
                        backgroundImage: AssetImage('assets/profileblank.png'),
                        foregroundImage: NetworkImage(imageServerdata == "no" ? "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png" : profilePicUrl),
                        onBackgroundImageError: (exception, stackTrace) {
                          setState(() {
                            this.profilePicUrl = "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260";
                          });
                          // return AssetImage('assets/profileblank.png');
                        },
                        radius: 50,
                        backgroundColor: Colors.white),
                  )
                /*otherAccountsPictures: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text('+'),
                       // backgroundImage: AssetImage('assets/profile.png'),
                      ),

                    ],*/
              ),
              ListTile(
                leading:Icon(Icons.house_rounded),
                title: Text("Home"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading:Icon(Icons.notifications),
                title: Text("Notification"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                onTap: () async {
                  ///  Comment //////
                  Navigator.of(context).pop();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );

                },
              ),


              /*Divider(),
              ListTile(
                leading:Icon(Icons.image),
                title: Text("Gallery"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading:Icon(Icons.settings),
                title: Text("Settings"),
                trailing: Icon(Icons.keyboard_arrow_right_sharp),
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),*/


            ],
          ),

        ),

        Container(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text('Ver - 1.0',style: TextStyle(color: colors.redtheme),),


          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
           key: _keyLoader,
           drawer: Drawer(
             child: _drawerMenus(),
           ),
           appBar: AppBar(
             flexibleSpace: Image(
               image: AssetImage('assets/backappbar.png'),
               fit: BoxFit.cover,
             ),
             backgroundColor: Colors.transparent,
             elevation: 0,
             actions: <Widget>[
               //_complainBadge(),
               _logoutBadge(),
               _notificationBadge(),
             ],
           ),
           body: SingleChildScrollView(
               child: Stack(
                   children: <Widget>[
                     Container(
                       height: MediaQuery.of(context).size.height,
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: ExactAssetImage(
                               'assets/dashboardbacknew.png'
                           ),
                           fit: BoxFit.fill,
                         ),
                       ),
                     ),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                         Container(
                             height: 170.0,
                             child: Column(
                                 children: <Widget>[
                                   GestureDetector(
                                     onTap: () {
                                       ///  Comment //////

                                       Navigator.of(context).push(
                                         PageRouteBuilder(
                                           transitionDuration: Duration(milliseconds: 500),
                                           pageBuilder: (
                                               BuildContext context,
                                               Animation<double> animation,
                                               Animation<double> secondaryAnimation) {
                                               return UserProfile();
                                             },
                                            transitionsBuilder: (
                                               BuildContext context,
                                               Animation<double> animation,
                                               Animation<double> secondaryAnimation,
                                               Widget child) {
                                             return Align(
                                               child: FadeTransition(
                                                 opacity: animation,
                                                 child: child,
                                               ),
                                             );
                                           },
                                         ),
                                       );
                                       // print("Notice");
                                     },
                                     child: SizedBox(
                                       height: 90.0,
                                       width: 90.0,
                                       child: Hero(
                                           tag: 'image',
                                           child: CircleAvatar(
                                             backgroundColor: Colors.white,
                                             radius: 80,
                                             child: CircleAvatar(
                                                 backgroundImage: AssetImage('assets/profileblank.png'),
                                                 foregroundImage: NetworkImage(imageServerdata == "no" ? "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png" : profilePicUrl),
                                                 onBackgroundImageError: (exception, stackTrace) {
                                                   setState(() {
                                                      this.profilePicUrl = "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260";
                                                   });
                                                 },
                                                 radius: 50,
                                                 backgroundColor: Colors.white), //'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'
                                           )
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 2.0),
                                   GestureDetector(
                                     onTap: () {
                                       ///  Comment //////
                                       ///
                                       Navigator.of(context).push(
                                         PageRouteBuilder(
                                           transitionDuration: Duration(milliseconds: 500),
                                           pageBuilder: (
                                               BuildContext context,
                                               Animation<double> animation,
                                               Animation<double> secondaryAnimation) {
                                               return UserProfile();
                                           },
                                           transitionsBuilder: (
                                               BuildContext context,
                                               Animation<double> animation,
                                               Animation<double> secondaryAnimation,
                                               Widget child) {
                                               return Align(
                                                 child: FadeTransition(
                                                   opacity: animation,
                                                   child: child,
                                               ),
                                             );
                                           },
                                         ),
                                       );
                                     },

                                       child: Text("View Profile",
                                           style: new TextStyle(color: colors.bluelight,fontSize: 10.0,fontFamily: 'Montserrat',
                                               fontWeight: FontWeight.w700))
                                     ),

                                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                   Text(usernameName != null ? usernameName:"",
                                       style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                           fontWeight: FontWeight.w700)),
                                   Text(loginAs != null ? loginAs:"",
                                       style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                           fontWeight: FontWeight.w700)),
                                   /* Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.double_arrow ),
                                        )*/

                                 ])
                         ),
                         Container(
                           height: 400.0,
                           child: _buildPageViewMenu(),
                         ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                         Container(
                             height: 200.0,
                             child: Column(
                                 children: <Widget>[
                                   Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: <Widget>[
                                         new Container(
                                           width: 80.0,
                                           // margin: const EdgeInsets.all(5.0),
                                           // padding: const EdgeInsets.all(0.0),
                                           child: Text("Notice",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                               fontWeight: FontWeight.w700)),
                                         )
                                       ]),
                                   _buildPageViewMessage(),
                                   _buildCircleIndicator()
                                 ])
                         ),


                       ],
                     )

                   ])
           )
       );



  }




}

noticePermission() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var noticePermit=prefs.getBool('notice')?? true;
  return noticePermit;
}

class Pages extends StatefulWidget {
  late Intro intro;
  late final text;
  Pages({this.text});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PagesState();
  }


}
class PagesState extends State<Pages> {

  bool shouldPop = true;
  SFData sfdata= SFData();
  var colors= AppColors();
  var noticePermit=false;
  var circularPermit=false,discussionPermit=false;
  var diaryPermit=false,complaintsPermit=false;
  var notifyPermit=false;
  var thoughtsPermit=false;
  late DateTime currentBackPressTime;


  ColorFilter greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  _navigateAndDisplayNotice(BuildContext context) async {
    ///  Comment //////
    ///
    /*final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notices()),
    );*/
    //noticesList(context,relationshipId,sessionID);
  }

  @override
  void initState() {
    super.initState();
     Future<bool> userIdData = sfdata.getNoticePerMit(context);
     userIdData.then((data) {
      setState(() {
      noticePermit=data;
      print('NOTICE_DATA----  $noticePermit');
       });
    },onError: (e) {
    });

    Future<bool> circular = sfdata.getCircularPerMit(context);
    circular.then((data) {
      setState(() {
        circularPermit=data;
        print('NOTICE_DATA----  $circularPermit');
      });
    },onError: (e) {
    });

    Future<bool> diary = sfdata.getDiaryPerMit(context);
    diary.then((data) {
      setState(() {
        diaryPermit=data;
        print('NOTICE_DATA----  $diaryPermit');
      });
    },onError: (e) {
    });

    Future<bool> notify = sfdata.getNotificationPerMit(context);
    notify.then((data) {
      setState(() {
        notifyPermit=data;
        print('NOTICE_DATA----  $notifyPermit');
      });
    },onError: (e) {
    });

    Future<bool> thoughts = sfdata.getThoughtsPerMit(context);
    thoughts.then((data) {
      setState(() {
        thoughtsPermit=data;
        print('NOTICE_DATA----  $thoughtsPermit');
      });
    },onError: (e) {
    });

    Future<bool> complaints = sfdata.getComplaintsPerMit(context);
    complaints.then((data) {
      setState(() {
        complaintsPermit=data;
        print('NOTICE_DATA----  $thoughtsPermit');
      });
    },onError: (e) {
    });

    Future<bool> discussion = sfdata.getDiscussionPerMit(context);
    discussion.then((data) {
      setState(() {
        discussionPermit=data;
        print('NOTICE_DATA----  $thoughtsPermit');
      });
    },onError: (e) {
    });

  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
     // Fluttertoast.showToast(msg: "Do you want to Exit.");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: onWillPop,
            child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey)
                        ),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: new Container(
                               // margin: const EdgeInsets.only(top: -0.1, right: 10.0, left: 10),
                                //padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                                width: 150.0,
                                // margin: const EdgeInsets.all(5.0),
                               // padding: const EdgeInsets.all(0.0),
                                decoration: BoxDecoration(
                                    color:colors.greylight ,
                                    borderRadius: BorderRadius.circular(0.0),
                                    border: Border.all(color: Colors.grey)

                                ),
                                child: Text("Communication",textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                              )
                            //child: Text('Deliver features faster', textAlign: TextAlign.center),
                          ),

                        ]),*/

                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                              Container(
                                  child: Center(
                                    child:  Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          ///////////////FIRST /////////////////////
                                          Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      _navigateAndDisplayNotice(context);
                                                    },
                                                    child:Container(
                                                        child: Card(
                                                          clipBehavior: Clip.antiAlias,
                                                          semanticContainer: true,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(7.0),
                                                          ),
                                                          elevation: 5,
                                                          margin: EdgeInsets.all(10),
                                                          child:/*ColorFiltered(
                                                              colorFilter: noticePermit ? ColorFilter.mode(
                                                                Colors.transparent,
                                                                BlendMode.saturation,
                                                              ) : ColorFilter.mode(
                                                                  Colors.white,
                                                                  BlendMode.saturation,
                                                              ),*/
                                                          Padding(
                                                                  padding: new EdgeInsets.all(11.0),
                                                                  child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height: 42.0,
                                                                          child: Image.asset( "assets/notice.png",
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 15.0),
                                                                        Text("Notice",
                                                                            style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700)),
                                                                      ])
                                                              )
                                                         // ),
                                                        )
                                                    ),
                                                    // ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      ///  Comment //////
                                                      if(circularPermit==true){
                                                        Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => Circulars()));
                                                        //print("Circular");
                                                      }
                                                    },
                                                    child: Container(
                                                        child: Card(
                                                            clipBehavior: Clip.antiAlias,
                                                            semanticContainer: true,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            elevation: 5,
                                                            margin: EdgeInsets.all(10),
                                                            /*child:ColorFiltered(
                                                              colorFilter: circularPermit ? ColorFilter.mode(
                                                                Colors.transparent,
                                                                BlendMode.saturation,
                                                              ) : ColorFilter.mode(
                                                                Colors.white,
                                                                BlendMode.saturation,
                                                              ),*/
                                                             child: Padding(
                                                                padding: new EdgeInsets.all(11.0),
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      SizedBox(
                                                                        height: 42.0,
                                                                        child: Image.asset( "assets/verified.png",
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 15.0),
                                                                      Text("Circular",
                                                                          style: new TextStyle(color: colors.pink,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                     ]),
                                                             ),
                                                          //),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      ///  Comment //////
                                                      if(diaryPermit==true){
                                                        Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Diary()));
                                                      }

                                                      print("DIARY");
                                                    },
                                                    child: Container(
                                                        child: Card(
                                                            clipBehavior: Clip.antiAlias,
                                                            semanticContainer: true,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            elevation: 5,
                                                            margin: EdgeInsets.all(10),

                                                            /*child:ColorFiltered(
                                                              colorFilter: diaryPermit ? ColorFilter.mode(
                                                                Colors.transparent,
                                                                BlendMode.saturation,
                                                               ) : ColorFilter.mode(
                                                                Colors.white,
                                                                BlendMode.saturation,
                                                               ),
*/
                                                             child: Padding(
                                                                padding: new EdgeInsets.all(11.0),
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      SizedBox(
                                                                        height: 42.0,
                                                                        child: Image.asset("assets/digitaldiary.png",
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 15.0),
                                                                      Text("Diary",
                                                                          style: new TextStyle(color: colors.red,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                      ])
                                                               )
                                                           //),
                                                        )
                                                     ),
                                                  ),
                                                )
                                              ]),

                                          ///////////////SECOND/////////////////////
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ///  Comment //////
                                                        if(thoughtsPermit==true){
                                                          Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => Thoughts()));
                                                        }

                                                      },
                                                      child:Visibility(
                                                        visible: true,
                                                        child: Container(
                                                            child: Card(
                                                                clipBehavior: Clip.antiAlias,
                                                                semanticContainer: true,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                ),
                                                                elevation: 5,
                                                                margin: EdgeInsets.all(10),
                                                                child:ColorFiltered(
                                                                    colorFilter: thoughtsPermit ? ColorFilter.mode(
                                                                      Colors.transparent,
                                                                      BlendMode.saturation,
                                                                    ) : ColorFilter.mode(
                                                                      Colors.white,
                                                                      BlendMode.saturation,
                                                                    ),
                                                                    child: Padding(
                                                                        padding: new EdgeInsets.all(15.0),
                                                                        child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                height: 40.0,
                                                                                child: Image.asset("assets/thoughts.png",
                                                                                  fit: BoxFit.contain,
                                                                                  color: colors.metirialgreen,
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                                              Text("Thoughts",
                                                                                  style: new TextStyle(color: colors.lightgreen,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                      fontWeight: FontWeight.w700)),

                                                                            ])
                                                                    )
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                    )

                                                ),

                                                Expanded(
                                                  child: Visibility(
                                                    maintainSize: true,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: true,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ///  Comment //////
                                                        if(complaintsPermit==true){
                                                          Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => ComplainAdmin()));
                                                         // print("Complain");
                                                        }

                                                      },
                                                      child: Container(
                                                          child: Card(
                                                              clipBehavior: Clip.antiAlias,
                                                              semanticContainer: true,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              elevation: 5,
                                                              margin: EdgeInsets.all(10),
                                                              child:ColorFiltered(
                                                                  colorFilter: complaintsPermit ? ColorFilter.mode(
                                                                    Colors.transparent,
                                                                    BlendMode.saturation,
                                                                  ) : ColorFilter.mode(
                                                                    Colors.white,
                                                                    BlendMode.saturation,
                                                                  ),
                                                                  child: Padding(
                                                                      padding: new EdgeInsets.all(11.0),
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Badge(
                                                                              showBadge: false,
                                                                              // badgeColor: Colors.green,
                                                                              position: BadgePosition.topStart(start: 45.0,top: 0.0),
                                                                              animationDuration: Duration(milliseconds: 300),
                                                                              animationType: BadgeAnimationType.slide,
                                                                              badgeContent: Text("0",
                                                                                style: TextStyle(color: Colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                              child: SizedBox(
                                                                                height: 42.0,
                                                                                child: Image.asset( "assets/complainbox.png",
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 15.0),
                                                                            Text("Complain",
                                                                                textAlign: TextAlign.center,
                                                                                style: new TextStyle(color: colors.orange,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),

                                                                          ])
                                                                  )
                                                              )

                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      ///  Comment //////
                                                      if(discussionPermit==true){
                                                        Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => DiscussBoxAdmin()));
                                                      }
                                                    },
                                                    child: Container(
                                                        child: Card(
                                                            clipBehavior: Clip.antiAlias,
                                                            semanticContainer: true,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            elevation: 5,
                                                            margin: EdgeInsets.all(10),
                                                            child:ColorFiltered(
                                                                colorFilter: discussionPermit ? ColorFilter.mode(
                                                                  Colors.transparent,
                                                                  BlendMode.saturation,
                                                                ) : ColorFilter.mode(
                                                                  Colors.white,
                                                                  BlendMode.saturation,
                                                                ),
                                                                child: Padding(
                                                                    padding: new EdgeInsets.all(11.0),
                                                                    child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          SizedBox(
                                                                            height: 42.0,
                                                                            child: Image.asset( "assets/discussion.png",
                                                                              color: colors.purpals,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 15.0),
                                                                          Text("Discussion",
                                                                              textAlign: TextAlign.center,
                                                                              style: new TextStyle(color: colors.purpals,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                  fontWeight: FontWeight.w700)),

                                                                        ])
                                                                )
                                                            )

                                                        )
                                                    ),
                                                  ),
                                                ),

                                              ]),

                                          ///////////////THIRD/////////////////////
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      ///  Comment //////
                                                      if(notifyPermit==true){
                                                        final result = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => Notifications()),
                                                        );

                                                      }

                                                    },

                                                    child:Container(
                                                        child: Card(
                                                          clipBehavior: Clip.antiAlias,
                                                          semanticContainer: true,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(7.0),
                                                          ),
                                                          elevation: 5,
                                                          margin: EdgeInsets.all(10),
                                                          child:ColorFiltered(
                                                              colorFilter: notifyPermit ? ColorFilter.mode(
                                                                Colors.transparent,
                                                                BlendMode.saturation,
                                                              ) : ColorFilter.mode(
                                                                Colors.white,
                                                                BlendMode.saturation,
                                                              ),
                                                              child: Padding(
                                                                  padding: new EdgeInsets.all(11.0),
                                                                  child:
                                                                  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height: 42.0,
                                                                          child: Image.asset( "assets/notify.png",
                                                                            color: colors.bluelight,
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 15.0),
                                                                        Text("Notification",
                                                                            style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700)),

                                                                      ])
                                                              )
                                                          ),
                                                        )

                                                    ),
                                                    // ),
                                                  ),

                                                ),

                                                Expanded(
                                                  child: Visibility(
                                                    maintainSize: false,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: false,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ///  Comment //////
                                                       Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => ComplainAdmin()));
                                                        print("Complain");
                                                      },
                                                      child: Container(
                                                          child: Card(
                                                              clipBehavior: Clip.antiAlias,
                                                              semanticContainer: true,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              elevation: 5,
                                                              margin: EdgeInsets.all(10),
                                                              child: Padding(
                                                                  padding: new EdgeInsets.all(11.0),
                                                                  child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        Badge(
                                                                          showBadge: false,
                                                                          // badgeColor: Colors.green,
                                                                          position: BadgePosition.topStart(start: 45.0,top: 0.0),
                                                                          animationDuration: Duration(milliseconds: 300),
                                                                          animationType: BadgeAnimationType.slide,
                                                                          badgeContent: Text("0",
                                                                            style: TextStyle(color: Colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          child: SizedBox(
                                                                            height: 42.0,
                                                                            child: Image.asset( "assets/complainbox.png",
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 15.0),
                                                                        Text("Complain Box",
                                                                            textAlign: TextAlign.center,
                                                                            style: new TextStyle(color: colors.orange,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700)),

                                                                      ])
                                                              )
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Visibility(
                                                      maintainSize: false,
                                                      maintainAnimation: true,
                                                      maintainState: true,
                                                      visible: false,
                                                       child: GestureDetector(
                                                       onTap: () {
                                                      ///  Comment //////
                                                      Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => DiscussBoxAdmin()));
                                                    },
                                                    child: Container(
                                                        child: Card(
                                                            clipBehavior: Clip.antiAlias,
                                                            semanticContainer: true,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            elevation: 5,
                                                            margin: EdgeInsets.all(10),
                                                            child: Padding(
                                                                padding: new EdgeInsets.all(11.0),
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      SizedBox(
                                                                        height: 42.0,
                                                                        child: Image.asset( "assets/book.png",
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 15.0),
                                                                      Text("Discussion Box",
                                                                          textAlign: TextAlign.center,
                                                                          style: new TextStyle(color: colors.yellow,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),

                                                                    ])
                                                            )
                                                        )
                                                    ),
                                                  ),)
                                                ),

                                              ]),
                                        ]),
                                  )
                              ),

                            ]
                        ),)
                  )
              ),
              Positioned(
                top: 2,
                child: Align(
                    alignment: Alignment.center,
                    child: new Container(
                      // margin: const EdgeInsets.only(top: -0.1, right: 10.0, left: 10),
                      // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      width: 150.0,
                      // margin: const EdgeInsets.all(5.0),
                      // padding: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                          color:colors.greylight ,
                          borderRadius: BorderRadius.circular(0.0),
                          border: Border.all(color: Colors.grey)

                      ),
                      child: Text("Communication",textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700)),
                    )
                ),

              ),

            ])
    );


  }



}



class Pages2 extends StatefulWidget {
  final text;
  Pages2({this.text});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Pages2State();
  }


}
class Pages2State extends State<Pages2> {

  SFData sfdata= SFData();
  var colors= AppColors();
  var timetablePermit=false;
  var assignPermit=false;
  var homeworkPermit=false;
  var lessonPlanPermit=false;
  var syllabusPerMit=false;
  var attendancePerMit=false,leaveApprovalODPerMit=false;
  var leavePerMit=false,leaveApprovalPerMit=false;

  @override
  void initState() {
    super.initState();
    Future<bool> userIdData = sfdata.getTimeTablePerMit(context);
    userIdData.then((data) {
      setState(() {
        timetablePermit=data;
        print('NOTICE_DATA----  $timetablePermit');
      });
    },onError: (e) {
    });

    Future<bool> circular = sfdata.getAssignmentPerMit(context);
    circular.then((data) {
      setState(() {
        assignPermit=data;
        print('NOTICE_DATA----  $assignPermit');
      });
    },onError: (e) {
    });

    Future<bool> diary = sfdata.getHomeWorkPerMit(context);
    diary.then((data) {
      setState(() {
        homeworkPermit=data;
        print('NOTICE_DATA----  $homeworkPermit');
      });
    },onError: (e) {
    });

    Future<bool> lessonPlan = sfdata.getLessonPlanPerMit(context);
    lessonPlan.then((data) {
      setState(() {
        lessonPlanPermit=data;
        print('NOTICE_DATA----  $lessonPlanPermit');
      });
    },onError: (e) {
    });

    Future<bool> syllabus = sfdata.getSyllabusPerMit(context);
    syllabus.then((data) {
      setState(() {
        syllabusPerMit=data;
        print('NOTICE_DATA----  $syllabusPerMit');
      });
    },onError: (e) {
    });

    Future<bool> attendance = sfdata.getAttendancePerMit(context);
    attendance.then((data) {
      setState(() {
        attendancePerMit=data;
        print('NOTICE_DATA----  $attendancePerMit');
      });
    },onError: (e) {
    });

    Future<bool> leave = sfdata.getLeavePerMit(context);
    leave.then((data) {
      setState(() {
        leavePerMit=data;
        print('NOTICE_DATA----  $leavePerMit');
      });
    },onError: (e) {
    });

    Future<bool> leaveApproval = sfdata.getLeaveApprovalPerMit(context);
    leaveApproval.then((data) {
      setState(() {
        leaveApprovalPerMit=data;
        print('NOTICE_DATA----  $leaveApprovalPerMit');
      });
    },onError: (e) {
    });

    Future<bool> leaveapprovalOD = sfdata.getODApprovalPerMit(context);
    leaveapprovalOD.then((data) {
      setState(() {
        leaveApprovalODPerMit=data;
        print('NOTICE_DATA----  $leaveApprovalODPerMit');
      });
    },onError: (e) {
    });


  }

  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
              child: Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          ///////////////FIRST /////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(assignPermit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => AssignmentList()));
                                      }

                                    },
                                    child:Visibility(
                                      visible: true,
                                      child: Container(
                                          child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              semanticContainer: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                               child:ColorFiltered(
                                                colorFilter: assignPermit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                  padding: new EdgeInsets.all(11.0),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 42.0,
                                                          child: Image.asset( "assets/assessment.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15.0),
                                                        Text("Assignment",
                                                            style: new TextStyle(color: colors.orange,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ])
                                              )
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(

                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(attendancePerMit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => AttendanceMenu()));
                                        print("ACTIVITY");
                                      }

                                    },
                                    child:Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child:ColorFiltered(
                                                colorFilter: attendancePerMit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(11.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 42.0,
                                                            child: Image.asset( "assets/attendance.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Attendance",
                                                              textAlign: TextAlign.center,
                                                              style: new TextStyle(color: colors.brown,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                )
                                            ),

                                        )
                                    ),
                                  ),

                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(homeworkPermit==true){
                                       Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => HomeWorkList()));
                                        print("HomeWork");
                                      }

                                    },
                                    child:Visibility(
                                      visible: true,
                                      child:Container(
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child:ColorFiltered(
                                                colorFilter: homeworkPermit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(11.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 42.0,
                                                            child: Image.asset( "assets/repotcard.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Home Work",
                                                              style: new TextStyle(color: colors.green,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                )),
                                          )
                                      ),
                                    ),
                                  ),

                                ),

                              ]),
                          ///////////////SECOND /////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(timetablePermit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => TimeTableClass()));
                                      }

                                      print("TIME TABLE");
                                    },
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child:ColorFiltered(
                                                colorFilter: timetablePermit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(11.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 42.0,
                                                            child: Image.asset( "assets/timetable.png",
                                                              color: colors.purpals,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Time Table",
                                                              style: new TextStyle(color: colors.purpals,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                ))
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(

                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(leavePerMit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => LeaveStatus()));
                                      }
                                    },
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child:ColorFiltered(
                                                colorFilter: leavePerMit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(11.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 42.0,
                                                            child: Image.asset( "assets/assignment.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                          SizedBox(height: 15.0),
                                                          Text("Apply Leave",
                                                              style: new TextStyle(color: colors.lightgreen,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                ))
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(leaveApprovalPerMit==true){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApprovals()));
                                       // print("APPROVALS");
                                      }

                                    },

                                   child:Visibility(
                                    visible: true,
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child:ColorFiltered(
                                                colorFilter: leaveApprovalPerMit ? ColorFilter.mode(
                                                  Colors.transparent,
                                                  BlendMode.saturation,
                                                ) : ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.saturation,
                                                ),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(11.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 42.0,
                                                            child: Image.asset( "assets/leaveaprovals.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Leave Approval",textAlign:TextAlign.center,
                                                              style: new TextStyle(color: colors.redtheme,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                ))
                                        )
                                    ),
                                   ),
                                  ),
                                )
                              ]),

                          ///////////////THIRD/////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      if(syllabusPerMit==true){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChapterListAdmin()));
                                        //print("APPROVALS");
                                      }

                                    },

                                    child:Visibility(
                                      visible: true,
                                      child: Container(
                                          child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              semanticContainer: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                              child:ColorFiltered(
                                                  colorFilter: syllabusPerMit ? ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.saturation,
                                                  ) : ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.saturation,
                                                  ),
                                                  child: Padding(
                                                      padding: new EdgeInsets.all(11.0),
                                                      child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 42.0,
                                                              child: Image.asset( "assets/book.png",
                                                                color: colors.bluelight,
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                            SizedBox(height: 15.0),
                                                            Text("Syllabus",textAlign:TextAlign.center,
                                                                style: new TextStyle(color: colors.bluelight,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                    fontWeight: FontWeight.w700)),

                                                          ])
                                                  ))
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child:Visibility(
                                    visible: false,
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child: Padding(
                                                padding: new EdgeInsets.all(15.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 40.0,
                                                        child: Image.asset( "assets/discussion.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Text("Syllabus",
                                                          style: new TextStyle(color: colors.yellow,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    ])
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child:GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChapterResAndLessonPlan()));

                                    },
                                    child: Visibility(
                                      visible: true,
                                      child: Container(
                                          child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              semanticContainer: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                              child: Padding(
                                                  padding: new EdgeInsets.all(15.0),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 40.0,
                                                          child: Image.asset( "assets/verified.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                        Text("Circular",
                                                            style: new TextStyle(color: colors.pink,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ])
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                )
                              ]),

                        ]
                    ),)
              )
          ),
          Positioned(
            top: 2,
            child: Align(
                alignment: Alignment.center,
                child: new Container(
                  // margin: const EdgeInsets.only(top: -0.1, right: 10.0, left: 10),
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  width: 150.0,
                  // margin: const EdgeInsets.all(5.0),
                  // padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      color:colors.greylight ,
                      borderRadius: BorderRadius.circular(0.0),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Text("Academics",textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700)),
                )
            ),

          ),
        ]);
  }
}


class Pages3 extends StatefulWidget {
  final text;
  Pages3({this.text});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Pages3State();
  }


}
class Pages3State extends State<Pages3> {
  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
              child: Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          ///////////////FIRST /////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => AssignmentList()));
                                    },
                                    child:Visibility(
                                      visible: true,
                                      child: Container(
                                          child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              semanticContainer: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                              child: Padding(
                                                  padding: new EdgeInsets.all(11.0),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 42.0,
                                                          child: Image.asset( "assets/assessment.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15.0),
                                                        Text("Assignment",
                                                            style: new TextStyle(color: colors.orange,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ])
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        ///  Comment //////
                                        /*Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => MyTeachers()));*/
                                      },
                                      child:Visibility(
                                        visible: true,
                                        child: Container(
                                            child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                semanticContainer: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                elevation: 5,
                                                margin: EdgeInsets.all(10),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(15.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 40.0,
                                                            child: Image.asset( "assets/verified.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                          Text("My Teacher",
                                                              style: new TextStyle(color: colors.pink,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),
                                                        ])
                                                )
                                            )
                                        ),
                                      ),
                                    )

                                ),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        ///  Comment //////
                                        /*Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => Thoughts()));*/
                                      },
                                      child:Visibility(
                                        visible: true,
                                        child: Container(
                                            child: Card(
                                                clipBehavior: Clip.antiAlias,
                                                semanticContainer: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                elevation: 5,
                                                margin: EdgeInsets.all(10),
                                                child: Padding(
                                                    padding: new EdgeInsets.all(15.0),
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: 40.0,
                                                            child: Image.asset( "assets/attendance.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                          Text("Thoughts",
                                                              style: new TextStyle(color: colors.red,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),

                                                        ])
                                                )
                                            )
                                        ),
                                      ),
                                    )
                                )
                              ]),
                          ///////////////SECOND /////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                     /* Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => HomeWorkList()));*/
                                      print("HomeWork");
                                    },
                                    child:Visibility(
                                      visible: false,
                                      child:Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child: Padding(
                                                padding: new EdgeInsets.all(11.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 42.0,
                                                        child: Image.asset( "assets/repotcard.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: 15.0),
                                                      Text("Home Work",
                                                          style: new TextStyle(color: colors.green,fontSize: 11.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    ])
                                            )
                                        )
                                    ),
                                   ),
                                  ),
                                ),

                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                    /* Navigator.push(context, MaterialPageRoute(builder:(context) => Diary())); */
                                     // print("TIME TABLE");
                                    },
                                    child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        semanticContainer: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        elevation: 5,
                                        margin: const EdgeInsets.all(10),
                                        child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 42.0,
                                                    child: Image.asset( "assets/timetable.png",
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  Text("Time Table",
                                                      style: TextStyle(color: colors.blueGrey,fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ])
                                        )
                                    ),

                                  ),
                                ),

                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ///  Comment //////
                                      /*Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => LeaveStatus()));*/
                                     // print("ASSISMENT");
                                    },
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: const EdgeInsets.all(10),
                                            child: Padding(
                                                padding: const EdgeInsets.all(11.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 42.0,
                                                        child: Image.asset( "assets/assignment.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      const SizedBox(height: 15.0),
                                                      Text("Apply Leave",
                                                          style: TextStyle(color: colors.lightgreen,fontSize: 11.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),

                                                    ])
                                            )
                                        )
                                    ),
                                  ),
                                )
                              ]),


                          ///////////////THIRD/////////////////////
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child:Visibility(
                                    visible: false,
                                    child:Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            elevation: 5,
                                            margin: const EdgeInsets.all(10),
                                            child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 40.0,
                                                        child: Image.asset( "assets/activity.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Text("Activity",
                                                          style: TextStyle(color: colors.brown,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),

                                                    ])
                                            )
                                        )
                                    ),
                                  ),

                                ),

                                Expanded(
                                  child:Visibility(
                                    visible: false,
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: const EdgeInsets.all(10),
                                            child: Padding (
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 40.0,
                                                        child: Image.asset( "assets/book.png",
                                                          color: colors.yellow,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Text("Syllabus",
                                                          style: TextStyle(color: colors.yellow,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),

                                                    ])
                                            )
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child:Visibility(
                                    visible: false,
                                    child: Container(
                                        child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            semanticContainer: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                            child: Padding(
                                                padding: new EdgeInsets.all(15.0),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 40.0,
                                                        child: Image.asset( "assets/verified.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Text("Circular",
                                                          style: new TextStyle(color: colors.pink,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),

                                                    ])
                                            )
                                        )
                                    ),
                                  ),
                                )
                              ]),




                        ]
                    ),)
              )
          ),
          Positioned(
            top: 2,
            child: Align(
                alignment: Alignment.center,
                child: new Container(
                  // margin: const EdgeInsets.only(top: -0.1, right: 10.0, left: 10),
                  //padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  width: 150.0,
                  // margin: const EdgeInsets.all(5.0),
                  // padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      color:colors.greylight ,
                      borderRadius: BorderRadius.circular(0.0),
                      border: Border.all(color: Colors.grey)

                  ),
                  child: Text("Assessment",textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700)),
                )
            ),

          ),
        ]);
  }
}





class PagesMessage extends StatelessWidget {
  final text;
  PagesMessage({this.text});
  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Center(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ///////////////FIRST /////////////////////
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          // height: MediaQuery.of(context).size.height  * 0.5,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                    padding: new EdgeInsets.all(0.0),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Expanded(
                                          Container(
                                              color: colors.reddark,
                                              width: 30.0,
                                              height: 110.0,
                                              child: new Center(
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'PRINCIPLE',
                                                        style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700),
                                                        /*children: [
                                                      WidgetSpan(
                                                        child: RotatedBox(quarterTurns: -1, child: Text('😃')),
                                                      )
                                                    ],*/
                                                      ),
                                                    ),
                                                  )
                                              )



                                          ),
                                          //),

                                          Expanded(
                                              child: Container(
                                                  height: 110.0,
                                                  padding: new EdgeInsets.all(5.0),
                                                  color: Colors.red,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                                      children:<Widget>[
                                                        Text("Admission Open PG to Class IX and XI (2021)",
                                                            textAlign: TextAlign.start,
                                                            style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 5.0),
                                                        Text("In the sample above, the text and the logo are centered on each line. In the following example, the crossAxisAlignment is set to CrossAxisAlignment.start, so that the children are left-aligned.",
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 15.0),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children:<Widget>[
                                                              Expanded(
                                                                child: Text("Time: 09:44 AM",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),

                                                              Expanded(
                                                                child: Text("Date: 09 Feb 2020",
                                                                    textAlign: TextAlign.end,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              )

                                                            ])



                                                      ])


                                              )
                                          ),

                                        ])
                                )
                            )
                        ),

                      ),
                    ]),




              ]
          ),
        )
    );
  }
}
class PagesMessage2 extends StatelessWidget {
  final text;
  PagesMessage2({this.text});
  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Center(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[


                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                ///////////////FIRST /////////////////////
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          // height: MediaQuery.of(context).size.height  * 0.5,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                    padding: new EdgeInsets.all(0.0),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Expanded(
                                          Container(
                                              color: colors.lightgreen,
                                              width: 30.0,
                                              height: 110.0,
                                              child: new Center(
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'TEACHER',
                                                        style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700),
                                                        /*children: [
                                                      WidgetSpan(
                                                        child: RotatedBox(quarterTurns: -1, child: Text('😃')),
                                                      )
                                                    ],*/
                                                      ),
                                                    ),
                                                  )
                                              )



                                          ),
                                          //),

                                          Expanded(
                                              child: Container(
                                                  height: 110.0,
                                                  padding: new EdgeInsets.all(5.0),
                                                  color: Colors.green,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                                      children:<Widget>[
                                                        Text("Admission Open PG to Class IX and XI (2021)",
                                                            textAlign: TextAlign.start,
                                                            style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 5.0),
                                                        Text("In the sample above, the text and the logo are centered on each line. In the following example, the crossAxisAlignment is set to CrossAxisAlignment.start, so that the children are left-aligned.",
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 15.0),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children:<Widget>[
                                                              Expanded(
                                                                child: Text("Time: 09:44 AM",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),

                                                              Expanded(
                                                                child: Text("Date: 09 Feb 2020",
                                                                    textAlign: TextAlign.end,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              )

                                                            ])



                                                      ])


                                              )
                                          ),

                                        ])
                                )
                            )
                        ),

                      ),
                    ]),




              ]
          ),
        )
    );
  }
}
class PagesMessage3 extends StatelessWidget {
  final text;
  PagesMessage3({this.text});
  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Center(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                /*Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: 90.0,
                        // margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(0.0),
                        child: Text("Notice",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700)),
                      )


                    ]),*/

                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                ///////////////FIRST /////////////////////
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          // height: MediaQuery.of(context).size.height  * 0.5,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                    padding: new EdgeInsets.all(0.0),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Expanded(
                                          Container(
                                              color: colors.reddark,
                                              width: 30.0,
                                              height: 110.0,
                                              child: new Center(
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'PRINCIPLE',
                                                        style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700),
                                                        /*children: [
                                                      WidgetSpan(
                                                        child: RotatedBox(quarterTurns: -1, child: Text('😃')),
                                                      )
                                                    ],*/
                                                      ),
                                                    ),
                                                  )
                                              )



                                          ),
                                          //),

                                          Expanded(
                                              child: Container(
                                                  height: 110.0,
                                                  padding: new EdgeInsets.all(5.0),
                                                  color: Colors.red,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                                      children:<Widget>[
                                                        Text("Admission Open PG to Class IX and XI (2021)",
                                                            textAlign: TextAlign.start,
                                                            style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 5.0),
                                                        Text("In the sample above, the text and the logo are centered on each line. In the following example, the crossAxisAlignment is set to CrossAxisAlignment.start, so that the children are left-aligned.",
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 15.0),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children:<Widget>[
                                                              Expanded(
                                                                child: Text("Time: 09:44 AM",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),

                                                              Expanded(
                                                                child: Text("Date: 09 Feb 2020",
                                                                    textAlign: TextAlign.end,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              )

                                                            ])



                                                      ])


                                              )
                                          ),

                                        ])
                                )
                            )
                        ),

                      ),
                    ]),




              ]
          ),
        )
    );
  }
}
class PagesMessage4 extends StatelessWidget {
  final text;
  PagesMessage4({this.text});
  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Center(
        child: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[


                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                ///////////////FIRST /////////////////////
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          // height: MediaQuery.of(context).size.height  * 0.5,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                    padding: new EdgeInsets.all(0.0),
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          // Expanded(
                                          Container(
                                              color: colors.lightgreen,
                                              width: 30.0,
                                              height: 110.0,
                                              child: new Center(
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: 'TEACHER',
                                                        style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700),
                                                        /*children: [
                                                      WidgetSpan(
                                                        child: RotatedBox(quarterTurns: -1, child: Text('😃')),
                                                      )
                                                    ],*/
                                                      ),
                                                    ),
                                                  )
                                              )



                                          ),
                                          //),

                                          Expanded(
                                              child: Container(
                                                  height: 110.0,
                                                  padding: new EdgeInsets.all(5.0),
                                                  color: Colors.green,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                                      children:<Widget>[
                                                        Text("Admission Open PG to Class IX and XI (2021)",
                                                            textAlign: TextAlign.start,
                                                            style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 5.0),
                                                        Text("In the sample above, the text and the logo are centered on each line. In the following example, the crossAxisAlignment is set to CrossAxisAlignment.start, so that the children are left-aligned.",
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 15.0),
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children:<Widget>[
                                                              Expanded(
                                                                child: Text("Time: 09:44 AM",
                                                                    textAlign: TextAlign.start,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              ),

                                                              Expanded(
                                                                child: Text("Date: 09 Feb 2020",
                                                                    textAlign: TextAlign.end,
                                                                    style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700)),
                                                              )

                                                            ])



                                                      ])


                                              )
                                          ),

                                        ])
                                )
                            )
                        ),

                      ),
                    ]),




              ]
          ),
        )
    );
  }
}





//////////////Logout dialog//////
Future<Future<ConfirmAction?>> _asyncConfirmDialognew(BuildContext context) async {
  SFData sfdata= SFData();
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Logout'),
        content: const Text(
            'Do you really want to logout?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Logout',style: TextStyle(color: Colors.red)),
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






//////////////Restart dialog//////
Future<void>  _asyncConfirmDialogRestart(BuildContext context) async {
  SFData sfdata= SFData();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Update'),
        content: const Text(
            'Permission update available. Restart App. now'),
        actions: <Widget>[
          /*FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),*/
          FlatButton(
            child: const Text('Login again',style: TextStyle(color: Colors.red)),
            onPressed: () {
              print("RESUME");
              sfdata.removeUserid(context);
              Navigator.of(context).pop(ConfirmAction.Accept);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Login(0)),
                ModalRoute.withName('/'),
              );
              //Phoenix.rebirth(context);
            },
          )
        ],
      );
    },
  );
}