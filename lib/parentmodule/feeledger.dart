
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/feemodel.dart';
import 'package:educareadmin/models/feestructure.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feesdues.dart';

class FeeLedger extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeeLedgerState();
  }
}


class FeeLedgerState extends State<FeeLedger> {

  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late String societyCode,fyID,sessionID,relationshipId,empCode,usernameName;
  late String groupCode,schoolCode,branchCode,userID;
  var colors= AppColors();
  List<FeeModel> leavelist = <FeeModel>[];
  var showSheet=1,showfeeInstals=1;
  var dueAmount;
  String duedate="";

  List<FeeStructure> feeInstallmentlistOne = <FeeStructure>[];
  List<FeeStructure> feeInstallmentlistStructur = <FeeStructure>[];

  List<FeeDepositHistory> paymentHistory = <FeeDepositHistory>[];
  List<FeeDue> feeduelist = <FeeDue>[];



  double totalFeeStructure=0.0;
  double totalFeeHistory=0.0;
  double academicYearBalance=0.0;

  @override
  void initState() {
    getSFData();





    super.initState();
  }

  Future<void> getSFData() async{
    Future<String?> branchCodedata = sfdata.getBranchCode(context);
    branchCodedata.then((data) {
      setState(() {
        branchCode=data.toString();
       // print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });
    Future<String?> schoolCodedata = sfdata.getSchoolCode(context);
    schoolCodedata.then((data) {
      setState(() {
        schoolCode=data.toString();
        //print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> groupCodedata = sfdata.getGroupCode(context);
    groupCodedata.then((data) {
      setState(() {
        groupCode=data.toString();
       // print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> societyCodedata = sfdata.getSocietyCode(context);
    societyCodedata.then((data) {
      setState(() {
        societyCode=data.toString();
       // print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIddata = sfdata.getRelationshipId(context);
    relationshipIddata.then((data) {
      // print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
       // print("relationshipId2 "+ relationshipId);
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
    Future<int> session = sfdata.getSessionId(context);
    session.then((data) {
      setState(() {
        sessionID=data.toString();
       // print("sessionID " + sessionID);
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

    Future<String> userCodeData = sfdata.getEmpCode(context);
    userCodeData.then((data) {
      setState(() {
        empCode=data.toString();
        print("empCode " + empCode);
        installmentList();
      });
    },onError: (e) {
      print(e);
    });


    Future<String> authToken = sfdata.getUseName(context);
    authToken.then((data) {
      print("authToken " + data.toString());
      setState(() {
        usernameName=data.toString();
      });
    },onError: (e) {
      print(e);
    });

  }


  //////////////////  Fee Installment Api //////////////////////
  Future<Null> installmentList() async {
    EasyLoading.show(status: 'Loading');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listFee(empCode,"11",relationshipId,sessionID,fyID)
        .then((result) {
      setState(() {
        EasyLoading.dismiss();
        if(result.feeStructure.isNotEmpty){
          // result[0].table?[0].feeDetails?[0];
          feeInstallmentlistOne=result.feeStructure.toList();
          paymentHistory=result.feeDepositHistory.toList();
          feeduelist=result.feeDues.toList();

          for(int i=0;i<feeInstallmentlistOne.length;i++){
            String code=feeInstallmentlistOne[0].installmentCode!;
            if(feeInstallmentlistOne[i].installmentCode==code){
              totalFeeStructure+=feeInstallmentlistOne[i].payableAmt!;
              int index=0;
              if(feeInstallmentlistStructur.isEmpty){
                FeeStructure newtable=new FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: totalFeeStructure,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
                feeInstallmentlistStructur.add(newtable);
              }else{
                feeInstallmentlistStructur[index]=FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: totalFeeStructure,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
              }
            }else{
              int index=i;
              FeeStructure newtable=new FeeStructure(rno: this.feeInstallmentlistOne[index].rno,studentCode: this.feeInstallmentlistOne[index].studentCode,installmentCode: this.feeInstallmentlistOne[index].installmentCode,installmentName: this.feeInstallmentlistOne[index].installmentName,feeHeadCode: this.feeInstallmentlistOne[index].feeHeadCode,feeHeadName: this.feeInstallmentlistOne[index].feeHeadName,headType: this.feeInstallmentlistOne[index].headType,month: this.feeInstallmentlistOne[index].month,frequency: this.feeInstallmentlistOne[index].frequency,amount: this.feeInstallmentlistOne[index].amount,concessionAmt: this.feeInstallmentlistOne[index].concessionAmt,payableAmt: this.feeInstallmentlistOne[index].payableAmt,paid: this.feeInstallmentlistOne[index].paid,netPayable: this.feeInstallmentlistOne[index].netPayable,dueStatus: this.feeInstallmentlistOne[index].dueStatus,paidStatus: this.feeInstallmentlistOne[index].paidStatus,dueDate: this.feeInstallmentlistOne[index].dueDate,chk: false );
              feeInstallmentlistStructur.add(newtable);
              totalFeeStructure+=feeInstallmentlistOne[i].payableAmt!;
            }
          }

          for(int i=0;i<paymentHistory.length;i++){
            totalFeeHistory+=paymentHistory[i].paid!;
          }

          for(int i=0;i<feeduelist.length;i++){
            dueAmount=feeduelist[0].dueAmount!;
            duedate=feeduelist[0].dueDate!;
          }

          academicYearBalance=totalFeeStructure-totalFeeHistory;

        }else{
          this.feeInstallmentlistOne=[];
          this.paymentHistory=[];
          this.feeduelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        this.feeInstallmentlistOne=[];
        this.paymentHistory=[];
        this.feeduelist=[];
      });
      EasyLoading.dismiss();
      print(error);
    });
  }




  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Fee Ledger",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/loginbottomplain.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                              // SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                            Container(
                                  color: colors.greydark,
                                  child: Padding(padding:  new EdgeInsets.all(5.0),
                                   child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child:Text(usernameName,
                                                //maxLines: 5,
                                                //textAlign: TextAlign.center,
                                                style: new TextStyle(color: colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                          ),
                                          Expanded(
                                            child:Text("",
                                                //maxLines: 5,
                                                //textAlign: TextAlign.center,
                                                style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),


                                  ),
                                ),
                             Card(
                               clipBehavior: Clip.antiAlias,
                               shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5.0),
                              ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                      height: 160,
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                              children: [

                                                Text("",textAlign: TextAlign.left,
                                                    style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                Text("₹ $dueAmount",textAlign: TextAlign.left,
                                                    style: new TextStyle(color: colors.blue,fontSize: 26.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                Text("Due as on date",textAlign: TextAlign.left,
                                                    style: new TextStyle(color: colors.grey,fontSize: 11.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700)),
                                                SizedBox(height: 10.0),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text("Due Date: ",textAlign: TextAlign.left,
                                                        style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                    Text("$duedate",textAlign: TextAlign.left,
                                                        style: new TextStyle(color: colors.redtheme,fontSize: 12.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ],
                                                ),

                                             SizedBox(height: 10.0),
                                             Container(
                                               height: 32,
                                               child:  Material(
                                                 elevation: 5.0,
                                                 borderRadius: BorderRadius.circular(30.0),
                                                 color: colors.bluelighthigh,
                                                 child: MaterialButton(
                                                   minWidth: 100.0,
                                                   //padding: EdgeInsets.fromLTRB(20.0,15.0,20.0,15.0),
                                                   onPressed: () async {
                                                     setState(() {
                                                       Navigator.pushReplacement(
                                                           context, MaterialPageRoute(builder: (context) => FeesDues()));
                                                     });
                                                   },
                                                   child: Text("Pay Now",
                                                       textAlign: TextAlign.center,
                                                       style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                           fontWeight: FontWeight.w700)),
                                                 ),
                                               ),

                                            ),


                                              ])
                                            ],
                                       )
                                     ),
                                ),


                            SizedBox(height: 10.0),
                            Container(
                                  color: colors.metirialgreen,
                                  child: Padding(padding:  new EdgeInsets.all(5.0),
                                    child:  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if(showfeeInstals==1){
                                            showfeeInstals=2;
                                          }else{
                                            showfeeInstals=1;
                                          }
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child:Text("Fee Structure",
                                                style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 25.0,
                                              child:Align(
                                                alignment: Alignment.centerRight,
                                                child:Image.asset(showfeeInstals == 2 ? "assets/uparrow.png" : "assets/downarrow.png",
                                                  fit: BoxFit.contain,color:colors.white ,
                                                ) ,
                                              ),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(5),
                              child: Column(
                                       children: [
                                      Visibility(
                                        visible: showfeeInstals==2?false:true,
                                        child:Column(
                                           children: [
                                             Container(
                                                 color: colors.metirialred,
                                                 child:Row(
                                                   children: [

                                                     Expanded(
                                                         child:Padding(
                                                           padding:  new EdgeInsets.all(5.0),
                                                           child:Text("Fee Installments",textAlign: TextAlign.left,
                                                               style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                   fontWeight: FontWeight.w700)),
                                                         )
                                                     ),

                                                     Expanded(
                                                         child:Padding(
                                                           padding:  new EdgeInsets.all(5.0),
                                                           child:Text("Amount",textAlign: TextAlign.left,
                                                               style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                   fontWeight: FontWeight.w700)),
                                                         )
                                                     ),
                                                   ],
                                                 )
                                             ),

                                             Container(
                                               child: MediaQuery.removePadding(
                                                 context: context,
                                                 removeTop: true,
                                                 child:SingleChildScrollView(
                                                   physics: ScrollPhysics(),
                                                   child: Column(
                                                     children: <Widget>[
                                                       // Text('Hey'),
                                                       ListView.builder(
                                                           physics: NeverScrollableScrollPhysics(),
                                                           shrinkWrap: true,
                                                           itemCount:feeInstallmentlistStructur.length,
                                                           itemBuilder: _buildRow
                                                       )
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             ),

                                             Container(
                                                 color: colors.greydark,
                                                 child:Row(
                                                   children: [
                                                     Expanded(
                                                         child:Padding(padding:  new EdgeInsets.all(5.0),
                                                           child:Text("Total Amount",textAlign: TextAlign.left,
                                                               style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                   fontWeight: FontWeight.w700)),
                                                         )
                                                     ),

                                                     Expanded(
                                                         child:Padding(padding:  new EdgeInsets.all(5.0),
                                                           child:Text('$totalFeeStructure',textAlign: TextAlign.left,
                                                               style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                   fontWeight: FontWeight.w700)),
                                                         )
                                                     ),
                                                   ],
                                                 )
                                             ),
                                           ])


                                         )
                                       ],
                                    )
                                ),


                           // SizedBox(height: 5.0),
                            Container(
                                  color: colors.metirialgreen,
                                  child: Padding(padding:  new EdgeInsets.all(5.0),
                                    child:  GestureDetector(
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child:Text("Fee Payment History",
                                                //maxLines: 5,
                                                //textAlign: TextAlign.center,
                                                style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 25.0,
                                              child:Align(
                                                alignment: Alignment.centerRight,
                                                child:Image.asset(showSheet == 1 ? "assets/uparrow.png" : "assets/downarrow.png",
                                                  fit: BoxFit.contain,color:colors.white ,
                                                ) ,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                            Card(
                                 clipBehavior: Clip.antiAlias,
                                 shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                               ),
                              elevation: 5,
                              margin: EdgeInsets.all(5),
                              child: Column(
                               children: [
                                Visibility(
                                    visible: showSheet==1?false:true,
                                    child: Column(
                                      children: [
                                        Container(
                                            color: colors.metirialred,
                                            child:Row(
                                              children: [

                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("Date",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),

                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("Amount",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),

                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("Receipt No.",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child:SingleChildScrollView(
                                              physics: ScrollPhysics(),
                                              child: Column(
                                                children: <Widget>[
                                                  // Text('Hey'),
                                                  ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:paymentHistory.length,
                                                      itemBuilder: _buildRowPayment
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                            color: colors.greydark,
                                            child:Row(
                                              children: [
                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("Total Amount",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),

                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("₹ $totalFeeHistory",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),
                                                Expanded(
                                                    child:Padding(padding:  new EdgeInsets.all(5.0),
                                                      child:Text("        ",textAlign: TextAlign.left,
                                                          style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    )
                                                ),
                                              ],
                                            )
                                        ),

                                      ],
                                    )



                                ),

                             ],
                            )
                           ),

                            SizedBox(height: 5.0),
                            Divider(
                                  height: 5.0,
                                  color: Colors.black,
                                ),

                            Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Text("Balance of Academic Year: ",textAlign: TextAlign.left,
                                          style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                      Text("₹ $academicYearBalance",textAlign: TextAlign.left,
                                          style: new TextStyle(color: colors.redtheme,fontSize: 14.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 50.0),

                              ]
                          )


                        ]
                    )
                )

            )

        ),
      ),
    );


  }


  Widget _buildRow(BuildContext context, int index) {
    var colors= AppColors();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      elevation: 1,
      // margin: EdgeInsets.all(5),
      child: InkWell(
         // onTap: () => onEdit(index),
          child: Padding(
            padding:EdgeInsets.all(3),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child:Padding(padding:  new EdgeInsets.all(5.0),
                          child:Text(feeInstallmentlistStructur[index].installmentName!,textAlign: TextAlign.left,
                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                        )
                    ),

                    Expanded(
                        child:Padding(padding:  new EdgeInsets.all(5.0),
                          child:Text('${feeInstallmentlistStructur[index].payableAmt}',textAlign: TextAlign.left,
                              style: new TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                        )
                    ),
                  ],
                )

              ],
            ),
          )

      ),
    );
  }


  Widget _buildRowPayment(BuildContext context, int index) {
    var colors= AppColors();
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      elevation: 1,
      // margin: EdgeInsets.all(5),
      child: InkWell(
        // onTap: () => onEdit(index),
          child: Padding(
            padding:EdgeInsets.all(3),
            child: Column(
              children: <Widget>[
                Row(
                  children: [

                    Expanded(
                        child:Padding(padding:  new EdgeInsets.all(5.0),
                          child:Text(paymentHistory[index].feeDepositDate!,textAlign: TextAlign.left,
                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                        )
                    ),

                    Expanded(
                        child:Padding(padding:  new EdgeInsets.all(5.0),
                          child: Text("₹ ${paymentHistory[index].paid!}",textAlign: TextAlign.left,
                              style: new TextStyle(color: Colors.green.shade800,fontSize: 12.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                        )
                    ),

                    Expanded(
                        child:Padding(padding:  new EdgeInsets.all(5.0),
                          child:Text(paymentHistory[index].recptNo!,textAlign: TextAlign.left,
                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                        )
                    ),

                  ],
                )

              ],
            ),
          )

      ),
    );
  }


}