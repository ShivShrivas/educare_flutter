import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/diary/creatediary.dart';
import 'package:educareadmin/diary/diarydetails.dart';
import 'package:educareadmin/models/diarydata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DiaryState();
  }
}



class DiaryState extends State<Diary> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var diaryPermit=false;
  List<DiaryData> _diarylist = <DiaryData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

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
    Future<bool> diary = sfdata.getDiaryPerMit(context);
    diary.then((data) {
      setState(() {
        diaryPermit=data;
        print('NOTICE_DATA----  $diaryPermit');
      });
    },onError: (e) {
    });
    diaryList();
    super.initState();
  }



  _navigateToCreateDiary(BuildContext context) async {
    final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateDiary()),
    );
    this.diaryList();
    print("BACKRESULT-- "+ result);
  }

  //////////////////  DiaryList API //////////////////////
  Future<Null> diaryList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listDiary("4",relationshipId,sessionId)
        .then((result) {
      //print(result.length);
      isLoader = false;
      if(result.isNotEmpty){
        _diarylist =result.toList();
        print(_diarylist[0].transID);
      }else{
        this._diarylist =[];
      }
      setState(() {
      });
    }).catchError((error) {
      print(error);
    });
  }

  onRefresh() async {
    this.diaryList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

  onEdit(index) {
    var rowData = this._diarylist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DiaryDetails(rowData),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    return Scaffold(
        //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Visibility(
          visible: diaryPermit,
          child:FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: colors.redtheme,
            onPressed: () {
              setState(() {
                _navigateToCreateDiary(context);
              });
            },
          ),
        ),



        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: () => onRefresh(),
            child: Container(
               // height: MediaQuery.of(context).size.height,
                child: Stack(
                    children: <Widget>[
                      Container(
                       // height: double.infinity ,
                       // width: double.infinity,
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
                          title: Text("Diary".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                SizedBox(height: 10.0),
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child:
                                  _diarylist .isNotEmpty
                                    ? Container(
                                  child: Expanded(
                                    child: ListView.builder(
                                      itemCount: _diarylist.length,
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
                                  child: Text("",style: TextStyle(color: colors.redtheme)),
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
        child:Container(
            child: Row(
                //mainAxisSize: MainAxisSize.max,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:
                          Container(
                            color: colors.metirialred,
                             width: 30.0,
                             height: 155.0,
                           // otherwise the logo will be tiny
                                   child: new Center(
                                   child: RotatedBox(
                                     quarterTurns: 3,
                                     child: RichText(
                                       text: TextSpan(
                                         text: "Teacher".toUpperCase(),
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
                                   ),

                          ),


                  ),
                  Expanded(
                      flex: 10,
                      child: Container(
                        // height: 120.0,
                          padding: new EdgeInsets.all(7.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                Text(_diarylist [index].messageTitle != null
                                    ? _diarylist [index].messageTitle.toUpperCase()
                                    : '',
                                    maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Text(_diarylist [index].message != null
                                    ? _diarylist [index].message
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
                                  visible: _diarylist[index].attachmentPath == null ? false : true,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children:<Widget>[
                                        Icon(Icons.attach_file_sharp,color: colors.bluelight)

                                      ]),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Time: "+_diarylist [index].time,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),

                                      Expanded(
                                        child: Text("Date: "+_diarylist [index].date,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      )

                                    ]),

                                Visibility(
                                    maintainSize: false,
                                    maintainAnimation: false,
                                    maintainState: false,
                                    visible: _diarylist [index].wantToRevertMessage == "No" ? false : false,
                                    child: Column(
                                      children: [
                                        const Divider(
                                          height: 20,
                                          thickness: 2,
                                          color: Colors.grey,
                                        ),

                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                            children:<Widget>[
                                              Text('Are you Interested ?', style: TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,color: colors.black),),
                                            ]),

                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:<Widget>[
                                              Expanded(
                                                child: FlatButton(
                                                  child: Text('YES', style: TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700,color: colors.green),),
                                                  onPressed: () {},
                                                ),
                                              ),

                                              Expanded(
                                                child: FlatButton(
                                                  child: Text('NO', style: TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700,color: colors.red),),
                                                  onPressed: () {},
                                                ),
                                              )

                                            ]),
                                      ],
                                    )

                                ),

                              ])


                      )
                  ),

                  Expanded(
                      flex: 1,
                      child:Visibility(
                        visible: true,
                        child: Container(
                            width: 35.0,
                            height: 135.0,
                            child: new Center(
                                child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist), onPressed: () {  },)
                            )
                        ),),
                  ),


                ])


        ),
      ),
    );
  }

}