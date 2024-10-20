import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printz/screens/file_upload_screen.dart';
import 'package:printz/screens/login_screen.dart';
import 'dart:math'; // Import dart:math for the log() function

// Main Screen where user selects files
class DocumentUploadScreen extends StatefulWidget {
  final String userName;

  DocumentUploadScreen({required this.userName});

  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Row(
              children: [
                const Icon(Icons.logout, color: Colors.black),
                const SizedBox(width: 18),
              ],
            ),
            onPressed: () {
              setState(() {
                _isLoading = true; // Start loading animation
              });

              // Simulate logout process
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
               padding:  const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.04,
                        top: screenHeight * 0.02,
                      ),
                      child: const Text(
                        'Choose your File & Doc for PrintOut',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    Center(
                      child: UploadContainer(userName: widget.userName),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                        strokeWidth: 4,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Logging out...',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class UploadContainer extends StatefulWidget {
  final String userName;

  UploadContainer({required this.userName});

  @override
  _UploadContainerState createState() => _UploadContainerState();
}

class _UploadContainerState extends State<UploadContainer> {
  late String userName;
  bool _isLoading = false;
  List<String> fileDetails = [];

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
  }

  // Utility function to convert bytes to readable size
  String getFileSizeString({required int bytes, int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor(); // Corrected usage of log()
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  Future<void> _pickFiles(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && result.files.isNotEmpty) {
      List<String> selectedFilePaths = result.paths.whereType<String>().toList();
      fileDetails.clear();

      for (var file in result.files) {
        String fileSize = getFileSizeString(bytes: file.size);
        fileDetails.add('File: ${file.name}, Size: $fileSize');
      }

      // Navigate to FileUploadScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileUploadScreen(
            selectedFilePaths: selectedFilePaths,
            userName: userName,
            fileDetails: fileDetails,
          ),
        ),
      );
    } else {
      print("No files selected");
    }
    

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.2,
        vertical: screenWidth * 0.1,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.upload_file,
            size: screenWidth * 0.16,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Select your file or image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : () => _pickFiles(context),
              icon: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Icon(Icons.upload_file_sharp, color: Colors.white),
              label: _isLoading
                  ? const Text(
                      'Loading...',
                      style: TextStyle(fontSize: 16),
                    )
                  : const Text(
                      'Browse',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B61FF),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

