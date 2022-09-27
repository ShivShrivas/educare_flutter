import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/timetabledata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createcomplain.dart';

class TimeTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimeTableState();
  }
}

class TimeTableState extends State<TimeTable> {

  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  late TimeTableData timetableList;
  List<Day> dayList = [];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var fyID;
  var saveuseId;



  List<UserType> userlist = <UserType>[];
  UserType? selectedUserCode;
  late String userCode;
  var sendusertypeId=1,empCode;
  TextEditingController _textController = TextEditingController();
  late List<bool> isSelected;

 // String _currentYear = DateFormat.D().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  var _day=DateTime.now().weekday;

  List<Color> _colors = [Colors.lightGreen,Colors.lightBlue, Colors.deepOrangeAccent, Colors.cyan,Colors.indigoAccent,Colors.amberAccent,Colors.redAccent,Colors.teal,Colors.orangeAccent,Colors.indigo,Colors.lightGreen,Colors.lightBlue, Colors.amberAccent, Colors.pinkAccent,Colors.indigoAccent,Colors.green,Colors.lightBlue, Colors.amberAccent, Colors.cyan,Colors.indigoAccent,Colors.green,Colors.redAccent,Colors.teal,Colors.green,Colors.redAccent,Colors.teal,Colors.orangeAccent,Colors.indigo];

  List<Color> _colorsBlank = [Colors.white60];

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


    getTimetableList();
    /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/
  }

  //////////////////  StudentList API //////////////////////
  Future<Null> getTimetableList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context,listen: false);
    return await api
        .gettimetableList("",empCode,relationshipId,sessionId)
        .then((result) {
      //print(result.length);
      setState(() {
        isLoader = false;
        if(result != null){
          timetableList=result;
            print("DAY--  $_day");

            if(_day == 1){
              if(timetableList.monday!= null){
                isSelected = [true, false,false,false,false,false];
                dayList=timetableList.monday;
              }else{
                dayList=[];
              }

            }else if(_day == 2){
              if(timetableList.tuesday!= null){
                isSelected = [false,true,false,false,false,false];
                dayList=timetableList.tuesday;
              }else{
                dayList=[];
              }
            }else if(_day == 3){
              if(timetableList.wednesday!= null){
                isSelected = [false,false,true,false,false,false];
                dayList=timetableList.wednesday;
              }else{
                dayList=[];
              }
            }else if(_day == 4){
              if(timetableList.thursday!= null){
                isSelected = [false, false,false,true,false,false];
                dayList=timetableList.thursday;
              }else{
                dayList=[];
              }
            }else if(_day == 5){
              if(timetableList.friday!= null){
                isSelected = [false, false,false,false,true,false];
                dayList=timetableList.friday;
              }else{
                dayList=[];
              }
            }else if(_day == 6){
              if(timetableList.saturday!= null){
                isSelected = [false, false,false,false,false,true];
                dayList=timetableList.saturday;
              }else{
                dayList=[];
              }
            }

          // print("EMPTYPE---   ${timetableList[0].monday[0].employeeName}");
        }else{
           this.dayList=[];
        }
      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
      });
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    isSelected = [true, false,false,false,false,false];
    getSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Builder(
          builder: (context) =>
          GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                //height: MediaQuery.of(context).size.height,
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
                            title: Text("Time Table",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                        Container(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ToggleButtons(
                                        borderColor: colors.redtheme,
                                        fillColor: colors.redtheme,
                                        borderWidth: 2,
                                        selectedBorderColor: colors.redtheme,
                                        selectedColor: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'MON',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'TUE',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'WED',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'THU',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'FRI',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Text(
                                              'SAT',
                                              style: TextStyle(fontSize: 14,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                        onPressed: (int index) {
                                          setState(() {
                                            for (int i = 0; i < isSelected.length; i++) {
                                              isSelected[i] = i == index;
                                              print(isSelected);
                                              print(index);
                                              if(index == 0){
                                                if(timetableList.monday!= null){
                                                  dayList=timetableList.monday;
                                                }else{
                                                  dayList=[];
                                                }

                                              }else if(index == 1){
                                                if(timetableList.tuesday!= null){
                                                  dayList=timetableList.tuesday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 2){
                                                if(timetableList.wednesday!= null){
                                                  dayList=timetableList.wednesday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 3){
                                                if(timetableList.thursday!= null){
                                                  dayList=timetableList.thursday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 4){
                                                if(timetableList.friday!= null){
                                                  dayList=timetableList.friday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 5){
                                                if(timetableList.saturday!= null){
                                                  dayList=timetableList.saturday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }
                                            }
                                          });
                                        },
                                        isSelected: isSelected,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                  MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: dayList.isNotEmpty
                                        ? Container(
                                      child: Expanded(
                                        child: ListView.builder(
                                          itemCount: dayList.length,
                                          itemBuilder: _buildRow,
                                        ),
                                      ),
                                    )
                                        : isLoader == true
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

  Widget _buildRow(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      margin: EdgeInsets.all(8),
      child: InkWell(
        // onTap: () => onEdit(index),
        child:Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        // height: 100.0,
                          color: Colors.white,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                // Padding(padding:  new EdgeInsets.all(2.0),),
                                AnimatedContainer(
                                  padding: new EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(right: 5.0),
                                  height: 53.0,
                                  decoration: BoxDecoration(
                                      color: dayList[index].subjectName != ''? _colors[index] :  _colorsBlank[0],
                                      borderRadius:BorderRadius.circular(10),
                                      border: Border.all(color: _colors[index],width: 2,)
                                  ),
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dayList[index].periodName != null
                                          ? dayList [index].periodName
                                          : '',
                                          style:  TextStyle(color: dayList[index].subjectName != ''? Colors.white :  Colors.black,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,fontSize: 11.0),textAlign: TextAlign.left),
                                      SizedBox(height: 5.0),
                                      Expanded(
                                        child: Text(dayList[index].fromTime != null
                                            ? dayList [index].fromTime
                                            : '',
                                            style:  TextStyle(color: dayList[index].subjectName != ''? Colors.white :  Colors.black,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,fontSize: 11.0),textAlign: TextAlign.left),
                                      ),

                                    ],),

                                ),
                              ])
                      )
                  ),

                  Expanded(
                    flex: 3,
                    child: Padding(padding:  new EdgeInsets.all(1.0),
                      child:   AnimatedContainer(
                        margin: const EdgeInsets.only(right: 1.0),
                        height: 55.0,
                        decoration: BoxDecoration(
                            color: dayList[index].subjectName != ''? _colors[index] :  _colorsBlank[0],
                            borderRadius:BorderRadius.circular(10),
                            border: Border.all(color: _colors[index],width: 2,)
                        ),
                        duration: Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('',
                                style:  TextStyle(color: dayList[index].subjectName != '' ?  Colors.white: Colors.black,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,fontSize: 13.0),textAlign: TextAlign.center),
                            Text(dayList[index].subjectName != ''
                                ? dayList [index].subjectName
                                : '--',
                                style:  TextStyle(color: dayList[index].subjectName != '' ?  Colors.white: Colors.black,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,fontSize: 13.0),textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),

          ],
        ),

      ),
    );
  }
}