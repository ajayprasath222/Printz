import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FileUploadScreen extends StatefulWidget {
  final List<String> selectedFilePaths;
  final String userName; // Passed from LoginScreen for displaying the username

  FileUploadScreen({
    required this.selectedFilePaths,
    required this.userName,
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
        size: 'Unknown', // You can implement file size retrieval if needed
        icon: iconDataAndColor['icon']!,
        color: iconDataAndColor['color']!,
        uploaded: false,
      );
    }).toList();
  }

  Future<void> uploadFile(FileItem file) async {
    try {
      final uri = Uri.parse(
          'https://example.com/upload'); // Replace with your upload URL

      // Create a multipart request
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file',
            widget.selectedFilePaths.firstWhere((p) => p.endsWith(file.name))));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully uploaded
        setState(() {
          file.uploaded = true; // Mark the file as uploaded
        });
      } else {
        // Handle error response
        setState(() {
          file.uploaded = false; // Mark the file as failed to upload
        });
      }
    } catch (e) {
      // Handle any exceptions
      setState(() {
        file.uploaded = false; // Mark the file as failed to upload
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            widget.userName, // Display the username passed from LoginScreen
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
                    },
                    child: FileCard(
                        file: files[index], onDelete: () => _removeFile(index)),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement file browsing functionality here
                  },
                  icon:
                      const Icon(Icons.upload_file_sharp, color: Colors.white),
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
  onPressed: _uploadFiles, // Start the upload process
  child: const Text(
    'Next',
    style: TextStyle(color: Colors.white), // Set text color to white
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.02,
      horizontal: MediaQuery.of(context).size.height * 0.04,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2), // Reduced border radius
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
        icon = Icons.picture_as_pdf; // PDF file icon
        color = Colors.red; // Color for PDF
        break;
      case 'doc':
      case 'docx':
        icon = Icons.article; // Word document icon
        color = Colors.blue; // Color for Word documents
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart; // Excel file icon
        color = Colors.green; // Color for Excel files
        break;
      case 'ppt':
      case 'pptx':
        icon = Icons.slideshow; // PowerPoint file icon
        color = Colors.orange; // Color for PowerPoint
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        icon = Icons.image; // Image file icon
        color = Colors.pink; // Color for images
        break;
      case 'mp4':
      case 'mov':
        icon = Icons.videocam; // Video file icon
        color = Colors.teal; // Color for videos
        break;
      case 'zip':
      case 'rar':
        icon = Icons.folder_zip; // Zip file icon
        color = Colors.brown; // Color for Zip files
        break;
      default:
        icon = Icons.file_present; // Generic file icon
        color = Colors.grey; // Default color
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

  FileCard({required this.file, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: file.uploaded
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Icon(
            file.icon,
            color: file.uploaded ? Colors.green : Colors.red,
          ),
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
