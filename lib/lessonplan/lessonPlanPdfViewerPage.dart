import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class LessonPlanPdfViewerPage extends StatefulWidget {
  String pathPDF;
  String NamePDF;
   LessonPlanPdfViewerPage(this.pathPDF,this.NamePDF);

  @override
  State<LessonPlanPdfViewerPage> createState() => _LessonPlanPdfViewerPageState();
}

class _LessonPlanPdfViewerPageState extends State<LessonPlanPdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Text(widget.NamePDF), //appbar title
            backgroundColor: Colors.redAccent //appbar background color
        ),
        body: Container(
            child: PDF().cachedFromUrl(
              widget.pathPDF,
              maxAgeCacheObject:Duration(days: 1), //duration of cache
              placeholder: (progress) => Center(child: Text('$progress %')),
              errorWidget: (error) => Center(child: Text(error.toString())),
            )
        )
    );
  }
}
