import 'package:flutter/material.dart';
import 'package:printz/screens/choose_file_screen.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/custom_text_field.dart';

class DetailsPage extends StatefulWidget {
  final String userName; // Add userName parameter
  final List<FileItem> selectedFiles;

  const DetailsPage({
    super.key,
    required this.userName, // Initialize userName
    required this.selectedFiles,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String sheetType = 'A4';
  String printType = 'Color';
  bool isFullColor = true;
  int numberOfCopies = 1;
  String colorPageNumber = ''; // Variable to store page number input
  String pageType = 'Single'; // Variable for Page Type

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.04), // Dynamic padding
          child: Text(
            widget.userName, // Access userName from widget
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0x00FBC232),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.01),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange, // Set the indicator color to orange
          tabs: const [
            Tab(
              child: Text(
                'Normal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700, // Increased font weight to w700
                  color: Colors.black, // Set text color to black
                ),
              ),
            ),
            Tab(
              child: Text(
                'Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700, // Increased font weight to w700
                  color: Colors.black, // Set text color to black
                ),
              ),
            ),
            Tab(
              child: Text(
                'Book',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700, // Increased font weight to w700
                  color: Colors.black, // Set text color to black
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
          child: Column(
            children: [
              // TabBarView to switch between content based on selected tab
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent(showPageType: true), // Normal tab with Page Type
                    _buildTabContent(showPageType: false), // Report tab without Page Type
                    _buildTabContent(showPageType: false), // Book tab without Page Type
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the common tab content
  Widget _buildTabContent({required bool showPageType}) {
    return SingleChildScrollView(
      // Allows the content to scroll if it exceeds the screen height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Sheet Type"),
          CustomRadioButton(
            options: const ['A4', 'A1', 'A3', 'A2'],
            selectedOption: sheetType,
            onChanged: (value) => setState(() => sheetType = value),
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("Print Type"),
          CustomRadioButton(
            options: const ['Color', 'Black & White'],
            selectedOption: printType,
            onChanged: (value) {
              setState(() {
                printType = value;
                // Reset color options when print type changes
                isFullColor = true; // Default to full color
                colorPageNumber = ''; // Clear the page number
              });
            },
          ),
          const SizedBox(height: 16),

          // Show Color Page options only if Color is selected
          if (printType == 'Color') ...[
            _buildSectionTitle("Color Page"),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: isFullColor,
                  onChanged: (value) => setState(() {
                    isFullColor = value!;
                    colorPageNumber = ''; // Reset the page number
                  }),
                ),
                const Text('Full'),
                const SizedBox(width: 35), // Add some spacing
                const Text(
                  '(or)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20), // Add some spacing
                Radio(
                  value: false,
                  groupValue: isFullColor,
                  onChanged: (value) => setState(() {
                    isFullColor = value!;
                  }),
                ),
                const Text('Enter color pg.no'),
              ],
            ),
            // Show text field for page number if not full color
            if (!isFullColor) ...[
              const SizedBox(height: 8), // Add spacing above the text field
              CustomTextField(
                label: "Page No", // Label for the text field
                onChanged: (value) {
                  colorPageNumber = value; // Store the page number input
                }, keyboardType: TextInputType.text,
              ),
            ],
          ],
          const SizedBox(height: 16),

          // Title for No. of Copies
          _buildSectionTitle("No. of Copies"),
          const SizedBox(height: 8), // Add spacing between title and text field
          CustomTextField(
            label: "", // No label for this text field
            keyboardType: TextInputType.number,
            onChanged: (value) {
              numberOfCopies = int.tryParse(value) ?? 1; // Store number of copies
            },
          ),
          const SizedBox(height: 16),

          // Conditionally show Page Type only for the Normal tab
          if (showPageType) ...[
            _buildSectionTitle("Page Type"),
            const SizedBox(height: 8), // Add spacing before the radio buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: 'Single',
                  groupValue: pageType,
                  onChanged: (value) {
                    setState(() {
                      pageType = value!; // Update state variable
                    });
                  },
                ),
                const Text('Single'),
                const SizedBox(width: 20),
                Radio(
                  value: 'Split in 2 + B2B',
                  groupValue: pageType,
                  onChanged: (value) {
                    setState(() {
                      pageType = value!; // Update state variable
                    });
                  },
                ),
                const Text('Split in 2 + B2B'),
                const SizedBox(width: 20),
                Radio(
                  value: 'B2B',
                  groupValue: pageType,
                  onChanged: (value) {
                    setState(() {
                      pageType = value!; // Update state variable
                    });
                  },
                ),
                const Text('B2B'),
              ],
            ),
          ],

          // Title for additional comments
          _buildSectionTitle("Anything to add Mention below"),
          const SizedBox(height: 8), // Add spacing between title and text field
          const CustomTextField(
            label: "", // No label for this text field
            maxLines: 4, keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16), // Add spacing at the bottom

          // Submit Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Set the color to orange
              minimumSize: const Size(double.infinity, 60), // Set width and height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0), // Reduce border radius
              ),
            ),
            onPressed: () {
              // Submit logic
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 20, // Increase font size
                color: Colors.white, // Set font color to white
                fontWeight: FontWeight.bold, // Optional: make text bold
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}