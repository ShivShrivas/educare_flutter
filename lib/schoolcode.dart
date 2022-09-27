import 'dart:async';
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:educareadmin/findschoolcode.dart';
import 'package:educareadmin/login.dart';
import 'package:educareadmin/models/logindata.dart';
import 'package:educareadmin/storedata/sfdata.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'network/api_service.dart';



class SchoolCode extends StatefulWidget {

  SchoolCode(this.ifLogin) : super();

  final int ifLogin;

  @override
  State<StatefulWidget> createState() {
    return SchoolCodeState();
  }
}

class SchoolCodeState extends State<SchoolCode> {

  var onTapRecognizer;

  SFData sfdata= SFData();
  CommonAction commonAlert= CommonAction();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";
  late StreamController<ErrorAnimationType> errorController;
  var schoolLogoUrl;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  List<LoginData> logindata = <LoginData>[];

  @override
  void initState() {
   // getLoginData();
   // loginRequest();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    //sfdata.removeAll(context);
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }


  Future<Null> connectionRequest() async {
    final api = Provider.of<ApiService>(context, listen: false);
    return await api
        .getconnection(currentText)
        .then((result) {
          Navigator.of(context,rootNavigator: true).pop();
          //print(result.length);
          if(result.length==1){
            print("MODELDATA");
            print(result[0].schoolCode);
            if(result[0].branchLogo == null){
              schoolLogoUrl="0";
            }else{
              schoolLogoUrl=result[0].branchLogo;
            }
            sfdata.saveConnectionDataToSF(context,result[0].groupName, result[0].societyName, result[0].schoolName, result[0].entity, result[0].groupCode, result[0].societyCode, result[0].schoolCode, result[0].branchCode, result[0].displayCode,schoolLogoUrl);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login(widget.ifLogin)));
          }else{
            commonAlert.showAlertDialog(context, "Error","Entered School Code does not exist. Try again","Try again");
          }
      setState(() {
      });
    }).catchError((error) {
     // isLoader = false;
      Navigator.of(context,rootNavigator: true).pop();
      print(error);
    });
  }







  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   var colors= AppColors();
   SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);
   return Scaffold(
     resizeToAvoidBottomInset: true,
      body: GestureDetector(
       onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
       },
       child: SingleChildScrollView(
        child: Container(
         height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/schoolcode.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            /////// AppBar  ////////////////
            Positioned(
              top: MediaQuery.of(context).size.height * 0.02,
              left: 20.0,
              right: 20.0,
              child: AppBar(
                title: Text(""),
                leading: new IconButton(
                  //icon: Text('Back', textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed:() {
                      SystemNavigator.pop();
                      /*Future.delayed(const Duration(milliseconds: 1000), () {
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      });*/
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SchoolCode(widget.ifLogin)));
                      // Navigator.of(context).pop();
                    }),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
              Container(
               child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                     new Container(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                          SizedBox(
                                height: 45.0,
                                child: Image.asset( "assets/logo.png",
                                 fit: BoxFit.contain,
                            ),
                           ),
                           SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                           Text("Enter School Code",
                               style: new TextStyle(color: colors.redtheme,fontSize: 22.0,fontFamily: 'Montserrat',
                                   fontWeight: FontWeight.w700)),
                           SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                           RichText(
                             textAlign: TextAlign.center,
                             text: TextSpan(
                               text: 'Please enter your ',
                               style: new TextStyle(color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                   fontWeight: FontWeight.w700),
                               children: <TextSpan>[
                                 TextSpan(text: 'School/College code', style: TextStyle(color: colors.redtheme,fontSize: 14.0,fontFamily: 'Montserrat',
                                     fontWeight: FontWeight.w700)),
                                 TextSpan(text: ' and login with credentials',style: new TextStyle(height: 1.8,color: colors.grey,fontSize: 14.0,fontFamily: 'Montserrat',
                                     fontWeight: FontWeight.w700)),
                               ],
                             ),
                           ),
                           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                           ///////////OTP Block////////////
                           Form(
                             key: formKey,
                             child: Padding(
                                 padding: const EdgeInsets.symmetric(
                                     vertical: 8.0, horizontal: 30),
                                 child: PinCodeTextField(
                                   appContext: context,
                                  /* pastedTextStyle: TextStyle(
                                     color: Colors.red.shade600,
                                     fontWeight: FontWeight.bold,
                                   ),*/
                                   length: 6,

                                   obscureText: false,
                                   obscuringCharacter: '*',
                                   blinkWhenObscuring: true,
                                   autoDisposeControllers:true,
                                   animationType: AnimationType.fade,
                                   /*validator: (v) {
                                    *//* if (v.length < 3) {
                                       return "I'm from validator";
                                     } else {
                                       return null;
                                     }*//*
                                   },*/
                                   pinTheme: PinTheme(
                                     shape: PinCodeFieldShape.box,
                                     borderRadius: BorderRadius.circular(5),
                                     fieldHeight: 50,
                                     fieldWidth: 40,
                                     activeFillColor: hasError ? Colors.redAccent : Colors.white,
                                   ),
                                   cursorColor: Colors.black,
                                   animationDuration: Duration(milliseconds: 300),
                                   //backgroundColor: Colors.redAccent,
                                   enableActiveFill: false,
                                   errorAnimationController: errorController,
                                   controller: textEditingController,
                                   keyboardType: TextInputType.text,
                                   boxShadows: [
                                     BoxShadow(
                                       offset: Offset(0, 1),
                                       color: Colors.black12,
                                       blurRadius: 10,
                                     )
                                   ],
                                   onCompleted: (v) {
                                     print("Completed");
                                     currentText=currentText.toUpperCase();
                                    // sfdata.saveConnectionDataToSF(context,"ADMIN");
                                   },
                                   // onTap: () {
                                   //   print("Pressed");
                                   // },
                                   onChanged: (value) {
                                     print(value);
                                     setState(() {
                                       currentText = value;
                                     });
                                   },
                                   beforeTextPaste: (text) {
                                     print("Allowing to paste $text");
                                     //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                     //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                     return true;
                                   },
                                 )),
                           ),

                          // SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                           Container(
                               margin: const EdgeInsets.symmetric(horizontal: 90),
                               child: ButtonTheme(
                                 height: 50,
                                  minWidth: 90,
                                   child: FlatButton(
                                     onPressed: () {
                                       print("School COde--- $currentText");
                                       if(currentText.length==6){
                                         commonAlert.showLoadingDialog(context, _keyLoader);
                                         connectionRequest();
                                       }else{
                                         commonAlert.showAlertDialog(context, "Alert","Please enter 6 digit school code","Ok");
                                       }
                                     },
                                     color: colors.redtheme,
                                     textColor: Colors.white,
                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                     child: Center(
                                         child: Text(
                                           "Let's Go",
                                           style: TextStyle(
                                               fontFamily: 'Montserrat',
                                               color: Colors.white,
                                               fontSize: 18,
                                               fontWeight: FontWeight.bold),
                                         )),
                                   )
                               )
                           ),
                           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                           GestureDetector(
                             onTap: () {
                               Navigator.pushReplacement(
                                   context, MaterialPageRoute(builder: (context) => FindCode()));
                             },
                             child: RichText(
                               textAlign: TextAlign.center,
                               text: TextSpan(
                                 text: 'Find ',
                                 style: new TextStyle(color: colors.grey,fontSize: 13.0,fontFamily: 'Montserrat',
                                     fontWeight: FontWeight.w700),
                                 children: <TextSpan>[
                                   TextSpan(text: 'School/College ', style: TextStyle(color: colors.redtheme,fontSize: 13.0,fontFamily: 'Montserrat',
                                       fontWeight: FontWeight.w700)),
                                   TextSpan(text: 'code',style: new TextStyle(height: 1.8,color: colors.grey,fontSize: 13.0,fontFamily: 'Montserrat',
                                       fontWeight: FontWeight.w700)),
                                 ],
                               ),
                             ),

                           )







                      ])

                     )


               ])
              )
              )

         ]),
       )
      )
      )
    );
  }

}