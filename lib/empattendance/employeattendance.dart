import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/calendardata.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmployeeAttendanceState();
  }

}



class EmployeeAttendanceState extends State<EmployeeAttendance> {

  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId,fyID,empCode,userID;
  var _inTime,_outTime,_odStatus,_tranID;
  bool isVisible=false,_isODVisible=false;
  List<AttendanceDataOd> _attendancelist = <AttendanceDataOd>[];
  bool isLoader = false;
  final RefreshController _refreshController = RefreshController();
  late int currentYear,currentMonth,currentDay;

  String finalDate = '';



  List<DateTime> presentDates = [];

  List<DateTime> absentDates = [];
  List<DateTime> halfdayDates = [];
  List<DateTime> notMarkedDates = [];


  double presentCount=0.0;
  double absentCount=0.0;
  double notMarkedCount=0.0;
  double halfdayCount=0.0;
  late bool _isButtonDisabled;
  int press=0;
  var selectedDate,selectDateCal;


  var emojiRegexp =
      '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';

  TextEditingController reasonController = new TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  CommonAction commonAlert= CommonAction();
  List<SectionDataList> sectionlist = <SectionDataList>[];
  SectionDataList? selectedsectionCode;
  String _leavetype="";

  List<String> leaveArray = ["OD"];


  getCurrentDate(){

    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    currentYear=dateParse.year;
    currentMonth=dateParse.month;
    currentDay=dateParse.day;
    setState(() {
      finalDate = formattedDate.toString() ;
      String _currentMonth = DateFormat.yMMM().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
      print("CurrentMonth--- "+_currentMonth);
    });

  }

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

 // var len = min(absentDates.length, presentDates.length);
  late double cHeight;

  DateTime _myDate = DateTime.now();
  DateTime _currentDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  DateTime _currentDate2 = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  String _currentMonth = DateFormat.yMMM().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  DateTime _targetDateTime = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  String _currentMonthNew = DateFormat.M().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  String _currentMonthfixed = DateFormat.M().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
  String _currentYear = DateFormat.y().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));


//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  /*EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2021, 6, 04): [
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2021, 6, 04),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

*/
  static Widget _presentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.green,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );
  static Widget _absentIcon(String day) => CircleAvatar(
    backgroundColor: Colors.red,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _notMarkedIcon(String day) => CircleAvatar(
    backgroundColor: Colors.yellow.shade800,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static Widget _haflDayIcon(String day) => CircleAvatar(
    backgroundColor: Colors.blueAccent,
    child: Text(
      day,
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );



  Map<String, double> dataMap = {
    "Present": 0,
    "Absent": 0,
    "Half Day": 0,
    "Not Marked": 0,
  };
  List<Color> colorList = [
    Colors.green,
    Colors.red,
    Colors.blueAccent,
    Colors.yellow.shade800,
  ];





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

    Future<int> FyIDdata = sfdata.getFyID(context);
    FyIDdata.then((data) {
      setState(() {
        fyID=data.toString();
        print("fyID " + fyID);
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

    Future<int> userIdData = sfdata.getUseId(context);
    userIdData.then((data) {
      setState(() {
        userID=data.toString();
        print("userID " + userID);
      });
    },onError: (e) {
      print(e);
    });

    selectedsectionCode=SectionDataList(sectionName: "OFFICIAL DUTY",code: "1");
    sectionlist.add(selectedsectionCode!);
    //sectionlist.add(new LeaveFor(name: "2",fullName: "Reject"));


    getCurrentDate();
    attendanceList();
   // diaryList();

    /*_markedDateMap.add(
        new DateTime(2021, 6, 10),
        new Event(
          date: new DateTime(2021, 6, 10),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2021, 6, 15),
        new Event(
          date: new DateTime(2021, 6, 15),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2021, 6, 22), [
      new Event(
        date: new DateTime(2021, 6, 28),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2021, 6, 22),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2021, 6, 22),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
*/



    super.initState();
  }


  //////////////////   DiaryList API  //////////////////////
  Future<Null> attendanceList() async {
    EasyLoading.show(status: 'loading...');
    presentCount=0.0;
    absentCount=0.0;
    notMarkedCount=0.0;
    halfdayCount=0.0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoader = true;
    //print("relationshipId2 " + preferences.getInt("RelationshipId").toString());
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .empAttendance("20",empCode,relationshipId,sessionId,fyID,_currentMonthNew,_currentYear)
        .then((result) {
      EasyLoading.dismiss();
      //print(result.length);
      isLoader = false;
      if(result.isNotEmpty){
        setState(() {
        _attendancelist =result.toList();
        for (int i = 0; i < _attendancelist.length; i++) {
          DateTime datetime= DateTime((_attendancelist[i].date).year,(_attendancelist[i].date).month,(_attendancelist[i].date).day);
          if(_attendancelist[i].abbr == "P"){
            presentDates.add(datetime);
            presentCount++;
          }else if(_attendancelist[i].abbr == "A"){
            absentDates.add(datetime);
            absentCount++;
          }else if(_attendancelist[i].abbr == "HD"){
            halfdayDates.add(datetime);
            halfdayCount++;
          }else{
            notMarkedDates.add(datetime);
            notMarkedCount++;
          }
        }
        dataMap["Present"] = presentCount;
        dataMap["Absent"] = absentCount;
        dataMap["Half Day"] = halfdayCount;
        dataMap["Not Marked"] = notMarkedCount;




        for (int i = 0; i < presentDates.length; i++) {
          _markedDateMap.add(
            presentDates[i],
            new Event(
              date: presentDates[i],
              title: 'Event 5',
              icon: _presentIcon(
                presentDates[i].day.toString(),
              ),
            ),
          );
        }

        for (int i = 0; i < absentDates.length; i++) {
          _markedDateMap.add(
            absentDates[i],
            new Event(
              date: absentDates[i],
              title: 'Event 5',
              icon: _absentIcon(
                absentDates[i].day.toString(),
              ),
            ),
          );
        }

        for (int i = 0; i < notMarkedDates.length; i++) {
          _markedDateMap.add(
            notMarkedDates[i],
            new Event(
              date: notMarkedDates[i],
              title: 'Event 5',
              icon: _notMarkedIcon(
                notMarkedDates[i].day.toString(),
              ),
            ),
          );
        }

        for (int i = 0; i < halfdayDates.length; i++) {
          _markedDateMap.add(
            halfdayDates[i],
            new Event(
              date: halfdayDates[i],
              title: 'Event 5',
              icon: _haflDayIcon(
                halfdayDates[i].day.toString(),
              ),
            ),
          );
        }


        });

      }else{
        this._attendancelist =[];
        EasyLoading.dismiss();
      }

    }).catchError((error) {
      print(error);
      EasyLoading.dismiss();
    });
  }



  //////////////////   Add OD API  //////////////////////
  Future<Null> addRemarks() async {
    EasyLoading.show(status: 'loading...');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .addODRemark("2",empCode,relationshipId,sessionId,fyID,reasonController.text.toString(),_tranID,'OD','$selectedDate',userID)
        .then((result) {
      EasyLoading.dismiss();
      if(result.isNotEmpty){
        setState(() {
          if(result.toString()=='"0"'){
            commonAlert.messageAlertError(context,'Remark not submitted.Please try again',"Error");
          }else{
            commonAlert.messageAlertSuccess(context,"Remark submitted successfully","Success");
          }
         // attendanceList();
        });
      }else{
        commonAlert.messageAlertError(context,'Remark not submitted.Please try again',"Error");
        EasyLoading.dismiss();
      }
    }).catchError((error) {
      print(error);
      EasyLoading.dismiss();
    });
  }


  feedBackAlertSuccess(BuildContext context,String msg, String ttl) {
    // Navigator.pop(context);
    final reasonfield = TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(80),FilteringTextInputFormatter.deny(
        RegExp(emojiRegexp),
      )],
      controller: reasonController,
      obscureText: false,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      expands: true,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Reason",
        hintStyle:style,
        enabled: true,
      ),
    );

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Column(
              children: [
                Text('Add Remark',style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0,color: colors.blue),),
                SizedBox(height: 10.0),
                Divider(height: 5.0,color: colors.greydark,),
                SizedBox(height: 20.0),
                Container(
                  height: 35.0,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color:colors.greylight ,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter dropDownState){
                        return DropdownButton<SectionDataList>(
                          isExpanded: true,
                          value: selectedsectionCode,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          underline: SizedBox(),
                          onChanged: (SectionDataList? data) {
                            setState(() {
                              selectedsectionCode=data;
                              _leavetype=selectedsectionCode!.sectionName;
                              print(_leavetype);
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
                            "Select Type",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }
                  ),


                ),
              ],
            ),

            content: new Container(
              height: 100.0,
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color:colors.greylight ,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey)
              ),
              child: reasonfield,
            ),

            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Submit'),
                  ],
                ),
                onPressed: () {
                  if(reasonController.text.length==0){
                    commonAlert.showToast(context,"Enter Remark");
                  }else{
                    Navigator.pop(context);
                    addRemarks();
                  }

                  // Navigator.of(context).pop();
                  // SystemNavigator.pop();
                },
              ),
            ],
          );
        });

  }



  @override
  Widget build(BuildContext context) {





    /// Example with custom icon
    final _calendarCarousel = CalendarCarousel<Event>(
      onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'Custom Header',
      weekFormat: true,
      markedDatesMap: _markedDateMap,
      height: 200.0,
      selectedDateTime: _currentDate2,
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (event) {
        return event.icon ?? Icon(Icons.help_outline);
      },
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal: true,
      // null for not showing hidden events indicator
      // markedDateIconMargin: 9,
     // markedDateIconOffset: 3,
    );


    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
    //  todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        this.setState(() {
          _isODVisible=false;
          selectedDate=commonAlert.dateFormateServer(context,date);
          selectDateCal=commonAlert.dateFormateMM(context,date);
          print(selectDateCal);
          //isVisible=false;
          for (int i = 0; i < _attendancelist.length; i++) {
              if(date==_attendancelist[i].date){
                print(_attendancelist[i].logIn);
                _inTime=_attendancelist[i].logIn;
                _outTime=_attendancelist[i].logOut;
                _odStatus=_attendancelist[i].isOd;
                _tranID=_attendancelist[i].attendanceTransId;
                if(_attendancelist[i].abbr=='A'){
                   if(_odStatus==0){
                     _isODVisible=true;
                   }
                   isVisible=true;
                }if(_attendancelist[i].abbr=='P'){
                  if(_odStatus==0){
                    //_isODVisible=true;
                  }
                  isVisible=true;
                }else if(_attendancelist[i].abbr=='HD'){
                  if(_odStatus==0){
                    _isODVisible=true;
                  }
                  isVisible=true;
                }else if(_attendancelist[i].abbr=='Not Marked'){
                  isVisible=false;
                }else{
                  isVisible=true;
                }

              }

          }

        });
        /*this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));*/
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null, // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },


      height: 330.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
     // markedDateCustomShapeBorder: CircleBorder(side: BorderSide(color: Colors.red)),
      /*markedDateMoreCustomDecoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20.0),
      ),*/
      markedDateCustomTextStyle: TextStyle(
        fontSize: 14,
        color: Colors.red,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
     // todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 365)),
      maxSelectedDate: _currentDate.add(Duration(days: 365)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
          _currentMonthNew = DateFormat.M().format(_targetDateTime);
          _currentYear = DateFormat.y().format(_targetDateTime);
          if(_currentMonthfixed == _currentMonthNew){
            _isButtonDisabled=true;
          }else{
            _isButtonDisabled=false;
          }
          if(press==0){
            press++;
            attendanceList();
          }else{

          }

          //attendanceList();

        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );



    var colors= AppColors();
        return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.redtheme,
          title: Text("Attendance Calendar",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
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
                      image: AssetImage("assets/loginbottom.png"),
                fit: BoxFit.fill,
              ),
          ),
        ),

            new Container(
               child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                 // SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                  // SizedBox(height: 5.0),
                  /*Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: _calendarCarousel,
                                ),*/
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(5),
                    child: Column(children: [

                      Container(
                        margin: EdgeInsets.only(
                          top: 30.0,
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                  _currentMonth,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,color: colors.blue
                                  ),
                                )),
                            FlatButton(
                              child: Text('PREV'),
                              onPressed: () {
                                setState(() {
                                  press=0;
                                  _targetDateTime = DateTime(
                                      _targetDateTime.year, _targetDateTime.month - 1);
                                  _currentMonth =
                                      DateFormat.yMMM().format(_targetDateTime);
                                });
                              },
                            ),
                            FlatButton(
                              child: Text('NEXT'),
                              onPressed: () {
                                if(_isButtonDisabled==false){

                                  setState(() {
                                    press=0;
                                    _targetDateTime = DateTime(
                                        _targetDateTime.year, _targetDateTime.month + 1);
                                    _currentMonth =
                                        DateFormat.yMMM().format(_targetDateTime);
                                  });
                                }

                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        child: _calendarCarouselNoHeader,
                      ),
                    ],),

                  ),


                Visibility(
                    visible: isVisible,
                    child:
                     Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      child:Container(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child:Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                               Expanded(
                                child: Container(
                                 color: colors.blue,
                                 child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                    child: new Text("Date- $selectDateCal",
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,color: colors.white ),
                                    ),
                                 ),
                                ),
                               )
                             ]),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      // color: colors.green,
                                      child:Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              new Text("$_inTime",
                                                style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,color: colors.black),
                                              ),
                                              SizedBox(height: 3.0,),
                                              new Text("In Time",
                                                style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,color: colors.black ),
                                              ),

                                            ]),
                                      ),
                                    ),

                                  ),

                                  Expanded(
                                    child: Container(
                                      // color: colors.green,
                                      child:Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              new Text("$_outTime",
                                                style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,color: colors.black ),
                                              ),
                                              SizedBox(height: 3.0,),
                                              new Text("Out Time",
                                                style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,color: colors.black ),
                                              ),

                                            ]),
                                      ),
                                    ),

                                  ),

                                  Expanded(
                                    child: Container(
                                      // color: colors.green,
                                      child:Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible :_isODVisible,
                                                child:
                                                GestureDetector(
                                                  onTap:() {
                                                    feedBackAlertSuccess(context,"","");
                                                  },
                                                  child: new Text('ADD REMARK',
                                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,color: colors.blue ),
                                                  ),
                                                ),

                                              ),

                                              Visibility(
                                                visible: _isODVisible==false?true:false,
                                                child: new Text(_odStatus==2?"Approved":_odStatus==3?"Reject":'',
                                                  style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w600,color: _odStatus==2?colors.green :_odStatus==3?colors.red :colors.white),
                                                ),

                                              ),


                                            ]),
                                      ),
                                    ),

                                  ),

                                ],
                              ),
                            ],
                          ) ,
                        ),




                      ),

                  ),
                ),





                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(5),
                    child:Container(
                      height: 220.0,
                      child:Center(
                        child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:<Widget>[
                                    Expanded(
                                      child: Container(
                                        color: colors.green,
                                        child:Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                new Text("$presentCount",
                                                  style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700,color: colors.white ),
                                                ),
                                                new Text("Present",
                                                  style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w700,color: colors.white ),
                                                ),

                                              ]),
                                        ),
                                      ),

                                    ),

                                    Expanded(
                                      child:Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          color: colors.redtheme,
                                          child:Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  new Text("$absentCount",
                                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                  ),
                                                  new Text("Absent",
                                                    style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                  ),

                                                ]),
                                          ),
                                        ),

                                      ),),

                                    Expanded(
                                      child:Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Container(
                                          color: Colors.blueAccent,
                                          child:Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  new Text("$halfdayCount",
                                                    style: new TextStyle(fontSize: 12.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                  ),
                                                  new Text("Half Day",
                                                    style: new TextStyle(fontSize: 10.0,fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight.w700,color: colors.white ),
                                                  ),

                                                ]),
                                          ),),
                                      ),),

                                  ]),

                              Row(
                                children: [
                                  Expanded(
                                      child: Column(children: [
                                        SizedBox(height: 20.0),
                                        PieChart(
                                          dataMap: dataMap,
                                          animationDuration: Duration(milliseconds: 1500),
                                          chartLegendSpacing: 50,
                                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                                          colorList: colorList,
                                          initialAngleInDegree: 0,
                                          chartType: ChartType.ring,
                                          ringStrokeWidth: 35,
                                          // centerText: "HYBRID",
                                          legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition: LegendPosition.right,
                                            showLegends: true,
                                            //legendShape: _BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          chartValuesOptions: ChartValuesOptions(
                                            showChartValueBackground: true,
                                            showChartValues: true,
                                            showChartValuesInPercentage: true,
                                            showChartValuesOutside: true,
                                            decimalPlaces: 1,
                                          ),
                                        )
                                      ],)
                                  ),

                                ],)

                            ]),
                      ),
                    ),
                  ),

                  //custom icon without header

                ]
            )
        ),

        ]
    )
                  )







              )

          ),
        ),



    );

    }


  Widget markerRepresent(Color color, String data,double count) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: 8.0,
      ),
      title: new Text(data,
          style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700),
      ),
      subtitle: new Text(count.toString(),
        style: new TextStyle(fontSize: 11.0,fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700),
      ),
    );
  }

}