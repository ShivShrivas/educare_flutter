import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/attendancedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentAttendanceState();
  }

}



class StudentAttendanceState extends State<StudentAttendance> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId,fyID,empCode;
  List<AttendanceData> _attendancelist = <AttendanceData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  late int currentYear,currentMonth,currentDay;

  String finalDate = '';



  List<DateTime> presentDates = [];

  List<DateTime> absentDates = [];
  List<DateTime> notMarkedDates = [];


  double presentCount=0;
  double absentCount=0;
  double notMarkedCount=0;
 late bool _isButtonDisabled;
  int press=0;




  getCurrentDate(){

    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    currentYear=dateParse.year;
    currentMonth=dateParse.month;
    currentDay=dateParse.day;

    setState(() {

      finalDate = formattedDate.toString() ;

      String _currentMonth = DateFormat.yMMM().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));

      print("CurrentMonth--- "+_currentMonth);

    });

  }

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

 // var len = min(absentDates.length, presentDates.length);
 late double cHeight;

  DateTime _myDate = DateTime.now();
  DateTime _currentDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime _currentDate2 = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  String _currentMonth = DateFormat.yMMM().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  String _currentMonthNew = DateFormat.M().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  String _currentYear = DateFormat.y().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  DateTime _targetDateTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  String _currentMonthfixed = DateFormat.M().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  /*EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2021, 6, 04): [
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

*/
  static Widget _presentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.green,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );
  static Widget _absentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.red,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _notMarkedIcon(String day) => CircleAvatar(
    backgroundColor: Colors.yellow.shade800,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );



  Map<String, double> dataMap = {
    "Present": 0,
    "Absent": 0,
    "NotMarked": 0,
  };
  List<Color> colorList = [
    Colors.green,
    Colors.red,
    Colors.yellow.shade800,
  ];

  @override
  void initState() {
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


    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
        print("empCode " + empCode);
      });
    },onError: (e) {
      print(e);
    });

    getCurrentDate();
    attendanceList();
   // diaryList();

    /*_markedDateMap.add(
        new DateTime(2021, 6, 10),
        new Event(
          date: new DateTime(2021, 6, 10),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2021, 6, 15),
        new Event(
          date: new DateTime(2021, 6, 15),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2021, 6, 22), [
      new Event(
        date: new DateTime(2021, 6, 28),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2021, 6, 22),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2021, 6, 22),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
*/

    super.initState();
  }

  //////////////////   DiaryList API  //////////////////////
  Future<Null> attendanceList() async {
    presentCount=0;
    absentCount=0;
    notMarkedCount=0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .studentAttendance("5",empCode,relationshipId,sessionId,fyID,_currentMonthNew,_currentYear)
        .then((result) {
      //print(result.length);
      isLoader = false;
      if(result.isNotEmpty){
        setState(() {
          _attendancelist =result.toList();
          for (int i = 0; i < _attendancelist.length; i++) {
            DateTime datetime= DateTime((_attendancelist[i].date).year,(_attendancelist[i].date).month,(_attendancelist[i].date).day);
            if(_attendancelist[i].abbreviation == "Present"){
              presentDates.add(datetime);
              presentCount++;
            }else if(_attendancelist[i].abbreviation == "Absent"){
              absentDates.add(datetime);
              absentCount++;
            }else{
              notMarkedDates.add(datetime);
              notMarkedCount++;
            }
          }

          dataMap["Present"] = presentCount;
          dataMap["Absent"] = absentCount;
          dataMap["NotMarked"] = notMarkedCount;
        });


      }else{
        this._attendancelist =[];
      }

    }).catchError((error) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {

    for (int i = 0; i < presentDates.length; i++) {
      _markedDateMap.add(
        presentDates[i],
        new Event(
          date: presentDates[i],
          title: 'Event 5',
          icon: _presentIcon(
            presentDates[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < absentDates.length; i++) {
      _markedDateMap.add(
        absentDates[i],
        new Event(
          date: absentDates[i],
          title: 'Event 5',
          icon: _absentIcon(
            absentDates[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < notMarkedDates.length; i++) {
      _markedDateMap.add(
        notMarkedDates[i],
        new Event(
          date: notMarkedDates[i],
          title: 'Event 5',
          icon: _notMarkedIcon(
            notMarkedDates[i].day.toString(),
          ),
        ),
      );
    }


    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
     // todayBorderColor: Colors.green,
      /*onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },*/
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
     //firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null, // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },


      height: 360.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
     // markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.red)),
      /*markedDateMoreCustomDecoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20.0),
      ),*/
      markedDateCustomTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.red,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),

      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      // return event.icon;
      // },
      // markedDateMoreShowTotal:
      // true,
      // todayButtonColor: Colors.yellow,

      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 365)),
      maxSelectedDate: _currentDate.add(Duration(days: 365)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
          _currentMonthNew = DateFormat.M().format(_targetDateTime);
          _currentYear = DateFormat.y().format(_targetDateTime);
          if(_currentMonthfixed == _currentMonthNew){
            _isButtonDisabled=true;
          }else{
            _isButtonDisabled=false;
          }
          if(press==0){
            press++;
            attendanceList();
          }

        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    var colors= AppColors();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Attendance Calendar",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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
        elevation: 5,
      ),
      body:Builder(
        builder: (context) =>
        new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                    child: Stack(
                        children: <Widget>[
                          Container(
                            // height: double.infinity ,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/loginbottom.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          new Container(
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                                    // SizedBox(height: 5.0),
                                    /*Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: _calendarCarousel,
                                ),*/
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.all(5),
                                      child: Column(children: [

                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 30.0,
                                            bottom: 16.0,
                                            left: 16.0,
                                            right: 16.0,
                                          ),
                                          child: new Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    _currentMonth,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24.0,
                                                    ),
                                                  )),
                                              FlatButton(
                                                child: Text('PREV'),
                                                onPressed: () {
                                                  setState(() {
                                                    press=0;
                                                    _targetDateTime = DateTime(
                                                        _targetDateTime.year, _targetDateTime.month - 1);
                                                    _currentMonth =
                                                        DateFormat.yMMM().format(_targetDateTime);
                                                  });
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('NEXT'),
                                                onPressed: () {
                                                  if(_isButtonDisabled==false){

                                                    setState(() {
                                                      press=0;
                                                      _targetDateTime = DateTime(
                                                          _targetDateTime.year, _targetDateTime.month + 1);
                                                      _currentMonth =
                                                          DateFormat.yMMM().format(_targetDateTime);
                                                    });
                                                  }

                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: _calendarCarouselNoHeader,
                                        ),
                                      ],),

                                    ),
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.all(5),
                                      child:Container(
                                        height: 220.0,
                                        child:Center(
                                          child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children:<Widget>[

                                                      Expanded(
                                                        child: Container(
                                                          color: colors.green,
                                                          child:Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  new Text("$presentCount",
                                                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                                  ),
                                                                  new Text("Present",
                                                                    style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                                  ),

                                                                ]),
                                                          ),
                                                        ),

                                                      ),

                                                      Expanded(
                                                        child:Padding(
                                                          padding: const EdgeInsets.only(left: 10.0),
                                                          child: Container(
                                                            color: colors.redtheme,
                                                            child:Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    new Text("$absentCount",
                                                                      style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700,color: colors.white ),
                                                                    ),
                                                                    new Text("Absent",
                                                                      style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700,color: colors.white ),
                                                                    ),

                                                                  ]),
                                                            ),
                                                          ),

                                                        ),),

                                                      Expanded(
                                                        child:Padding(
                                                          padding: const EdgeInsets.only(left: 10.0),
                                                          child: Container(
                                                            color: Colors.yellow.shade800,
                                                            child:Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    new Text("$notMarkedCount",
                                                                      style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700,color: colors.white ),
                                                                    ),
                                                                    new Text("NotMarked",
                                                                      style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700,color: colors.white ),
                                                                    ),

                                                                  ]),
                                                            ),),
                                                        ),),


                                                      /* Expanded(
                                                     child:Padding(
                                                         padding: const EdgeInsets.only(left: 10.0),
                                                     child: Column(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         new Text("Present -  $presentCount",
                                                           style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                               fontWeight: FontWeight.w700,color: colors.green ),
                                                         ),
                                                         SizedBox(height: 10.0,),
                                                         new Text("Absent -  $absentCount",
                                                           style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                               fontWeight: FontWeight.w700,color: colors.redtheme ),
                                                         ),
                                                         SizedBox(height: 10.0,),
                                                         new Text("NotMarked -  $notMarkedCount",
                                                           style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                               fontWeight: FontWeight.w700,color: colors.yellow ),
                                                         ),
                                                        // markerRepresent(Colors.red, "Absent",absentCount),
                                                        // markerRepresent(Colors.green, "Present",presentCount),
                                                        // markerRepresent(Colors.yellow, "NotMarked",notMarkedCount),
                                                       ],)
                                                     ),
                                                 ),

                                                */

                                                    ]),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(children: [
                                                          SizedBox(height: 20.0),
                                                          PieChart(
                                                            dataMap: dataMap,
                                                            animationDuration: Duration(milliseconds: 8000),
                                                            chartLegendSpacing: 50,
                                                            chartRadius: MediaQuery.of(context).size.width / 3.2,
                                                            colorList: colorList,
                                                            initialAngleInDegree: 0,
                                                            chartType: ChartType.ring,
                                                            ringStrokeWidth: 35,
                                                            // centerText: "HYBRID",
                                                            legendOptions: LegendOptions(
                                                              showLegendsInRow: false,
                                                              legendPosition: LegendPosition.right,
                                                              showLegends: true,
                                                              //legendShape: _BoxShape.circle,
                                                              legendTextStyle: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            chartValuesOptions: ChartValuesOptions(
                                                              showChartValueBackground: true,
                                                              showChartValues: true,
                                                              showChartValuesInPercentage: true,
                                                              showChartValuesOutside: true,
                                                              decimalPlaces: 1,
                                                            ),
                                                          )
                                                        ],)
                                                    ),

                                                  ],)

                                              ]),
                                        ),
                                      ),
                                    ),

                                    //custom icon without header

                                  ]
                              )
                          ),

                        ]
                    )
                )







            )

        ),
      ),



    );
  }

  Widget markerRepresent(Color color, String data,double count) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: 8.0,
      ),
      title: new Text(data,
          style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700),
      ),
      subtitle: new Text(count.toString(),
        style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700),
      ),
    );
  }

}