import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/employeedata.dart';
import 'package:educareadmin/models/timetabledata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfData.dart';
import 'package:educareadmin/syllabus/chapterlist.dart';
import 'package:expandable_group/expandable_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeTableAdmin extends StatefulWidget {

  TimeTableAdmin(this.empData) : super();

  final EmpData empData;


  @override
  State<StatefulWidget> createState() {
    return TimeTableAdminState();
  }
}

class TimeTableAdminState extends State<TimeTableAdmin> {

  var colors= AppColors();
  bool isLoader = false;
  bool allVisible = false;
  final RefreshController _refreshController = RefreshController();

  late TimeTableData timetableList;
  List<Day> dayList = [];
  List<List<Day>> dayListAll = [];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var fyID;
  var saveuseId;

  var _day=DateTime.now().weekday;



  List<UserType> userlist = <UserType>[];
  late UserType selectedUserCode;
  late String userCode;
  var sendusertypeId=1,empCode;
  TextEditingController _textController = TextEditingController();
  late List<bool> isSelected;
  late List<dynamic> isWeekDays;


  List<Color> _colors = [Colors.redAccent,Colors.cyan, Colors.green, Colors.lightBlue,Colors.indigoAccent,Colors.teal,Colors.redAccent,Colors.green,Colors.orangeAccent,Colors.indigo,Colors.lightGreen,Colors.lightBlue, Colors.amberAccent, Colors.pinkAccent,Colors.indigoAccent,Colors.green,Colors.lightBlue, Colors.amberAccent, Colors.cyan,Colors.indigoAccent,Colors.green,Colors.redAccent,Colors.teal,Colors.green,Colors.redAccent,Colors.teal,Colors.orangeAccent,Colors.indigo];

  List<Color> _colorsBlank = [Colors.white,Colors.black];

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
        if(widget.empData.employeeCode!=null){
          empCode=widget.empData.employeeCode;
        }
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
        .gettimetableList(empCode,"",relationshipId,sessionId)
        .then((result) {
      //print(result.length);
      setState(() {
        isLoader = false;
        if(result != null){
          timetableList=result;

          if(timetableList.monday!= null){
            dayListAll.add(timetableList.monday);
          }else{
            dayListAll.add(dayList);
          }

          if(timetableList.tuesday!= null){
            dayListAll.add(timetableList.tuesday);
          }else{
            dayListAll.add(dayList);
          }
          if(timetableList.wednesday!= null){
            dayListAll.add(timetableList.wednesday);
          }else{
            dayListAll.add(dayList);
          }
          if(timetableList.thursday!= null){
            dayListAll.add(timetableList.thursday);
          }else{
            dayListAll.add(dayList);
          }
          if(timetableList.friday!= null){
            dayListAll.add(timetableList.friday);
          }else{
            dayListAll.add(dayList);
          }
          if(timetableList.saturday!= null){
            dayListAll.add(timetableList.saturday);
          }else{
            dayListAll.add(dayList);
          }


          if(_day == 1){
            if(timetableList.monday!= null){
              isSelected = [true, false,false,false,false,false,false];
              dayList=timetableList.monday;
            }else{
              dayList=[];
            }

          }else if(_day == 2){
            if(timetableList.tuesday!= null){
              isSelected = [false,true,false,false,false,false,false];
              dayList=timetableList.tuesday;
            }else{
              dayList=[];
            }
          }else if(_day == 3){
            if(timetableList.wednesday!= null){
              isSelected = [false,false,true,false,false,false,false];
              dayList=timetableList.wednesday;
            }else{
              dayList=[];
            }
          }else if(_day == 4){
            if(timetableList.thursday!= null){
              isSelected = [false, false,false,true,false,false,false];
              dayList=timetableList.thursday;
            }else{
              dayList=[];
            }
          }else if(_day == 5){
            if(timetableList.friday!= null){
              isSelected = [false,false,false,false,true,false,false];
              dayList=timetableList.friday;
            }else{
              dayList=[];
            }
          }else if(_day == 6){
            if(timetableList.saturday!= null){
              isSelected = [false,false,false,false,false,true,false];
              dayList=timetableList.saturday;
            }else{
              dayList=[];
            }
          }else{
            isSelected = [false,false,false,false,false,false,true];
            dayList=timetableList.saturday;
          }
        // print("EMPTYPE---   ${timetableList[0].monday[0].employeeName}");
        }else{
         // this.dayList;
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
    isWeekDays=["MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY"];
    isSelected = [true,false,false,false,false,false,false];
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
                //height: MediaQuery.of(context).size.height,
                  child: Stack(
                      children: <Widget>[
                        Container(
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
                            title: Text("Time Table".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'MON',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'TUE',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'WED',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'THU',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'FRI',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'SAT',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'ALL',
                                              style: TextStyle(fontSize: 11,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
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
                                                allVisible=false;
                                                if(timetableList.monday!= null){
                                                  dayList=timetableList.monday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 1){
                                                allVisible=false;
                                                if(timetableList.tuesday!= null){
                                                  dayList=timetableList.tuesday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 2){
                                                allVisible=false;
                                                if(timetableList.wednesday!= null){
                                                  dayList=timetableList.wednesday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 3){
                                                allVisible=false;
                                                if(timetableList.thursday!= null){
                                                  dayList=timetableList.thursday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 4){
                                                allVisible=false;
                                                if(timetableList.friday!= null){
                                                  dayList=timetableList.friday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 5){
                                                allVisible=false;
                                                if(timetableList.saturday!= null){
                                                  dayList=timetableList.saturday;
                                                }else{
                                                  dayList=[];
                                                }
                                              }else if(index == 6){
                                                allVisible=true;
                                              }else{


                                              }
                                            }
                                          });
                                        },
                                        isSelected: isSelected,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                  Visibility(
                                      visible: allVisible == false ? true: false,
                                      child:MediaQuery.removePadding(
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
                                              margin: const EdgeInsets.all(50.0),
                                              child: Center(child: CircularProgressIndicator()))
                                            : Container(
                                              margin: const EdgeInsets.all(150.0),
                                              child: Text(""),
                                        ),
                                      ),
                                  ),

                                  Visibility(
                                    visible: allVisible ==false ? false: true,
                                    child:MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: dayList.isNotEmpty
                                          ? Container(
                                           child: Expanded(
                                             child: ListView(
                                                 shrinkWrap: true,
                                                 children: <Widget>[
                                                 Container(
                                                  decoration: BoxDecoration(
                                                  color: colors.greylight,
                                                  borderRadius:BorderRadius.circular(10),
                                                   //border: Border.all(color: _colors[index],width: 2,)
                                                  ),
                                                   child: Column(
                                                         children:isWeekDays.map((e) {
                                                         int index = isWeekDays.indexOf(e);
                                                         return ExpandableGroup(
                                                           isExpanded: index == 0,
                                                           header: _header(isWeekDays[index]),
                                                           items: _buildItems(context, dayListAll[index],index),
                                                           headerEdgeInsets: EdgeInsets.only(left: 16.0, right: 16.0),
                                                         );
                                                       }).toList(),
                                                     ),
                                                 )
                                             ]
                                          ),
                                        ),
                                      )
                                          : isLoader == true
                                          ? Container(
                                             margin: const EdgeInsets.all(50.0),
                                            child: Center(child: CircularProgressIndicator()))
                                            : Container(
                                             margin: const EdgeInsets.all(150.0),
                                              child: Text(""),
                                      ),
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



  List<ListTile> _buildItems(BuildContext context, List<Day> items, int index) => items
      .map((e) => ListTile(
       title: Container(
         margin: const EdgeInsets.only(right: 1.0),
         height: 40.0,
         decoration: BoxDecoration(
             color: e.subjectName != ''? _colors[index] :  _colorsBlank[0],
             borderRadius:BorderRadius.circular(10),
             border: Border.all(color: _colors[index],width: 2,)
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(e.dayClass != ''
                 ? "(${e.dayClass})     "
                 : '',
                 style:  TextStyle(color: e.subjectName != '' ?  Colors.white: Colors.black,fontFamily: 'Montserrat',
                     fontWeight: FontWeight.w600,fontSize: 12.0),textAlign: TextAlign.center),
             Text(e.subjectName != ''
                 ? e.subjectName
                 : '--',
                 style:  TextStyle(color: e.subjectName != '' ?  Colors.white: Colors.black,fontFamily: 'Montserrat',
                     fontWeight: FontWeight.w600,fontSize: 12.0),textAlign: TextAlign.center),
           ],
         ),
       ),

       leading: Container(
         padding: new EdgeInsets.all(5.0),
         margin: const EdgeInsets.all(2.0),
         decoration: BoxDecoration(
             color: e.subjectName != ''? _colors[index] :  _colorsBlank[0],
             borderRadius:BorderRadius.circular(10),
             border: Border.all(color: _colors[index],width: 2,)
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           //mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(height: 2.0),
             Text(e.periodName != null
                 ? e.periodName
                 : '', style:  TextStyle(color: e.subjectName != ''? Colors.white : Colors.black,fontFamily: 'Montserrat',
                     fontWeight: FontWeight.w600,fontSize: 11.0),textAlign: TextAlign.left),

             SizedBox(height: 5.0),
          Expanded(
           child:Text(e.fromTime != null
               ? e.fromTime
               : '', style:  TextStyle(color: e.subjectName != ''? Colors.white :  Colors.black,fontFamily: 'Montserrat',
               fontWeight: FontWeight.w600,fontSize: 11.0),textAlign: TextAlign.left),
         ),

             ],),
          ),
      ))
      .toList();

   Widget _header(String name) =>  Text(name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ));


  onEdit(index) async {
    var rowData = this.dayList[index];
    if(rowData.subjectName !=""){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ChapterList(rowData),
        ),
      );
    }
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
        onTap: () => onEdit(index),
        child:Column(
          children: <Widget>[
            Row(
                children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                        //height: 100.0,
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
                                   Text(dayList[index].dayClass != ''
                                       ? "(${dayList [index].dayClass})     "
                                       : '',
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