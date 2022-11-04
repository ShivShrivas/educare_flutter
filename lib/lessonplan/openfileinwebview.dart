import 'package:educareadmin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenWebView extends StatefulWidget {
  String categoryTitle;
  String docTitle;
  OpenWebView(this.categoryTitle,this.docTitle);

  @override
  OpenWebViewState createState() => OpenWebViewState();
}

class OpenWebViewState extends State<OpenWebView> {
  int position = 1 ;

  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A){
    setState(() {
      position = 1;
    });
  }
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (kDebugMode) {
      print( 'https://docs.google.com/gview?embedded=true&url=${widget.categoryTitle}');
    }
    WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/backappbar.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("${widget.docTitle}",
            textAlign: TextAlign.center,
            style:  TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700)),
        leading:  IconButton(

            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();

            }),
      ),
      body: IndexedStack(
        index: position,
        children: [
          WebView(
            onPageFinished: doneLoading,
            onPageStarted: startLoading,
            backgroundColor: MyApp.colors.redthemenew,

            initialUrl:
                'https://docs.google.com/gview?embedded=true&url=${widget.categoryTitle}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
          Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                  color: MyApp.colors.redthemenew,
                )),
          ),
        ],
      ),
    );
  }
}
