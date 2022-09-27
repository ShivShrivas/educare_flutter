import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/feemodel.dart';
import 'package:educareadmin/models/feestructure.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/leavelistapprove.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeesDues extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeesDuesState();
  }
}

class FeesDuesState extends State<FeesDues> with SingleTickerProviderStateMixin{
  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<FeeModel> leavelist = <FeeModel>[];
  List<FeeStructure> feeInstallmentlistOne = <FeeStructure>[];
  List<FeeInstallment> feeInstallmentlist = <FeeInstallment>[];
  FeeInstallment? feeInstallment;

  List<LeaveListApprove> leavelistapproved = <LeaveListApprove>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID;
  bool addRemove=true;
  double totalpayable=0.0;
  int totalvisible=1;
  late TabController _tabController;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  CommonAction commonAlert= CommonAction();



  //////////////////  Fee Installment Api //////////////////////
  Future<Null> installmentList() async {
     EasyLoading.show(status: 'Loading');
     SharedPreferences preferences = await SharedPreferences.getInstance();
     // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listFee(empCode,"11",relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        EasyLoading.dismiss();
        if(result.feeInstallment.isNotEmpty){
         // result[0].table?[0].feeDetails?[0];
         // feeInstallment=result.feeInstallment;

          feeInstallmentlist=result.feeInstallment;
          feeInstallmentlistOne=result.feeStructure.toList();
        }else{
          this.feeInstallmentlist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
        this.feeInstallmentlist=[];
      });
      EasyLoading.dismiss();
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

    installmentList();
    super.initState();
  }

  onRefresh() async {
    //this.leaveList();
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
                      ///////AppBar
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Fee Pay",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: feeInstallmentlist.isNotEmpty
                                    ? Container(
                                      child: Expanded(
                                        child: ListView.builder(
                                          itemCount: feeInstallmentlist.length,
                                          itemBuilder: _buildRow,
                                    ),
                                  ),
                                )
                                    : isLoader == true
                                    ? Container(
                                     margin: const EdgeInsets.all(180.0),
                                     child: Center(child: CircularProgressIndicator()))
                                     : Container(
                                       margin: const EdgeInsets.all(170.0),
                                       child: Text(""),
                                )),


                                Visibility(
                                    visible: totalvisible == 1?false:true,
                                    child: new Container(
                                      height: 100,
                                      color: colors.greylight,
                                      child: Padding(
                                        padding: new EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('₹ $totalpayable', maxLines: 1,
                                                        // textAlign: TextAlign.justify,
                                                        style: new TextStyle(color: colors.blue,fontSize: 18.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                    SizedBox(height: 5,),
                                                    Text('TOTAL PAYABLE', maxLines: 1,
                                                        // textAlign: TextAlign.justify,
                                                        style: new TextStyle(color: colors.black,fontSize: 9.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ],
                                                )
                                            ),

                                            Expanded(
                                                flex: 1,
                                                child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Material(
                                                      elevation: 5.0,
                                                      borderRadius: BorderRadius.circular(30.0),
                                                      color: colors.metirialgreen,
                                                      child: MaterialButton(
                                                        //minWidth: MediaQuery.of(context).size.width,
                                                        padding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                                                        onPressed: () async {
                                                          setState(() {


                                                          });
                                                        },
                                                        child: Text("PAY NOW",
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                            )


                                          ],
                                        ),
                                      ),
                                    )
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

    /*var rowData = this.leavelist[index];
    print("BACK_PRESS ${rowData.transId}");
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => LeaveAppDetails(rowData)),
    );

    this.leaveList();*/

  }

  onAddRemove(index, BuildContext context) async {
    setState(() {
      // var rowData = this.leavelist[index];
     // print("INDEX--  ${index}");
      if(index==0){
        int newindexNext=index+1;
        if(this.feeInstallmentlist.length<newindexNext){
          if(this.feeInstallmentlist[newindexNext].chk==true){
            commonAlert.showToast(context,"First Remove next installment");
          }else{
            if(this.feeInstallmentlist[index].chk==false){
              if(feeInstallmentlistOne[index].installmentCode==feeInstallmentlistOne[newindexNext].installmentCode){
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
                feeInstallmentlistOne[newindexNext]=FeeStructure(rno: this.feeInstallmentlistOne[newindexNext].rno,studentCode: this.feeInstallmentlistOne[newindexNext].studentCode,installmentCode: this.feeInstallmentlistOne[newindexNext].installmentCode,installmentName: this.feeInstallmentlistOne[newindexNext].installmentName,feeHeadCode: this.feeInstallmentlistOne[newindexNext].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[newindexNext].feeHeadName,headType: this.feeInstallmentlistOne[newindexNext].headType,month: this.feeInstallmentlistOne[newindexNext].month,frequency: this.feeInstallmentlistOne[newindexNext].frequency,amount: this.feeInstallmentlistOne[newindexNext].amount,concessionAmt: this.feeInstallmentlistOne[newindexNext].concessionAmt,payableAmt: this.feeInstallmentlistOne[newindexNext].payableAmt,paid: this.feeInstallmentlistOne[newindexNext].paid,netPayable: this.feeInstallmentlistOne[newindexNext].netPayable,dueStatus: this.feeInstallmentlistOne[newindexNext].dueStatus,paidStatus: this.feeInstallmentlistOne[newindexNext].paidStatus,dueDate: this.feeInstallmentlistOne[newindexNext].dueDate,chk: true );
              }else{
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
              }
              feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: true);
              totalpayable += double.parse(this.feeInstallmentlist[index].netPayable!);
            }else{
              if(feeInstallmentlistOne[index].installmentCode==feeInstallmentlistOne[newindexNext].installmentCode){
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
                feeInstallmentlistOne[newindexNext]=FeeStructure(rno: this.feeInstallmentlistOne[newindexNext].rno,studentCode: this.feeInstallmentlistOne[newindexNext].studentCode,installmentCode: this.feeInstallmentlistOne[newindexNext].installmentCode,installmentName: this.feeInstallmentlistOne[newindexNext].installmentName,feeHeadCode: this.feeInstallmentlistOne[newindexNext].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[newindexNext].feeHeadName,headType: this.feeInstallmentlistOne[newindexNext].headType,month: this.feeInstallmentlistOne[newindexNext].month,frequency: this.feeInstallmentlistOne[newindexNext].frequency,amount: this.feeInstallmentlistOne[newindexNext].amount,concessionAmt: this.feeInstallmentlistOne[newindexNext].concessionAmt,payableAmt: this.feeInstallmentlistOne[newindexNext].payableAmt,paid: this.feeInstallmentlistOne[newindexNext].paid,netPayable: this.feeInstallmentlistOne[newindexNext].netPayable,dueStatus: this.feeInstallmentlistOne[newindexNext].dueStatus,paidStatus: this.feeInstallmentlistOne[newindexNext].paidStatus,dueDate: this.feeInstallmentlistOne[newindexNext].dueDate,chk: false );
              }else{
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
              }
              feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: false);
              totalpayable -=  double.parse(this.feeInstallmentlist[index].netPayable!);
            }
          }
        }else{
          if(this.feeInstallmentlist[index].chk==false){
            if(feeInstallmentlistOne[index].installmentCode==feeInstallmentlistOne[newindexNext].installmentCode){
              feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
              feeInstallmentlistOne[newindexNext]=FeeStructure(rno: this.feeInstallmentlistOne[newindexNext].rno,studentCode: this.feeInstallmentlistOne[newindexNext].studentCode,installmentCode: this.feeInstallmentlistOne[newindexNext].installmentCode,installmentName: this.feeInstallmentlistOne[newindexNext].installmentName,feeHeadCode: this.feeInstallmentlistOne[newindexNext].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[newindexNext].feeHeadName,headType: this.feeInstallmentlistOne[newindexNext].headType,month: this.feeInstallmentlistOne[newindexNext].month,frequency: this.feeInstallmentlistOne[newindexNext].frequency,amount: this.feeInstallmentlistOne[newindexNext].amount,concessionAmt: this.feeInstallmentlistOne[newindexNext].concessionAmt,payableAmt: this.feeInstallmentlistOne[newindexNext].payableAmt,paid: this.feeInstallmentlistOne[newindexNext].paid,netPayable: this.feeInstallmentlistOne[newindexNext].netPayable,dueStatus: this.feeInstallmentlistOne[newindexNext].dueStatus,paidStatus: this.feeInstallmentlistOne[newindexNext].paidStatus,dueDate: this.feeInstallmentlistOne[newindexNext].dueDate,chk: true );
            }else{
              feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
            }
            feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: true);
            totalpayable += double.parse(this.feeInstallmentlist[index].netPayable!);
          }else{
            if(feeInstallmentlistOne[index].installmentCode==feeInstallmentlistOne[newindexNext].installmentCode){
              feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
              feeInstallmentlistOne[newindexNext]=FeeStructure(rno: this.feeInstallmentlistOne[newindexNext].rno,studentCode: this.feeInstallmentlistOne[newindexNext].studentCode,installmentCode: this.feeInstallmentlistOne[newindexNext].installmentCode,installmentName: this.feeInstallmentlistOne[newindexNext].installmentName,feeHeadCode: this.feeInstallmentlistOne[newindexNext].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[newindexNext].feeHeadName,headType: this.feeInstallmentlistOne[newindexNext].headType,month: this.feeInstallmentlistOne[newindexNext].month,frequency: this.feeInstallmentlistOne[newindexNext].frequency,amount: this.feeInstallmentlistOne[newindexNext].amount,concessionAmt: this.feeInstallmentlistOne[newindexNext].concessionAmt,payableAmt: this.feeInstallmentlistOne[newindexNext].payableAmt,paid: this.feeInstallmentlistOne[newindexNext].paid,netPayable: this.feeInstallmentlistOne[newindexNext].netPayable,dueStatus: this.feeInstallmentlistOne[newindexNext].dueStatus,paidStatus: this.feeInstallmentlistOne[newindexNext].paidStatus,dueDate: this.feeInstallmentlistOne[newindexNext].dueDate,chk: false );
            }else{
              feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );

            } feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: false);
            totalpayable -=  double.parse(this.feeInstallmentlist[index].netPayable!);
          }
        }

      }else{
        int newindex=index-1;
        int newindexNext=index+1;
        if(feeInstallmentlist[newindex].netPayable=="0.00"){
          if(this.feeInstallmentlist[index].chk==false){
            feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: true);
            feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
            totalpayable += double.parse(this.feeInstallmentlist[index].netPayable!);
          }else{
            feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: false);
            feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
            totalpayable -=  double.parse(this.feeInstallmentlist[index].netPayable!);
          }
        }else{

          if(this.feeInstallmentlist[newindex].chk==false){
            commonAlert.showToast(context,"First add previous installment");
          }else{
            if(this.feeInstallmentlist.length<newindexNext){
              if(this.feeInstallmentlistOne[newindexNext].chk==true){
                commonAlert.showToast(context,"First Remove next installment");
              }else{
                if(this.feeInstallmentlist[index].chk==false){
                  feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
                  feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: true);
                  totalpayable += double.parse(this.feeInstallmentlist[index].netPayable!);
                }else{
                  feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: false);
                  feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
                  totalpayable -=  double.parse(this.feeInstallmentlist[index].netPayable!);
                }
              }
            }else{

              if(this.feeInstallmentlist[index].chk==false){
                feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: true);
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: true );
                totalpayable += double.parse(this.feeInstallmentlist[index].netPayable!);
              }else{
                feeInstallmentlist[index]=FeeInstallment(srNo: this.feeInstallmentlist[index].srNo,studentCode: this.feeInstallmentlist[index].studentCode,installmentCode:  this.feeInstallmentlist[index].installmentCode,installmentName:  this.feeInstallmentlist[index].installmentName,dueStatus: this.feeInstallmentlist[index].dueStatus,dueDate: this.feeInstallmentlist[index].dueDate,netPayable: this.feeInstallmentlist[index].netPayable,feeHeadDetails: this.feeInstallmentlist[index].feeHeadDetails,chk: false);
                feeInstallmentlistOne[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
                totalpayable -=  double.parse(this.feeInstallmentlist[index].netPayable!);
              }

            }
          }

        }

      }

      if(totalpayable>0){
        totalvisible=0;
      }else{
        totalvisible=1;
      }
     // print("TOTALV-- "+ totalvisible.toString());







    });



  }


  feedBackAlertSuccess(BuildContext context, List<FeeHeadDetail> feeHeadDetails) {
    // Navigator.pop(context);
    double total=0.0;
    for(int i=0;i<feeHeadDetails.length;i++){
      total+=double.parse(feeHeadDetails[i].payableAmt!);
    }
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title:Text('Fee Details',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700, fontSize: 16.0,color: colors.black),),
            content: SingleChildScrollView(
              child: Container(
                width: double.minPositive,
                child: Column(
                  children: [

                    SizedBox(height: 10.0),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: feeHeadDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // height: 50,
                          // color: Colors.amber[colorCodes[index]],
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                Text(feeHeadDetails[index].feeHeadName!,style: TextStyle(fontFamily: 'Montserrat', fontSize: 12.0,color: colors.black),),
                              ),

                              Expanded(
                                child:
                                Text('₹ ${feeHeadDetails[index].payableAmt!}',style: TextStyle(fontFamily: 'Montserrat', fontSize: 12.0,color: colors.black),),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),

                    SizedBox(height: 30.0),
                    Divider(
                      color: Colors.black,
                    ),

                    SizedBox(height: 2.0),
                    Row(
                      children: [
                        Expanded(
                          child:
                          Text('Total :',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700, fontSize: 12.0,color: colors.blue),),
                        ),

                        Expanded(
                          child:
                          Text('₹ $total',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700, fontSize: 12.0,color: colors.blue),),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.0),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),

              ),

            ),

            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Close',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w700, fontSize: 16.0,color: colors.red),),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.of(context).pop();
                  // SystemNavigator.pop();
                },
              ),
            ],
          );
        });

  }




  Widget _buildRow(BuildContext context, int index) {

    Color getMyColor(String moneyCounter) {
      if (moneyCounter == ''){
        return colors.metirialred;
      } else if (moneyCounter == 'Rejected') {
        return colors.metirialgreen;
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
                    width: 10.0,
                    height: 110.0,
                    child: RotatedBox(
                        quarterTurns: 3,
                        child:Row(
                          children: [
                            Expanded(
                              child:Container(
                                color: getMyColor(''),
                                child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "".toUpperCase(),
                                            style: new TextStyle(color: colors.white,fontSize: 10.0,fontFamily: 'Montserrat',
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
                  ),

                  Expanded(
                      child: Container(
                          height: 110.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget>[
                                Visibility(
                                  visible: true,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:<Widget>[
                                        Expanded(
                                          flex:3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(feeInstallmentlist[index].installmentName!, maxLines: 1,
                                                  // textAlign: TextAlign.justify,
                                                  style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                              Text('DUE DATE- ${feeInstallmentlist[index].dueDate!}',maxLines: 1,
                                                  style: new TextStyle(color: colors.grey,fontSize: 8.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                           flex:1,
                                           child: Container(
                                            //padding: EdgeInsets.all(5),
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.info_outline,
                                              ),
                                              iconSize: 22,
                                              color: Colors.grey,
                                             // splashColor: Colors.blueGrey,
                                              onPressed: () {
                                                feedBackAlertSuccess(context,feeInstallmentlist[index].feeHeadDetails);
                                              },
                                            ),
                                          ),
                                        )

                                      ]),
                                ),

                                SizedBox(height: 5.0),
                          Visibility(
                              maintainSize: false,
                              visible: feeInstallmentlist[index].netPayable=="0.00"?false:true,
                              child: Divider(
                                height: 5.0,
                                color: Colors.black,
                              ),
                          ),

                                SizedBox(height: 5.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        flex: 3,
                                         child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                           Visibility(
                                           maintainSize: false,
                                           visible: feeInstallmentlist[index].netPayable=="0.00"?false:true,
                                           child:Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text("₹ ${feeInstallmentlist[index].netPayable}",
                                                     textAlign: TextAlign.start,
                                                     style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                         fontWeight: FontWeight.w700)),
                                                 Text("NET PAYABLE",
                                                     textAlign: TextAlign.start,
                                                     style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                                         fontWeight: FontWeight.w700)),
                                               ])

                                           ),

                                               Visibility(
                                                   maintainSize: false,
                                                   visible: feeInstallmentlist[index].netPayable=="0.00"?true:false,
                                                   child:Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("₹ ${feeInstallmentlist[index].feeHeadDetails[0].payableAmt}",
                                                             textAlign: TextAlign.start,
                                                             style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                 fontWeight: FontWeight.w700)),
                                                         Text("PAID",
                                                             textAlign: TextAlign.start,
                                                             style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                                                 fontWeight: FontWeight.w700)),
                                                       ])

                                               ),

                                             ],
                                           ),

                                      ),

                                      Expanded(
                                        flex: 1,
                                        child:Column(
                                            children: [
                                           Visibility(
                                            maintainSize: false,
                                            visible: feeInstallmentlist[index].netPayable=="0.00"?false:true,
                                            child: Container(
                                                height: 30,
                                                //margin: const EdgeInsets.symmetric(horizontal: 40),
                                                child: Material(
                                                  elevation: 5.0,
                                                  borderRadius: BorderRadius.circular(30.0),
                                                  color: feeInstallmentlist[index].chk == false? colors.bluelighthigh:colors.redtheme,
                                                  child: MaterialButton(
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                    onPressed: () async {
                                                      setState(() {
                                                        if(addRemove==true){
                                                          addRemove=false;
                                                          onAddRemove(index,context);
                                                        }else{
                                                          addRemove=true;
                                                          onAddRemove(index,context);
                                                        }

                                                      });
                                                    },
                                                    child: Text(feeInstallmentlist[index].chk == false?"PAY":"Remove",
                                                        textAlign: TextAlign.center,
                                                        style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ),
                                                )
                                            ),
                                            ),

                                           Visibility(
                                                maintainSize: false,
                                                visible: feeInstallmentlist[index].netPayable=='0.00'?true:false,
                                                child: Container(
                                                    height: 30,
                                                    //margin: const EdgeInsets.symmetric(horizontal: 40),
                                                    child: Text("Paid",
                                                            textAlign: TextAlign.center,
                                                            style: new TextStyle(color: colors.lightgreen,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),

                                                ),
                                              )
                                            ],
                                          ),


                                      )

                                    ])

                              ])
                      )
                  ),

                  Container(
                      width: 5.0,
                      height: 100.0,
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