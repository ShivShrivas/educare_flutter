import 'package:educareadmin/complainsBox/complainchatboxadmin.dart';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/complainlist.dart';
import 'package:educareadmin/models/studentdatamodel.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/parentmodule/createcomplain.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplainAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ComplainAdminState();
  }
}


class ComplainAdminState extends State<ComplainAdmin> {
  var colors= AppColors();
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();

  List<StudentDataStore> studentsdataList = [];

  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var saveuseId;
  List<ComplainData> complainlist = <ComplainData>[];

  onRefresh() async {
    // this.noticesList();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
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

    Future<int> useIdData = sfdata.getUseId(context);
    useIdData.then((data) {
      print("useIdData " + data.toString());
      setState(() {
        saveuseId=data.toString();
      });
    },onError: (e) {
      print(e);
    });
    getComplainList();

    /* String jsonUser = jsonEncode(studentsdataList);
    print(jsonUser);
   for(int i=0; i< studentsdataList.length; i++) {
     print(' ${studentsdataList[i].code} ');
     print(' ${studentsdataList[i].name} ');
   }*/
  }


  //////////////////  getCircular API //////////////////////
  Future<Null> getComplainList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getComplainsAdmin("4",relationshipId,sessionId,saveuseId)
        .then((result) {
      //print(result.length);
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          complainlist=result.toList();
          print(complainlist[0].transId);
        }else{
          this.complainlist=[];
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
      context, MaterialPageRoute(builder: (context) => CreateComplain()),
    );
    this.getSavedData();
    print("BACKRESULT-- "+ result);
  }

  Color selectedColorStatus(String status) {
    Color c;
    if (status == 'In-Process'){
      c = Colors.green;
    }else{
      c = Colors.red;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: colors.redtheme,
          onPressed: () {
            setState(() {
              _navigateAndDisplaySelection(context);
              *//*Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CreateCircular()));*//*
            });
          },
        ),*/
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
                          title: Text("Complain Box".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                                  complainlist.isNotEmpty
                                    ? Container(
                                  child: Expanded(
                                    child: ListView.builder(
                                      itemCount: complainlist.length,
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
                                       child: Column(
                                         children: [
                                           /*Text("No Complain",style: TextStyle(color: colors.redtheme)),
                                           IconButton(icon: Icon(Icons.refresh_sharp,color: colors.black), onPressed:() {
                                             getComplainList();
                                           })*/
                                         ],
                                       )
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


  onEdit(index) async {
    var rowData = this.complainlist[index];

    final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => ComplainChatBoxAdmin(rowData)),
    );
    this.getSavedData();
    print("BACKRESULT-- "+ result);

   /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ComplainChatBoxAdmin(rowData),
      ),
    );*/
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
        child:Column(
          children: <Widget>[
            Container(
                height: 30.0,
                color: colors.metirialred,
                child: new Center(
                  child: RichText(
                    text: TextSpan(
                      text: complainlist[index].createdByName!= null ? complainlist[index].createdByName: '',
                      style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
            ),

            Container(
              //height: 155.0,
              padding: new EdgeInsets.all(10.0),
              child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(complainlist[index].date != null
                        ? complainlist[index].date: '',
                        style: new TextStyle(color: colors.grey,fontSize: 10.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 10.0,),
                    Text(complainlist[index].time != null
                        ? complainlist[index].time: '',
                        style: new TextStyle(color: colors.grey,fontSize: 10.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700)),

                  ]),

            ),

            Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        //height: 155.0,
                          padding: new EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              children:<Widget>[
                                //SizedBox(height: 20.0),
                                /*SizedBox(height: 5.0),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'By- ',
                                    style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700),
                                    children: <TextSpan>[
                                      TextSpan(text: complainlist[index].createdByName != null
                                          ? complainlist[index].createdByName
                                          : '', style: TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)
                                      ),
                                    ],
                                  ),
                                ),
                          */
                               // SizedBox(height: 5.0),
                                Text(complainlist[index].compalinSubject != null
                                    ? complainlist[index].compalinSubject.toUpperCase(): '',
                                    // textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 5.0),
                                Text(complainlist[index].complainDescription != null
                                    ? complainlist[index].complainDescription: '',
                                    // textAlign: TextAlign.justify,
                                    // maxLines: 2,
                                    style: new TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 40.0),
                                // Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:<Widget>[
                                      Expanded(
                                        child: Text("Ticket No.: "+complainlist[index].ticket.toString(),
                                            textAlign: TextAlign.start,
                                            style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),

                                      Expanded(
                                        child: Text(complainlist[index].status,
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(color: selectedColorStatus(complainlist[index].status),fontSize: 11.0,fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700)),
                                      ),

                                      Visibility(
                                        maintainSize: false,
                                        maintainAnimation: false,
                                        maintainState: false,
                                        visible: complainlist[index].attachmentPath == null ? false : true,
                                        child: Expanded(
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children:<Widget>[
                                                Icon(Icons.attach_file_sharp,color: colors.bluelight)

                                              ]),
                                        ),
                                      ),

                                    ])
                              ])
                      )
                  ),
                  Visibility(
                    maintainSize: false,
                    maintainAnimation: false,
                    maintainState: false,
                    visible: complainlist[index].status == 'Closed' ? true : true,
                    child: Container(
                        width: 35.0,
                        height: 135.0,
                        child: new Center(
                            child: IconButton(icon: Icon(Icons.arrow_forward_ios,color: colors.greylist), onPressed: () {  },)
                        )



                    ),
                  ),

                ]),


          ],
        ),






      ),
    );


  }
}