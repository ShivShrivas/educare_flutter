import 'dart:convert';
import 'dart:io';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/conts/permissionrequest.dart';
import 'package:educareadmin/models/alldatateacher.dart';
import 'package:educareadmin/models/classcode.dart';
import 'package:educareadmin/models/empleavedata.dart';
import 'package:educareadmin/models/leavechartdata.dart';
import 'package:educareadmin/models/leavedaywise.dart';
import 'package:educareadmin/models/leavefor.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/leavemaster.dart';
import 'package:educareadmin/models/leavetype.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveFormEdit extends StatefulWidget {


  LeaveFormEdit(this.leaveData) : super();

  final LeaveList leaveData;

  @override
  State<StatefulWidget> createState() {
    return LeaveFormEditState();
  }
}



class LeaveFormEditState extends State<LeaveFormEdit> {

  List<String> _status = ["All", "Students", "Staff"];
  List<String> _noticeFor = ["Class Wise", "Individual"];
  List<String> _noticeForStaff = ["Both","Teaching", "Non Teaching"];
  String _noticeForStaffValue = "Both";
  String _statusGroupValue = "All",groupType="1";
  String _noticeForGroupValue = "",noticeForType="0";
  String noticeForStaffType="1";
  var _selecteddropDownMenu;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  late String societyCode,fyID,sessionID,relationshipId;
  late String currentDate='',hidedate='',todate='';
  var showdateServer,hidedateServer;
  var tranIDforfileUpload;

  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();



  List<ClassData> classlist = <ClassData>[];
  List<LeaveTypeMaster> leavemasterlist = <LeaveTypeMaster>[];
  LeaveTypeMaster? leavemaster;
  ClassData? selectedClassCode;
  String classCode="0";
  String _chosenValue='Android';
  String _nameIsResponsible='';
  String _LeaveforName='';

  String dropdownvalue = 'Apple';
  var items =  ['Apple','Banana','Grapes','Orange','watermelon','Pineapple'];


  List<TeacherListData> userlist = <TeacherListData>[];
  TeacherListData? selectedUserCode;
  late String userCode,selectEmpCode='';
  var sendusertypeId=1;
  String maxdate="";
  var colors= AppColors();
  late String code;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName="",leaveForCode="";
  late int laveMasterCode;
  late List<PlatformFile> _paths;
  late String _directoryPath;
  String _extension='pdf,png,jpeg';
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  String  _filePath="";
  int leavemasterCode=0;
  late String groupCode,schoolCode,branchCode,userID,empCode,departmentCode,designationCode;
  late File selectedFile;
  bool notPermitted=true;
  bool in_AbsenceVisible=false;
  bool is_LeaveforVisible=false;
  bool is_LeaveUpdateVisible=false;



  List<LeaveChartData> leavelist = <LeaveChartData>[];
  LeaveChartData? _leaveChartData;
  var inputFormat = DateFormat('dd-MM-yyyy');

  List<LeaveFor> leaveForlist = <LeaveFor>[];
  LeaveFor? leaveFordrop;
  var emojiRegexp =
      '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';


  TextEditingController reasonController = new TextEditingController();
  TextEditingController onleaveController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();


  List <String> spinnerItems = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five'
  ] ;

  List<String> leavetypeList=<String>[];
  List<String> selectedItemValue = <String>[];
  List<LeaveTypeData> leaveMasterlist = <LeaveTypeData>[];
  List<DayWiseStatus> userleavelist = <DayWiseStatus>[];
  var difference;
  var casualLeaveID,earnedLeaveID,medicalLeaveID,sickLeaveID,selectLaeaveCode,lwpID;
  var causalleaveGiven=0.0,earnedleaveGiven=0.0,medicalleaveGiven=0.0,sickleaveGiven=0.0;
  var causalleaveBal,earnedleaveBal,medicalleaveBal,sickleaveBal;
  int currentIndex=5;
  bool isLoader = false;


  List<DayWiseStatus> daywiseStatus = <DayWiseStatus>[];

  List<EmpleaveData> leavetypelist = <EmpleaveData>[];

  var isLeaveDays=0.0;



  @override
  void initState() {
    getSFData();

    _fileName="";
   // _clearCachedFiles();
    super.initState();
  }

  Future<void> getSFData() async{
    Future<String?> branchCodedata = sfdata.getBranchCode(context);
    branchCodedata.then((data) {
      setState(() {
        branchCode=data.toString();
        print("branchCode " +branchCode);
      });
    },onError: (e) {
      print(e);
    });
    Future<String?> schoolCodedata = sfdata.getSchoolCode(context);
    schoolCodedata.then((data) {
      setState(() {
        schoolCode=data.toString();
        print("schoolCode " +schoolCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> groupCodedata = sfdata.getGroupCode(context);
    groupCodedata.then((data) {
      setState(() {
        groupCode=data.toString();
        print("groupCode " +groupCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String?> societyCodedata = sfdata.getSocietyCode(context);
    societyCodedata.then((data) {
      setState(() {
        societyCode=data.toString();
        print("societyCode " +societyCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<int> relationshipIddata = sfdata.getRelationshipId(context);
    relationshipIddata.then((data) {
      // print("relationshipId " + data.toString());
      setState(() {
        relationshipId=data.toString();
        print("relationshipId2 "+ relationshipId);
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
    Future<int> session = sfdata.getSessionId(context);
    session.then((data) {
      setState(() {
        sessionID=data.toString();
        print("sessionID " + sessionID);
        employeeList(sessionID,relationshipId);

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
      });
    },onError: (e) {
      print(e);
    });

    Future<String> depCodeData = sfdata.getDepCode(context);
    depCodeData.then((data) {
      setState(() {
        departmentCode=data.toString();
        print("departmentCode " + departmentCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> designCodeData = sfdata.getDesignCode(context);
    designCodeData.then((data) {
      setState(() {
         designationCode=data.toString();
         print("designationCode " + designationCode);
      });
    },onError: (e) {
      print(e);
    });

    Future<String> maxdateData = sfdata.getMaxDate(context);
    maxdateData.then((data) {
      setState(() {
        maxdate=data.toString();
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        setState(() {
          reasonController.text=widget.leaveData.leaveReason;
          remarksController.text=widget.leaveData.remarks;
          onleaveController.text=widget.leaveData.onLeaveContactNo;
          leaveForCode=widget.leaveData.leaveFor;
          selectEmpCode=widget.leaveData.inAbsenceResponsibleEmployeeId;
          if(widget.leaveData.leaveFor=='F'){
            isLeaveDays=1;
            _LeaveforName='Full';
          }else{
            isLeaveDays=0.5;
            _LeaveforName='Half';
          }
          _nameIsResponsible=widget.leaveData.resName;
          currentDate=widget.leaveData.leaveFrom;
          todate=widget.leaveData.leaveTo;
          // DateTime currentDateString = DateTime.parse(currentDate);
           DateTime input = formatter.parse(currentDate);
          showdateServer = commonAlert.dateFormateServer(context, input);
          hidedateServer = commonAlert.dateFormateServer(context, formatter.parse(todate));
         // print("hidedateServer " + hidedateServer);
         // print("showdateServer " + showdateServer);

        });

      });
    },onError: (e) {
      print(e);
    });

    leaveForlist.add(new LeaveFor(name: "",fullName: "---Select Leave For---"));
    leaveForlist.add(new LeaveFor(name: "F",fullName: "Full"));
    leaveForlist.add(new LeaveFor(name: "HDF",fullName: "First Half"));
    leaveForlist.add(new LeaveFor(name: "HDS",fullName: "Second Half"));


   // leaveTypeMaster();
    leaveTypeMaster();
    leaveTypeList();
    askPermission();
    leaveMasterList();

    //dayWiseLeaveStatusUpdate();

  }

  void displayCalendar(BuildContext context,int caltype) {
      CupertinoRoundedDatePicker.show(
      context,
      fontFamily: "Montserrat",
      textColor: Colors.white,
      background: colors.redtheme,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.date,
      minimumDate: DateTime.now().subtract(Duration(days: 1)),
      onDateTimeChanged: (newDate) {
        // final DateTime now = DateTime.now();
       // final DateFormat formatter = DateFormat('yyyy-MM-dd');
        setState(() {
          if(caltype ==1){
            currentDate=commonAlert.dateFormate(context, newDate);
            showdateServer = commonAlert.dateFormateServer(context, newDate);
          }else{
            todate=commonAlert.dateFormate(context, newDate);
            hidedateServer = commonAlert.dateFormateServer(context, newDate);
            //hidedate = formatter.format(newDate);
            dayWiseLeaveStatusUpdate();
          }
          print("formatted " + currentDate);
        });

       // onChanged(result);
      },


    );

  }


  dayWiseLeaveStatusUpdate(){
    userleavelist = <DayWiseStatus>[];

      var fromdate=currentDate;
      var toodate=todate;
      var fromDateSplit=fromdate.split('-');
      var toDateSplit=toodate.split('-');

      var day=fromDateSplit[0];
      var month=fromDateSplit[1];
      var year=fromDateSplit[2];

      var today=toDateSplit[0];
      var tomonth=toDateSplit[1] ;
      var toyear=toDateSplit[2];


      var date1 = DateTime(int.parse(year), int.parse(month),int.parse(day));
      final date2 = DateTime(int.parse(toyear), int.parse(tomonth),int.parse(today));

     // var date1 = DateTime(2021, 10,05);
     // final date2 = DateTime(2021, 10,09);
      difference = date2.difference(date1).inDays;
      difference=difference+1;
      print(difference);
      if(difference<0){
        commonAlert.showToast(context,"Wrong Date selection");
      }else{
        if(difference<=5){
          for(int i=0;i<difference;i++){
            //date1 = new DateTime(date1.year, date1.month, date1.day + 1);
            String formattedDate = DateFormat('yyyy-MM-dd').format(date1);
            String formattedDateUser = DateFormat('dd-MM-yyyy').format(date1);
            print(date1);
            print(formattedDate);
            setState(() {
              userleavelist.add(new DayWiseStatus(dateData: formattedDate,dateDataUser:formattedDateUser,abbrTypeIdEmployee: leavetypelist[i].abbrTypeIdFirst,typeName:leavetypelist[i].leaveTypeName));
              //selectedItemValue.add(new LeaveChartData(employeeCode: '', departmentCode: '', designationCode: '', leaveTypeCode: '', leaveType: '', totalLeaves: 0, allotedLeaves: 0, leaveTaken: 0, balance: 0, totalApprovedLeave: 0, totalAllotedLeave: 0, abbrTypeId: 0));
              selectedItemValue.add("Change");
            });
            date1=new DateTime(date1.year, date1.month, date1.day + 1);
          }
        }else{
          commonAlert.messageAlertError(context,"Sorry! more than 5 days leave not apply by mobile application","Not Allowed");
        }
      }
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

  //////////////////  Notices API //////////////////////
  Future<Null> leaveTypeList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listLeaveChart(empCode,"5",relationshipId,sessionID,fyID)
        .then((result) {
      setState(() {
        //isLoader = false;
        if(result.isNotEmpty){
          leavelist=result.toList();
          for(int i=0;i<leavelist.length;i++){
            //leavetypeList.add(leavelist[i].abbrTypeId);

            if(leavelist[i].leaveType=='Casual Leave'){
              casualLeaveID=leavelist[i].abbrTypeId;
              causalleaveBal=leavelist[i].balance;
            }
            if(leavelist[i].leaveType=='Earned Leave'){
              earnedLeaveID=leavelist[i].abbrTypeId;
              earnedleaveBal=leavelist[i].balance;
            }
            if(leavelist[i].leaveType=='Medical Leave'){
              medicalLeaveID=leavelist[i].abbrTypeId;
              medicalleaveBal=leavelist[i].balance;
            }
            if(leavelist[i].leaveType=='Sick Leave'){
              sickLeaveID=leavelist[i].abbrTypeId;
              sickleaveBal=leavelist[i].balance;
            }
          }


        }else{
          this.leavelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
      });
      print(error);
    });
  }


  //////////////////  leaveTypeList API //////////////////////
  Future<Null> leaveMasterList() async {
    // isLoader = true;
    leavetypeList.add('Change');
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listtypeChart("14")
        .then((result) {
      setState(() {
        //isLoader = false;
        if(result.isNotEmpty){
          leaveMasterlist=result.toList();
          for(int i=0;i<leaveMasterlist.length;i++){
            leavetypeList.add(leaveMasterlist[i].abbrType);
            //leavetypeList.add(leavelist[i].abbrTypeId);
            if(leaveMasterlist[i].abbrType=='Leave Without Pay'){
              lwpID=leaveMasterlist[i].abbrTypeId;
            }
          }

          // leaveBalanceList();
        }else{
          // this.leavetypelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        //isLoader = false;
      });
      print(error);
    });
  }

  //////////////////  leaveTypeList API //////////////////////
  Future<Null> leaveTypeMaster() async {
    EasyLoading.show(status: 'loading...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userleavelist = <DayWiseStatus>[];
   // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listStatusChart("14",widget.leaveData.transId,relationshipId,sessionID,fyID)
        .then((result) {
      EasyLoading.dismiss();
      setState(() {
        //isLoader = false;
        if(result.isNotEmpty){
          leavetypelist=result.toList();
         for(int i=0;i<leavetypelist.length;i++){
           userleavelist.add(new DayWiseStatus(dateData: leavetypelist[i].dateData,dateDataUser: leavetypelist[i].dateData,abbrTypeIdEmployee : leavetypelist[i].abbrTypeIdFirst,typeName:leavetypelist[i].leaveTypeName));
           selectedItemValue.add("Change");
         }
        }else{
          this.leavetypelist=[];
        }
      });
    }).catchError((error) {
      EasyLoading.dismiss();
      print(error);
      commonAlert.messageAlertError(context,'Day wise status not respond.Please try again',"Error");
    });
  }

  //////////////////  employeeList API //////////////////////
  Future<Null> employeeList(String sessionID, String relationshipId) async {
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getEmpList("4",relationshipId,sessionID)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          userlist=result;
        //  selectEmpCode = result[0].employeeCode.toString();
         // print("OutputrelationshipId2 "+ result[0].employeeCode.toString());
        });

      }else{
        this.userlist = [];
      }

    }).catchError((error) {

      print(error);
    });
  }

//////////////////  LeaveSave API //////////////////////
  Future<void> saveLeave(BuildContext context,int relationshipId,int sessionID,int fyID,int userID) async {
    final api = Provider.of<ApiService>(context, listen: false);
    return await api.updateLeave(widget.leaveData.transId,empCode,leavemasterCode,designationCode,departmentCode,showdateServer,hidedateServer,reasonController.text,remarksController.text,leaveForCode,"",onleaveController.text,"","",selectEmpCode,"","",relationshipId,fyID,sessionID,userID,"19",jsonEncode(userleavelist))
        .then((result) {
      if(result.isNotEmpty){
        Navigator.of(context,rootNavigator: true).pop();
        if(result.toString() == '"1"'){
          commonAlert.messageAlertSuccess(context,"Leave application submitted successfully","Success");
        }else if(result.toString() == '"-1"'){
          commonAlert.messageAlertError(context,'Leave application not submitted.Please try again',"Leave Already Taken");
        }else{
          commonAlert.messageAlertError(context,'Leave application not submitted.Please try again',"Error");
        }
      }
    }).catchError((error) {
      print("Exception");
      print(error);
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertError(context,"Leave application not submitted","Error");
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final reasonfield = TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(80),FilteringTextInputFormatter.deny(
        RegExp(emojiRegexp),
      )],
      controller: reasonController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Reason",
        enabled: true,

      ),
    );

    final onleaveContact = TextField(
      controller: onleaveController,
      keyboardType: TextInputType.phone,
      inputFormatters:[LengthLimitingTextInputFormatter(10),FilteringTextInputFormatter.digitsOnly],
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter mobile",
        enabled: true,
      ),
    );

    final remarkField = TextField(
      controller: remarksController,
      keyboardType: TextInputType.multiline,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(emojiRegexp),
        ),
      ],
      maxLines: 20,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter remarks",
        enabled: true,
      ),
    );



    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Edit Leave Application",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 14.0,fontFamily: 'Montserrat',
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
                                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                          //////////////////////////  Responsible By  ///////////////////////////////////////////
                                          Container(
                                              child: Padding(padding:  new EdgeInsets.all(5.0),
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      Row(
                                                        children: [
                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Text("In Absence Responsible Employee",textAlign: TextAlign.left,
                                                                style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                    fontWeight: FontWeight.w700)),
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                           visible: in_AbsenceVisible,
                                                           child: Row(
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
                                                                    child: DropdownButton<TeacherListData>(
                                                                      isExpanded: true,
                                                                      value: selectedUserCode,
                                                                      icon: Icon(Icons.arrow_drop_down),
                                                                      iconSize: 24,
                                                                      elevation: 16,
                                                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                                                      underline: SizedBox(),
                                                                      onChanged: (TeacherListData? data) {
                                                                        setState(() {
                                                                          selectedUserCode = data!;
                                                                          selectEmpCode=selectedUserCode!.employeeCode;
                                                                          _nameIsResponsible=selectedUserCode!.employeeName;
                                                                          //print(selectEmpCode);
                                                                        });
                                                                      },
                                                                      items: this.userlist.map((TeacherListData data) {
                                                                        return DropdownMenuItem<TeacherListData>(
                                                                          child: Text(data.employeeName,style: new TextStyle(fontSize: 14.0,
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                          value: data,
                                                                        );
                                                                      }).toList(),


                                                                      hint:Text(
                                                                        "Select Employee",
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
                                                      ),

                                                      Visibility(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: <Widget>[
                                                            Expanded(
                                                                child: Container(
                                                                    margin: const EdgeInsets.all(5.0),
                                                                    child: Text(_nameIsResponsible,textAlign: TextAlign.left,
                                                                      style: new TextStyle(color: colors.green,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700)),
                                                                ),
                                                            ),
                                                            Expanded(
                                                                child:Container(
                                                                  margin: const EdgeInsets.all(5.0),
                                                                  child: new GestureDetector(
                                                                         onTap: () {
                                                                           setState(() {
                                                                             if(in_AbsenceVisible==false){
                                                                                 in_AbsenceVisible=true;
                                                                             }else{
                                                                                 in_AbsenceVisible=false;
                                                                             }
                                                                           });
                                                                          },
                                                                          child: Text("Edit",textAlign: TextAlign.end,
                                                                              style: new TextStyle(color: in_AbsenceVisible==true?colors.redtheme:colors.bluelight,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                  fontWeight: FontWeight.w700)),
                                                                   )
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                              )
                                          ),

                                          //////////////////////////   Leave For  ////////////////////////////////////////////////
                                          Container(
                                              child: Padding(padding:  new EdgeInsets.all(5.0),
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children:<Widget>[
                                                                    Row(
                                                                      children: [
                                                                        Padding(padding:  new EdgeInsets.all(5.0),
                                                                          child: Text("Leave For",textAlign: TextAlign.left,
                                                                              style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                  fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                   Visibility(
                                                                        visible: is_LeaveforVisible,
                                                                        child: Row(
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
                                                                             child: DropdownButton<LeaveFor>(
                                                                               isExpanded: true,
                                                                               value: leaveFordrop,
                                                                               icon: Icon(Icons.arrow_drop_down),
                                                                               iconSize: 24,
                                                                               elevation: 16,
                                                                               style: TextStyle(color: Colors.black, fontSize: 18),
                                                                               underline: SizedBox(),
                                                                               onChanged: (LeaveFor? data) {
                                                                                 setState(() {
                                                                                   leaveFordrop = data!;
                                                                                   leaveForCode=leaveFordrop!.name;

                                                                                   // print(leaveForCode);
                                                                                   if(leaveForCode=='F'){
                                                                                     isLeaveDays=1;
                                                                                     _LeaveforName='Full';
                                                                                   }else{
                                                                                     isLeaveDays=0.5;
                                                                                     _LeaveforName='Half';
                                                                                   }

                                                                                 });
                                                                               },
                                                                               items: this.leaveForlist.map((LeaveFor data) {
                                                                                 return DropdownMenuItem<LeaveFor>(
                                                                                   child: Text(data.fullName,style: new TextStyle(fontSize: 14.0,
                                                                                       fontFamily: 'Montserrat',
                                                                                       fontWeight: FontWeight.w700),),
                                                                                   value: data,
                                                                                 );
                                                                               }).toList(),

                                                                               hint:Text(
                                                                                 "Select Leave for",
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
                                                                   ),

                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Container(
                                                                            margin: const EdgeInsets.all(5.0),
                                                                            child: Text(_LeaveforName,textAlign: TextAlign.left,
                                                                                style: new TextStyle(color: colors.green,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ),
                                                                        ),

                                                                        Expanded(
                                                                            child:Container(
                                                                                margin: const EdgeInsets.all(5.0),
                                                                                child: new GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      if(is_LeaveforVisible==false){
                                                                                        is_LeaveforVisible=true;
                                                                                      }else{
                                                                                        is_LeaveforVisible=false;
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: Text("Edit",textAlign: TextAlign.end,
                                                                                      style: new TextStyle(color: is_LeaveforVisible==true?colors.redtheme:colors.bluelight,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                          fontWeight: FontWeight.w700)),
                                                                                )

                                                                            )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ]),
                                                              ),
                                                          ]),
                                                    ]),
                                              )
                                          ),

                                          //////////////////////////  Reason | Date  /////////////////////////////////////////////
                                          Container(
                                              alignment: Alignment.center,
                                              child: Padding(padding:  new EdgeInsets.all(5.0),
                                                child: Column(
                                                 // mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      Row(
                                                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children:<Widget>[
                                                                    Row(
                                                                        children: [
                                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                                            child: Text("Leave From",textAlign: TextAlign.left,
                                                                                style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ),
                                                                        ]),

                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          displayCalendar(context,1);
                                                                        },
                                                                        child: new Container(
                                                                          alignment: Alignment.center,
                                                                          height: 50.0,
                                                                          margin: const EdgeInsets.all(5.0),
                                                                          padding: const EdgeInsets.all(5.0),
                                                                          decoration: BoxDecoration(
                                                                              color:colors.greylight ,
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              border: Border.all(color: Colors.grey)
                                                                          ),
                                                                          child: Text(currentDate ,textAlign: TextAlign.start,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                        )
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children:<Widget>[
                                                                    Row(
                                                                        children: [
                                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                                            child: Text("Leave To",textAlign: TextAlign.left,
                                                                                style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ),
                                                                        ]),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          if(is_LeaveUpdateVisible==false){
                                                                            commonAlert.showToast(context,"Enable Edit mode");
                                                                          }else{
                                                                            displayCalendar(context,2);
                                                                          }
                                                                        },
                                                                        child: new Container(
                                                                          alignment: Alignment.center,
                                                                          height: 50.0,
                                                                          margin: const EdgeInsets.all(5.0),
                                                                          padding: const EdgeInsets.all(5.0),
                                                                          decoration: BoxDecoration(
                                                                              color:colors.greylight ,
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              border: Border.all(color: Colors.grey)
                                                                          ),
                                                                          child: Text(todate,textAlign: TextAlign.start,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                        )
                                                                    ),

                                                                  ]),
                                                            ),
                                                            Visibility(
                                                                visible: false,
                                                                child:
                                                                Expanded(
                                                                 flex: 2,
                                                                  child:Container(
                                                                  child: Column(
                                                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Row(
                                                                          children: [
                                                                            Padding(padding:  new EdgeInsets.all(5.0),
                                                                              child: Text("",textAlign: TextAlign.left,
                                                                                  style: new TextStyle(color: colors.green,fontSize: 10.0,fontFamily: 'Montserrat',
                                                                                      fontWeight: FontWeight.w700)),
                                                                            ),
                                                                          ]),
                                                                      FlatButton(
                                                                        child: Text('Sync.'),
                                                                        color: Colors.green,
                                                                        textColor: Colors.white,
                                                                        onPressed: () {
                                                                          if(leaveForCode == ''){
                                                                            commonAlert.showToast(context,"Select Leave for");
                                                                          }else{
                                                                            dayWiseLeaveStatusUpdate();
                                                                          }


                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            ),
                                                            ),


                                                          ]),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5.0),
                                                              child: Text("",textAlign: TextAlign.left,
                                                                  style: new TextStyle(color: colors.green,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                            ),

                                                          ),
                                                          Expanded(
                                                              child:Container(
                                                                  margin: const EdgeInsets.all(5.0),
                                                                  child: new GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        if(is_LeaveUpdateVisible==false){
                                                                           is_LeaveUpdateVisible=true;
                                                                           dayWiseLeaveStatusUpdate();
                                                                        }else{
                                                                           is_LeaveUpdateVisible=false;
                                                                           leaveTypeMaster();
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text("Edit",textAlign: TextAlign.end,
                                                                        style: new TextStyle(color: is_LeaveUpdateVisible==true?colors.redtheme:colors.bluelight,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                            fontWeight: FontWeight.w700)),
                                                                  )
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      Visibility(
                                                         visible: true,
                                                         child:   Container(
                                                          //height: 100,
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
                                                                    itemCount:userleavelist.length,
                                                                    itemBuilder: _buildRow
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                       ),
                                                      ),

                                                      //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Row(
                                                        children: [
                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Text("Reason",textAlign: TextAlign.left,
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
                                                                child: reasonfield,
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                )
                                          ),

                                          ////////////////////////// Contact number  ///////////////////////////////////////////
                                          Container(
                                              child: Padding(padding:  new EdgeInsets.all(5.0),
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      Row(
                                                        children: [
                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Text("On Leave Contact Number",textAlign: TextAlign.left,
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
                                                                height: 50.0,
                                                                margin: const EdgeInsets.all(5.0),
                                                                padding: const EdgeInsets.all(3.0),
                                                                decoration: BoxDecoration(
                                                                    color:colors.greylight ,
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                    border: Border.all(color: Colors.grey)
                                                                ),
                                                                child: onleaveContact,
                                                              )
                                                          ),
                                                        ],
                                                      ),

                                                      ////////////////////////// Remarks ///////////////////////////////////////////
                                                      SizedBox(height: 8.0),
                                                      Container(
                                                          child: Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Column(
                                                              //mainAxisAlignment: MainAxisAlignment.center,
                                                                children:<Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Padding(padding:  new EdgeInsets.all(0.0),
                                                                        child: Text("Remarks",textAlign: TextAlign.left,
                                                                            style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.w700)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8.0),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Expanded(
                                                                          child: new Container(
                                                                            alignment: Alignment.topLeft,
                                                                            height: 80.0,
                                                                            margin: const EdgeInsets.all(0.0),
                                                                            padding: const EdgeInsets.all(3.0),
                                                                            decoration: BoxDecoration(
                                                                                color:colors.greylight ,
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                                border: Border.all(color: Colors.grey)
                                                                            ),
                                                                            child: remarkField,
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ]),
                                                          )
                                                      ),

                                                      /* Row(
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
                                                      ),*/
                                                      SizedBox(height: 20.0),
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
                                                                if(leaveForCode == ""){
                                                                  commonAlert.showToast(context,"Select Leave for");
                                                                }else if(selectEmpCode == null){
                                                                  commonAlert.showToast(context,"Select Responsible Employee");
                                                                }else if(reasonController.text.isEmpty){
                                                                  commonAlert.showToast(context,"Enter Reason");
                                                                }else if(onleaveController.text.isEmpty){
                                                                  commonAlert.showToast(context,"Enter Contact number");
                                                                }else if(onleaveController.text.length<10){
                                                                  commonAlert.showToast(context,"Enter Correct Mobile Number");
                                                                }else if(remarksController.text.isEmpty){
                                                                  commonAlert.showToast(context,"Enter Remarks");
                                                                }else{
                                                                  if(selectEmpCode == null){
                                                                     selectEmpCode="";
                                                                  }
                                                                if(notPermitted==false){
                                                                  commonAlert.showToast(context,"Leave balance not available.Please check your leave chart");
                                                                }else{

                                                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                  setState(() {
                                                                    var relationshipID= preferences.getInt("RelationshipId") ?? 0;
                                                                    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
                                                                    var fyid = preferences.getInt("ActiveFinancialYearId")?? 0;
                                                                    var userid = preferences.getInt("UserId")?? 0;
                                                                    //print("API DATA");

                                                                    var fromDateSplit=showdateServer.split('-');
                                                                    var toDateSplit=hidedateServer.split('-');

                                                                    var day=fromDateSplit[2];
                                                                    var month=fromDateSplit[1];
                                                                    var year=fromDateSplit[0];

                                                                    var today=toDateSplit[2];
                                                                    var tomonth=toDateSplit[1] ;
                                                                    var toyear=toDateSplit[0];


                                                                    var date1 = DateTime(int.parse(year), int.parse(month),int.parse(day));
                                                                    final date2 = DateTime(int.parse(toyear), int.parse(tomonth),int.parse(today));
                                                                    var difference = date2.difference(date1).inDays;
                                                                    difference=difference+1;
                                                                    print(difference);
                                                                    if(difference<=5){
                                                                      commonAlert.showLoadingDialog(context, _keyLoader);
                                                                      saveLeave(context,relationshipID,sessionid,fyid,userid);
                                                                    }else{
                                                                      commonAlert.messageAlertError(context,"Sorry! more than 5 days leave not apply by mobile application","Not Allowed");
                                                                    }
                                                                  });

                                                                }
                                                              }
                                                                //uploadmultipleimage();
                                                              },
                                                              child: Text("Update",
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
                                    )
                                )
                              ]
                          )
                          // )
                          // ),

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

    List<DropdownMenuItem<String>> _dropDownItem() {
      List<String> ddl = ["Select", "Casual Leave", "Earned Leave", "Medical Leave"];
      return ddl
          .map((value) => DropdownMenuItem(
            value: value,
            child:  Text(value,style: new TextStyle(fontSize: 10.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700),),
      ))
          .toList();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 5,
      // margin: EdgeInsets.all(5),
      child: InkWell(
         // onTap: () => onEdit(index),
          child: Padding(
            padding:EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(userleavelist[index].dateDataUser,
                                    maxLines: 1,
                                    //textAlign: TextAlign.start,
                                    style: new TextStyle(color: Colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ],
                            )
                        ),
                      ),

                      Expanded(
                        child:new Container(
                          height: 30.0,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(userleavelist[index].typeName==null?'':userleavelist[index].typeName,
                                      maxLines: 1,
                                      //textAlign: TextAlign.start,
                                      style: new TextStyle(color: Colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                ],
                              )
                          ),
                        )
                      ),

                      Visibility(
                        visible: is_LeaveUpdateVisible==true?true:false,
                        child: Expanded(
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color:colors.greylight ,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Text('Select',style: new TextStyle(fontSize: 12.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                                isDense: true,
                                value: selectedItemValue[index],
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 10),
                                underline: SizedBox(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedItemValue[index]= value!;
                                    print(value);
                                    causalleaveGiven=0.0;
                                    earnedleaveGiven=0.0;
                                    medicalleaveGiven=0.0;
                                    sickleaveGiven=0.0;
                                    notPermitted=true;

                                    if(selectedItemValue[index]=='Casual Leave'){
                                      selectLaeaveCode=casualLeaveID;
                                    }else if(selectedItemValue[index]=='Earned Leave'){
                                      selectLaeaveCode=earnedLeaveID;
                                    }else if(selectedItemValue[index]=='Medical Leave'){
                                      selectLaeaveCode=medicalLeaveID;
                                    }else if(selectedItemValue[index]=='Sick Leave'){
                                      selectLaeaveCode=sickLeaveID;
                                    }else if(selectedItemValue[index]=='Leave Without Pay'){
                                      selectLaeaveCode=lwpID;
                                    }else{
                                      selectLaeaveCode="";
                                      causalleaveGiven=0.0;
                                      earnedleaveGiven=0.0;
                                      medicalleaveGiven=0.0;
                                      sickleaveGiven=0.0;
                                    }

                                  });
                                 if(selectLaeaveCode==""){
                                   commonAlert.showToast(context,"Select Leave Type");
                                  }else{
                                   print(selectLaeaveCode);
                                   print(earnedLeaveID);
                                   print(earnedleaveBal);
                                   setState(() {
                                     // commonAlert.dateFormateServer(context,inputFormat.parse(userleavelist[index].dateData))
                                     userleavelist[index]=new DayWiseStatus(dateData: userleavelist[index].dateData,dateDataUser: userleavelist[index].dateDataUser,abbrTypeIdEmployee: selectLaeaveCode);
                                     for(int i=0;i<userleavelist.length;i++){
                                       if(userleavelist[i].abbrTypeIdEmployee == casualLeaveID){
                                         causalleaveGiven+=isLeaveDays;
                                       }
                                       if(userleavelist[i].abbrTypeIdEmployee == earnedLeaveID){
                                         earnedleaveGiven+=isLeaveDays;
                                       }
                                       if(userleavelist[i].abbrTypeIdEmployee == medicalLeaveID){
                                         medicalleaveGiven+=isLeaveDays;
                                       }
                                       if(userleavelist[i].abbrTypeIdEmployee == sickLeaveID){
                                         sickleaveGiven+=isLeaveDays;
                                       }
                                     }

                                     if(causalleaveBal != null){
                                       if(causalleaveBal<causalleaveGiven){
                                         commonAlert.showToast(context,"Balance not available");
                                        // selectedItemValue=[];
                                         notPermitted=false;
                                       }
                                     }
                                     if(earnedleaveBal != null){
                                       if(earnedleaveBal<earnedleaveGiven){
                                         commonAlert.showToast(context,"Balance not available");
                                         //selectedItemValue=[];
                                         notPermitted=false;
                                       }
                                     }
                                     if(medicalleaveBal != null){
                                       if(medicalleaveBal<medicalleaveGiven){
                                         commonAlert.showToast(context,"Balance not available");
                                         //selectedItemValue=[];
                                         notPermitted=false;
                                       }
                                     }
                                     if(sickleaveBal != null){
                                       if(sickleaveBal<sickleaveGiven){
                                         commonAlert.showToast(context,"Balance not available");
                                        // selectedItemValue=[];
                                         notPermitted=false;
                                       }
                                     }
                                    // print(causalleaveGiven);

                                   });


                                 }
                               },

                               // items: _dropDownItem(),
                                items:leavetypeList.map((String data) {
                                  return DropdownMenuItem<String>(
                                    child: Text(data,style: new TextStyle(fontSize: 12.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                    value: data,
                                  );
                                }).toList(),

                                /*hint:Text(
                                "Select",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),



                              ),*/
                              ),
                            )
                        ),
                      ),

                    ])

              ],
            ),
          )

      ),
    );
  }






}