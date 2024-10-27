// file_item.dart
import 'package:flutter/material.dart';

class FileItem {
  final String name;  // The name of the file
  final String size;  // The size of the file
  final IconData icon; // The icon representing the file type
  final Color color; // The color of the icon
  bool uploaded; // Status to indicate if the file is uploaded

  FileItem({
    required this.name,
    required this.size,
    required this.icon,
    required this.color,
    this.uploaded = false, // Default value
  });
}
