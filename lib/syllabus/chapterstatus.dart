

import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/models/chapterdata.dart';
import 'package:educareadmin/models/chapterstatusdata.dart';
import 'package:educareadmin/models/chapterstatuslist.dart';
import 'package:educareadmin/models/empleavedata.dart';
import 'package:educareadmin/models/leavelist.dart';
import 'package:educareadmin/models/noticedata.dart';
import 'package:educareadmin/models/sectiondata.dart';
import 'package:educareadmin/network/api_service.dart';
import 'package:educareadmin/storedata/sfData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterStatus extends StatefulWidget {
  CommonAction common= CommonAction();

  ChapterStatus(this.chapterData,this.sectionCode) : super();

  final ChapterData chapterData;
  final String sectionCode;



  @override
  State<StatefulWidget> createState() {
    return ChapterStatusState();
  }
}


class ChapterStatusState extends State<ChapterStatus> {

  var showSheet=2;
  CommonAction commonAlert= CommonAction();
  List<EmpleaveData> statuslist = <EmpleaveData>[];
  late EmpleaveData userleavelistCode;
  var colors= AppColors();
  SFData sfdata= SFData();
  var sessionId;
  var relationshipId;
  var empCode,fyID,userID;
  var emojiRegexp =
      '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';

  TextEditingController reasonController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  var showdateServer,currentDate;
  int classTaken=0;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  List<ChapterStatusData> statusDropdownList = <ChapterStatusData>[];
  List<ChapterStatusList> chapterStatusList = <ChapterStatusList>[];
  ChapterStatusData? statusCodeData;
  int _statusCode=0;

  bool isLoader = false;

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

/*

    for(int i=0;i<12;i++){
      EmpleaveData chapterData=new EmpleaveData(dateData: "27/12/2021",abbrTypeIdFirst: "Remarks given by teacher Remarks given by teacher Remarks given by teacher",firstIsApproved: "In-Progress",abbrTypeIdSecond: "",secondIsApproved: "",leaveTypeName: "",secondLeaveTypeName: "");
      statuslist.add(chapterData);
    }
*/

    // print(" LEVEL--  ${widget.leaveData.secondLevelEmpName}");
    statusList();
    getstatusList();
    super.initState();
  }


  //////////////////  Status API //////////////////////
  Future<Null> statusList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   // EasyLoading.show(status: 'loading...');
    //isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .chapterStatusList("5",widget.chapterData.status)
        .then((result) {
     // EasyLoading.dismiss();
      setState(() {
        // isLoader = false;
        if(result.isNotEmpty){
          statusDropdownList=result.toList();
          statusCodeData= result[0];
          _statusCode= result[0].id;
        }else{
          this.statusDropdownList=[];
        }
      });
    }).catchError((error) {
      setState(() {
       // EasyLoading.dismiss();
        // isLoader = false;
      });
      print(error);
    });
  }


  //////////////////  Status API //////////////////////
  Future<Null> postStatus(String date,String remark,int statuscode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     EasyLoading.show(status: 'loading...');
    //isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .saveStatus("1",widget.chapterData.classCode,widget.sectionCode,widget.chapterData.subjectCode,widget.chapterData.chapterId,empCode,date,statuscode,remark,userID,relationshipId,sessionId,fyID)
        .then((result) {
       EasyLoading.dismiss();
      setState(() {
        // isLoader = false;
        if(result.isNotEmpty){
          print("RESULT-- $result");
          if(result.toString()=='"1"'){
            commonAlert.messageAlertSuccess(context,"Chapter Status submitted successfully","Success");
          }else{
            commonAlert.messageAlertError(context,'Status not submitted.Please try again',"Error");
          }
        }else{

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


  //////////////////  Get Status API //////////////////////
  Future<Null> getstatusList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'loading...');
    isLoader = true;
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getchapterStatusList("4",widget.chapterData.chapterId,relationshipId,sessionId)
        .then((result) {
       EasyLoading.dismiss();
      setState(() {
         isLoader = false;
        if(result.isNotEmpty){
          chapterStatusList=result.toList();
          classTaken=chapterStatusList.length;
        }else{
          this.chapterStatusList=[];
          EasyLoading.dismiss();
        }
      });
    }).catchError((error) {
      setState(() {
         EasyLoading.dismiss();
         //isLoader = false;
      });
      print(error);
    });
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
          currentDate=commonAlert.dateFormate(context, newDate);
          showdateServer = commonAlert.dateFormateServer(context, newDate);
          print("formatted " + currentDate);
        });

        // onChanged(result);
      },


    );

  }

  addStatus(BuildContext context) {
    // Navigator.pop(context);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    currentDate = formatter.format(now);
    showdateServer = commonAlert.dateFormateServer(context, now);
    DateTime startDate = now.subtract(Duration(days: 8));
    DateTime endDate = now.add(Duration(days: 0));

    final reasonfield = TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(200),FilteringTextInputFormatter.deny(
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
        hintText: "Enter Remark",
        hintStyle:style,
        enabled: true,
      ),
    );

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Builder(
                builder: (context) => CupertinoAlertDialog(
                  title: Column(
                    children: [
                      Text('Add Status',style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0,color: colors.blue),),
                      SizedBox(height: 10.0),
                      Divider(height: 5.0,color: colors.greydark,),
                      SizedBox(height: 20.0),
                      Container(
                        height: 35.0,
                        //margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color:colors.greylight ,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey)
                        ),
                        child:StatefulBuilder(
                            builder: (BuildContext context, StateSetter dropDownState){

                              return DropdownButton<ChapterStatusData>(
                                isExpanded: true,
                                value: statusCodeData,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 18),
                                underline: SizedBox(),
                                onChanged:(ChapterStatusData? data) {
                                  dropDownState(() {
                                    statusCodeData = data!;
                                    _statusCode=statusCodeData!.id;
                                    print(_statusCode);
                                  });
                                },
                                items: this.statusDropdownList.map((ChapterStatusData data) {
                                  return DropdownMenuItem<ChapterStatusData>(
                                    child: Text("  "+data.processName,style: new TextStyle(fontSize: 11.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700)),
                                    value: data,
                                  );
                                }).toList(),
                                hint:Text(
                                  "Select Section",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }
                        ),
                      ),

                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          HorizontalDatePickerWidget(
                          startDate: startDate,
                          endDate: endDate,
                          selectedDate: now,
                          monthFontSize: 10,
                          dayFontSize: 10,
                          weekDayFontSize: 10,
                          height: 50,
                          selectedColor: Colors.redAccent,
                          widgetWidth: MediaQuery.of(context).size.width,
                          datePickerController: DatePickerController(),
                          onValueSelected: (date) {
                            setState(() {
                              currentDate=commonAlert.dateFormate(context, date);
                              showdateServer = commonAlert.dateFormateServer(context, date);
                              print('selected = ${currentDate}');
                            });


                          },
                        ),

                          ],
                        ),
                      ),

                    ],
                  ),

                  content: Column(
                    children: [
                      new Container(
                        height: 100.0,
                        //margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color:colors.greylight ,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: reasonfield,
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Column(
                        children: <Widget>[
                          Text('CLOSE',style: TextStyle(fontFamily: 'Montserrat', fontSize: 14.0,color: colors.red)),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Column(
                        children: <Widget>[
                          Text('ADD',style: TextStyle(fontFamily: 'Montserrat', fontSize: 14.0,color: colors.blue)),
                        ],
                      ),
                      onPressed: () {
                        if(reasonController.text.length==0){
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Enter Remark')),);
                        }else{
                          print('selected = ${currentDate}');
                          print('EDIT = ${reasonController.text}');
                          print('SERVER = ${showdateServer}');
                          postStatus(showdateServer,reasonController.text,_statusCode);
                          Navigator.pop(context);
                        }
                        // Navigator.of(context).pop();
                        // SystemNavigator.pop();
                      },
                    ),

                  ],
                ),
            ),
          )


    );

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

  Color getMyColorStatus(int moneyCounter) {
    if (moneyCounter == 0){
      return colors.redtlight;
    }else if (moneyCounter == 1){
      return colors.yellow;
    }else{
      return colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors= AppColors();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: colors.redtheme,
        title: Text("Chapter Status",textAlign: TextAlign.center,style: new TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700)),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed:() {
              Navigator.pop(context, 'Yep!');

              // Navigator.of(context).pop();
            }),
        //backgroundColor: Colors.transparent,
        elevation: 5,
      ),

      body: SingleChildScrollView(
        child: Container(
          child: new Container(
            child: Column(
                children: <Widget>[
                  Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Column(
                          children: <Widget>[
                            Padding(
                              padding: new EdgeInsets.all(10.0),
                              child: Column(
                                // mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                            child: Column(
                                              children: [
                                                Row(
                                                    children: <Widget>[
                                                      Text('CHAPTER',maxLines: 1,
                                                          style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    ]),
                                                Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(widget.chapterData.chapterName != null
                                                            ? widget.chapterData.chapterName!
                                                            : '',
                                                            style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.w700)),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("LECT. TAKEN",maxLines: 1,
                                                        style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ]),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text('$classTaken/${widget.chapterData.noOfPeriod}',
                                                          style: new TextStyle(color:colors.grey,fontSize: 13.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text('STATUS',maxLines: 1,
                                                        style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ]),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(getStatusName(widget.chapterData.status),
                                                          style: new TextStyle(color:getMyColorStatus(widget.chapterData.status),fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              Row(
                                                  children: <Widget>[
                                                    Text('TOPIC',maxLines: 1,
                                                        style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight.w700)),
                                                  ]),

                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child:Text(widget.chapterData.topic != null
                                                          ? widget.chapterData.topic!
                                                          : '',
                                                          style: new TextStyle(color:colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.w700)),
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ),

                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                  visible: true,
                                                  child: Container(
                                                      height: 35,
                                                      width: 110,
                                                      child: Material(
                                                        elevation: 5.0,
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        color: colors.blue,
                                                        child: MaterialButton(
                                                          minWidth: MediaQuery.of(context).size.width,
                                                          onPressed: () async {
                                                            setState(() {
                                                              addStatus(context);
                                                            });
                                                          },
                                                          child: Text("ADD STATUS",
                                                              textAlign: TextAlign.center,
                                                              style: new TextStyle(color: colors.white,fontSize: 11.0,fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.w700)),
                                                        ),
                                                      )
                                                  ),
                                              ),

                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ]),
                            ),
                          ])
                  ),

                  Column(
                      children:<Widget>[
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.all(10),
                              child: Text('Status History',maxLines: 1,
                                  style: new TextStyle(color: colors.blue,fontSize: 15.0,fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700)),
                            ),

                          ],
                        ),

                        Container(
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child:Column(
                                children: <Widget>[
                                  ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:chapterStatusList.length,
                                      itemBuilder: _buildRowSecond
                                  )
                                ],
                              ),

                          ),
                        ),
                      ])
                ]),
          ),
        ),

      ),
    );


  }


  Widget _buildRowSecond(BuildContext context, int index) {
    var colors= AppColors();

    String getStatusName(int moneyCounter) {
      if (moneyCounter == 1){
        return "In-Progress";
      } else if (moneyCounter == 2) {
        return "Complete";
      }else{
        return "Revision";
      }
    }

    Color getMyColor(int moneyCounter) {
      if (moneyCounter == 1){
        return colors.yellow;
      } else if (moneyCounter == 2) {
        return colors.green;
      }else{
        return colors.redtheme;
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3.0,
      margin: EdgeInsets.all(5),
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
                        flex: 1,
                        child:Padding(padding: const EdgeInsets.all(1.0),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:<Widget>[
                                  Text(commonAlert.dateFormateServertoMobile(context,chapterStatusList[index].statusDate), maxLines: 1,
                                      style: new TextStyle(color: colors.black,fontSize: 11.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 3.0),
                                  Text('Date',maxLines: 1,
                                      style: new TextStyle(color: colors.greydark,fontSize: 11.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                ])
                        ),
                      ),

                      Container(height: 70.0, child: VerticalDivider(color: Colors.grey,)),
                      Expanded(
                        flex: 4,
                        child:Padding(padding: const EdgeInsets.all(3.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:<Widget>[
                                  Text('Remark',maxLines: 1,
                                      style: new TextStyle(color: colors.black,fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 2.0),
                                  Text(chapterStatusList[index].remark != ''
                                      ? chapterStatusList[index].remark
                                      : '',
                                      //maxLines: 3,
                                      style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(getStatusName(chapterStatusList[index].status),maxLines: 1,
                                          style: new TextStyle(color: getMyColor(chapterStatusList[index].status),fontSize: 11.0,fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  )
                                ])
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