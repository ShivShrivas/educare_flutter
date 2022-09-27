import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';



class CommonAction{
  showAlertDialog(BuildContext context,String title,String message,String button) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text(button),
                  ],
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  /*Widget okButton = FlatButton(
      child: Text(button),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );*/


  messageAlertSuccess(BuildContext context,String msg, String ttl) {
   // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                  Navigator.of(context).pop();
                 // SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  messageAlertError(BuildContext context,String msg, String ttl) {
    // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                 // Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

   Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CupertinoActivityIndicator(),
                        SizedBox(height: 10,),
                        Text("Loading...",style: TextStyle(color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),)
                      ]),
                    )
                  ]));
              });
     }



  void showToast(BuildContext context,String message) {
    final scaffold = Scaffold.of(context);
    // ignore: deprecated_member_use
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.redAccent,fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
         // duration: Duration(seconds: 3)
      ),
    );
  }


  String dateFormate(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateMM(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateServer(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateStringServer(BuildContext context,String date){
   // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }


  String dateFormateMMtoM(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('dd MMM yyyy');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }

  String dateFormateServertoMobile(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }




  String leavefordata(BuildContext context,String leave){
    late String leavefullform;
    if(leave == 'F'){
      leavefullform='Full';
    }else if(leave == 'HDF'){
      leavefullform='First Half';
    }else if(leave == 'HDS'){
      leavefullform='Second Half';
    }
    return leavefullform;

  }

}