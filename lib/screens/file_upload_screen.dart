import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'choose_file_screen.dart';

class FileUploadScreen extends StatefulWidget {
  final List<String> selectedFilePaths;
  final String userName;

  FileUploadScreen({
    required this.selectedFilePaths,
    required this.userName, required List<String> fileDetails,
  });

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  late List<FileItem> files;

  @override
  void initState() {
    super.initState();
    files = widget.selectedFilePaths.map((path) {
      final iconDataAndColor = getFileIcon(path);
      return FileItem(
        name: path.split('/').last,
        size: getFileSize(path),
        icon: iconDataAndColor['icon']!,
        color: iconDataAndColor['color']!,
        uploaded: false,
      );
    }).toList();
  }

  // Function to pick new files from local storage
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allows selecting multiple files
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.path != null) {
            files.add(FileItem(
              name: file.name,
              size: getFileSize(file.path!),
              icon: getFileIcon(file.path!)['icon']!,
              color: getFileIcon(file.path!)['color']!,
              uploaded: false,
            ));
          }
        }
      });
    }
  }

  String getFileSize(String path) {
    final file = File(path);
    if (file.existsSync()) {
      final sizeInBytes = file.lengthSync();
      if (sizeInBytes < 1000) {
        return '${sizeInBytes.toString()} Bytes';
      } else if (sizeInBytes < 1000000) {
        return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
      } else if (sizeInBytes < 1000000000) {
        return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      } else {
        return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
      }
    }
    return 'Unknown';
  }

  Future<void> uploadFile(FileItem file) async {
    try {
      final uri = Uri.parse('https://example.com/upload'); // Replace with your upload URL

      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          widget.selectedFilePaths.firstWhere((p) => p.endsWith(file.name)),
        ));

      // Show loading status
      setState(() {
        file.uploaded = false; // Reset uploaded state
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          file.uploaded = true; // Mark the file as uploaded
        });
      } else {
        _showSnackBar('Error: File upload failed.'); // Provide error feedback
      }
    } catch (e) {
      _showSnackBar('Exception: ${e.toString()}'); // Handle exceptions
    }
  }

  void _uploadFiles() {
    for (var file in files) {
      uploadFile(file); // Start uploading each file
    }
  }

  void _removeFile(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.userName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.01),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Files',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(files[index].name),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      _removeFile(index); // Remove the file from the list
                      _showSnackBar('File removed successfully.');
                    },
                    child: FileCard(
                      file: files[index], // Pass the file directly
                      onDelete: () => _removeFile(index), // Handle deletion
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFiles, // Pick files when "Browse" button is pressed
                  icon: const Icon(Icons.upload_file_sharp, color: Colors.white),
                  label: const Text(
                    'Browse',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.height * 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _uploadFiles(); // Start the upload process
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseFileScreen(files: files), // Pass files to ChooseFileScreen
                      ),
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.height * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getFileIcon(String path) {
    String extension = path.split('.').last.toLowerCase();
    IconData icon;
    Color color;

    switch (extension) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.article;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'ppt':
      case 'pptx':
        icon = Icons.slideshow;
        color = Colors.orange;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        icon = Icons.image;
        color = Colors.pink;
        break;
      case 'mp4':
      case 'mov':
        icon = Icons.videocam;
        color = Colors.teal;
        break;
      case 'zip':
      case 'rar':
        icon = Icons.folder_zip;
        color = Colors.brown;
        break;
      default:
        icon = Icons.file_present;
        color = Colors.grey;
    }

    return {'icon': icon, 'color': color};
  }
}

class FileItem {
  final String name;
  final String size;
  final IconData icon;
  final Color color;
  bool uploaded;

  FileItem({
    required this.name,
    required this.size,
    required this.icon,
    required this.color,
    this.uploaded = false,
  });
}

class FileCard extends StatelessWidget {
  final FileItem file;
  final VoidCallback onDelete;

  const FileCard({
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: file.color,
          child: Icon(file.icon, color: Colors.white),
        ),
        title: Text(file.name),
        subtitle: Text(file.size),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
