import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'noticedetailsparent.dart';

class NoticesParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticesParentState();
  }
}


class NoticesParentState extends State<NoticesParent> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<NoticeData> noticelist = <NoticeData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  //////////////////  Notices API //////////////////////
  Future<Null> noticesList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   isLoader = true;
   //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listNotice("4",relationshipId,sessionId)
        .then((result) {
      //print(result.length);

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
    noticesList();
    super.initState();

  }

  onRefresh() async {
    this.noticesList();
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
                              title: Text("Notice Board",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
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
                                         margin: const EdgeInsets.all(180.0),
                                         child: Center(child: CircularProgressIndicator()))
                                        : Container(
                                         margin: const EdgeInsets.all(170.0),
                                         child: Text(""),
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
    var rowData = this.noticelist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NoticeDetailsParent(rowData),
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
              // mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      color: colors.metirialred,
                      width: 30.0,
                      height: 155.0,
                      child: new Center(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: RichText(
                              text: TextSpan(
                                text: noticelist[index].noticeBy!= null
                                    ? noticelist[index].noticeBy.toUpperCase()
                                    : '',
                                style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
                                /*children: [
                                                      WidgetSpan(
                                                        child: RotatedBox(quarterTurns: -1, child: Text('😃')),
                                                      )
                                                    ],*/
                              ),
                            ),
                          )
                      )



                  ),

                  Expanded(
                      child: Container(
                          height: 155.0,
                          padding: new EdgeInsets.all(5.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(noticelist[index].noticeHeadline != null
                                    ? noticelist[index].noticeHeadline.toUpperCase()
                                    : '',
                                    maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text(noticelist[index].description != null
                                    ? noticelist[index].description
                                    : '',
                                    // textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 20.0),
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

                                SizedBox(height: 5.0),
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

                                    ])



                              ])


                      )
                  ),

                  Container(
                      width: 35.0,
                      height: 135.0,
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