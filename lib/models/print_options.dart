class PrintOptions {
  String sheetType;
  String printType;
  bool isFullColor;
  String pageType;
  int numberOfCopies;
  String additionalInfo;

  PrintOptions({
    required this.sheetType,
    required this.printType,
    required this.isFullColor,
    required this.pageType,
    required this.numberOfCopies,
    required this.additionalInfo,
  });
}
