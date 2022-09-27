
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/conts/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class ForgotPassword extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordState();
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  var common= CommonAction();


  bool _isObscure = true;
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var colors= AppColors();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter user ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: new BorderSide(color: colors.redtheme),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
          color: colors.redtheme,
            width: 2.0,
         ),
        ),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
          color: colors.redtheme,
          width: 2.0,
         ),
         ),

        suffixIcon: IconButton(
          onPressed: (){},
          icon: Icon(Icons.person_rounded,color: colors.redtheme),
        ),

      ),
    );
    final passwordField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter email",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: new BorderSide(color: colors.redtheme)
          ),
        enabled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: colors.redtheme,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: colors.redtheme,
            width: 2.0,
          ),
        ),

          suffixIcon: IconButton(
              icon: Icon(Icons.email_outlined,color: colors.redtheme),
              onPressed: () {

                setState(() {
                  _isObscure = !_isObscure;
                });
              }),
        /*suffixIcon: IconButton(
          onPressed: (){},
          icon: Icon(Icons.remove_red_eye,color: colors.redtheme),
        ),*/

      ),
    );


    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: colors.redtheme,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showAlertDialog(context);
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(

        body: new GestureDetector(
             onTap: () {
             FocusScope.of(context).requestFocus(new FocusNode());
           },
          child: SingleChildScrollView(
          child: Container(
           height: MediaQuery.of(context).size.height,
           child: Stack(
               children: <Widget>[
                 Container(
                   height: double.infinity ,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage("assets/loginbottom.png"),
                         fit: BoxFit.fill,
                   ),
                 ),
                 ),
                 ///////AppBar
                 Positioned(
                   top: MediaQuery.of(context).size.height * 0.02,
                   left: 20.0,
                   right: 20.0,
                   child: AppBar(
                     title: Text(""),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                      new Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 70.0,
                            child: Image.asset( "assets/logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                          Text("Forgot Your Password",
                              style: new TextStyle(color: colors.black,fontSize: 20.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                          Container(
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              semanticContainer: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(20),
                              child: Padding(
                                  padding: new EdgeInsets.all(20.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:Text("User ID",
                                        textAlign: TextAlign.start,
                                        style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400)),
                                ),
                                    emailField,
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Registered Email",
                                        textAlign: TextAlign.start,
                                        style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400)),
                                ),
                                    passwordField,  ////password
                                   // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 60),
                                    child: loginButon,
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                /*Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                    Text("New password is sent your email",
                                        textAlign: TextAlign.center,style: new TextStyle(color: colors.grey,fontSize: 12.0,fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700)),
                                ]),
                                Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: 'user@allen.com',
                                              style: new TextStyle(color: colors.redtheme,fontSize: 12.0,fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ]),

                                    */

                              ])
                            ),

                            )
                          )


                        ]
                      ))


                    ]
                 ))




               ]
          )
          )
          )
        )
    );
  }



  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
       // Navigator.pushReplacement(
          //  context, MaterialPageRoute(builder: (context) => Login()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Mail Sent"),
      content: Text("New password is sent your email.- user@allen.com"),
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
    );
  }
}