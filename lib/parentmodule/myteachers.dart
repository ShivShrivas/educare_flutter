import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/studentattdata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyTeachers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyTeachersState();
  }
}

class MyTeachersState extends State<MyTeachers> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  // List<StudentAttData> studentsdataList = [];
  List<StudentAttData> newdataList = [];
  late StudentAttData _studentAttData;

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var fyID;
  var saveuseId;
  List<ComplainData> complainlist = <ComplainData>[];
  String selectdesign="",selectImage="",selectName="";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);





  List<ClassDataList> classlist = <ClassDataList>[];
  late ClassDataList selectedClassCode;
  String _classCode="0";

  List<SectionDataList> sectionlist = <SectionDataList>[];
  late SectionDataList selectedsectionCode;
  String _sectionCode="0";


  List<UserType> userlist = <UserType>[];
  late UserType selectedUserCode;
  late String userCode;
  var sendusertypeId=1,empCode;
  TextEditingController _textController = TextEditingController();
  bool isPresent=true;
  var isPresentImage="";
  bool _savebutton=false;

  late String currentDate,todate;
  String showdateServer="";
  CommonAction commonAlert= CommonAction();
  late DateTime now,calenderDate;


  onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }


  Future<void> getSavedData() async{
    Future<int> sessionIdData = sfdata.getSessionId(context);
    sessionIdData.then((data) {
      print("authToken " + data.toString());
      setState(() {
        sessionId=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
      print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
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

    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      print("useIdData " + data.toString());
      setState(() {
        saveuseId=data.toString();
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


    now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    setState(() {
      currentDate = formatter.format(now);
      calenderDate=now;
    });
    //classList();
    //getStudentList();

    /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/

    newdataList.add(new StudentAttData(studentId: "1",studentCode: "0001",name: "Amit Sharma",fatherName: "test",abbrType: "Science"));
    newdataList.add(new StudentAttData(studentId: "1",studentCode: "0001",name: "Varun Singh",fatherName: "test",abbrType: "Math"));
  }



  @override
  void initState() {
    super.initState();
    getSavedData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Builder(
          builder: (context) =>
          new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                  child: Stack(
                      children: <Widget>[
                        Container(
                          // height: double.infinity,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/loginbottom.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        ///////AppBar/////////////////////////
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: 20.0,
                          right: 20.0,
                          child: AppBar(
                            title: Text("My Teacher".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700)),
                            leading: new IconButton(
                              // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                                icon: Icon(Icons.arrow_back),
                                color: Colors.black,
                                onPressed:() {
                                  Navigator.of(context).pop();
                                }),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                        new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                                  MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: newdataList.isNotEmpty
                                        ? Container(
                                         child: Expanded(
                                          child: ListView.builder(
                                          itemCount: 2,
                                          itemBuilder: _buildRow,
                                        ),
                                      ),
                                    ): isLoader == true
                                        ? Container(
                                         margin: const EdgeInsets.all(180.0),
                                         child: Center(child: CircularProgressIndicator()))
                                        : Container(
                                          margin: const EdgeInsets.all(150.0),
                                          child: Text(""),
                                    ),
                                  ),

                                ]
                            )),


                      ]
                  )
              )
          ),
        )

    );

  }


  void _showRatingAppDialog() {
    /*final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      initialRating: 2,
      title: 'Rate your Teacher',
      message: 'Rate your teacher and tell others what you think.'
          ' Add more description here if you want.',
      //image: Image.asset("assets/images/devs.jpg", height: 100,),
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {

        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );*/
  }


  onEdit(index) async {
    _showRatingAppDialog();
  }

  Widget _buildRow(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 30,
                  color: Colors.white,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 8,
                  //margin: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () => onEdit(index),
                    child:Column(
                      children: <Widget>[
                        SizedBox(height: 30),
                        Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                    // height: 100.0,
                                      padding: new EdgeInsets.all(5.0),
                                      //color: Colors.white,
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                          children:<Widget>[
                                            Padding(padding:  new EdgeInsets.all(2.0),
                                              child: Container(
                                                child: Column(children: [
                                                  Container(
                                                    child: Center(
                                                      child: Text(
                                                          newdataList[index].name != null
                                                              ? newdataList [index].name
                                                              : '',
                                                          style:  TextStyle(color: Colors.redAccent,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700),textAlign: TextAlign.left),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Center(
                                                      child: Text(newdataList[index].abbrType != null
                                                              ? newdataList [index].abbrType: '',
                                                          style:  TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w600),textAlign: TextAlign.left),
                                                    ),
                                                  ),
                                                  Wrap(
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                        size: 20.0,
                                                      ),
                                                      Text('4',
                                                          style:  TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w600),textAlign: TextAlign.left),
                                                    ],
                                                  ),


                                                          /* RatingBar.builder(
                                                        itemSize: 15,
                                                        initialRating: 3,
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: false,
                                                        itemCount: 5,
                                                        updateOnDrag: false,
                                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        *//*onRatingUpdate: (rating) {
                                                          print(rating);
                                                        },*//*
                                                      )*/



                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(5),
                                                        child: Text('Message',
                                                            style:  TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',fontStyle: FontStyle.italic,
                                                                fontWeight: FontWeight.w700),textAlign: TextAlign.left),
                                                      ),
                                                    ],
                                                  ),

                                                  Container(
                                                    margin: EdgeInsets.all(5),
                                                    child: Text('If you are planning for a year, sow rice; if you are planning for a decade, plant trees; if you are planning for a lifetime, educate people.',
                                                        style:  TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),textAlign: TextAlign.left),
                                                  ),


                                                ],),

                                              ),
                                            ),

                                          ])
                                  )
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              child: Align(
                  alignment: Alignment.center,
                  child: new Container(
                    // margin: const EdgeInsets.only(top: -0.1, right: 10.0, left: 10),
                    //padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    //width: 150.0,
                    child: ClipOval(
                      //child: FadeInImage(image: NetworkImage(""), placeholder: AssetImage('assets/profileblank.png'),
                      child: FadeInImage(image: NetworkImage("https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
                        placeholder: AssetImage('assets/profileblank.png'),
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, url, error) => Image.asset('assets/profileblank.png',width: 65,
                          height: 65,),
                      ),
                    ),
                  )
              ),

            ),
          ]),
    );
  }
}