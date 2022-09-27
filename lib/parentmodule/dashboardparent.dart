import 'package:badges/badges.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/login.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/models/studentdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/parentmodule/noticeparent.dart';
import 'package:educareadmin/parentmodule/thoughts.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notifications.dart';
import 'circularlistParents.dart';
import 'complain.dart';
import 'diarylistparents.dart';
import 'discussionbox.dart';
import 'feeledger.dart';
import 'feesdues.dart';
import 'studentattendance.dart';
import 'timetablestudent.dart';



enum ConfirmAction { Cancel, Accept}

class DashBoardParent extends StatefulWidget {
  DashBoardParent(
      this.comm,
      this.acadmincs,
      this.assessment,
      this.fees,
      );

  final bool comm;
  final bool acadmincs;
  final bool assessment;
  final bool fees;

  @override
  State<StatefulWidget> createState() {
    return DashBoardParentState();
  }
}



class DashBoardParentState extends State<DashBoardParent> {

  CommonAction commonAlert= CommonAction();
  var colors= AppColors();
  int _curr=0;
  SFData sfdata= SFData();
  var usernameName,loginAs;
  var sessionID;
  List<NoticeData> noticelist = <NoticeData>[];
  List<StudentData> userdata = <StudentData>[];
  bool isLoader = false;
  var relationshipId;
  var bottomNotification=0;
  var profilePicUrl,empCode,fyID,saveuseId;
  var isNotifyTrue=0;


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
    new Center(child:new Pages2(text: "Page 2",)),
    //new Center(child:new Pages(text: "Page 3",)),
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
  void initState() {

    if(widget.comm==true){
      _list.add(new Center(child:new Pages(text: "false",)));
    }
    if(widget.acadmincs==true){
      _list.add(new Center(child:new Pages2(text: "false",)));
    }
    if(widget.fees==true){
      _list.add(new Center(child:new PagesFee(text: "false",)));
    }

    Future<String> authToken = sfdata.getUseName(context);
    authToken.then((data) {
     // print("authToken " + data.toString());
      setState(() {
        usernameName=data.toString();
      });
    },onError: (e) {
      //print(e);
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
     // print("authToken " + data.toString());
      setState(() {
        sessionID=data;
        //print("SESSION"+sessionID.toString());
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
     // print("profileData " + data.toString());
      setState(() {
        profilePicUrl=data.replaceAll("..", "");
        String baseUrl=colors.imageUrl;
        profilePicUrl='$baseUrl$profilePicUrl';

       // print("IMAGEURL " + profilePicUrl);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
       // print("empCode " + empCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      //print("saveuseId " + data.toString());
      setState(() {
        saveuseId=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
       // print("fyID " + fyID);
        UserDetails(context,empCode,relationshipId,sessionID);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> noti = sfdata.getIsNotification(context);
    noti.then((data) {
      setState(() {
        isNotifyTrue=data;
        //isNotifyTrue=true;
        print("NOTIFICATION " + isNotifyTrue.toString());
      });
    },onError: (e) {
      print(e);
    });



    WidgetsBinding.instance?.addPostFrameCallback((_) => _animateSlider());



    super.initState();

  }

  //////////////////  Notices API //////////////////////
  Future<Null> noticesList(BuildContext context,int relationshipID,int session) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
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
      }
      setState(() {
      });
    }).catchError((error) {
      print(error);
    });
  }


  //////////////////  UserDetails API //////////////////////
  Future<Null> UserDetails(BuildContext context,String code,int relationshipID,int session) async {
    final api = Provider.of<ApiService>(context, listen: false);
    print(" StudentCode---  $code");
    return await api
        .listuserData("11",code,relationshipID,session,fyID)
        .then((result) {
     // print(result);
     // isLoader = false;
      if(result.isNotEmpty){
        userdata=result.toList();
        sfdata.saveStudentDataToSF(context,userdata[0].studentCode,userdata[0].classCode,userdata[0].sectionCode,userdata[0].className,
            userdata[0].sectionName,userdata[0].fatherName,userdata[0].motherName,userdata[0].name,userdata[0].mobile,userdata[0].dob,userdata[0].dateOfAdmission,userdata[0].studentPhoto);
      }else{
        this.userdata=[];
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
         // print(commonAlert.dateFormate(context, result[0].toDate as DateTime));
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

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(20)
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.4,
            child: AnimatedContainer(
              duration: Duration(seconds: 10),
              child: new Center(
                child: new Text("Other student Profile"),
              ),
            ),

          );

        });
  }

  Widget _notificationBadge() {
    return Badge(
        badgeColor: isNotifyTrue==1?Colors.lightBlueAccent:colors.redthemenew,
        position: BadgePosition.topEnd(top: 0, end: 16),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        elevation: isNotifyTrue==1?5.0:0.0,
        badgeContent: Text("8",
          style: TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(icon: Icon(Icons.notifications_on_outlined), onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Notifications()));

          }),
        )
    );
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
                  //controller: _pageController,
                  onPageChanged: (num){
                    setState(() {
                      _curr=num;
                    });
                  },

                ),
              )

            ])

    );
  }

  onTapdetails(index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NoticesParent(),
      ),
    );
   /* var rowData = this._diarylist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DiaryDetails(rowData),
      ),
    );*/
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
                                    // textAlign: TextAlign.justify,
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
                accountName: Text(usernameName != null ? usernameName:"",style: new TextStyle(color: colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700)),
                accountEmail: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Padding(padding: const EdgeInsets.all(0.0),
                              child:  GestureDetector(
                                onTap: () {

                                },
                                child: Text(loginAs,
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              )
                          )
                      ),
                      Expanded(
                          child: Padding(padding: const EdgeInsets.all(10.0),
                              child:  GestureDetector(
                                onTap: () {
                                  print("CLICK");
                                  Navigator.of(context).pop();
                                  displayBottomSheet(context);
                                },
                                child: Text("Change Account",
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
                                 foregroundImage: NetworkImage(profilePicUrl != null ? profilePicUrl : ""), radius: 50,
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
                onTap: (){
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
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
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text('Ver - 1.0.0',style: TextStyle(color: colors.redtheme),),
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          height: 165.0,
                          child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                   /* Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => UserProfile()));*/
                                    // print("Notice");
                                  },
                                  child: SizedBox(
                                      height: 110.0,
                                      width: 110.0,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 110,
                                        child: CircleAvatar(
                                            backgroundImage: AssetImage('assets/profileblank.png'),
                                            foregroundImage: NetworkImage(profilePicUrl != null ? profilePicUrl : ""),
                                            onBackgroundImageError: (exception, stackTrace) {
                                              setState(() {
                                                // this.profilePicUrl = null;
                                              });
                                            },
                                            radius: 50,
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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


                  /* Image.asset(
                "assets/dashboardback.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),*/
                  /* Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: <Widget>[
                    //_complainBadge(),
                    _logoutBadge(),
                    _notificationBadge(),

                  ],
                ),
              ),*/




                ])
        )
    );
  }
}

class Pages extends StatefulWidget {
  final text;
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
  var circularPermit=false;
  var diaryPermit=false;
  var notifyPermit=false;
  var thoughtsPermit=false,complaintsPermit=false,discussionPermit=false;

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

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
        onWillPop: () async{  return shouldPop;  },
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

                              ///////////////FIRST /////////////////////
                              Container(
                                  child: Center(
                                    child:  Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:<Widget>[
                                          Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if(noticePermit==true){
                                                        final result = await Navigator.push(
                                                          context,MaterialPageRoute(builder: (context) => NoticesParent()),
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
                                                              colorFilter: noticePermit ? ColorFilter.mode(
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
                                                          ),
                                                        )

                                                    ),
                                                    // ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if(circularPermit==true){
                                                        Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => CircularsParent()));
                                                       // print("Circular");
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
                                                          colorFilter: circularPermit ? ColorFilter.mode(
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
                                                                      child: Image.asset( "assets/verified.png",
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 15.0),
                                                                    Text("Circular",
                                                                        style: new TextStyle(color: colors.pink,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                            fontWeight: FontWeight.w700)),
                                                                  ])
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if(diaryPermit==true){
                                                        Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => DiaryParents()));
                                                        print("DIARY");
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
                                                              colorFilter: diaryPermit ? ColorFilter.mode(
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
                                                                          child: Image.asset( "assets/digitaldiary.png",
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 15.0),
                                                                        Text("Diary",
                                                                            style: new TextStyle(color: colors.red,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700)),
                                                                      ])
                                                              )
                                                          ),
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
                                                                                child: Image.asset( "assets/attendance.png",
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                                              Text("Thoughts",
                                                                                  style: new TextStyle(color: colors.red,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                      fontWeight: FontWeight.w700)),

                                                                            ])
                                                                    ))
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
                                                     if(complaintsPermit==true){
                                                       Navigator.push(
                                                           context, MaterialPageRoute(builder: (context) => Complain()));
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
                                                                            Text("Complain Box",
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
                                                     if(discussionPermit==true){
                                                       Navigator.push(
                                                           context, MaterialPageRoute(builder: (context) => DiscussBox()));
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
                                                            child:  ColorFiltered(
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
                                                  child: Visibility(
                                                    maintainSize: false,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: false,
                                                   child: GestureDetector(
                                                    onTap: () async {
                                                      if(notifyPermit==true){
                                                      /*  Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => NoticesParent()));*/
                                                       /* final result = await Navigator.push(
                                                          context,MaterialPageRoute(builder: (context) => Notices()),); */
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
                                                                  child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        SizedBox(
                                                                          height: 42.0,
                                                                          child: Image.asset( "assets/notify.png",
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
                                                ),

                                                Expanded(
                                                  child: Visibility(
                                                    maintainSize: false,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: false,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => Complain()));
                                                        //print("Complain");
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
                                                                          //badgeColor: Colors.green,
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
                                                          Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => DiscussBox()));
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
  var attendancePerMit=false;

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
                                      if(assignPermit==true){

                                      }
                                      /*Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => AssignmentList()));*/
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
                                      if(attendancePerMit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => StudentAttendance()));
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
                                                              style: new TextStyle(color: colors.brown,fontSize: 11.0,fontFamily: 'Montserrat',
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
                                      if(homeworkPermit==true){

                                      }
                                     /* Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => HomeWorkList()));*/
                                      print("HomeWork");
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
                                                  ):ColorFilter.mode(
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
                                      if(timetablePermit==true){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTable()));
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
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Time Table",
                                                              style: new TextStyle(color: colors.blueGrey,fontSize: 11.0,fontFamily: 'Montserrat',
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

                                    },
                                    child: Visibility(
                                      visible: false,
                                      child:Container(
                                          child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              semanticContainer: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              elevation: 5,
                                              margin: EdgeInsets.all(10),
                                              child:ColorFiltered(
                                                  colorFilter: true ? ColorFilter.mode(
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
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {

                                    },
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
                                              child:ColorFiltered(
                                                  colorFilter: true ? ColorFilter.mode(
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
                                                padding: new EdgeInsets.all(15.0),
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
                                                          style: new TextStyle(color: colors.brown,fontSize: 11.0,fontFamily: 'Montserrat',
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
                                                        child: Image.asset( "assets/book.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Text("Syllabus",
                                                          style: new TextStyle(color: colors.yellow,fontSize: 11.0,fontFamily: 'Montserrat',
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
                                                          style: new TextStyle(color: colors.pink,fontSize: 11.0,fontFamily: 'Montserrat',
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


class PagesFee extends StatefulWidget {
  final text;
  PagesFee({this.text});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PagesFeeState();
  }


}
class PagesFeeState extends State<PagesFee> {

  SFData sfdata= SFData();
  var colors= AppColors();
  var feePermit=false;
  var assignPermit=false;
  var homeworkPermit=false;
  var lessonPlanPermit=false;

  @override
  void initState() {
    super.initState();
    Future<bool> userIdData = sfdata.getFeePerMit(context);
    userIdData.then((data) {
      setState(() {
        feePermit=data;
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
                                      if(feePermit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => FeesDues()));
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
                                                colorFilter: feePermit ? ColorFilter.mode(
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
                                                            child: Image.asset( "assets/feemenu.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Fee Pay",
                                                              style: new TextStyle(color: colors.bluelight,fontSize: 11.0,fontFamily: 'Montserrat',
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
                                      if(feePermit==true){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => FeeLedger()));
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
                                                colorFilter: feePermit ? ColorFilter.mode(
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
                                                            child: Image.asset( "assets/ledger.png",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15.0),
                                                          Text("Fee Ledger",
                                                              textAlign: TextAlign.center,
                                                              style: new TextStyle(color: colors.brownred,fontSize: 11.0,fontFamily: 'Montserrat',
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
                                      /* Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => HomeWorkList()));*/

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
                  child: Text("Fees",textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
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
Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  SFData sfdata= SFData();
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
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
            child: const Text('Yes'),
            onPressed: () {
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