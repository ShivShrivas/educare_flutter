import 'dart:convert';
import 'dart:io';

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/conts/permissionrequest.dart';
import 'package:educareadmin/models/classcode.dart';
import 'package:educareadmin/models/classdata.dart';
import 'package:educareadmin/models/employedata.dart';
import 'package:educareadmin/models/leavefor.dart';
import 'package:educareadmin/models/leavemaster.dart';
import 'package:educareadmin/models/noticesaveresponse.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/models/subjectdata.dart';
import 'package:educareadmin/models/userslist.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfData.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;
import 'package:shared_preferences/shared_preferences.dart';

class CreateAssignment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateAssignmentState();
  }
}



class CreateAssignmentState extends State<CreateAssignment> {

  List<String> _status = ["All", "Students", "Staff"];
  List<String> _noticeFor = ["Class Wise", "Individual"];
  List<String> _noticeForStaff = ["Both","Teaching", "Non Teaching"];
  String _noticeForStaffValue = "Both";
  String _statusGroupValue = "All",groupType="1";
  String _noticeForGroupValue = "",noticeForType="0";
  String noticeForStaffType="1";
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  late String societyCode,fyID,sessionID,relationshipId;
  late String currentDate,hidedate,todate;
  late String showdateServer="",hidedateServer;
  var tranIDforfileUpload;

  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();



  List<ClassDataList> classlist = <ClassDataList>[];
  ClassDataList? selectedClassCode;
  String _classCode="0";

  List<SectionDataList> sectionlist = <SectionDataList>[];
  SectionDataList? selectedsectionCode;
  String _sectionCode="0";

  List<EmployeeData> userlist = <EmployeeData>[];
  EmployeeData? selectedUserCode;
  late String userCode,selectEmpCode;
  var sendusertypeId=1;
  String maxdate="";
  var colors= AppColors();
  late String code;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _fileName="",leaveForCode;
  late List<PlatformFile> _paths;
  late String _directoryPath;
  late String _extension='pdf,png,jpeg';
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  String  _filePath="";
  late int leavemasterCode;
  late String groupCode,schoolCode,branchCode,userID,empCode,departmentCode,designationCode;
  late File selectedFile;

  List<SubjectData> subjectlist = <SubjectData>[];
  SubjectData? selectedsubjectCode;
  String _subjectCode="0";

  List<LeaveFor> leaveForlist = <LeaveFor>[];
  LeaveFor? leaveFordrop;
  var emojiRegexp =
      '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';



  TextEditingController reasonController = new TextEditingController();
  TextEditingController onleaveController = new TextEditingController();
  TextEditingController remarksController = new TextEditingController();
  var saveuseId;

  List <String> spinnerItems = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five'
  ] ;


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

      });
    },onError: (e) {
      print(e);
    });

    Future<int> userIdData = sfdata.getUseId(context);
    userIdData.then((data) {
      setState(() {
        saveuseId=data.toString();
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
        print("maxdate " + maxdate);

        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        setState(() {
          currentDate = formatter.format(now);
          // DateTime maxtodayDate = DateTime.parse(maxdate);
          // maxdate = formatter.format(maxtodayDate);
          showdateServer = commonAlert.dateFormateServer(context, now);
          todate=currentDate;
          hidedateServer = commonAlert.dateFormateServer(context, formatter.parse(todate));
          print("hidedateServer " + hidedateServer);
          print("showdateServer " + showdateServer);
        });

      });
    },onError: (e) {
      print(e);
    });

    leaveForlist.add(new LeaveFor(name: "",fullName: "---Select Leave For---"));
    leaveForlist.add(new LeaveFor(name: "F",fullName: "Full"));
    leaveForlist.add(new LeaveFor(name: "HDF",fullName: "First Half"));
    leaveForlist.add(new LeaveFor(name: "HDS",fullName: "Second Half"));

    classList();
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
            todate=commonAlert.dateFormate(context, newDate);
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


  //////////////////  Class API //////////////////////
  Future<Null> classList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getClassListdiscussion("6",relationshipid,sessionid,saveuseId,fyID)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          classlist=result;
         // selectedClassCode = result[0];
         // _classCode = result[0].classCode.toString();
          //  print("OutputrelationshipId2 "+ classlist[0].className);
         // sectionList();
        });

      }else{
        this.classlist = [];
      }

    }).catchError((error) {

      print(error);
    });
  }

  //////////////////  Sections API //////////////////////
  Future<Null> sectionList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getSectionListdiscussion("6",relationshipid,sessionid,saveuseId,fyID,_classCode)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          if(result[0].code != null){
            sectionlist=result;
            selectedsectionCode= result[0];
           // _sectionCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          }else{
            _sectionCode="0";
            this.sectionlist = [];
          }

        });
      }else{
        this.sectionlist = [];
      }
    }).catchError((error) {
      print(error);
    });
  }

  //////////////////  Subject API //////////////////////
  Future<Null> subjectList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var relationshipid= preferences.getInt("RelationshipId") ?? 0;
    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getSubjectList("7",relationshipid,sessionid,saveuseId,fyID,_classCode,_sectionCode)
        .then((result) {
      if(result.isNotEmpty){
        setState(() {
          if(result[0].code != null){
            subjectlist=result;
            selectedsubjectCode=result[0];
            // _subjectCode = result[0].code.toString();
            //print("OutputrelationshipId2 "+ classlist[0].className);
          }else{
            _subjectCode="0";
            this.subjectlist = [];
          }
          //  getStudentList();
        });
      }else{
        setState(() {
          _subjectCode="0";
          this.subjectlist = [];

        });

      }
    }).catchError((error) {
      print(error);
    });
  }



  Future uploadfile(String tranId,int relationshipID,int sessionid) async{
    Map<String, String> allheaders = {
      'Content-Type': 'multipart/form-data',
      "Accept": "application/json"
    };
    var request = http.MultipartRequest('POST', Uri.parse(colors.imageUploadUrl+'DigitalNoticeBoardApi/InsertUpdateDeleteDigitalNoticeBoardFiles'));
    request.headers.addAll(allheaders);
    request.fields.addAll({
      'TransID': tranId,
      'RelationshipId': relationshipId,
      'SessionId': sessionID
    });
    print("--NEWPATHHTTP--- "+_filePath);
    request.files.add(await http.MultipartFile.fromPath('File', _filePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _fileName="";
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"Notice saved successfully","Successfully");
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

  Future uploadMultipleImage(String tranId,int relationshipID,int sessionid) async {
    var uri = Uri.parse("http://192.168.0.2:91/api/DigitalNoticeBoardApi/InsertUpdateDeleteDigitalNoticeBoardFiles");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = "multipart/form-data"; //multipart/form-data
    request.fields['TransID'] = "DINTC0100200020120212021000000047";
    request.fields['RelationshipId'] = relationshipId;
    request.fields['SessionId'] =sessionID;
    // var multipartFile = new http.MultipartFile("imagefile", stream, length, filename: _filePath);
    if(_filePath.isNotEmpty) {
      print("--NEWPATH--- "+_filePath);
      request.files
          .add(await http.MultipartFile.fromPath('File', _filePath));
      // var multipartFile = new http.MultipartFile.fromBytes('File', File(_filePath).readAsBytesSync(), filename: _filePath.split("/").last);
      // var multipartFile = new http.MultipartFile.fromString('File',_filePath, filename: _fileName);
      /*var multipartFile = new http.MultipartFile.fromBytes(
          'File', selectedFile.readAsBytesSync(),
          filename: selectedFile.path.split("/").last);*/
      //request.files.add(multipartFile);
    }else{
      print("NO _    Image Uploaded");
    }
    /* List<MultipartFile> newList = new List<MultipartFile>();

    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i].toString());
      var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile("imagefile", stream, length,
          filename: basename(imageFile.path));
      newList.add(multipartFile);
    }*/


    var response = await request.send();

    if (response.statusCode == 200) {
      _filePath="";
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"Notice saved successfully","Successfully");
      print("Image Uploaded");
    } else {
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"File Uploading Failed","Error");
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  void selectFileSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(20)
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.2,
            child: AnimatedContainer(
              duration: Duration(seconds: 10),
              child: Padding(
                padding:  new EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        new Text("Select File",style: TextStyle(fontSize: 15.0,fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,color: colors.bluelight)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        FlatButton(
                          child: new Text("File  (pdf,png,jpeg)",style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,color: colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                            _openFileExplorer();
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    /*Row(
                        children: [
                          FlatButton(
                            child: new Text("Audio    (mp3,wav)",style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,color: colors.black)),
                            onPressed: () {
                              Navigator.pop(context);
                              openAudioPicker();
                            },
                          ),
                        ]),*/
                  ],
                ),
              ),

            ),

          );

        });
  }





  /*Future<void> saveLeave(BuildContext context,int relationshipId,int sessionID,int fyID,int userID) async {
    final api = Provider.of<ApiService>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("STOREDATA---- $relationshipId " "$sessionID " "$fyID " "$userID");
    return await api.createLeave(empCode,leaveForCode,designationCode,departmentCode,showdateServer,hidedateServer,reasonController.text,remarksController.text,leavemasterCode,"",onleaveController.text,"","",selectEmpCode,"","",relationshipId,fyID,sessionID,userID,"1")
        .then((result) {
      if(result.isNotEmpty){
        Navigator.of(context,rootNavigator: true).pop();
        commonAlert.messageAlertSuccess(context,"Leave application submitted successfully","Successfully");
      }

    }).catchError((error) {
      print("Exception");
      print(error);
      Navigator.of(context,rootNavigator: true).pop();
      commonAlert.messageAlertSuccess(context,"Notice not uploaded","Error");
    });
  }
*/
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final reasonfield = TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(80),FilteringTextInputFormatter.deny(
       RegExp(emojiRegexp))],
      controller: reasonController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Topic",
        enabled: true,

      ),
    );

    final onleaveContact = TextField(
      controller: onleaveController,
      keyboardType: TextInputType.phone,
      inputFormatters:[LengthLimitingTextInputFormatter(10),],
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
        hintText: "Enter description",
        enabled: true,
      ),
    );



    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("New Assignment",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700)),
        leading: new IconButton(
          // icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed:() {
              Navigator.pop(context,'Yep!');
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
                                          ////////////////////////// Select Class Section  ///////////////////////////////////////////
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
                                                                          child: Text("Class",textAlign: TextAlign.left,
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
                                                                                  color:colors.greylight,
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                  border: Border.all(color: Colors.grey)
                                                                              ),
                                                                              child: DropdownButton<ClassDataList>(
                                                                                isExpanded: true,
                                                                                value: selectedClassCode,
                                                                                icon: Icon(Icons.arrow_drop_down),
                                                                                iconSize: 24,
                                                                                elevation: 16,
                                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                                                underline: SizedBox(),
                                                                                /*underline: Container(
                                                                                  height: 2,
                                                                                  color: Colors.deepPurpleAccent,
                                                                                ),*/
                                                                                onChanged: (ClassDataList? data) {
                                                                                  setState(() {
                                                                                    selectedClassCode = data!;
                                                                                    _classCode=selectedClassCode!.classCode;
                                                                                    //print(selectedClassCode.classCode);
                                                                                    sectionList();
                                                                                  });
                                                                                },
                                                                                items: this.classlist.map((ClassDataList data) {
                                                                                  return DropdownMenuItem<ClassDataList>(
                                                                                    child: Text("  "+data.className,style: new TextStyle(fontSize: 14.0,
                                                                                        fontFamily: 'Montserrat',
                                                                                        fontWeight: FontWeight.w700)),
                                                                                    value: data,
                                                                                  );
                                                                                }).toList(),

                                                                                hint:Text(
                                                                                  "Select Class",
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
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children:<Widget>[
                                                                    Row(
                                                                      children: [
                                                                        Padding(padding:  new EdgeInsets.all(5.0),
                                                                          child: Text("Section",textAlign: TextAlign.left,
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
                                                                              child: DropdownButton<SectionDataList>(
                                                                                isExpanded: true,
                                                                                value: selectedsectionCode,
                                                                                icon: Icon(Icons.arrow_drop_down),
                                                                                iconSize: 24,
                                                                                elevation: 16,
                                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                                                underline: SizedBox(),
                                                                                onChanged: (SectionDataList? data) {
                                                                                  setState(() {
                                                                                    selectedsectionCode = data!;
                                                                                    _sectionCode=selectedsectionCode!.code;
                                                                                    subjectList();
                                                                                    //print(sendusertypeId);
                                                                                  });
                                                                                },
                                                                                items: this.sectionlist.map((SectionDataList data) {
                                                                                  return DropdownMenuItem<SectionDataList>(
                                                                                    child: Text("  "+data.sectionName,style: new TextStyle(fontSize: 14.0,
                                                                                        fontFamily: 'Montserrat',
                                                                                        fontWeight: FontWeight.w700)),
                                                                                    value: data,
                                                                                  );
                                                                                }).toList(),

                                                                                hint:Text(
                                                                                  "Select Section",
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
                                                            ),
                                                          ]),
                                                    ]),
                                              )
                                          ),
                                          ////////////////////////// Select Subject  ///////////////////////////////////////////
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
                                                                          child: Text("Group",textAlign: TextAlign.left,
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
                                                                              child: DropdownButton<LeaveFor>(
                                                                                isExpanded: true,
                                                                                value: leaveFordrop,
                                                                                icon: Icon(Icons.arrow_drop_down),
                                                                                iconSize: 24,
                                                                                elevation: 16,
                                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                                                underline: SizedBox(),
                                                                                /*underline: Container(
                                                                                   height: 2,
                                                                                   color: Colors.deepPurpleAccent,
                                                                                 ),*/
                                                                                onChanged: (LeaveFor? data) {
                                                                                  setState(() {
                                                                                    leaveFordrop = data!;
                                                                                    leaveForCode=leaveFordrop!.name;
                                                                                    print(leaveForCode);
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
                                                                                  "Select Group",
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
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                                              child: DropdownButton<SubjectData>(
                                                                                isExpanded: true,
                                                                                value: selectedsubjectCode,
                                                                                icon: Icon(Icons.arrow_drop_down),
                                                                                iconSize: 24,
                                                                                elevation: 16,
                                                                                style: TextStyle(color: Colors.black, fontSize: 18),
                                                                                underline: SizedBox(),
                                                                                /*underline: Container(
                                                                                 height: 2,
                                                                                 color: Colors.deepPurpleAccent,
                                                                                 ),*/
                                                                                onChanged: (SubjectData? data) {
                                                                                  setState(() {
                                                                                    selectedsubjectCode = data!;
                                                                                    _subjectCode=selectedsubjectCode!.code;
                                                                                    print(_subjectCode);
                                                                                  });
                                                                                },
                                                                                items: this.subjectlist.map((SubjectData data) {
                                                                                  return DropdownMenuItem<SubjectData>(
                                                                                    child: Text(data.subjectName,style: new TextStyle(fontSize: 14.0,
                                                                                        fontFamily: 'Montserrat',
                                                                                        fontWeight: FontWeight.w700),),
                                                                                    value: data,
                                                                                  );
                                                                                }).toList(),

                                                                                hint:Text(
                                                                                  "Select Subject",
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
                                                            ),


                                                          ]),


                                                    ]),
                                              )

                                          ),
                                          ////////////////////////// Date  ///////////////////////////////////////////
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
                                                                            child: Text("Show Date",textAlign: TextAlign.left,
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
                                                                          child: Text(currentDate,textAlign: TextAlign.start,style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.w700)),
                                                                        )
                                                                    ),

                                                                  ]),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children:<Widget>[
                                                                    Row(
                                                                        children: [
                                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                                            child: Text("Hide Date",textAlign: TextAlign.left,
                                                                                style: new TextStyle(color: colors.black,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                                    fontWeight: FontWeight.w700)),
                                                                          ),
                                                                        ]),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          displayCalendar(context,2);
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
                                                          ]),
                                                      /*const Divider(
                                                           height: 20,
                                                           thickness: 2,
                                                           color: Colors.red,
                                                         ),*/
                                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                      Row(
                                                        children: [
                                                          Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Text("Topic",textAlign: TextAlign.left,
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
                                          ////////////////////////// Remarks  ///////////////////////////////////////////
                                          Container(
                                              child: Padding(padding:  new EdgeInsets.all(5.0),
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                    children:<Widget>[
                                                      ////////////////////////// Remarks  ///////////////////////////////////////////
                                                      SizedBox(height: 8.0),
                                                      Container(
                                                          child: Padding(padding:  new EdgeInsets.all(5.0),
                                                            child: Column(
                                                              //mainAxisAlignment: MainAxisAlignment.center,
                                                                children:<Widget>[
                                                                  Row(
                                                                    children: [
                                                                      Padding(padding:  new EdgeInsets.all(0.0),
                                                                        child: Text("Description",textAlign: TextAlign.left,
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

                                                                if(leaveForCode == null){
                                                                  commonAlert.showToast(context,"Select Leave for");
                                                                }else if(leavemasterCode == null){
                                                                  commonAlert.showToast(context,"Select Leave Type");
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
                                                                  commonAlert.showLoadingDialog(context, _keyLoader);
                                                                  SharedPreferences preferences = await SharedPreferences.getInstance();
                                                                  setState(() {
                                                                    var relationshipID= preferences.getInt("RelationshipId") ?? 0;
                                                                    var sessionid = preferences.getInt("ActiveAcademicYearId") ?? 0;
                                                                    var fyid = preferences.getInt("ActiveFinancialYearId")?? 0;
                                                                    var userid = preferences.getInt("UserId")?? 0;
                                                                    //print("API DATA");
                                                                    //saveLeave(context,relationshipID,sessionid,fyid,userid);
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




}