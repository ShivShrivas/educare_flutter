import 'dart:convert';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/assignleavechart.dart';
import 'package:educareadmin/models/empleavedata.dart';
import 'package:educareadmin/models/leavechartdata.dart';
import 'package:educareadmin/models/leavefor.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/leavetype.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveAppDetails extends StatefulWidget {

  CommonAction common= CommonAction();

  LeaveAppDetails(this.leaveData) : super();

  final LeaveList leaveData;


  @override
  State<StatefulWidget> createState() {
    return LeaveAppDetailsState();
  }
}


class LeaveAppDetailsState extends State<LeaveAppDetails> {



  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  var sessionId;
  var relationshipId;
  var empCode,fyID;

  SFData sfdata= SFData();

  List<LeaveChartData> leavechartlist = <LeaveChartData>[];

  List<EmpleaveData> userleavelist = <EmpleaveData>[];
  late EmpleaveData userleavelistCode;

  List<LeaveFor> leaveForlist = <LeaveFor>[];
  List<AssignLeaveChart> assignLeaveChart = <AssignLeaveChart>[];
  LeaveFor? leaveFordrop;
  late AssignLeaveChart assignChart;
  late String leaveForCode;
  late String leaveForName;
  var difference;
  var isApproved=0;
  var isLeaveDays=0.0;

  late String currentDate,hidedate,todate;
  var colors= AppColors();

  bool isLoader = false;
  bool ifReject = false;
  List<LeaveTypeData> leavetypelist = <LeaveTypeData>[];
  late LeaveTypeData _leaveTypeData;
  var leaveabbrType,selectLaeaveCode;
  int casualLeaveID=0,earnedLeaveID=0,medicalLeaveID=0,sickLeaveID=0,lwpID=0;
  var casualLeaveCode,earnedLeaveCode,medicalLeaveCode,sickLeaveCode,lwpcode;
  var showSheet=1;
  var rejectDate;

  var causalleaveGiven=0.0,earnedleaveGiven=0.0,medicalleaveGiven=0.0,sickleaveGiven=0.0,lwpleaveGiven=0.0;
  var causalleaveBal=0.0,earnedleaveBal=0.0,medicalleaveBal=0.0,sickleaveBal=0.0;
  int currentIndex=5;
  var finalLeaveStatus='2';

  CommonAction commonAlert= CommonAction();

  List<String> selectedItemValue=<String>[];
  List<String> selectedItemValueStatus=[];
  bool is_LeaveUpdateVisible=false;
  var newleaveCode=0;
  List<String> leavetypeList=<String>[];
  List<LeaveTypeData> leaveMasterlist = <LeaveTypeData>[];

  var emojiRegexp =
      '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';


  TextEditingController remarkController = new TextEditingController();

  List<String> leaveArray = ["Select", "Casual Leave", "Earned Leave", "Medical Leave", "Sick Leave"];
  var selectdropDown="Select";

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);

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


  //////////////////  leaveTypeList API //////////////////////
  Future<Null> leaveTypeList() async {
    leavetypeList.add('Change');
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listtypeChart("14")
        .then((result) {
      setState(() {
        isLoader = false;
        if(result.isNotEmpty){
          leavetypelist=result.toList();
          for(int i=0;i<leavetypelist.length;i++){
            leavetypeList.add(leavetypelist[i].abbrType);
            AssignLeaveChart assignleavechart=new AssignLeaveChart(leaveTypeCode: leavetypelist[i].code,approvedLeave: 0.0);
            assignLeaveChart.add(assignleavechart);

            if(leavetypelist[i].abbrType=='Casual Leave'){
              casualLeaveID=leavetypelist[i].abbrTypeId;
              casualLeaveCode=leavetypelist[i].code;
            }
            if(leavetypelist[i].abbrType=='Earned Leave'){
              earnedLeaveID=leavetypelist[i].abbrTypeId;
              earnedLeaveCode=leavetypelist[i].code;
            }
            if(leavetypelist[i].abbrType=='Medical Leave'){
              medicalLeaveID=leavetypelist[i].abbrTypeId;
              medicalLeaveCode=leavetypelist[i].code;
            }
            if(leavetypelist[i].abbrType=='Sick Leave'){
              sickLeaveID=leavetypelist[i].abbrTypeId;
              sickLeaveCode=leavetypelist[i].code;
            }
            if(leavetypelist[i].abbrType=='Leave Without Pay'){
              lwpID=leavetypelist[i].abbrTypeId;
              lwpcode=leavetypelist[i].code;
            }
          }

          leaveBalanceList();
        }else{
          this.leavetypelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        isLoader = false;
      });
      print(error);
    });
  }



  //////////////////  leaveTypeList API //////////////////////
  Future<Null> leaveStatusList() async {
    userleavelist = <EmpleaveData>[];
    EasyLoading.show(status: 'loading...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listStatusChart("14",widget.leaveData.transId,relationshipId,sessionId,fyID)
        .then((result) {
      EasyLoading.dismiss();
      setState(() {
       // isLoader = false;
        if(result.isNotEmpty){
          userleavelist=result.toList();
          if(widget.leaveData.empApprovalLevel == "1"){
            for (int i = 0; i < userleavelist.length; i++) {
              selectedItemValue.add("Change");
              selectedItemValueStatus.add("Approved");
            }
          }else{
            for (int i = 0; i < userleavelist.length; i++){
              userleavelist[i]=new EmpleaveData(dateData: userleavelist[i].dateData,abbrTypeIdFirst:userleavelist[i].abbrTypeIdFirst,firstIsApproved:userleavelist[i].firstIsApproved,abbrTypeIdSecond: userleavelist[i].abbrTypeIdFirst,secondIsApproved:userleavelist[i].firstIsApproved, leaveTypeName: userleavelist[i].leaveTypeName, secondLeaveTypeName: userleavelist[i].leaveTypeName);
              selectedItemValue.add("Change");
              selectedItemValueStatus.add("Approved");
            }
          }
          leaveTypeList();
        }else{
          this.userleavelist=[];
        }
      });
    }).catchError((error) {
      setState(() {
        EasyLoading.dismiss();
       // isLoader = false;
      });
      print(error);
    });
  }


  //////////////////  Balance API //////////////////////
  Future<Null> leaveBalanceList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   // isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .listLeaveChart(widget.leaveData.employeeCode,"5",relationshipId,sessionId,fyID)
        .then((result) {
        setState(() {
       // isLoader = false;
        if(result.isNotEmpty){
          setState(() {

            leavechartlist=result.toList();
            for (int i = 0; i < leavechartlist.length; i++) {
                 if(leavechartlist[i].leaveType=='Casual Leave'){
                   causalleaveBal=leavechartlist[i].balance;
                 }
                 if(leavechartlist[i].leaveType=='Earned Leave'){
                   earnedleaveBal=leavechartlist[i].balance;
                 }
                 if(leavechartlist[i].leaveType=='Medical Leave'){
                   medicalleaveBal=leavechartlist[i].balance;
                 }
                 if(leavechartlist[i].leaveType=='Sick Leave'){
                   sickleaveBal=leavechartlist[i].balance;
                 }
            }

            for(int i=0;i<userleavelist.length;i++){

              if(int.parse(userleavelist[i].abbrTypeIdFirst) == casualLeaveID){
                causalleaveGiven+=isLeaveDays;
                for(int j=0;j<assignLeaveChart.length;j++){
                  if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                    assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                  }
                }
              }
              if(int.parse(userleavelist[i].abbrTypeIdFirst) == earnedLeaveID){
                earnedleaveGiven+=isLeaveDays;
                for(int j=0;j<assignLeaveChart.length;j++){
                  if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                    assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                  }
                }
              }
              if(int.parse(userleavelist[i].abbrTypeIdFirst) == medicalLeaveID){
                medicalleaveGiven+=isLeaveDays;
                for(int j=0;j<assignLeaveChart.length;j++){
                  if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                    assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                  }
                }

              }
              if(int.parse(userleavelist[i].abbrTypeIdFirst) == sickLeaveID){

                sickleaveGiven+=isLeaveDays;
                for(int j=0;j<assignLeaveChart.length;j++){
                  if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                    assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                  }
                }

              }
              if(int.parse(userleavelist[i].abbrTypeIdFirst) == lwpID){

                lwpleaveGiven+=isLeaveDays;
                for(int j=0;j<assignLeaveChart.length;j++){
                  if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                    assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                  }
                }

              }
            }
            print("MAIN---   ${jsonEncode(assignLeaveChart)}");
           // print("CUALLEVAE-GIVEN  "+causalleaveGiven.toString());

          });
        }else{

         // this.leavelist=[];
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  _finalleaveStatus(){
    setState(() {
      if(widget.leaveData.empApprovalLevel == "1"){
        for(int i=0;i<userleavelist.length;i++){
          if(userleavelist[i].firstIsApproved=='1'){
            finalLeaveStatus="1";
          }else{
            rejectDate=userleavelist[i].dateData;
          }
        }
      }else{
        for(int i=0;i<userleavelist.length;i++){
          if(userleavelist[i].secondIsApproved=='1'){
            finalLeaveStatus="1";
          }else{
            rejectDate=userleavelist[i].dateData;
          }
        }
      }

    });
  }

  //////////////////  Balance API //////////////////////
  Future<Null> saveLeaveList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _finalleaveStatus();
    print("FINAL STATUS--   $finalLeaveStatus");

    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .leaveApprovals("13",remarkController.text,finalLeaveStatus,commonAlert.dateFormateStringServer(context,currentDate),commonAlert.dateFormateStringServer(context,todate),widget.leaveData.employeeCode,widget.leaveData.transId,empCode,empCode,jsonEncode(assignLeaveChart),jsonEncode(userleavelist),sessionId,relationshipId,fyID)
        .then((result) {
      Navigator.of(context,rootNavigator: true).pop();
      setState(() {
        if(result.isNotEmpty){
          setState((){
            print(result.toString());
            if(result.toString()=='"2"'){
              commonAlert.messageAlertSuccess(context,"Leave application approved successfully","Approved");
            }else if(result.toString()=='"3"'){
              commonAlert.messageAlertSuccess(context,"Leave application Rejected","Rejected");
            }else{
              commonAlert.messageAlertError(context,"Leave application not approved","Error");
            }
          });
        }else{
          // this.leavelist=[];
        }
      });
    }).catchError((error) {
      Navigator.of(context,rootNavigator: true).pop();
      print(error);
    });




   /* ---





    if(rejectDate==null){
      final api = Provider.of<ApiService>(context, listen: false);
      return await api
          .leaveApprovals("13",remarkController.text,finalLeaveStatus,commonAlert.dateFormateStringServer(context,currentDate),commonAlert.dateFormateStringServer(context,todate),widget.leaveData.employeeCode,widget.leaveData.transId,empCode,empCode,jsonEncode(assignLeaveChart),jsonEncode(userleavelist),sessionId,relationshipId,fyID)
          .then((result) {
        Navigator.of(context,rootNavigator: true).pop();
        setState(() {
          if(result.isNotEmpty){
            setState((){
              print(result.toString());
              if(result.toString()=='"2"'){
                commonAlert.messageAlertSuccess(context,"Leave application approved successfully","Approved");
              }else if(result.toString()=='"3"'){
                commonAlert.messageAlertSuccess(context,"Leave application Rejected","Rejected");
              }else{
                commonAlert.messageAlertError(context,"Leave application not approved","Error");
              }
            });
          }else{
            // this.leavelist=[];
          }
        });
      }).catchError((error) {
        Navigator.of(context,rootNavigator: true).pop();
        print(error);
      });

    }else{

      /*var fromDateSplit=commonAlert.dateFormateMMtoM(context,rejectDate).split('-');
      var toDateSplit=todate.split('-');

      var day=fromDateSplit[0];
      var month=fromDateSplit[1];
      var year=fromDateSplit[2];

      var today=toDateSplit[0];
      var tomonth=toDateSplit[1] ;
      var toyear=toDateSplit[2];
      var date1 = DateTime(int.parse(year), int.parse(month),int.parse(day));
      final date2 = DateTime(int.parse(toyear), int.parse(tomonth),int.parse(today));*/

      final api = Provider.of<ApiService>(context, listen: false);
      return await api
          .leaveApprovals("13",remarkController.text,finalLeaveStatus,commonAlert.dateFormateStringServer(context,currentDate),commonAlert.dateFormateStringServer(context,todate),widget.leaveData.employeeCode,widget.leaveData.transId,empCode,empCode,jsonEncode(assignLeaveChart),jsonEncode(userleavelist),sessionId,relationshipId,fyID)
          .then((result) {
        Navigator.of(context,rootNavigator: true).pop();
        setState(() {
          if(result.isNotEmpty){
            setState((){
              print(result.toString());
              if(result.toString()=='"2"'){
                commonAlert.messageAlertSuccess(context,"Leave application approved successfully","Approved");
              }else if(result.toString()=='"3"'){
                commonAlert.messageAlertSuccess(context,"Leave application Rejected","Rejected");
              }else{
                commonAlert.messageAlertError(context,"Leave application not approved","Error");
              }

            });
          }else{
            // this.leavelist=[];
          }
        });
      }).catchError((error) {
        Navigator.of(context,rootNavigator: true).pop();
        print(error);
      });

      /*if(date1==date2){
        final api = Provider.of<ApiService>(context, listen: false);
        return await api
            .leaveApprovals("13",remarkController.text,finalLeaveStatus,commonAlert.dateFormateStringServer(context,currentDate),commonAlert.dateFormateStringServer(context,todate),widget.leaveData.employeeCode,widget.leaveData.transId,empCode,empCode,jsonEncode(assignLeaveChart),jsonEncode(userleavelist),sessionId,relationshipId,fyID)
            .then((result) {
          Navigator.of(context,rootNavigator: true).pop();
          setState(() {
            if(result.isNotEmpty){
              setState((){
                print(result.toString());
                if(result.toString()=='"2"'){
                  commonAlert.messageAlertSuccess(context,"Leave application approved successfully","Approved");
                }else if(result.toString()=='"3"'){
                  commonAlert.messageAlertSuccess(context,"Leave application Rejected","Rejected");
                }else{
                  commonAlert.messageAlertError(context,"Leave application not approved","Error");
                }

              });
            }else{
              // this.leavelist=[];
            }
          });
        }).catchError((error) {
          Navigator.of(context,rootNavigator: true).pop();
          print(error);
        });


      }else{
        Navigator.of(context,rootNavigator: true).pop();
        commonAlert.messageAlertError(context,"Not Allowed Reject in middle dates","Error");
      }*/

   */



  }


  void displayCalendar(BuildContext context,int caltype) {
    var showdateServer;
    if(caltype ==1){
      showdateServer = commonAlert.dateFormateStringServer(context,currentDate);
    }else{
      showdateServer = commonAlert.dateFormateStringServer(context,todate);
    }
      CupertinoRoundedDatePicker.show(
      context,
      fontFamily: "Montserrat",
      textColor: Colors.white,
      background: colors.redtheme,
      borderRadius: 16,
      initialDatePickerMode: CupertinoDatePickerMode.date,
      initialDate:DateTime.parse(showdateServer),
     //minimumDate: DateTime.now().subtract(Duration(days: 1)),
      onDateTimeChanged: (newDate) {
        setState(() {
          if(caltype ==1){
            currentDate=commonAlert.dateFormate(context, newDate);
            //showdateServer = commonAlert.dateFormateServer(context, newDate);
          }else{
            todate=commonAlert.dateFormate(context, newDate);
            //hidedateServer = commonAlert.dateFormateServer(context, newDate);
            //hidedate = formatter.format(newDate);

          }
         // print("formatted " + currentDate);
        });

      },
    );

  }



  @override
  void initState() {

    currentDate=widget.leaveData.leaveFrom;
    todate=widget.leaveData.leaveTo;
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
      });
    },onError: (e) {
      print(e);
    });

    setState(() {

      if(widget.leaveData.leaveFor=="F"){
        isLeaveDays=1;
      }else{
        isLeaveDays=0.5;
      }

      leaveForlist.add(new LeaveFor(name: "1",fullName: "Approved"));
      leaveForlist.add(new LeaveFor(name: "2",fullName: "Reject"));
      leaveForName=leaveForlist[0].fullName;
      leaveForCode=leaveForlist[0].name;

      if(widget.leaveData.empApprovalLevel=="1"){
        if(widget.leaveData.firstApprovalStatus=="Approved"){
          isApproved=1;
        }else if(widget.leaveData.firstApprovalStatus=="Rejected"){
          isApproved=2;
        }else{
          isApproved=0;
          leaveStatusList();
        }
      }else{
        if(widget.leaveData.secondApprovalStatus=="Approved"){
          isApproved=1;
        }else if(widget.leaveData.secondApprovalStatus=="Rejected"){
          isApproved=2;
        }else{
          isApproved=0;
          leaveStatusList();
        }

      }

      /*var fromdate=widget.leaveData.leaveFrom;
      var todate=widget.leaveData.leaveTo;
      var fromDateSplit=fromdate.split('-');
      var toDateSplit=todate.split('-');

      var day=fromDateSplit[0];
      var month=fromDateSplit[1];
      var year=fromDateSplit[2];

      var today=toDateSplit[0];
      var tomonth=toDateSplit[1] ;
      var toyear=toDateSplit[2];


      //var date1 = DateTime(int.parse(year), int.parse(month),int.parse(day));
      //final date2 = DateTime(int.parse(toyear), int.parse(tomonth),int.parse(today));

      var date1 = DateTime(2021, 10,05);
      final date2 = DateTime(2021, 10,09);
      difference = date2.difference(date1).inDays;
      difference=difference+1;
      print(difference);
      for(int i=0;i<difference;i++){
        //date1 = new DateTime(date1.year, date1.month, date1.day + 1);
        String formattedDate = DateFormat('dd-MM-yyyy').format(date1);
        print(date1);
        userleavelist.add(new EmpleaveData(date: formattedDate,abbrTypeIdFirst: "Second Half",firstIsApproved: "",abbrTypeIdSecond: "Second Half",secondIsApproved: ""));
        date1=new DateTime(date1.year, date1.month, date1.day + 1);
      }
      print(userleavelist.length);*/
    });


    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    CommonAction common= CommonAction();
    var colors= AppColors();

    Color getMyColor(String moneyCounter) {
      if (moneyCounter == 'Pending'){
        return colors.yellow;
      } else if (moneyCounter == 'Rejected') {
        return colors.metirialred;
      }else{
        return colors.metirialgreen;
      }
    }


    final reasonfield = TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(80),FilteringTextInputFormatter.deny(
        RegExp(emojiRegexp),
      )],
      controller: remarkController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Remarks",
        enabled: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Application Details",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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
        GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
                child:  Container(
                  child: Column(
                      children: <Widget>[
                        //SizedBox(height: MediaQuery.of(context).size.height * 0.14),
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
                                      height: 35.0,
                                      // color: widget.leaveData.status == "Pending" ? colors.metirialred:colors.metirialgreen,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:Container(
                                              color: getMyColor(widget.leaveData.firstApprovalStatus),
                                              child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: widget.leaveData.firstApprovalStatus != null
                                                              ? widget.leaveData.firstApprovalStatus.toUpperCase() : '',
                                                              style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                              text:'1st Level',
                                                              style: new TextStyle(color: colors.white,fontSize: 9.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ),
                                          SizedBox(width:1.0),
                                          Visibility(
                                            visible: widget.leaveData.secondApprovalStatus == "" ? false : true,
                                            child:Expanded(
                                              child:Container(
                                                color: getMyColor(widget.leaveData.secondApprovalStatus),
                                                child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: widget.leaveData.secondApprovalStatus!= null
                                                                  ? widget.leaveData.secondApprovalStatus.toUpperCase() : '',
                                                            style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            text:'2nd Level',
                                                            style: new TextStyle(color: colors.white,fontSize: 9.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                              ),

                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  SizedBox(height: 5.0),
                                  Padding(
                                    padding: new EdgeInsets.all(10.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      //mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text('Reason',maxLines: 1, textAlign:TextAlign.left,
                                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                          Row(
                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                             // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(widget.leaveData.leaveReason != null
                                                      ? widget.leaveData.leaveReason
                                                      : '',style: new TextStyle(color: colors.blue,fontSize: 13.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                                ),

                                              ]),

                                          SizedBox(height: 5.0),
                                          Text('Remark',maxLines: 1, textAlign:TextAlign.left,
                                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700)),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child:Text(widget.leaveData.remarks != null
                                                      ? widget.leaveData.remarks : '',style: new TextStyle(color: colors.greydark,fontSize: 12.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700)),
                                                ),
                                              ]),
                                          SizedBox(height: 10.0),

                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child:Text(widget.leaveData.resName != null
                                                      ? 'Responsible Person- '+widget.leaveData.resName
                                                      : '',
                                                      style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ),//
                                              ]),
                                          SizedBox(height: 5.0),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child:Text(widget.leaveData.resName != null
                                                      ? 'Contact No.- '+widget.leaveData.onLeaveContactNo
                                                      : '',
                                                      style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ),
                                              ]),

                                          SizedBox(height: 10.0),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Expanded(
                                                  child:Text(widget.leaveData.leaveFor != null
                                                      ? 'Leave For- '+ common.leavefordata(context, widget.leaveData.leaveFor)
                                                      : '',style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ),
                                              ]),

                                          SizedBox(height: 10.0),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children:<Widget>[
                                                Expanded(
                                                  child: Text(widget.leaveData.leaveFrom != null ? "From Date: "+widget.leaveData.leaveFrom:'',
                                                      textAlign: TextAlign.start,
                                                      style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                ),
                                                Expanded(
                                                  child: Text(widget.leaveData.leaveTo != null ? "To Date: "+widget.leaveData.leaveTo :'',
                                                      textAlign: TextAlign.end,
                                                      style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight.w700)),
                                                )
                                              ]),

                                          Visibility(
                                                 visible: isApproved==1 ? true:isApproved==2 ? true: false,
                                                 child: Column(
                                                  children: [
                                                    SizedBox(height: 40.0),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child:Text(isApproved==1?'Leave Approved !!':'Leave Rejected !!',
                                                                // maxLines: 5,
                                                                textAlign: TextAlign.center,
                                                                style: new TextStyle(color: isApproved==1 ? colors.lightgreen : isApproved==2 ? colors.red : colors.lightgreen,fontSize: 16.0,fontFamily: 'Montserrat',
                                                                    fontWeight: FontWeight.w700)),
                                                          ),
                                                        ]),
                                                    ],
                                                 ),
                                             ),

                                          Visibility(
                                              visible: isApproved==1 ? false : isApproved==2 ? false : true,
                                              child: Column(
                                                  children: [
                                                     SizedBox(height: 30.0),
                                                     Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:Text('------------ For Approval -----------',
                                                              // maxLines: 5,
                                                              textAlign: TextAlign.center,
                                                              style: new TextStyle(color: colors.lightgreen,fontSize: 14.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),
                                                        ),
                                                      ]),
                                                     SizedBox(height: 20.0),
                                                     Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                         children:<Widget>[
                                                           Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                displayCalendar(context,1);
                                                              },
                                                              child: Text('Approve From Date',
                                                                  style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                      fontWeight: FontWeight.w700)),
                                                           )),
                                                           Expanded(
                                                             child: GestureDetector(
                                                               onTap: () {
                                                                 displayCalendar(context,2);
                                                               },
                                                               child: Text('Approve To Date',
                                                                 textAlign: TextAlign.end,
                                                                 style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                     fontWeight: FontWeight.w700)),
                                                             ),)
                                                     ]),

                                                     SizedBox(height: 5.0),
                                                     Row(
                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                         children:<Widget>[
                                                           Expanded(
                                                             child: GestureDetector(
                                                               onTap: () {
                                                                 displayCalendar(context,1);
                                                               },
                                                               child: Text(currentDate == null ?'--':currentDate,
                                                                 textAlign: TextAlign.start,
                                                                 style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',fontWeight: FontWeight.w700)),
                                                             ),
                                                           ),
                                                           Expanded(
                                                             child: GestureDetector(
                                                               onTap: () {
                                                                 displayCalendar(context,2);
                                                               },
                                                               child: Text(todate == null ?'--':todate,
                                                                 textAlign: TextAlign.end,
                                                                 style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',fontWeight: FontWeight.w700)),
                                                           ),)
                                                         ]
                                                     ),

                                                     SizedBox(height: 5.0),
                                                     Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: <Widget>[
                                                        Expanded(
                                                            child:Container(
                                                                //margin: const EdgeInsets.all(5.0),
                                                                  child:Center(
                                                                    child: TextButton(
                                                                      child: Text(is_LeaveUpdateVisible==true?" Rollback ":" Edit Leave type ",style: new TextStyle(color: colors.white,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.w700)),
                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(is_LeaveUpdateVisible==true?colors.green:colors.yellow)),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if(is_LeaveUpdateVisible==false){
                                                                            is_LeaveUpdateVisible=true;
                                                                          }else{
                                                                            causalleaveGiven=0.0;
                                                                            earnedleaveGiven=0.0;
                                                                            medicalleaveGiven=0.0;
                                                                            sickleaveGiven=0.0;
                                                                            lwpleaveGiven=0.0;
                                                                            for(int i=0;i<assignLeaveChart.length;i++) {
                                                                              assignLeaveChart[i]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[i].leaveTypeCode,approvedLeave: 0.0);
                                                                            }
                                                                            is_LeaveUpdateVisible=false;
                                                                            leaveBalanceList();
                                                                            leaveStatusList();
                                                                          }
                                                                        });

                                                                      },
                                                                    ),
                                                                  ),


                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  //SizedBox(height: 5.0),
                                                  Container(
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
                                                                  itemBuilder: widget.leaveData.empApprovalLevel == "1" ? _buildRow : _buildRowSecond
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                    ),
                                                  ),
                                                   // SizedBox(height: 10.0),
                                                  Row(
                                                      children: [
                                                        Padding(padding:  new EdgeInsets.all(5.0),
                                                          child: Text("Remarks",textAlign: TextAlign.left,
                                                              style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
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

                                                    SizedBox(height: 10.0),
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
                                                            if(causalleaveGiven>causalleaveBal){
                                                              commonAlert.messageAlertError(context,"Casual Leave not available","Error");
                                                            }else if(earnedleaveGiven>earnedleaveBal){
                                                              commonAlert.messageAlertError(context,"Earned Leave not available","Error");
                                                            }else if(medicalleaveGiven>medicalleaveBal){
                                                              commonAlert.messageAlertError(context,"Medical Leave not available","Error");
                                                            }else if(sickleaveGiven>sickleaveBal){
                                                              commonAlert.messageAlertError(context,"Sick Leave not available","Error");
                                                            }else{
                                                              if(selectLaeaveCode==""){
                                                                commonAlert.messageAlertError(context,"Select leave type to assign for leave","Error");
                                                              }else{
                                                                commonAlert.showLoadingDialog(context, _keyLoader);
                                                                saveLeaveList();
                                                              }
                                                            }
                                                          },

                                                          child: Text("Submit",
                                                              textAlign: TextAlign.center,
                                                              style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                                        ),
                                                      )
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  new Container(
                                                    height: 2.0,
                                                    color: Colors.black12,
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if(showSheet==1){
                                                          showSheet=2;
                                                        }else{
                                                          showSheet=1;
                                                        }
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                          child:Text(widget.leaveData.empName+"'s Leave Balance Sheet",
                                                              // maxLines: 5,
                                                              textAlign: TextAlign.center,
                                                              style: new TextStyle(color: colors.blue,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),
                                                        ),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 25.0,
                                                            child:Align(
                                                              alignment: Alignment.centerRight,
                                                              child:Image.asset(showSheet == 1 ? "assets/uparrow.png" : "assets/downarrow.png",
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                  //
                                                  Visibility(
                                                      visible: showSheet == 1 ? false:true,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            //mainAxisSize: MainAxisSize.max,
                                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                Expanded(
                                                                    child: Container(
                                                                        //height: 120.0,
                                                                        padding: new EdgeInsets.all(10.0),
                                                                        color: Colors.white,
                                                                        child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children:<Widget>[

                                                                              SizedBox(height:20.0),
                                                                              Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children:<Widget>[
                                                                                    Expanded(
                                                                                      child: Text("Causal Leave",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Leave : $causalleaveGiven",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Balance : $causalleaveBal",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    )
                                                                                  ]),

                                                                              SizedBox(height:15.0),
                                                                              Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children:<Widget>[
                                                                                    Expanded(
                                                                                      child: Text("Earned Leave",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Leave : $earnedleaveGiven",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Balance : $earnedleaveBal",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    )
                                                                                  ]),

                                                                              SizedBox(height:15.0),
                                                                              Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children:<Widget>[
                                                                                    Expanded(
                                                                                      child: Text("Medical Leave",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Leave : $medicalleaveGiven",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Balance : $medicalleaveBal",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    )
                                                                                  ]),

                                                                              SizedBox(height:15.0),
                                                                              Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children:<Widget>[
                                                                                    Expanded(
                                                                                      child: Text("Sick Leave",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(color: colors.blue,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    /* Expanded(
                                                                                       child: Text("Allotted",
                                                                                        textAlign: TextAlign.start,
                                                                                        style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
                                                                                        fontWeight: FontWeight.w700)),
                                                                                    ), */
                                                                                    Expanded(
                                                                                      child: Text("Leave : $sickleaveGiven",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text("Balance : $sickleaveBal",
                                                                                          textAlign: TextAlign.start,
                                                                                          style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                                                              fontWeight: FontWeight.w700)),
                                                                                    )

                                                                                  ]),

                                                                            ])
                                                                    )
                                                                ),



                                                              ]),





                                                        ],
                                                      )
                                                  ),

                                                ],
                                              ),
                                          ),

                                        ]),
                                  ),
                                ])
                              )
                         ]),
                   ),

            )

        ),
      ),
    );

  }




  onEdit(index) {
   // var rowData = this.leavelist[index];
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LeaveDetails(rowData),
      ),
    );*/
  }


  Widget _buildRow(BuildContext context, int index) {
    var colors= AppColors();

    List<DropdownMenuItem<String>> _dropDownItem() {
     // List<String> ddl = ["Select", "Casual Leave", "Earned Leave", "Medical Leave"];
      return leavetypeList
          .map((value) => DropdownMenuItem(
           value: value,
            child:  Text(value,style: new TextStyle(fontSize: 10.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700),),
      ))
          .toList();
    }

    List<DropdownMenuItem<String>> _dropDownItemStatus() {
      List<String> ddl = ["Approved", "Reject"];
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
        onTap: () => onEdit(index),
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
                              Text(userleavelist[index].dateData != null
                                  ? userleavelist[index].dateData: '',
                                  maxLines: 1, style: new TextStyle(color: Colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                      ),
                    ),

                    Visibility(
                        visible:true,//is_LeaveUpdateVisible==false?true:false,
                        child: Expanded(
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(userleavelist[index].leaveTypeName != null
                                  ? userleavelist[index].leaveTypeName!: '',
                                  maxLines: 1,
                                  //textAlign: TextAlign.start,
                                  style: new TextStyle(color: Colors.black,fontSize: 10.0,fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                      ),
                    ),
                    ),

                    Visibility(
                      visible: is_LeaveUpdateVisible,
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
                              value: selectedItemValue[index],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black, fontSize: 10),
                              underline: SizedBox(),
                              onChanged: (String? value) {
                               selectedItemValue[index]= value!;
                               setState(() {
                                causalleaveGiven=0.0;
                                earnedleaveGiven=0.0;
                                medicalleaveGiven=0.0;
                                sickleaveGiven=0.0;
                                lwpleaveGiven=0.0;
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
                                 lwpleaveGiven=0.0;
                               }
                               currentIndex=index;
                               });

                               if(selectLaeaveCode==""){
                                 commonAlert.showToast(context,"Select Leave Type");
                               }else{
                                 setState(() {
                                   userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:selectLaeaveCode.toString(),firstIsApproved:userleavelist[index].firstIsApproved,abbrTypeIdSecond: userleavelist[index].abbrTypeIdSecond,secondIsApproved:userleavelist[index].secondIsApproved, leaveTypeName: userleavelist[index].leaveTypeName, secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);
                                 });

                                  for(int i=0;i<assignLeaveChart.length;i++) {
                                    assignLeaveChart[i]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[i].leaveTypeCode,approvedLeave: 0.0);
                                  }
                                 for(int i=0;i<userleavelist.length;i++){

                                  if(int.parse(userleavelist[i].abbrTypeIdFirst) == casualLeaveID){
                                     causalleaveGiven+=isLeaveDays;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[i].abbrTypeIdFirst) == earnedLeaveID){
                                     earnedleaveGiven+=isLeaveDays;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[i].abbrTypeIdFirst) == medicalLeaveID){
                                     medicalleaveGiven+=isLeaveDays;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[i].abbrTypeIdFirst) == sickLeaveID){
                                     sickleaveGiven+=isLeaveDays;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[i].abbrTypeIdFirst) == lwpID){
                                    lwpleaveGiven+=isLeaveDays;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                       }
                                     }
                                   }
                                 }

                               }


                              },

                              items: _dropDownItem(),
                              /*this.leavetypelist.map((LeaveTypeData data) {
                                return DropdownMenuItem<LeaveTypeData>(
                                  child: Text(data.abbrType,style: new TextStyle(fontSize: 10.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),),
                                  value: data,
                                );
                              }).toList(),*/

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

                    Visibility(
                      visible: true,
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
                              value: selectedItemValueStatus[index],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black, fontSize: 10),
                              underline: SizedBox(),
                              onChanged: (String? value) {
                                selectedItemValueStatus[index]= value!;
                                print(selectedItemValueStatus[index]);
                                setState(() {
                                  if(selectedItemValueStatus[index]=='Reject'){
                                    userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:userleavelist[index].abbrTypeIdFirst,firstIsApproved:"2",abbrTypeIdSecond: userleavelist[index].abbrTypeIdSecond,secondIsApproved:userleavelist[index].secondIsApproved,leaveTypeName: userleavelist[index].leaveTypeName,secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);
                                     ifReject=true;
                                    if(int.parse(userleavelist[index].abbrTypeIdFirst) == casualLeaveID){
                                     causalleaveGiven--;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[index].abbrTypeIdFirst) == earnedLeaveID){
                                     earnedleaveGiven--;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                       }
                                     }
                                   }
                                   if(int.parse(userleavelist[index].abbrTypeIdFirst) == medicalLeaveID){
                                     medicalleaveGiven--;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                       }
                                     }

                                   }
                                   if(int.parse(userleavelist[index].abbrTypeIdFirst) == sickLeaveID){
                                     sickleaveGiven--;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                       }
                                     }

                                   }
                                   if(int.parse(userleavelist[index].abbrTypeIdFirst) == lwpID){
                                     lwpleaveGiven--;
                                     for(int j=0;j<assignLeaveChart.length;j++){
                                       if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                         assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                       }
                                     }

                                   }
                                  }else{
                                    userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:userleavelist[index].abbrTypeIdFirst,firstIsApproved:"1",abbrTypeIdSecond: userleavelist[index].abbrTypeIdSecond,secondIsApproved:userleavelist[index].secondIsApproved,leaveTypeName: userleavelist[index].leaveTypeName,secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);
                                    if(ifReject==true){
                                      if(int.parse(userleavelist[index].abbrTypeIdFirst) == casualLeaveID){
                                        causalleaveGiven++;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdFirst) == earnedLeaveID){
                                        earnedleaveGiven++;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdFirst) == medicalLeaveID){
                                        medicalleaveGiven++;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                          }
                                        }

                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdFirst) == sickLeaveID){
                                        sickleaveGiven++;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                          }
                                        }

                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdFirst) == lwpID){
                                        lwpleaveGiven++;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                          }
                                        }

                                      }
                                    }
                                  }
                                });
                              },
                              items: _dropDownItemStatus(),
                            ),
                          )
                      ),
                    ),
                     //
                    Visibility(
                      visible: false,
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

                          child: DropdownButton<LeaveFor>(
                            isExpanded: true,
                            value: leaveFordrop,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 10),
                            underline: SizedBox(),
                            onChanged: (LeaveFor? data) {
                              setState(() {
                                leaveFordrop = data!;
                                leaveForCode=leaveFordrop!.name;
                                print(leaveForCode);
                              });
                            },

                            items: this.leaveForlist.map((LeaveFor data){
                              return DropdownMenuItem<LeaveFor>(
                                child: Text(data.fullName,style: new TextStyle(fontSize: 10.0, fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),),
                                value: data,
                              );
                            }).toList(),

                            hint:Text(
                              leaveForName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                    ),
                    ),

                    Visibility(
                      visible: false,
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
                            child: DropdownButton<LeaveFor>(
                              isExpanded: true,
                              value: leaveFordrop,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black, fontSize: 10),
                              underline: SizedBox(),
                              onChanged: (LeaveFor? data) {
                                setState(() {
                                  leaveFordrop = data!;
                                  leaveForCode=leaveFordrop!.name;
                                  print(leaveForCode);
                                });
                              },
                              items: this.leaveForlist.map((LeaveFor data) {
                                return DropdownMenuItem<LeaveFor>(
                                  child: Text(data.fullName,style: new TextStyle(fontSize: 10.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),),
                                  value: data,
                                );
                              }).toList(),

                              hint:Text(leaveForName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              ),
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


  Widget _buildRowSecond(BuildContext context, int index) {
    var colors= AppColors();

    List<DropdownMenuItem<String>> _dropDownItem() {
     // leaveArray= ["Select", "Casual Leave", "Earned Leave", "Medical Leave"];
      return leavetypeList
          .map((value) => DropdownMenuItem(
            value: value,
            child:  Text(value,style: new TextStyle(fontSize: 10.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700),),
      ))
          .toList();
    }

    List<DropdownMenuItem<String>> _dropDownItemStatus() {
      List<String> ddl = ["Approved", "Reject"];
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
          onTap: () => onEdit(index),
          child: Padding(
            padding:EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(userleavelist[index].dateData != null
                                    ? userleavelist[index].dateData: '',
                                    maxLines: 1,
                                    //textAlign: TextAlign.start,
                                    style: new TextStyle(color: Colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ],
                            )
                        ),
                      ),
                      Visibility(
                         visible: true,
                         child: Expanded(
                            flex: 1,
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  color:colors.white ,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.white)
                              ),
                              child: Center(
                                child: Text(userleavelist[index].leaveTypeName!= null
                                    ? userleavelist[index].leaveTypeName!: 'Pending',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color: Colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: true,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  color:colors.white ,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.white)
                              ),
                              child: Center(
                                child: Text(userleavelist[index].firstIsApproved == "1" ? "Approved": 'Reject',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(color:userleavelist[index].firstIsApproved == "1"
                                        ?Colors.green:Colors.red,fontSize: 8.0,fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: is_LeaveUpdateVisible==false?true:false,
                        child: Expanded(
                            flex: 1,
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  color:colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.white)
                              ),
                              child: Center(
                                child: Text(userleavelist[index].leaveTypeName != null
                                    ? userleavelist[index].leaveTypeName!: 'Pending',
                                    maxLines: 1, textAlign: TextAlign.center,
                                    style: new TextStyle(color: Colors.black,fontSize: 8.0,fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700)),
                              ),
                            )
                        ),
                      ),

                      Visibility(
                        visible: is_LeaveUpdateVisible,
                        child: Expanded(
                            flex: 2,
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  color:colors.greylight ,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedItemValue[index], // _selectDrop(index)  selectedItemValue[index]
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 10),
                                underline: SizedBox(),
                                onChanged: (String? value) {
                                  selectedItemValue[index]= value!;
                                  setState(() {
                                    causalleaveGiven=0.0;
                                    earnedleaveGiven=0.0;
                                    medicalleaveGiven=0.0;
                                    sickleaveGiven=0.0;
                                    lwpleaveGiven=0.0;

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
                                      lwpleaveGiven=0.0;
                                    }
                                    currentIndex=index;
                                  });

                                  if(selectLaeaveCode==""){
                                    commonAlert.showToast(context,"Select Leave Type");
                                  }else{
                                    setState(() {
                                      userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:userleavelist[index].abbrTypeIdFirst,firstIsApproved:userleavelist[index].firstIsApproved,abbrTypeIdSecond: selectLaeaveCode.toString(),secondIsApproved:userleavelist[index].secondIsApproved,leaveTypeName:userleavelist[index].leaveTypeName,secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);
                                    });

                                    for(int i=0;i<assignLeaveChart.length;i++) {
                                      assignLeaveChart[i]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[i].leaveTypeCode,approvedLeave: 0.0);
                                    }
                                    for(int i=0;i<userleavelist.length;i++){
                                      if(int.parse(userleavelist[i].abbrTypeIdSecond) == casualLeaveID){
                                        causalleaveGiven+=isLeaveDays;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[i].abbrTypeIdSecond) == earnedLeaveID){
                                        earnedleaveGiven+=isLeaveDays;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[i].abbrTypeIdSecond) == medicalLeaveID){
                                        medicalleaveGiven+=isLeaveDays;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[i].abbrTypeIdSecond) == sickLeaveID){
                                        sickleaveGiven+=isLeaveDays;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[i].abbrTypeIdSecond) == lwpID){
                                        lwpleaveGiven+=isLeaveDays;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                          }
                                        }
                                      }
                                    }

                                    print("ASSIGNLIDT ${jsonEncode(assignLeaveChart)}");
                                  }
                                },

                                items: _dropDownItem(),
                                /*this.leavetypelist.map((LeaveTypeData data) {
                                return DropdownMenuItem<LeaveTypeData>(
                                  child: Text(data.abbrType,style: new TextStyle(fontSize: 10.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),),
                                  value: data,
                                );
                              }).toList(),*/

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

                      Visibility(
                        visible: true,
                        child: Expanded(
                            flex: 2,
                            child: new Container(
                              height: 35.0,
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  color:colors.greylight,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.grey)
                              ),

                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedItemValueStatus[index],
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 10),
                                underline: SizedBox(),
                                onChanged: (String? value) {
                                  selectedItemValueStatus[index]=value!;
                                  //print(selectedItemValueStatus[index]);
                                  setState(() {
                                    if(selectedItemValueStatus[index]=='Reject'){
                                      ifReject=true;
                                      userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:userleavelist[index].abbrTypeIdFirst,firstIsApproved:userleavelist[index].firstIsApproved,abbrTypeIdSecond: userleavelist[index].abbrTypeIdSecond,secondIsApproved:"2",leaveTypeName: userleavelist[index].leaveTypeName,secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);

                                      if(int.parse(userleavelist[index].abbrTypeIdSecond) == casualLeaveID){
                                        causalleaveGiven--;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdSecond) == earnedLeaveID){
                                        earnedleaveGiven--;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                          }
                                        }
                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdSecond) == medicalLeaveID){
                                        medicalleaveGiven--;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                          }
                                        }

                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdSecond) == sickLeaveID){
                                        sickleaveGiven--;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                          }
                                        }

                                      }
                                      if(int.parse(userleavelist[index].abbrTypeIdSecond) == lwpID){
                                        lwpleaveGiven--;
                                        for(int j=0;j<assignLeaveChart.length;j++){
                                          if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                            assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                          }
                                        }

                                      }

                                      print("ASSIGNLIDT ${jsonEncode(assignLeaveChart)}");

                                    }else{
                                      userleavelist[index]=new EmpleaveData(dateData: userleavelist[index].dateData,abbrTypeIdFirst:userleavelist[index].abbrTypeIdFirst,firstIsApproved:userleavelist[index].firstIsApproved,abbrTypeIdSecond: userleavelist[index].abbrTypeIdSecond,secondIsApproved:"1",leaveTypeName: userleavelist[index].leaveTypeName,secondLeaveTypeName: userleavelist[index].secondLeaveTypeName);
                                      if(ifReject==true){
                                        if(int.parse(userleavelist[index].abbrTypeIdSecond) == casualLeaveID){
                                          causalleaveGiven++;
                                          for(int j=0;j<assignLeaveChart.length;j++){
                                            if(assignLeaveChart[j].leaveTypeCode == casualLeaveCode){
                                              assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: causalleaveGiven);
                                            }
                                          }
                                        }
                                        if(int.parse(userleavelist[index].abbrTypeIdSecond) == earnedLeaveID){
                                          earnedleaveGiven++;
                                          for(int j=0;j<assignLeaveChart.length;j++){
                                            if(assignLeaveChart[j].leaveTypeCode == earnedLeaveCode){
                                              assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: earnedleaveGiven);
                                            }
                                          }
                                        }
                                        if(int.parse(userleavelist[index].abbrTypeIdSecond) == medicalLeaveID){
                                          medicalleaveGiven++;
                                          for(int j=0;j<assignLeaveChart.length;j++){
                                            if(assignLeaveChart[j].leaveTypeCode == medicalLeaveCode){
                                              assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: medicalleaveGiven);
                                            }
                                          }

                                        }
                                        if(int.parse(userleavelist[index].abbrTypeIdSecond) == sickLeaveID){
                                          sickleaveGiven++;
                                          for(int j=0;j<assignLeaveChart.length;j++){
                                            if(assignLeaveChart[j].leaveTypeCode == sickLeaveCode){
                                              assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: sickleaveGiven);
                                            }
                                          }

                                        }
                                        if(int.parse(userleavelist[index].abbrTypeIdSecond) == lwpID){
                                          lwpleaveGiven++;
                                          for(int j=0;j<assignLeaveChart.length;j++){
                                            if(assignLeaveChart[j].leaveTypeCode == lwpcode){
                                              assignLeaveChart[j]=new AssignLeaveChart(leaveTypeCode: assignLeaveChart[j].leaveTypeCode,approvedLeave: lwpleaveGiven);
                                            }
                                          }

                                        }
                                      }

                                      print("ASSIGNLIDT ${jsonEncode(assignLeaveChart)}");
                                    }
                                  });
                                },
                                items: _dropDownItemStatus(),
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