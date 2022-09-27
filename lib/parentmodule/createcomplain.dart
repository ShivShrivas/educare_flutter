import 'dart:convert';
import 'dart:io';

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/conts/permissionrequest.dart';
import 'package:educareadmin/models/roledata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateComplain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateComplainState();
  }
}

class Item {
  const Item(this.name,this.desgnation,this.id,this.icon);
  final String name;
  final String desgnation;
  final String id;
  final String icon;
}

class CreateComplainState extends State<CreateComplain> {
  String groupType="1";
  String noticeForType="0";
  String noticeForStaffType="1";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  String? societyCode,fyID,sessionID,relationshipId;
  late String currentDate,hidedate;
  late String showdateServer,hidedateServer;
  var tranIDforfileUpload;
  var ticketNumber;
  var selectUserProfileID=0;

  String selectdesign="",selectImage="",selectName="";
  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  List<UserType> userlist = <UserType>[];
  List<RoleData> roleTypeuserlist = <RoleData>[];
  UserType? selectedUserCode;
  RoleData? roleTypeuserData;

  String userCode="";
  var sendusertypeId=1;
  var sendusertypeName="";
  var maxdate;
  var colors= AppColors();
  late String code;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName="";
  late List<PlatformFile> _paths;
  late String _directoryPath;
  String _extension='pdf,png,jpeg';
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  String  _filePath="";
  late String groupCode,schoolCode,branchCode,userID;
  late File selectedFile;


  TextEditingController headlineController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();


  @override
  void initState() {
    getSFData();
    _fileName="";
    _clearCachedFiles();
    super.initState();
  }

  Future<void> getSFData() async{
    Future<String?> branchCodedata = sfdata.getBranchCode(context);
    branchCodedata.then((data) {
      setState(() {
        branchCode=data.toString();
        //print("societyCode " +societyCode);
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
        //print("societyCode " +societyCode);
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
       // print("sessionID " + sessionID);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> maxdateData = sfdata.getMaxDate(context);
    maxdateData.then((data) {
      setState(() {
        maxdate=data.toString();
        //print("maxdate " + maxdate);
        
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        setState(() {
          currentDate = formatter.format(now);
         // maxdate = formatter.format(maxdate);
          showdateServer = commonAlert.dateFormateServer(context, now);
          hidedateServer = commonAlert.dateFormateServer(context, formatter.parse(maxdate));
          print("hidedateServer " + hidedateServer);
        });

      });
    },onError: (e) {
      print(e);
    });
    usersList();
    askPermission();
  }


  void displayCalendar(BuildContext context,int caltype) {
    CupertinoRoundedDatePicker.show(
      context,
      fontFamily: "Montserrat",
      textColor: Colors.white,
      background: colors.redtheme,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (newDate) {
       // final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        setState(() {
          if(caltype ==1){
            currentDate=commonAlert.dateFormate(context, newDate);
            showdateServer = commonAlert.dateFormateServer(context, newDate);
          }else{
            maxdate=commonAlert.dateFormate(context, newDate);
            hidedateServer = commonAlert.dateFormateServer(context, newDate);
            //hidedate = formatter.format(newDate);

          }
          print("formatted " + currentDate);
        });

      },
    );

  }

  ///////////////////Permission /////
  askPermission() async {
    var status= PermissionsService().requestStoragePermission(
        onPermissionDenied: () {
          print('Permission has been denied');
        });
   // var status = await Permission.storage.status;
    if(status == true){
      print('Permission');
    }else{
      print('NOTPermission');
      /*showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Camera Permission'),
            content: Text(
                'This app needs camera access to take pictures for upload user profile photo'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text('Settings'),
                onPressed: () => openAppSettings(),
              ),
            ],
          ));*/
    }

  }
  /////////////////file explorer //////////
  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: _pickingType,allowMultiple: _multiPick,allowedExtensions: (_extension.isNotEmpty ? false)
        ?_extension.replaceAll(' ', '').split(',')
        : null);

    if(result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        print("FileNameNEW------" + selectedFile.path);
        _fileName=selectedFile.path.split("/").last;
        _filePath=selectedFile.path;
        print("FileNameNEW------" + selectedFile.path.split("/").last);
      });

    } else {
      // User canceled the picker
    }
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );*/
    });
  }


  //////////////////  UserType API //////////////////////
  Future<Null> usersList() async {
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getUserList("4")
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          userlist=result;
          selectedUserCode = result[0];
          sendusertypeId = result[0].roleId;
          sendusertypeName=selectedUserCode!.roleName;
          roleTypeList();
        //  print("OutputrelationshipId2 "+ result[0].userTypeId.toString());
        });

      }else{
        this.userlist = [];
      }

    }).catchError((error) {

      print(error);
    });
  }
  //////////////////  Roletype Data API //////////////////////
  Future<Null> roleTypeList() async {
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getRoleTypeUserList("5",sendusertypeId)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          roleTypeuserlist=result;
          roleTypeuserData = result[0];
        });

      }else{
        this.userlist = [];
      }

    }).catchError((error) {

      print(error);
    });
  }

  //////////////////  Upload file API //////////////////////
  Future uploadfile(String tranId,int relationshipID,int sessionid) async{
    Map<String, String> allheaders = {
      'Content-Type': 'multipart/form-data',
      "Accept": "application/json"
    };
    var request = http.MultipartRequest('POST', Uri.parse(colors.imageUploadUrl+'DigitalComplainApi/InsertUpdateDeleteDigitalComplainFiles'));
    request.headers.addAll(allheaders);
    request.fields.addAll({
      'TransID': tranId,
      'RelationshipId': relationshipId!,
      'SessionId': sessionID!
    });
    print("--NEWPATHHTTP--- "+_filePath);
    request.files.add(await http.MultipartFile.fromPath('File', _filePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _fileName="";
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"Complain saved successfully\nTicket No.- $ticketNumber","Successfully");
      print(await response.stream.bytesToString());
    }
    else {
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"File Uploading Failed","Error");
      print("Upload Failed");
      print(response.reasonPhrase);
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }

}

  void selectFileSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(20)
        ),
        builder: (ctx) {
          return Container(
           height: MediaQuery.of(context).size.height  * 0.3,
            child: AnimatedContainer(
              duration: Duration(seconds: 10),
              child: Padding(
                  padding:  new EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        new Text("Select file",style: TextStyle(fontSize: 15.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,color: colors.bluelight)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        FlatButton(
                        child: new Text("File     (pdf,png,jpeg)",style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,color: colors.black)),
                       onPressed: () {
                         Navigator.pop(context);
                         _openFileExplorer();
                        },
                       ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
        });
  }



  //////////////////  Upload Data API //////////////////////
  Future<void> saveComplainData(BuildContext context,int relationshipId,int sessionID,int fyID,int userID) async {
    final api = Provider.of<ApiService>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //selectUserProfileID
    return await api.createComplain("1",sendusertypeId,selectUserProfileID,headlineController.text,descriptionController.text,relationshipId,sessionID,fyID,userID)
        .then((result) {
         if(result.isNotEmpty){
           if(result[0].status == "1"){
             headlineController.text="";
             descriptionController.text="";
             tranIDforfileUpload=result[0].id;
             ticketNumber=result[0].ticket;
             if(_filePath.isNotEmpty){
               uploadfile(tranIDforfileUpload,relationshipId,sessionID);
             }else{
               Navigator.of(context,rootNavigator: true).pop();
               commonAlert.messageAlertSuccess(context,"Complain saved successfully\nTicket No.- $ticketNumber","Successfully");
             }
           }else{
             commonAlert.messageAlertSuccess(context,"Complain not uploaded","Error");
           }
         }

    }).catchError((error) {
      print("Exception");
      print(error);
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"Circular not uploaded","Error");
    });
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    final noticeheadline = TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(100),
      ],
      controller: headlineController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Subject",
        enabled: true,

      ),
    );

    final noticeDesc = TextField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 20,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Complain",
        enabled: true,
      ),
    );



    return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.redtheme,
          title: Text("New Complain",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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
                          new Container(
                                   //color: Colors.redAccent,
                                     child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           ////////////////////////// Complain to  ///////////////////////////////////////////
                                           Visibility(
                                             visible: true,
                                             child: Container(
                                               child: Padding(padding:  new EdgeInsets.all(10.0),
                                                 child: Column(
                                                   //mainAxisAlignment: MainAxisAlignment.center,
                                                     children:<Widget>[
                                                       Row(
                                                         children: [
                                                           Padding(padding:  new EdgeInsets.all(5.0),
                                                             child: Text("Send To (Role)",textAlign: TextAlign.left,
                                                                 style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                     fontWeight: FontWeight.w700)),
                                                           ),
                                                         ],
                                                       ),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                         children: <Widget>[
                                                           Expanded(
                                                               child: new Container(
                                                                 height: 50.0,
                                                                 margin: const EdgeInsets.all(5.0),
                                                                 padding: const EdgeInsets.all(5.0),
                                                                 decoration: BoxDecoration(
                                                                     color:colors.greylight ,
                                                                     borderRadius: BorderRadius.circular(5.0),
                                                                     border: Border.all(color: Colors.grey)
                                                                 ),
                                                                 child: DropdownButton<UserType>(
                                                                   isExpanded: true,
                                                                   value: selectedUserCode,
                                                                   icon: Icon(Icons.arrow_drop_down),
                                                                   iconSize: 24,
                                                                   elevation: 16,
                                                                   style: TextStyle(color: Colors.black, fontSize: 18),
                                                                   underline: SizedBox(),
                                                                   /*underline: Container(
                                                                      height: 2,
                                                                      color: Colors.deepPurpleAccent,
                                                                    ),*/
                                                                   onChanged: (UserType? data) {
                                                                     setState(() {
                                                                       selectName='';
                                                                       selectedUserCode = data!;
                                                                       sendusertypeId=selectedUserCode!.roleId;
                                                                       sendusertypeName=selectedUserCode!.roleName;
                                                                       roleTypeList();
                                                                       print(sendusertypeId);
                                                                     });
                                                                   },
                                                                   items: this.userlist.map((UserType data){
                                                                     return DropdownMenuItem<UserType>(
                                                                       child: Text(data.roleName!=null?data.roleName:'',style: new TextStyle(fontSize: 14.0,
                                                                           fontFamily: 'Montserrat',
                                                                           fontWeight: FontWeight.w700)),
                                                                       value: data,
                                                                     );
                                                                   }).toList(),

                                                                   hint:Text(
                                                                     "Select Designation",
                                                                     style: TextStyle(
                                                                         color: Colors.black,
                                                                         fontSize: 14,
                                                                         fontWeight: FontWeight.w500),
                                                                   ),
                                                                 ),



                                                               )

                                                           ),



                                                         ],
                                                       ),



                                                     ]),
                                               )

                                           ),
                                           ),
                                           ////////////////////////// Search User List  ///////////////////////////////////////////
                                           Visibility(
                                           visible: true,
                                            child: Container(
                                                   child: Padding(padding:  new EdgeInsets.all(10.0),
                                                     child: Column(
                                                       //mainAxisAlignment: MainAxisAlignment.center,
                                                         children:<Widget>[
                                                           Row(
                                                             children: [
                                                               Padding(padding:  new EdgeInsets.all(5.0),
                                                                 child: Text('Select $sendusertypeName',textAlign: TextAlign.left,
                                                                     style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                         fontWeight: FontWeight.w700)),
                                                               ),
                                                             ],
                                                           ),
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                             children: <Widget>[
                                                               Expanded(
                                                                   child: new Container(
                                                                     height: 50.0,
                                                                     margin: const EdgeInsets.all(5.0),
                                                                     padding: const EdgeInsets.all(5.0),
                                                                     decoration: BoxDecoration(
                                                                         color:colors.greylight ,
                                                                         borderRadius: BorderRadius.circular(5.0),
                                                                         border: Border.all(color: Colors.grey)
                                                                     ),
                                                                     child: DropdownButton(
                                                                       isExpanded: true,
                                                                       value: roleTypeuserData,
                                                                       icon: Icon(Icons.arrow_drop_down),
                                                                       iconSize: 24,
                                                                       elevation: 16,
                                                                       style: TextStyle(color: Colors.black, fontSize: 18),
                                                                       underline: SizedBox(),
                                                                       items: roleTypeuserlist.map((RoleData items){
                                                                         return DropdownMenuItem(
                                                                             value: items,
                                                                             child: Column(children: [
                                                                               Text(
                                                                                   items.profileName !=null ? items.profileName! :'',
                                                                                   style:  TextStyle(fontSize:14.0,color: Colors.black,fontFamily: 'Montserrat',
                                                                                       fontWeight: FontWeight.w700),textAlign: TextAlign.left),
                                                                              // Divider()
                                                                             ],)
                                                                         );

                                                                       }).toList(),
                                                                       onChanged: (RoleData? items) {
                                                                         setState(() {
                                                                           selectdesign=items?.designation;
                                                                          // selectImage=items?.profilePic;
                                                                           selectName=items?.profileName;
                                                                           selectUserProfileID=items!.userId;
                                                                          // print(selectUserProfileID);
                                                                           // value;
                                                                         });
                                                                       },
                                                                       hint:Text(
                                                                         "Select",
                                                                         style: TextStyle(
                                                                             color: Colors.black,
                                                                             fontSize: 14,
                                                                             fontWeight: FontWeight.w500),
                                                                       ),
                                                                     ),
                                                                   )

                                                               ),
                                                             ],
                                                           ),

                                                         ]),
                                                   )

                                               ),
                                           ),
                                           ///////////////////////  Select User from List ////////////////////////////////
                                           Visibility(
                                             visible: selectName == '' ? false : false,
                                             child: Padding(padding:  new EdgeInsets.all(10.0),
                                               child:   Container(
                                                 child:  Column(children: [
                                                   Row(
                                                     children: [
                                                       ClipOval(
                                                         child: FadeInImage(image: NetworkImage("${colors.imageUploadUrl}${selectImage}"), placeholder: AssetImage('assets/profileblank.png'),
                                                           width: 50,
                                                           height: 50,
                                                           fit: BoxFit.cover,
                                                         ),
                                                       ),
                                                       SizedBox(width: 20,),
                                                       Column(
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Text(
                                                               selectName != null? selectName:'',
                                                               style: TextStyle(color: Colors.red,fontFamily: 'Montserrat',
                                                                   fontWeight: FontWeight.w400),textAlign: TextAlign.left),
                                                           Text(
                                                              selectdesign != null? selectdesign:'',
                                                              style: TextStyle(color: Colors.black54,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                 fontWeight: FontWeight.w400),textAlign: TextAlign.left,),
                                                         ],),

                                                     ],
                                                   ),
                                                   Divider()
                                                 ],),

                                               ),
                                             ),
                                           ),
                                           ////////////////////////// Notice Headline  ///////////////////////////////////////////
                                           Container(
                                            child: Padding(padding:  new EdgeInsets.all(10.0),
                                                   child: Column(
                                                     //mainAxisAlignment: MainAxisAlignment.center,
                                                       children:<Widget>[
                                                         Row(
                                                           children: [
                                                             Padding(padding:  new EdgeInsets.all(5.0),
                                                               child: Text("Subject",textAlign: TextAlign.left,
                                                                   style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                       fontWeight: FontWeight.w700)),
                                                             ),
                                                           ],
                                                         ),
                                                         Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                           children: <Widget>[
                                                             Expanded(
                                                                 child: new Container(
                                                                   height: 50.0,
                                                                   margin: const EdgeInsets.all(5.0),
                                                                   padding: const EdgeInsets.all(5.0),
                                                                   decoration: BoxDecoration(
                                                                       color:colors.greylight ,
                                                                       borderRadius: BorderRadius.circular(5.0),
                                                                       border: Border.all(color: Colors.grey)
                                                                   ),
                                                                   child: noticeheadline,


                                                                 )

                                                             ),



                                                           ],
                                                         ),



                                                       ]),
                                                 )
                                           ),
                                           ////////////////////////// Notice Description  ///////////////////////////////////////////
                                           Container(
                                                 child: Padding(padding:  new EdgeInsets.all(10.0),
                                                   child: Column(
                                                     //mainAxisAlignment: MainAxisAlignment.center,
                                                       children:<Widget>[
                                                         Row(
                                                           children: [
                                                             Padding(padding:  new EdgeInsets.all(5.0),
                                                               child: Text("Complain",textAlign: TextAlign.left,
                                                                   style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                       fontWeight: FontWeight.w700)),
                                                             ),
                                                           ],
                                                         ),
                                                         Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                           children: <Widget>[
                                                             Expanded(
                                                                 child: new Container(
                                                                   alignment: Alignment.topLeft,
                                                                   height: 120.0,
                                                                   margin: const EdgeInsets.all(5.0),
                                                                   padding: const EdgeInsets.all(3.0),
                                                                   decoration: BoxDecoration(
                                                                       color:colors.greylight ,
                                                                       borderRadius: BorderRadius.circular(5.0),
                                                                       border: Border.all(color: Colors.grey)
                                                                   ),
                                                                   child: noticeDesc,


                                                                 )

                                                             ),



                                                           ],
                                                         ),
                                                         Row(
                                                           children: [
                                                             Padding(padding:  new EdgeInsets.all(10.0),
                                                               child: Text("Attachment",textAlign: TextAlign.left,
                                                                   style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                       fontWeight: FontWeight.w700)),
                                                             ),
                                                             Padding(padding:  new EdgeInsets.all(10.0),
                                                                 child:  IconButton(icon: Icon(Icons.attach_file_sharp,color: colors.bluelight), onPressed:() {
                                                                   selectFileSheet(context);
                                                                 })
                                                             ),
                                                             Padding(padding:  new EdgeInsets.all(1.0),
                                                               child: Text(_fileName,textAlign: TextAlign.left,
                                                                   style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                       fontWeight: FontWeight.w300)),
                                                             ),
                                                           ],
                                                         ),
                                                         Container(
                                                             margin: const EdgeInsets.symmetric(horizontal: 100),
                                                             child: Material(
                                                               elevation: 5.0,
                                                               borderRadius: BorderRadius.circular(30.0),
                                                               color: colors.redtheme,
                                                               child: MaterialButton(
                                                                 minWidth: MediaQuery.of(context).size.width,
                                                                 padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                                                 onPressed: () async {
                                                                   if(headlineController.text.isEmpty){
                                                                     commonAlert.showToast(context,"Enter Subject");
                                                                   }else if(descriptionController.text.isEmpty){
                                                                     commonAlert.showToast(context,"Enter about complain");
                                                                   }else{
                                                                     commonAlert.showLoadingDialog(context, _keyLoader);
                                                                     SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                     setState(() {
                                                                       var relationshipID= preferences.getInt("RelationshipId") ?? 0;
                                                                       var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
                                                                       var fyid = preferences.getInt("ActiveFinancialYearId")?? 0;
                                                                       var userid = preferences.getInt("UserId")?? 0;
                                                                       print("API DATA");
                                                                       saveComplainData(context,relationshipID,sessionid,fyid,userid);
                                                                       //uploadMultipleImage(tranIDforfileUpload,relationshipID,sessionid);

                                                                     });

                                                                   }

                                                                   //uploadmultipleimage();
                                                                 },
                                                                 child: Text("Submit",
                                                                     textAlign: TextAlign.center,
                                                                     style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                                               ),
                                                             )
                                                         ),
                                                         SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                                       ]),
                                                 )

                                           ),
                                         ]
                                     ))
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




}