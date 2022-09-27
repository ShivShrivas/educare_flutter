
import 'package:educareadmin/conts/colors.dart';
import 'package:educareadmin/schoolcode.dart';
import 'package:flutter/material.dart';




class FindCode extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return FindCodeState();
  }
}

class FindCodeState extends State<FindCode> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  bool _isObscure = true;
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var colors= AppColors();

    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Search school name",
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
          icon: Icon(Icons.search,color: colors.redtheme),
        ),

      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: new GestureDetector(
             onTap: () {
             FocusScope.of(context).requestFocus(new FocusNode());
          },
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
                           Navigator.pushReplacement(
                               context, MaterialPageRoute(builder: (context) => SchoolCode(0)));
                           //Navigator.of(context).pop();
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          Text("Find School Code",
                              style: new TextStyle(color: colors.black,fontSize: 20.0,fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 25),
                            child: emailField,
                          )

                        ]
                      ))


                    ]
                 ))
               ]
          )
          )
        )
    );
  }

}