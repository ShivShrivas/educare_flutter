

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/empleavedata.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveDetails extends StatefulWidget {

  CommonAction common= CommonAction();

  LeaveDetails(this.leaveData) : super();

  final LeaveList leaveData;



  @override
  State<StatefulWidget> createState() {
    return LeaveDetailsState();
  }
}


class LeaveDetailsState extends State<LeaveDetails> {

  var showSheet=2;

  List<EmpleaveData> userleavelist = <EmpleaveData>[];
  late EmpleaveData userleavelistCode;

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var empCode,fyID;

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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

    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
        print("fyID " + fyID);
      });
    },onError: (e) {
      print(e);
    });

   // print(" LEVEL--  ${widget.leaveData.secondLevelEmpName}");

    leaveStatusList();
    super.initState();
  }


  //////////////////  leaveTypeList API //////////////////////
  Future<Null> leaveStatusList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    //isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listStatusChart("14",widget.leaveData.transId,relationshipId,sessionId,fyID)
        .then((result) {
      EasyLoading.dismiss();
      setState(() {
        // isLoader = false;
        if(result.isNotEmpty){
          userleavelist=result.toList();
        }else{
          this.userleavelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        EasyLoading.dismiss();
        // isLoader = false;
      });
      print(error);
    });
  }








  @override
  Widget build(BuildContext context) {

    CommonAction common= CommonAction();
    var colors= AppColors();




    Color getMyColor(String moneyCounter) {
      if (moneyCounter == 'Pending'){
        return colors.yellow;
      } else if (moneyCounter == 'Rejected') {
        return colors.metirialred;
      }else{
        return colors.metirialgreen;
      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Application Details",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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

      body: SingleChildScrollView(
        child: Container(
            child: new Container(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                          Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: 35.0,
                                       // color: widget.leaveData.status == "Pending" ? colors.metirialred:colors.metirialgreen,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:Container(
                                                color: getMyColor(widget.leaveData.firstApprovalStatus),
                                                child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text:widget.leaveData.firstApprovalStatus!= null
                                                                ? widget.leaveData.firstApprovalStatus.toUpperCase() : '',
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text:'1st Level',
                                                            style: new TextStyle(color: colors.white,fontSize: 9.0,fontFamily: 'Montserrat',
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
                                              visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                                              child:Expanded(
                                                child:Container(
                                                  color: getMyColor(widget.leaveData.secondApprovalStatus),
                                                  child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: widget.leaveData.secondApprovalStatus!= null
                                                                  ? widget.leaveData.secondApprovalStatus.toUpperCase() : '',
                                                              style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:'2nd Level',
                                                              style: new TextStyle(color: colors.white,fontSize: 9.0,fontFamily: 'Montserrat',
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
                                    SizedBox(height: 5.0),
                                    Padding(
                                      padding: new EdgeInsets.all(10.0),
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.max,
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                        Row(
                                         children: <Widget>[
                                            Text('Reason',maxLines: 1,
                                            style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                           ]),
                                            Row(
                                                children: <Widget>[
                                                  Expanded(
                                                   child: Text(widget.leaveData.leaveReason != null
                                                      ? widget.leaveData.leaveReason
                                                      : '',
                                                      //maxLines: 1,
                                                      // textAlign: TextAlign.justify,
                                                      style: new TextStyle(color: colors.blue,fontSize: 13.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                   ),
                                                ]),
                                            SizedBox(height: 15.0),
                                            Row(
                                                children: <Widget>[
                                                  Text('Remark',maxLines: 1,
                                                      style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ]),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Expanded(
                                                    child:Text(widget.leaveData.remarks != null
                                                        ? widget.leaveData.remarks
                                                        : '',
                                                        style: new TextStyle(color:colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                ]),

                                            SizedBox(height: 15.0),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Expanded(
                                                    child:Text(widget.leaveData.resName != null
                                                        ? 'Responsible - '+widget.leaveData.resName
                                                        : '',
                                                        // maxLines: 5,
                                                        // textAlign: TextAlign.justify,
                                                        style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                ]),
                                            SizedBox(height: 15.0),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                //mainAxisSize: MainAxisSize.max,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child:Text(widget.leaveData.resName != null
                                                        ? 'Contact No.- '+widget.leaveData.onLeaveContactNo
                                                        : '',
                                                        // maxLines: 5,
                                                        // textAlign: TextAlign.justify,
                                                        style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                ]),
                                            SizedBox(height: 15.0),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                //mainAxisSize: MainAxisSize.max,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child:Text(widget.leaveData.leaveFor != null
                                                        ? 'Leave For- '+ common.leavefordata(context, widget.leaveData.leaveFor)
                                                        : '',style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                ]),

                                            SizedBox(height: 15.0),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children:<Widget>[
                                                  Expanded(
                                                    child: Text(widget.leaveData.leaveFrom != null ? "From Date: "+widget.leaveData.leaveFrom:'',
                                                        textAlign: TextAlign.start,
                                                        style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                  Expanded(
                                                    child: Text(widget.leaveData.leaveTo != null ? "To Date: "+widget.leaveData.leaveTo :'',
                                                        textAlign: TextAlign.end,
                                                        style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  )

                                                ]),

                                            Visibility(
                                              visible: widget.leaveData.status == "Pending" ? false: true,
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      SizedBox(height: 25.0),
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          //mainAxisSize: MainAxisSize.max,
                                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:Text('--------- Approval Details ---------',
                                                                  // maxLines: 5,
                                                                  textAlign: TextAlign.center,
                                                                  style: new TextStyle(color: colors.green,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                            ),
                                                          ]),

                                                      SizedBox(height: 20.0),
                                                      Container(
                                                          height: 35.0,
                                                          // color: widget.leaveData.status == "Pending" ? colors.metirialred:colors.metirialgreen,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:Container(
                                                                  child: Center(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          RichText(
                                                                            text: TextSpan(
                                                                              text:widget.leaveData.firstLevelEmpName != ''
                                                                                  ? widget.leaveData.firstLevelEmpName: '',
                                                                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            text: TextSpan(
                                                                              text:'1st Approval',
                                                                              style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                                                                  fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width:1.0),

                                                              Expanded(
                                                                  child:Container(
                                                                    child: Center(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                text: widget.leaveData.secondLevelEmpName == ''
                                                                                    ? 'Not assigned' : widget.leaveData.secondLevelEmpName,
                                                                                style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                text:'2nd Approval',
                                                                                style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )

                                                                    ),
                                                                  ),

                                                                ),
                                                            ],
                                                          )
                                                      ),

                                                      SizedBox(height: 20.0),
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text(widget.leaveData.approvedFrom != null
                                                                  ? 'Approved From: '+widget.leaveData.approvedFrom
                                                                  : '',
                                                                  textAlign: TextAlign.start,
                                                                  style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                            ),

                                                            Expanded(
                                                              child: Text(widget.leaveData.approvedTo !=null ?"Approved To: "+widget.leaveData.approvedTo :'',
                                                                  textAlign: TextAlign.end,
                                                                  style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                            )

                                                          ]),

                                                      SizedBox(height: 20.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if(showSheet==1){
                                                              showSheet=2;
                                                            }else{
                                                              showSheet=1;
                                                            }
                                                          });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              child:Text("Day wise status",
                                                                  //maxLines: 5,
                                                                  //textAlign: TextAlign.center,
                                                                  style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 25.0,
                                                                child:Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child:Image.asset(showSheet == 1 ? "assets/uparrow.png" : "assets/downarrow.png",
                                                                    fit: BoxFit.contain,
                                                                  ) ,
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),

                                                  Visibility(
                                                   visible: showSheet == 1 ? false:true,
                                                   child: Column(
                                                     children: [
                                                       SizedBox(height: 10.0),
                                                    Container(
                                                      color: colors.greylight,
                                                      child: Row(
                                                           crossAxisAlignment: CrossAxisAlignment.center,
                                                           mainAxisAlignment: MainAxisAlignment.start,
                                                           children: <Widget>[
                                                             Expanded(
                                                               flex: 1,
                                                               child: Center(
                                                                   child: Column(
                                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                                     children: [
                                                                       Text('Date',
                                                                           maxLines: 1,
                                                                           //textAlign: TextAlign.start,
                                                                           style: new TextStyle(color: colors.blue,fontSize: 8.0,fontFamily: 'Montserrat',
                                                                               fontWeight: FontWeight.w700)),
                                                                     ],
                                                                   )
                                                               ),
                                                             ),
                                                             Visibility(
                                                               visible: true,
                                                               child: Expanded(
                                                                   flex: 1,
                                                                   child: new Container(
                                                                    // height: 35.0,
                                                                     margin: const EdgeInsets.all(1.0),
                                                                     padding: const EdgeInsets.all(2.0),
                                                                     child: Center(
                                                                       child: Text('Leave Type',
                                                                           maxLines: 1,
                                                                           textAlign: TextAlign.center,
                                                                           style: new TextStyle(color:colors.blue,fontSize: 8.0,fontFamily: 'Montserrat',
                                                                               fontWeight: FontWeight.w700)),
                                                                     ),
                                                                   )
                                                               ),
                                                             ),

                                                             Visibility(
                                                               visible: true,
                                                               child: Expanded(
                                                                   flex: 1,
                                                                   child: new Container(
                                                                     //height: 35.0,
                                                                     margin: const EdgeInsets.all(1.0),
                                                                     padding: const EdgeInsets.all(2.0),
                                                                     child: Center(
                                                                       child: Text('1st Level Status',
                                                                           maxLines: 1,
                                                                           textAlign: TextAlign.center,
                                                                           style: new TextStyle(color:colors.blue,fontSize: 8.0,fontFamily: 'Montserrat',
                                                                               fontWeight: FontWeight.w700)),
                                                                     ),
                                                                   )
                                                               ),
                                                             ),

                                                             Visibility(
                                                               visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                                                               child: Expanded(
                                                                   flex: 1,
                                                                   child: new Container(
                                                                    // height: 35.0,
                                                                     margin: const EdgeInsets.all(1.0),
                                                                     padding: const EdgeInsets.all(2.0),

                                                                     child: Center(
                                                                       child: Text('Leave Type',
                                                                           maxLines: 1,
                                                                           textAlign: TextAlign.center,
                                                                           style: new TextStyle(color:colors.blue,fontSize: 8.0,fontFamily: 'Montserrat',
                                                                               fontWeight: FontWeight.w700)),
                                                                     ),
                                                                   )
                                                               ),
                                                             ),

                                                             Visibility(
                                                               visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                                                               child: Expanded(
                                                                   flex: 1,
                                                                   child: new Container(
                                                                    // height: 35.0,
                                                                     margin: const EdgeInsets.all(1.0),
                                                                     padding: const EdgeInsets.all(2.0),
                                                                     child: Center(
                                                                       child: Text('2nd Level Status',
                                                                           maxLines: 1,
                                                                           textAlign: TextAlign.center,
                                                                           style: new TextStyle(color:colors.blue,fontSize: 8.0,fontFamily: 'Montserrat',
                                                                               fontWeight: FontWeight.w700)),
                                                                     ),
                                                                   )
                                                               ),
                                                             ),

                                                            ]),
                                                        ),

                                                       ////////////////////// List
                                                       Container(
                                                         //height: 100,
                                                         child: MediaQuery.removePadding(
                                                           context: context,
                                                           removeTop: true,
                                                           child:SingleChildScrollView(
                                                             physics: ScrollPhysics(),
                                                             child: Column(
                                                               children: <Widget>[
                                                                 ListView.builder(
                                                                     physics: NeverScrollableScrollPhysics(),
                                                                     shrinkWrap: true,
                                                                     itemCount:userleavelist.length,
                                                                     itemBuilder: _buildRowSecond
                                                                 )
                                                               ],
                                                             ),
                                                           ),
                                                         ),
                                                       ),

                                                     ],
                                                   ),


                                                ),

                                              ])

                                            ),


                                          ]),

                                    ),
                                  ])
                          )
                        ]),

                  ),



        ),

      ),
    );


  }


  Widget _buildRowSecond(BuildContext context, int index) {
    var colors= AppColors();
    return Card(
      clipBehavior: Clip.antiAlias,
      // margin: EdgeInsets.all(5),
      child: InkWell(
         // onTap: () => onEdit(index),
          child: Padding(
            padding:EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(userleavelist[index].dateData != null
                                    ? userleavelist[index].dateData: '',
                                    maxLines: 1,
                                    //textAlign: TextAlign.start,
                                    style: new TextStyle(color: Colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ],
                            )
                        ),
                      ),

                      Visibility(
                        visible: true,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: Text(userleavelist[index].leaveTypeName!= null
                                    ? userleavelist[index].leaveTypeName!: '',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color: Colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: true,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                             // height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: Text(userleavelist[index].firstIsApproved == "1" ? "Approved": 'Reject',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color:userleavelist[index].firstIsApproved == "1"
                                        ?Colors.green:Colors.red,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                             // height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: Text(userleavelist[index].secondLeaveTypeName! == null ? "": userleavelist[index].secondLeaveTypeName!,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color:colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                             // height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: Text(userleavelist[index].secondIsApproved == "1" ? "Approved": 'Reject',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color:userleavelist[index].secondIsApproved == "1"
                                        ?Colors.green:Colors.red,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                    ])

              ],
            ),
          )

      ),
    );
  }




}