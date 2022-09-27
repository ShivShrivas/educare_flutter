

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/models/diarydata.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiaryDetailsParents extends StatefulWidget {


  DiaryDetailsParents(this.diaryData) : super();

  final DiaryData diaryData;


  @override
  State<StatefulWidget> createState() {
    return DiaryDetailsParentsState();
  }
}


class DiaryDetailsParentsState extends State<DiaryDetailsParents> {



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
  Widget build(BuildContext context) {


    var colors= AppColors();

    return Scaffold(

      body: SingleChildScrollView(

        child: Container(
        height: MediaQuery.of(context).size.height,

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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.02,
            left: 20.0,
            right: 20.0,
            child: AppBar(
              title: Text("Diary Details".toUpperCase(),textAlign: TextAlign.center,style: new TextStyle(color: Colors.black,fontSize: 16.0,fontFamily: 'Montserrat',
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
                 SizedBox(height: MediaQuery.of(context).size.height * 0.14),
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
                            height: 30.0,
                            color: colors.metirialred,
                                child: new Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Teacher".toUpperCase(),
                                      style: new TextStyle(color: colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
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
                                // mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(widget.diaryData.messageTitle != null
                                        ? widget.diaryData.messageTitle.toUpperCase()
                                        : '',
                                        //maxLines: 1,
                                        // textAlign: TextAlign.justify,
                                        style: new TextStyle(color: colors.blue,fontSize: 14.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                  ]),
                              SizedBox(height: 10.0),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child:Text(widget.diaryData.message != null
                                          ? widget.diaryData.message
                                          : '',
                                         // maxLines: 5,
                                          // textAlign: TextAlign.justify,
                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ),

                                  ]),
                              SizedBox(height: 20.0),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:<Widget>[
                                    Expanded(
                                      child: Text("Time: "+widget.diaryData .time,
                                          textAlign: TextAlign.start,
                                          style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ),

                                    Expanded(
                                      child: Text("Date: "+widget.diaryData.date,
                                          textAlign: TextAlign.end,
                                          style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    )

                                  ]),

                              SizedBox(height: 5.0),

                              Visibility(
                                maintainSize: false,
                                maintainAnimation: true,
                                maintainState: true,
                                visible:widget.diaryData.attachmentPath == null ? false : true,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:<Widget>[
                                      IconButton(icon: Icon(Icons.attach_file_sharp,color: colors.bluelight), onPressed:() {

                                        String path=colors.imageUrl+("/"+widget.diaryData.attachmentPath).replaceAll('..', '');
                                        print(path);
                                        _launchInWebViewOrVC(path);
                                      })

                                    ]),
                              ),
                              Visibility(
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  visible:widget.diaryData.wantToRevertMessage == "No" ? false : true,
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

                            ]),


                      ),

                  ])
                )
           ]),

          ),







        ])




        ),



      ),
    );


  }






}