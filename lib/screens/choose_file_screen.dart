import 'package:flutter/material.dart';
import 'package:printz/screens/file_upload_screen.dart';

class ChooseFileScreen extends StatefulWidget {
  final List<FileItem> files;

  const ChooseFileScreen({
    Key? key,
    required this.files,
  }) : super(key: key);

  @override
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
        title: const Text('Choose Files'),
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
                      isCheckedList[index] = value!; // Toggle the checkbox value
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
          width: double.infinity, // Make the button fill the available width
          child: ElevatedButton(
            onPressed: isCheckedList.contains(true) ? () {
              List<FileItem> selectedFiles = [];
              for (int i = 0; i < widget.files.length; i++) {
                if (isCheckedList[i]) {
                  selectedFiles.add(widget.files[i]); // Add selected files to the list
                }
              }
              if (selectedFiles.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No files selected')),
                );
              } else {
                // Handle selected files
                Navigator.pop(context, selectedFiles); // Return selected files to the previous screen
              }
            } : null, // Make the button inactive if no checkbox is selected
            child: const Text(
              'Update',
              style: TextStyle(fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold, // Set text to bold
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 4.0),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0), // Set border radius
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class FileItem {
//   final String name;
//   final String size;
//   final IconData icon;
//   final Color color;
//   bool uploaded;

//   FileItem({
//     required this.name,
//     required this.size,
//     required this.icon,
//     required this.color,
//     this.uploaded = false,
//   });
// }
