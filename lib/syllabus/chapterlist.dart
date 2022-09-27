import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/chapterdata.dart';
import 'package:educareadmin/models/timetabledata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:educareadmin/syllabus/chapterstatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum ConfirmAction { Cancel, Accept}

class ChapterList extends StatefulWidget {


  ChapterList(this.dayData) : super();

  final Day dayData;

  @override
  State<StatefulWidget> createState() {
    return ChapterListState();
  }
}


class ChapterListState extends State<ChapterList> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  List<ChapterData> chapterlist = <ChapterData>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  var empCode,fyID;
  CommonAction commonAlert= CommonAction();

  //////////////////  Chapter Api //////////////////////
  Future<Null> chapterList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listChapter(widget.dayData.classCode,widget.dayData.sectionCode,widget.dayData.subjectCode,"10",sessionId,relationshipId,sessionId,fyID)
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          chapterlist=result.toList();
        }else{
          this.chapterlist=[];
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
        chapterList();
      });
    },onError: (e) {
      print(e);
    });

    /*for(int i=0;i<6;i++){
      ChapterData chapterData=new ChapterData(chapter: "A Letter to God",book: "General English",period: "10",topic: "Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things,Nouns refer to persons, animals, places, things, ideas, or events, etc. Nouns encompass",status: _status[i]);
      chapterlist.add(chapterData);
    }*/

    super.initState();
  }

  onRefresh() async {
    this.chapterList();
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

                      ////////////   ---AppBar--- ////////////////////
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: 20.0,
                        right: 20.0,
                        child: AppBar(
                          title: Text("Chapters",textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                Container(
                                  color: colors.redtheme,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child:Padding(padding: const EdgeInsets.all(5.0),
                                            child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children:<Widget>[
                                                  Text("${widget.dayData.dayClass}", maxLines: 1,
                                                      style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                  SizedBox(height: 1.0),
                                                  Text('Class/Section',maxLines: 1,
                                                      style: new TextStyle(color: colors.greylight2,fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ]),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child:Padding(padding: const EdgeInsets.all(5.0),
                                            child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children:<Widget>[
                                                  Text("${widget.dayData.subjectName}", maxLines: 1,
                                                      style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                  SizedBox(height: 1.0),
                                                  Text('Subject',maxLines: 1,
                                                      style: new TextStyle(color: colors.greylight2,fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ])
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child:
                                  chapterlist.isNotEmpty
                                    ? Container(
                                    child: Expanded(
                                    child: ListView.builder(
                                      itemCount: chapterlist.length,
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


  _navigateAndDisplaySelection(BuildContext context, index) async {
    var rowData = this.chapterlist[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChapterStatus(rowData,widget.dayData.sectionCode)),
    );
    this.chapterList();
   // print("BACKRESULT-- "+ result);
  }

  Widget _buildRow(BuildContext context, int index) {

    Color getMyColor(int moneyCounter) {
      if (moneyCounter == 0){
        return colors.rednotcomplete;
      }else if (moneyCounter == 1){
        return colors.listorange;
      }else{
        return colors.greennotcomplete;
      }
    }

    Color getMyColorStatus(int moneyCounter) {
      if (moneyCounter == 0){
        return colors.redtlight;
      }else if (moneyCounter == 1){
        return colors.yellow;
      }else{
        return colors.green;
      }
    }

    String getStatusName(int moneyCounter) {
      if (moneyCounter == 0){
        return "Not Started";
      }else if (moneyCounter == 1){
        return "In-Progress";
      }else{
        return "Complete";
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 3,
      margin: EdgeInsets.all(7),
      child: InkWell(
        onTap: () => _navigateAndDisplaySelection(context,index),
        child: Container(
          color: getMyColor(chapterlist[index].status),
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Container(
                        color: getMyColorStatus(chapterlist[index].status),
                        width: 18.0,
                        height: 110.0,
                        child: new Center(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: RichText(
                                text: TextSpan(
                                  text: getStatusName(chapterlist[index].status),
                                  style: new TextStyle(color: colors.white,fontSize: 10.0,fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                        ),
                    ),

                    Expanded(
                      flex: 1,
                      child:Padding(padding: const EdgeInsets.all(1.0),
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:<Widget>[
                                Text("${chapterlist[index].nameOfBook}", maxLines: 2, textAlign: TextAlign.center,
                                    style: new TextStyle(color: colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Text('Book',maxLines: 1,
                                    style: new TextStyle(color: colors.grey,fontSize: 9.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                /*ImageIcon(
                                  AssetImage("assets/openbook.png"),
                                  color: colors.blue,
                                  size: 18,
                                ),*/

                              ])
                      ),
                    ),

                    Container(height: 90.0, child: VerticalDivider(color: Colors.grey,)),
                    Expanded(
                      flex: 4,
                      child:Padding(padding: const EdgeInsets.all(1.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text(chapterlist[index].chapterName != null
                                    ? chapterlist[index].chapterName!
                                    : '', maxLines: 2,
                                    style: new TextStyle(color: colors.blue,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                /*Text(chapterlist[index].status == false?"In-Progress":"Complete", maxLines: 1,
                                        style: new TextStyle(color: chapterlist[index].status ==false?colors.redtlight:colors.green,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),*/
                                SizedBox(height: 10.0),
                                Text('Topic',maxLines: 1,
                                    style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                Text(chapterlist[index].topic != null
                                    ? chapterlist[index].topic!
                                    : '--',maxLines: 2,
                                    style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),

                                Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                          children: [
                                            Text("Assign Lect. - ",maxLines: 1,
                                                style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                            Text("${chapterlist[index].noOfPeriod}",maxLines: 2,
                                                style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700)),
                                          ],
                                        ),
                                    ),

                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("Taken Lect. - ",maxLines: 1,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                          Text("${chapterlist[index].total_TransID}",maxLines: 2,
                                              style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),




                              ])
                      ),



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


      ),
    );
  }

}