import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/leavelistapprove.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'leaveapprovedetails.dart';
import 'odLeaveapproval.dart';

class LeaveApprovals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeaveApprovalsState();
  }
}

class LeaveApprovalsState extends State<LeaveApprovals> with SingleTickerProviderStateMixin{
  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<LeaveList> leavelist = <LeaveList>[];
  List<LeaveListApprove> leavelistapproved = <LeaveListApprove>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID,leaveApprovalODPerMit=false;

  late TabController _tabController;

  //////////////////  Notices API //////////////////////
  Future<Null> leaveList() async {
    this.leavelist=[];
    this.leavelistapproved=[];
   // EasyLoading.show(status: '');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listLeave(empCode,"15",relationshipId,sessionId,fyID)
        .then((result) {
          setState(() {
          isLoader = false;
        if(result.isNotEmpty){
          for(int i=0;i<result.length;i++){
            if(result[i].status=="Pending"){
              LeaveList leaveList=new LeaveList(empName:result[i].empName,transId:result[i].transId,employeeCode:result[i].employeeCode,
                  leaveFrom:result[i].leaveFrom,leaveTo:result[i].leaveTo,leaveReason:result[i].leaveReason,remarks:result[i].remarks,
                  isApproved:result[i].isApproved,status:result[i].status,transectionId:result[i].transectionId,noOfDaysApproved:result[i].noOfDaysApproved,
                  leaveFor:result[i].leaveFor,approvedFrom:result[i].approvedFrom,approvedTo:result[i].approvedTo,firstApprovalStatus:result[i].firstApprovalStatus,
                  secondApprovalStatus:result[i].secondApprovalStatus,firstLevelEmpName:result[i].firstLevelEmpName,secondLevelEmpName:result[i].secondLevelEmpName,empApprovalLevel:result[i].empApprovalLevel, departmentCode: '', onLeaveAddress: '', voucherType: '', inAbsenceResponsibleEmployeeId: '', designationCode: '', voucherNo: '', resName: result[i].resName, onLeaveContactNo: result[i].onLeaveContactNo,
                  communicationPrefferedMode: '',fyId: 0,sessionId: 0,createdOn: result[i].createdOn,createdBy: result[i].createdBy,isLeaveRecieved:result[i].isLeaveRecieved,isDeleted: result[i].isDeleted,relationshipId:result[i].relationshipId  );
              leavelist.add(leaveList);
            }else{
              LeaveListApprove leaveList=new LeaveListApprove(empName:result[i].empName,transId:result[i].transId,employeeCode:result[i].employeeCode,
                  leaveFrom:result[i].leaveFrom,leaveTo:result[i].leaveTo,leaveReason:result[i].leaveReason,remarks:result[i].remarks,
                  isApproved:result[i].isApproved,status:result[i].status,transectionId:result[i].transectionId,noOfDaysApproved:result[i].noOfDaysApproved,
                  leaveFor:result[i].leaveFor,approvedFrom:result[i].approvedFrom,approvedTo:result[i].approvedTo,firstApprovalStatus:result[i].firstApprovalStatus,
                  secondApprovalStatus:result[i].secondApprovalStatus,firstLevelEmpName:result[i].firstLevelEmpName,secondLevelEmpName:result[i].secondLevelEmpName,empApprovalLevel:result[i].empApprovalLevel, departmentCode: '', onLeaveAddress: '', voucherType: '', inAbsenceResponsibleEmployeeId: '', designationCode: '', voucherNo: '', resName: result[i].resName, onLeaveContactNo: result[i].onLeaveContactNo,
                  communicationPrefferedMode: '',fyId: 0,sessionId: 0,createdOn: result[i].createdOn,createdBy: result[i].createdBy,isLeaveRecieved:result[i].isLeaveRecieved,isDeleted: result[i].isDeleted,relationshipId:result[i].relationshipId );
              leavelistapproved.add(leaveList);
            }
          }
          // print(leavelist[0].transId);
        }else{
          this.leavelist=[];
          this.leavelistapproved=[];
        }
      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
        this.leavelist=[];
        this.leavelistapproved=[];
      });
     // EasyLoading.dismiss();
      print(error);
    });
  }


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
    Future<bool> leaveapprovalOD = sfdata.getODApprovalPerMit(context);
    leaveapprovalOD.then((data) {
      setState(() {
        leaveApprovalODPerMit=data;
        print('NOTICE_DATA----  $leaveApprovalODPerMit');
      });
    },onError: (e) {
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Visibility(
        visible: leaveApprovalODPerMit,
        child:FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OdLeaveApproval()));
          },
          label: const Text('OD for Approvals',style: TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700),),
          icon: const Icon(Icons.thumb_up),
          backgroundColor: colors.redtheme,
        ),
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
                      ///////AppBar
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Leave for Approvals",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                           // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                                new Container(
                                  decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
                                  child: new TabBar(
                                    controller: _tabController,
                                    tabs: [
                                      new Tab(
                                        child: Text("Pending",textAlign: TextAlign.center,style: new TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                        //icon: const Icon(Icons.home),
                                       // text: 'Pending',
                                      ),
                                      new Tab(
                                        child: Text("Approved",textAlign: TextAlign.center,style: new TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                        //icon: const Icon(Icons.my_location),
                                       // text: 'Approved',
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
                                        child:leavelist.isNotEmpty ? Container(
                                        child: Expanded(
                                          child: ListView.builder(
                                            itemCount: leavelist.length,
                                            itemBuilder: _buildRow,
                                          ),
                                        ),
                                      ): isLoader == true
                                        ? Container(
                                          margin: const EdgeInsets.all(180.0),
                                          child: Center(child: CircularProgressIndicator()))
                                          : Container(
                                          margin: const EdgeInsets.all(160.0),
                                          child: Text("",style: TextStyle(color: colors.redtheme),),
                                         ),),

                                      MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child:leavelistapproved.isNotEmpty ? Container(
                                          child: Expanded(
                                            child: ListView.builder(
                                              itemCount: leavelistapproved.length,
                                              itemBuilder: _buildRowApproved,
                                            ),
                                          ),
                                        ): isLoader == true
                                            ? Container(
                                             margin: const EdgeInsets.all(180.0),
                                             child: Center(child: CircularProgressIndicator()))
                                            : Container(
                                               margin: const EdgeInsets.all(160.0),
                                               child: Text("",style: TextStyle(color: colors.redtheme),),
                                        ),),
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


  onEdit(index,BuildContext context) async{
    var rowData = this.leavelist[index];
    print("BACK_PRESS ${rowData.transId}");
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => LeaveAppDetails(rowData)),
    );

    this.leaveList();

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
        onTap: () => onEdit(index,context),
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 30.0,
                      height: 140.0,
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
                                            text: leavelist[index].firstApprovalStatus != null
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
                                    child:Container(   //
                                      color: getMyColor(leavelist[index].secondApprovalStatus),
                                      child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: leavelist[index].secondApprovalStatus!= null
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
                          height: 132.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(leavelist[index].empName != null
                                    ? leavelist[index].empName
                                    : '', maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text('Reason',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                // ignore: unnecessary_null_comparison
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
                                    ])
                              ])
                      )
                  ),
                  Container(
                      width: 35.0,
                      height: 140.0,
                      child: new Center(
                          child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist), onPressed: () {  },)
                      )
                  ),

                ])

          ],
        ),
      ),
    );
  }

  Widget _buildRowApproved(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: InkWell(
       // onTap: () => onEdit(index),
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 30.0,
                    height: 140.0,
                    child: RotatedBox(
                        quarterTurns: 3,
                        child:Row(
                          children: [
                            Expanded(
                              child:Container(
                                color: leavelistapproved[index].firstApprovalStatus == "Pending" ? colors.metirialred:colors.metirialgreen,
                                child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: leavelistapproved[index].firstApprovalStatus!= null
                                                ? leavelistapproved[index].firstApprovalStatus.toUpperCase() : '',
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
                              visible: leavelistapproved[index].secondApprovalStatus == "" ? false : true,
                              child:Expanded(
                                child:Container(
                                  color: leavelistapproved[index].secondApprovalStatus == "Pending" ? colors.metirialred:colors.metirialgreen,
                                  child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: leavelistapproved[index].secondApprovalStatus!= null
                                                  ? leavelistapproved[index].secondApprovalStatus.toUpperCase() : '',
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
                          height: 132.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(leavelistapproved[index].empName != null
                                    ? leavelistapproved[index].empName
                                    : '', maxLines: 1,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text('Reason',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(leavelistapproved[index].leaveReason != null
                                    ? leavelistapproved[index].leaveReason
                                    : '', maxLines: 1,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text('Remark',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(leavelistapproved[index].remarks != null
                                    ? leavelistapproved[index].remarks
                                    : '',
                                    maxLines: 2,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Leave From:  "+leavelistapproved[index].leaveFrom,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("Leave To:  "+leavelistapproved[index].leaveTo,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )
                                    ])
                              ])
                          )
                  ),
                  Container(
                      width: 5.0,
                      height: 140.0,
                      child: new Center(
                          child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist), onPressed: () {  },)
                      )
                  ),

                ])

          ],
        ),
      ),
    );
  }

}