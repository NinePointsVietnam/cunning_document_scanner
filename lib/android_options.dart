class AndroidScannerOptions {
  const AndroidScannerOptions({
    this.scannerMode = AndroidScannerMode.scannerModeFull,
  });

  final AndroidScannerMode scannerMode;
}

enum AndroidScannerMode {
  scannerModeFull(
      1), // adds ML-enabled image cleaning capabilities (erase stains, fingers, etc…) to the SCANNER_MODE_BASE_WITH_FILTER mode.
  scannerModeBaseWithFilter(
      2), // Adds image filters (grayscale, auto image enhancement, etc…) to the SCANNER_MODE_BASE mode.
  scannerModeBase(3); // basic editing capabilities (crop, rotate, reorder pages, etc…).

  const AndroidScannerMode(this.value);
  final int value;
}
