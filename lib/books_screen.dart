import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class BooksScreen extends StatefulWidget {
  final String ageRange;
  final String type;

  const BooksScreen({super.key, required this.ageRange, required this.type});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final Dio dio = Dio();
  Map<int, double> progressMap = {};
  Map<int, String> filePathMap = {};

  Map<String, List<Map<String, String>>> get books => {
    '0-4': [
      {
        'title': 'Lulu',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/0-4/Lulu%200-4.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/0-4/Lulu%200-4.docx',
      },
      {
        'title': 'Milos Colorful Day',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/0-4/Milos%20Colorful%20Day%200-4.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/0-4/Milos%20Colorful%20Day%200-4.docx',
      },
    ],
    '4-8': [
      {
        'title': 'Max the curious boy',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/4-8/Max%20the%20curious%20boy%204-8.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/4-8/Max%20the%20curious%20boy%204-8.docx',
      },
      {
        'title': 'Sophie and the Magical Garden',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/4-8/Sophie%20and%20the%20Magical%20Garden%204-8.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/4-8/Sophie%20and%20the%20Magical%20Garden%204-8.docx',
      },
    ],
    '8-12': [
      {
        'title': 'ori and loria',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/12/ori%20and%20loria%2012.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/12/ori%20and%20loria%2012.docx',
      },
      {
        'title': 'Willow Creek',
        'pdf':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/12/Willow%20Creek%2012.pdf',
        'word':
            'https://obuehwqalxwaybvlrgdk.supabase.co/storage/v1/object/public/books/12/Willow%20Creek%2012.docx',
      },
    ],
  };

  Future<void> _downloadFile(String url, int index) async {
    final fileName = Uri.parse(url).pathSegments.last;
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    setState(() {
      progressMap[index] = 0.0;
    });

    try {
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progressMap[index] = received / total;
            });
          }
        },
      );

      setState(() {
        progressMap.remove(index);
        filePathMap[index] = filePath;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Downloaded to: $filePath')));
    } catch (e) {
      setState(() {
        progressMap.remove(index);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  void _openFile(int index) {
    final path = filePathMap[index];
    if (path != null) {
      OpenFile.open(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedBooks = books[widget.ageRange] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.ageRange} Books - ${widget.type.toUpperCase()}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: selectedBooks.length,
        itemBuilder: (context, index) {
          final book = selectedBooks[index];
          final url = book[widget.type]!;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                widget.type == 'pdf' ? Icons.picture_as_pdf : Icons.description,
                size: 36,
                color: Colors.blue,
              ),
              title: Text(book['title']!, style: const TextStyle(fontSize: 18)),
              trailing: progressMap.containsKey(index)
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: progressMap[index],
                        strokeWidth: 3,
                      ),
                    )
                  : filePathMap.containsKey(index)
                  ? ElevatedButton(
                      onPressed: () => _openFile(index),
                      child: const Text('Open'),
                    )
                  : ElevatedButton(
                      onPressed: () => _downloadFile(url, index),
                      child: const Text('Download'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
