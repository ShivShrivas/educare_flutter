import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createnotice.dart';
import 'noticedetailsapproval.dart';

class NoticesApprovals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticesApprovalsState();
  }
}








class NoticesApprovalsState extends State<NoticesApprovals> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<NoticeData> noticelist = <NoticeData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var noticePermit,noticeApprove;


  //////////////////  Notices API //////////////////////
  Future<Null> noticesList() async {
   SharedPreferences preferences = await SharedPreferences.getInstance();
   isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listNotice("4",relationshipId,sessionId)
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          noticelist=result.toList();
          print(noticelist[0].transId);
        }else{
          this.noticelist=[];
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
      //print("authToken " + data.toString());
      setState(() {
        sessionId=data;
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIdData = sfdata.getRelationshipId(context);
    relationshipIdData.then((data) {
      //print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
      });
    },onError: (e) {
      print(e);
    });


    Future<bool> userIdData = sfdata.getNoticePerMit(context);
    userIdData.then((data) {
      setState(() {
        noticePermit=data;
       // print('NOTICE_DATA----  $noticePermit');
      });
    },onError: (e) {
    });
    noticesList();

    super.initState();
  }

  onRefresh() async {
    this.noticesList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => CreateNotice()),
    );

    this.noticesList();
    print("BACKRESULT-- "+ result);
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
                              title: Text("Notices for Approvals",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                              leading: new IconButton(
                                // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                                  icon: Icon(Icons.arrow_back),
                                  color: Colors.black,
                                  onPressed:() {
                                    Navigator.pop(context, 'Yep!');
                                    //Navigator.of(context).pop();
                                  }),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          ),
                          new Container(
                              child: Column(
                                  children: <Widget>[
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                                    SizedBox(height: 10.0),
                                    MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child:
                                      noticelist.isNotEmpty
                                        ? Container(
                                          child: Expanded(
                                            child: ListView.builder(
                                             itemCount: noticelist.length,
                                             itemBuilder: _buildRow,
                                          ),
                                        ),
                                      )
                                        : isLoader == true
                                        ? Container(
                                         margin: const EdgeInsets.all(200.0),
                                         child: Center(child: CircularProgressIndicator()))
                                        : Container(
                                           margin: const EdgeInsets.all(160.0),
                                           child: Text("",style: TextStyle(color: colors.redtheme),),
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

  onEdit(index) {
    var rowData = this.noticelist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NoticeDetailsApprove(rowData),
      ),
    );
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
                children: <Widget>[
                  Container(
                      color: colors.metirialred,
                      width: 28.0,
                      height: 125.0,
                      child: new Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: RichText(
                              text: TextSpan(
                                text: noticelist[index].noticeBy != null
                                    ? noticelist[index].noticeBy.toUpperCase()
                                    : '',
                                style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                      )
                  ),

                  Expanded(
                      child: Container(
                          //height: 125.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:<Widget>[

                                Text(noticelist[index].noticeHeadline != null
                                    ? noticelist[index].noticeHeadline.toUpperCase()
                                    : '',
                                    maxLines: 1,
                                    style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(noticelist[index].description != null
                                    ? noticelist[index].description
                                    : '',
                                    maxLines: 2,
                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),

                                SizedBox(height: 5.0),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: noticelist[index].attachmentPath == null ? false : true,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children:<Widget>[
                                        Icon(Icons.attach_file_sharp,color: colors.bluelight)
                                      ]),
                                ),

                                SizedBox(height: 10.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Time: "+noticelist[index].time,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Expanded(
                                        child: Text("Date: "+noticelist[index].date,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )
                                    ]),
                              ])
                      )
                  ),

                  Container(
                      width: 30.0,
                     // height: 135.0,
                      child: new Center(
                          child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist,size: 18,), onPressed: () {  },)
                      )



                  ),

                ])

          ],
        ),
      ),
    );
  }

}