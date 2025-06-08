import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';


class PdfViewerPage extends StatefulWidget {
  final String url;
  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _error;
  late Uint8List _pdfBytes;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final resp = await http.get(Uri.parse(widget.url));
      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
      _pdfBytes = resp.bodyBytes;  // already Uint8List

      // now this matches the PdfDocument API:
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(_pdfBytes),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (!_isLoading && _error == null) {
      _pdfController.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('جاري التحميل…')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ')),
        body: Center(child: Text('تعذّر تحميل الـ PDF:\n$_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض الواجب'),

      ),
      body: PdfViewPinch(
        controller: _pdfController,
        onDocumentError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ أثناء العرض: $err')),
          );
        },
      ),
    );
  }
}