import 'package:educareadmin/conts/colors.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'markattendance.dart';
import 'subjectmarkattendance.dart';

class AttendanceMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AttendanceMenuState();
  }
}

class AttendanceMenuState extends State<AttendanceMenu> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);




  @override
  void initState() {
    super.initState();

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
                            title: Text("Attendance",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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

                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                     elevation: 5,
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => MarkAttendance()));
                                            },
                                          child:Container(
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                // Add one stop for each color. Stops should increase from 0 to 1
                                               // stops: [0.1, 0.5, 0.7, 0.9],
                                                colors: [
                                                  Colors.deepOrangeAccent,
                                                  Colors.red,
                                                  /*Colors.redAccent[800],
                                                  Colors.redAccent[700],
                                                  Colors.redAccent[600],
                                                  Colors.redAccent[400],*/
                                                ],
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Class Attendance",style: new TextStyle(color: colors.white,fontSize: 22.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                        SizedBox(height: 40.0,),
                                                        Text("Mark student daily attendance class wise", style: style.copyWith(color: Colors.white,fontSize: 14.0, fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w500)),
                                                      ],
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        new Center(
                                                            child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.white), onPressed: () {  },))
                                                      ],
                                                    )
                                                ),

                                              ],
                                            ),
                                          )
                                  ),
                                ),

                                Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      elevation: 5,
                                    child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => SubjectAttendance()));
                                        },
                                      child:Container(
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            // Add one stop for each color. Stops should increase from 0 to 1
                                            // stops: [0.0, 0.0, 0.7, 0.9],
                                            colors: [

                                              Colors.indigo,
                                              Colors.teal,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          children: [

                                            Expanded(
                                                flex: 8,
                                                child:Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Subject wise Attendance",style: new TextStyle(color: colors.white,fontSize: 22.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                    SizedBox(height: 40.0,),
                                                    Text("Mark student daily attendance subject wise", style: style.copyWith(color: Colors.white,fontSize: 14.0, fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w500)),
                                                  ],
                                                )
                                            ),

                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    new Center(
                                                        child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.white), onPressed: () {  },))
                                                  ],
                                                )
                                            ),




                                          ],
                                        ),
                                      )

                                    ),




                                  )




                                ]
                            )),


                      ]
                  )
              )
          ),
        )

    );

  }



}