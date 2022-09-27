import 'package:educareadmin/LeaveManagment/leavechart.dart';
import 'package:educareadmin/LeaveManagment/leaveform.dart';
import 'package:educareadmin/LeaveManagment/leaveformedit.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'leavedetails.dart';


enum ConfirmAction { Cancel, Accept}

class LeaveStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaveStatusState();
  }
}


class LeaveStatusState extends State<LeaveStatus> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<LeaveList> leavelist = <LeaveList>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID;
  CommonAction commonAlert= CommonAction();

  //////////////////  Leave API //////////////////////
  Future<Null> leaveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listLeave(empCode,"4",relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          leavelist=result.toList();
          print(leavelist[0].transId);
        }else{
          this.leavelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
      });
      print(error);
    });
  }

  //////////////////  leave Cancel API //////////////////////
  Future<Null> leaveCancel(String transId) async {
    // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .leaveCancel("20",transId,relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        //isLoader = false;
        if(result.isNotEmpty){
          commonAlert.messageAlertSuccess(context,"Leave application cancel successfully","Success");
        }else{
        }
      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
      });
      print(error);
    });
  }


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
    leaveList();

    super.initState();
  }

  onRefresh() async {
    this.leaveList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => LeaveForm()),
    );
    this.leaveList();
    print("BACKRESULT-- "+ result);
  }


  @override
  Widget build(BuildContext context) {
    // setState(() => context = context);
    var colors= AppColors();


    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.insert_drive_file_outlined),
          backgroundColor: colors.redtheme,
          onPressed: () {
            setState(() {
              _navigateAndDisplaySelection(context);
              /* Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreateNotice()));*/
            });
          },
        ),
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

                      ////////////   ---AppBar--- ////////////////////
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Leave Application",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                                Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     // mainAxisSize: MainAxisSize.max,
                                     // crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                     Padding(padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                                         child: GestureDetector(
                                           onTap: () {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => LeaveChart()));
                                           },
                                           child:Text('Leave Chart',
                                               textAlign: TextAlign.end,
                                               style: new TextStyle(color: colors.redtheme,fontSize: 14.0,fontFamily: 'Montserrat',
                                                   fontWeight: FontWeight.w700,decoration: TextDecoration.underline)),
                                         )
                                     ),
                                    ]),

                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child:
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
                               ),

                              ]
                          )),

                    ]
                )
            )
        )
    );

  }


  Future<Future<ConfirmAction?>> _asyncDeleteConfirm(BuildContext context, String transId) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Cancel Leave'),
          content: const Text(
              'Do you want to cancel your leave application?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Yes',style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
                leaveCancel(transId);
              },
            )
          ],
        );
      },
    );
  }


  onEdit(index) async {
    var rowData = this.leavelist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LeaveDetails(rowData),
      ),
    );

  }

  Widget _buildRow(BuildContext context, int index) {

    Color getMyColor(String moneyCounter) {
      if (moneyCounter == 'Pending'){
        return colors.yellow;
      } else if (moneyCounter == 'Rejected') {
        return colors.metirialred;
      }else{
        return colors.metirialgreen;
      }
    }


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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 30.0,
                    height: 180.0,
                    child: RotatedBox(
                        quarterTurns: 3,
                        child:Row(
                          children: [
                            Expanded(
                              child:Container(
                                color: getMyColor(leavelist[index].firstApprovalStatus),
                                child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: leavelist[index].firstApprovalStatus!= null
                                                ? leavelist[index].firstApprovalStatus.toUpperCase() : '',
                                            style: new TextStyle(color: colors.white,fontSize: 10.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),

                                        RichText(
                                          text: TextSpan(
                                            text:'1st Level',
                                            style: new TextStyle(color: colors.white,fontSize: 8.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),

                            SizedBox(width:1.0),
                            Visibility(
                              visible: leavelist[index].secondApprovalStatus == "" ? false : true,
                              child:Expanded(
                                child:Container(
                                  color: getMyColor(leavelist[index].secondApprovalStatus),
                                  child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: leavelist[index].secondApprovalStatus != null
                                                  ? leavelist[index].secondApprovalStatus.toUpperCase() : '',
                                              style: new TextStyle(color: colors.white,fontSize: 10.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:'2nd Level',
                                              style: new TextStyle(color: colors.white,fontSize: 8.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )
                    ),
                  ),

                  Expanded(
                      child: Container(
                          height: 180.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(leavelist[index].empName != null
                                    ? leavelist[index].empName
                                    : '', maxLines: 1,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text('Reason',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(leavelist[index].leaveReason != null
                                    ? leavelist[index].leaveReason
                                    : '', maxLines: 1,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text('Remark',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(leavelist[index].remarks != null ? leavelist[index].remarks : '',
                                    // textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Leave From:  "+leavelist[index].leaveFrom,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("Leave To:  "+leavelist[index].leaveTo,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )
                                    ]),

                                SizedBox(height: 4.0),
                                Visibility(
                                    visible:leavelist[index].firstApprovalStatus=='Pending'?true:false,
                                    child: Container(
                                      //width: 30.0,
                                      height: 30.0,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children:<Widget>[
                                            Expanded(
                                              child: Padding(padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 5.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _asyncDeleteConfirm(context,leavelist[index].transId);
                                                    },
                                                    child:Text("Cancel",
                                                        textAlign: TextAlign.start,
                                                        style: new TextStyle(color: colors.redtheme,fontSize: 13.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  )
                                              ),

                                            ),
                                            Expanded(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext context) => LeaveFormEdit(this.leavelist[index]),
                                                      ),
                                                    );
                                                    this.leaveList();
                                                    //print("BACKRESULTEDIT-- "+ result);
                                                  },
                                                  child: Text("Edit",
                                                      textAlign: TextAlign.end,
                                                      style: new TextStyle(color: colors.bluelight,fontSize: 13.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                )

                                            )
                                          ]),
                                    )







                                ),
                              ])
                      )
                  ),
                  Container(
                      width: 30.0,
                      height: 180.0,
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