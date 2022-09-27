import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/employeedata.dart';
import 'package:educareadmin/models/classsectiondata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'timetable.dart';
import 'timetableadmin.dart';

class TimeTableClass extends StatefulWidget {

  CommonAction common= CommonAction();

  @override
  State<StatefulWidget> createState() {
    return TimeTableClassState();
  }
}

class TimeTableClassState extends State<TimeTableClass> with SingleTickerProviderStateMixin{
  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<ClassSectionData> classlist = <ClassSectionData>[];
  List<EmpData> employeeList = <EmpData>[];
  EmployeData? _employeData;
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID,userID;

  late TabController _tabController;



  @override
  void initState() {
    _tabController = new TabController(length: 2,vsync: this);
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
    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
        print("empCode " + empCode);
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

    Future<int> userIdData = sfdata.getUseId(context);
    userIdData.then((data) {
      setState(() {
        userID=data.toString();
      });
    },onError: (e) {
      print(e);
    });
    classList();

    employeList();

    super.initState();
  }


  //////////////////  Class List Api //////////////////////
  Future<Null> classList() async {
    //EasyLoading.show(status: 'Loading');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listclass("4",relationshipId,sessionId,fyID,userID)
        .then((result) {
        setState(() {
       // EasyLoading.dismiss();
        if(result.isNotEmpty){
          classlist=result;
        }else{
          this.classlist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
        this.classlist=[];
      });
     // EasyLoading.dismiss();
      print(error);
    });
  }


  //////////////////  Employee List Api //////////////////////
  Future<Null> employeList() async {
    EasyLoading.show(status: 'Loading');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listemployee("7",relationshipId,sessionId,fyID)
        .then((result) {
      print(result);
      setState(() {
        EasyLoading.dismiss();
        if(result.table!.isNotEmpty){
          employeeList=result.table!;
        }else{
          this.employeeList=[];
        }
      });
    }).catchError((error) {
      setState(() {
        EasyLoading.dismiss();
        //isLoader = false;
        this.employeeList=[];
      });
      EasyLoading.dismiss();
      print(error);
    });
  }



  onRefresh() async {
  //  this.leaveList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() => context = context);
    var colors= AppColors();
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,


        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () => onRefresh(),
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
                      ///////AppBar
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
                      new Container(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                                new Container(
                                  decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
                                  child: new TabBar(
                                    controller: _tabController,
                                    tabs: [
                                      new Tab(
                                        child: Text("Class Wise",textAlign: TextAlign.center,style: new TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                      ),

                                      new Tab(
                                        child: Text("Employee Wise",textAlign: TextAlign.center,style: new TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                ),
                                new Expanded(
                                  // height: 80.0,
                                  child: new TabBarView(
                                    controller: _tabController,
                                    children: <Widget>[
                                      MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child:classlist.isNotEmpty ? Container(
                                          child: Expanded(
                                            child: ListView.builder(
                                              itemCount: classlist.length,
                                              itemBuilder: _buildRow,
                                            ),
                                          ),
                                        ): isLoader == true
                                            ? Container(
                                             margin: const EdgeInsets.all(160.0),
                                               child: Center(child: CircularProgressIndicator()))
                                            : Container(
                                             margin: const EdgeInsets.all(160.0),
                                               child: Text("",style: TextStyle(color: colors.redtheme),),
                                        ),),


                                    MediaQuery.removePadding(
                                     context: context,
                                     removeTop: true,
                                     child: new GridView.count(
                                      crossAxisCount: 3,
                                      children: new List<Widget>.generate(employeeList.length, (index) {
                                      return new GridTile(
                                      child: new Card(
                                      elevation: 3,
                                      margin: EdgeInsets.all(5),
                                     // color: Colors.blue.shade200,
                                      child:InkWell(
                                       onTap: () => onEditGrid(index,context),
                                       child:new Center(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [

                                             SizedBox(
                                               height: 70.0,
                                               width: 70.0,
                                               child: Hero(
                                                   tag: 'image',
                                                   child: CircleAvatar(
                                                     backgroundColor: Colors.white,
                                                     radius: 140,
                                                     child: CircleAvatar(
                                                         backgroundImage: AssetImage('assets/profileblank.png'),
                                                          foregroundImage: NetworkImage(employeeList[index].employeePhotoPath == null ?'': '${colors.imageUrl}${employeeList[index].employeePhotoPath.replaceAll("..", '')}'),
                                                        // foregroundImage: NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'),
                                                         onBackgroundImageError: (exception, stackTrace) {
                                                           setState(() {
                                                             // this.profilePicUrl = null;
                                                           });
                                                         },
                                                         radius: 70,
                                                         backgroundColor: Colors.white), //'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'
                                                   )
                                               ),
                                             ), //'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'

                                             SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                             Text(employeeList[index].displayName!,
                                                 textAlign: TextAlign.center,
                                                 style: new TextStyle(color: colors.blue,fontSize: 10.0,fontFamily: 'Montserrat',
                                                     fontWeight: FontWeight.w700,)),


                                           ],
                                         ),
                                       ),

                                      ),




                                   ),
                                   );
                                  }),

                                  ),
                                  ),




                                    ],
                                  ),
                                ),


                              ]
                          )),
                    ]
                )
            )
        )






    );

  }

  onEditGrid(index,BuildContext context) async{
    var rowData = this.employeeList[index];
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TimeTableAdmin(rowData)));
    /*final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => LeaveAppDetails(rowData)),
    );*/
  }

  onEdit(index,BuildContext context) async{
    var rowData = this.classlist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TimeTableClassSection(rowData),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 2,
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () => onEdit(index,context),
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          height: 40.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text('   ${classlist[index].className!}  ${classlist[index].sectionName!}', maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ])
                      )
                  ),
                  Container(
                      width: 30.0,
                      child: new Center(
                          child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist,size: 18.0), onPressed: () {

                          },)

                      )
                  ),

                ])

          ],
        ),
      ),
    );
  }


}