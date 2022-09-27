import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/leavechartdata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaveChartState();
  }
}



class LeaveChartState extends State<LeaveChart> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<LeaveChartData> leavelist = <LeaveChartData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID;
  CommonAction commonAlert= CommonAction();


  //////////////////  Notices API //////////////////////
  Future<Null> leaveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listLeaveChart(empCode,"5",relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          leavelist=result.toList();
        }else{
          this.leavelist=[];
          commonAlert.messageAlertSuccess(context,'Leave not assigned.Please contact to administrator',"Leave not assigned");
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
    Future<int> sessionIdData = sfdata.getSessionId(context);
    sessionIdData.then((data) {
     // print("authToken " + data.toString());
      setState(() {
        sessionId=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
     // print("relationshipId " + data.toString());
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
        //print("empCode " + empCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
        //print("fyID " + fyID);
      });
    },onError: (e) {
      print(e);
    });
    leaveList();
    super.initState();

  }

  onRefresh() async {
    this.leaveList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }



  @override
  Widget build(BuildContext context) {
    // setState(() => context = context);
    var colors= AppColors();
    return Scaffold(
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

                      ////////////   -------- AppBar---------  ///////////////////
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Leave Chart",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                                leavelist.isNotEmpty
                                    ? Container(
                                      child: Expanded(
                                        child: ListView.builder(
                                        itemCount: leavelist.length,
                                        itemBuilder: _buildRow,
                                    ),
                                  ),
                                )
                                    : isLoader == true
                                    ? Container(
                                     margin: const EdgeInsets.all(180.0),
                                     child: Center(child: CircularProgressIndicator()))
                                    : Container(
                                         margin: const EdgeInsets.all(160.0),
                                         child: Text("",style: TextStyle(color: colors.redtheme),),
                                  // )
                                ),
                              ]
                          )),

                    ]
                )
            )
        )






    );

  }

  onEdit(index) {

  }

  Widget _buildRow(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () => onEdit(index),
        child: Column(
          children: <Widget>[
            Row(
              //mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                        //  height: 120.0,
                          padding: new EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(leavelist[index].leaveType != null
                                    ? leavelist[index].leaveType
                                    : '',
                                    maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 20.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 20.0),
                                //SizedBox(height: 7.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Allotted: ${leavelist[index].allotedLeaves}",
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("EL: ${leavelist[index].el}",
                                            textAlign: TextAlign.center,
                                            style: new TextStyle(fontSize: 11.0,color: colors.metirialgreen,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("Taken: ${leavelist[index].leaveTaken}",
                                            textAlign: TextAlign.center,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("Balance: ${leavelist[index].elbalance}",
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )

                                    ])
                              ])
                      )
                  ),



                ])

          ],
        ),
      ),
    );
  }

}