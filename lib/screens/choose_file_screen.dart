import 'package:flutter/material.dart';
// Import the DetailsScreen file here
import 'details_screen.dart';

class ChooseFileScreen extends StatefulWidget {
  final List<FileItem> files;
  final String userName;

  const ChooseFileScreen({
    super.key,
    required this.files,
    required this.userName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChooseFileScreenState createState() => _ChooseFileScreenState();
}

class _ChooseFileScreenState extends State<ChooseFileScreen> {
  late List<bool> isCheckedList;

  @override
  void initState() {
    super.initState();
    isCheckedList = List<bool>.filled(widget.files.length, false); // Initialize all checkboxes as false
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: widget.files.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                child: CheckboxListTile(
                  title: Text(widget.files[index].name),
                  subtitle: Text('Size: ${widget.files[index].size}'),
                  value: isCheckedList[index],
                  onChanged: (value) {
                    setState(() {
                      isCheckedList[index] = value!;
                    });
                  },
                  secondary: Icon(widget.files[index].icon, color: widget.files[index].color),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isCheckedList.contains(true)
                ? () {
                    List<FileItem> selectedFiles = [];
                    for (int i = 0; i < widget.files.length; i++) {
                      if (isCheckedList[i]) {
                        selectedFiles.add(widget.files[i]);
                      }
                    }
                    if (selectedFiles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No files selected')),
                      );
                    } else {
                      // Navigate to DetailsScreen with selectedFiles as arguments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(selectedFiles: selectedFiles, userName: widget.userName,),
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
            ),
            child: const Text(
              'Update',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Define the FileItem class as you need it
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
