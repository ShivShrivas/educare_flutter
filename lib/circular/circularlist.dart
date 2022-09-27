import 'package:educareadmin/circular/circulardetails.dart';
import 'package:educareadmin/circular/createcircular.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/circulardata.dart';
import 'package:educareadmin/models/studentdatamodel.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Circulars extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CircularsState();
  }
}


class CircularsState extends State<Circulars> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  List<StudentDataStore> studentsdataList = [];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId,circularPermit=false;
  List<CircularData> circularlist = <CircularData>[];

  onRefresh() async {
   // this.noticesList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }


  Future<void> setStudentData() async{
   // _studentDataStore=StudentDataStore(code: "1",name: "amit");
    studentsdataList.add(StudentDataStore(code: "1",name: "amit"));
    studentsdataList.add(StudentDataStore(code: "2",name: "amitkumar"));
    studentsdataList.add(StudentDataStore(code: "3",name: "amit3434"));
    studentsdataList.add(StudentDataStore(code: "4",name: "amit3434"));
    studentsdataList.add(StudentDataStore(code: "5",name: "amit56565"));

  }

  Future<void> getSavedData() async{

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

    Future<bool> circular = sfdata.getCircularPerMit(context);
    circular.then((data) {
      setState(() {
        circularPermit=data;
        print('NOTICE_DATA----  $circularPermit');
      });
    },onError: (e) {
    });

    getCircularList();

   /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/
  }


  //////////////////  getCircular API //////////////////////
  Future<Null> getCircularList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getCircular("4",relationshipId,sessionId)
        .then((result) {
      //print(result.length);
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          circularlist=result.toList();
          print(circularlist[0].transId);
        }else{
          this.circularlist=[];
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
    super.initState();
    getSavedData();
  }





  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateCircular()),
    );
    this.getSavedData();
   // print("BACKRESULT-- "+ result);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Visibility(
        visible: circularPermit,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: colors.redtheme,
          onPressed: () {
            setState(() {
              setStudentData();
              _navigateAndDisplaySelection(context);
              /*Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreateCircular()));*/
            });
          },
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
                    ///////AppBar/////////////////////////
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: 20.0,
                      right: 20.0,
                      child: AppBar(
                        title: Text("Circular".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                circularlist.isNotEmpty
                                  ? Container(
                                    child: Expanded(
                                      child: ListView.builder(
                                    itemCount: circularlist.length,
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


  onEdit(index) {
    var rowData = this.circularlist[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CircularDetails(rowData),
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
                                text: circularlist[index].circularBy!= null
                                    ? circularlist[index].circularBy.toUpperCase()
                                    : '',
                                style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
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
                                Text(circularlist[index].circularHeadline != null
                                    ? circularlist[index].circularHeadline.toUpperCase()
                                    : '',
                                    maxLines: 1,
                                    // textAlign: TextAlign.justify,
                                    style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 2.0),
                                Text(circularlist[index].description != null
                                    ? circularlist[index].description
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
                                  visible: circularlist[index].attachmentPath == null ? false : true,
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
                                        child: Text("Time: "+circularlist[index].time,
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),

                                      Expanded(
                                        child: Text("Date: "+circularlist[index].date,
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