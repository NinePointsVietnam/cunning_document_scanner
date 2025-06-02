//
//  ScannerOptions.swift
//  cunning_document_scanner
//
//  Created by Maurits van Beusekom on 15/10/2024.
//

import Foundation

enum CunningScannerImageFormat: String {
    case jpg
    case png
}

struct CunningScannerOptions {
    let imageFormat: CunningScannerImageFormat
    let jpgCompressionQuality: Double
    let isGalleryImportAllowed: Bool
    let useWeScan: Bool
    let noOfPages: Int?
    
    //WeScan parameters
    let isAutoScanEnabled: Bool
    let isAutoScanAllowed: Bool
    let isFlashAllowed: Bool
    let backgroundColor: Int?
    let tintColor: Int?
    
    init() {
        self.imageFormat = CunningScannerImageFormat.png
        self.jpgCompressionQuality = 1.0
        self.isGalleryImportAllowed = false
        self.useWeScan = false
        self.noOfPages = 1
        self.isAutoScanEnabled = false
        self.isAutoScanAllowed = false
        self.isFlashAllowed = false
        self.backgroundColor = nil
        self.tintColor = nil
    }
    
    init(imageFormat: CunningScannerImageFormat) {
        self.imageFormat = imageFormat
        self.jpgCompressionQuality = 1.0
        self.isGalleryImportAllowed = false
        self.useWeScan = false
        self.noOfPages = 1
        self.isAutoScanEnabled = false
        self.isAutoScanAllowed = false
        self.isFlashAllowed = false
        self.backgroundColor = nil
        self.tintColor = nil
    }
    
    init(
        imageFormat: CunningScannerImageFormat,
        jpgCompressionQuality: Double,
        useWeScan: Bool = false,
        noOfPages: Int? = 1,
        isGalleryImportAllowed: Bool = false,
        isAutoScanEnabled: Bool = false,
        isAutoScanAllowed: Bool = false,
        isFlashAllowed: Bool = false,
        backgroundColor: Int? = nil,
        tintColor: Int? = nil
    ) {
        self.imageFormat = imageFormat
        self.jpgCompressionQuality = jpgCompressionQuality
        self.useWeScan = useWeScan
        self.noOfPages = noOfPages
        self.isGalleryImportAllowed = isGalleryImportAllowed
        self.isAutoScanEnabled = isAutoScanEnabled
        self.isAutoScanAllowed = isAutoScanAllowed
        self.isFlashAllowed = isFlashAllowed
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
    
    static func fromArguments(args: Any?) -> CunningScannerOptions {
        if (args == nil) {
            return CunningScannerOptions()
        }
        
        let scannerOptionsDict = args as? Dictionary<String, Any>
        
        if (scannerOptionsDict == nil) {
            return CunningScannerOptions()
        }
          
        let imageFormat: String = (scannerOptionsDict!["imageFormat"] as? String) ?? "png"
        let jpgCompressionQuality: Double = (scannerOptionsDict!["jpgCompressionQuality"] as? Double) ?? 1.0
        let useWeScan: Bool = (scannerOptionsDict!["useWeScan"] as? Bool) ?? false
        let noOfPages: Int = (scannerOptionsDict!["noOfPages"] as? Int) ?? 1
        
        //WeScan
        let isAutoScanEnabled: Bool = (scannerOptionsDict!["isAutoScanEnabled"] as? Bool) ?? false
        let isAutoScanAllowed: Bool = (scannerOptionsDict!["isAutoScanAllowed"] as? Bool) ?? false
        let isFlashAllowed: Bool = (scannerOptionsDict!["isFlashAllowed"] as? Bool) ?? false
        let isGalleryImportAllowed: Bool = (scannerOptionsDict!["isGalleryImportAllowed"] as? Bool) ?? false
        let backgroundColor: Int? = (scannerOptionsDict!["backgroundColor"] as? Int)
        let tintColor: Int? = (scannerOptionsDict!["tintColor"] as? Int)            
        
        return CunningScannerOptions(
            imageFormat: CunningScannerImageFormat(rawValue: imageFormat) ?? CunningScannerImageFormat.png,
            jpgCompressionQuality: jpgCompressionQuality,
            useWeScan: useWeScan,
            noOfPages: noOfPages,
            isGalleryImportAllowed: isGalleryImportAllowed,
            isAutoScanEnabled: isAutoScanEnabled,
            isAutoScanAllowed: isAutoScanAllowed,
            isFlashAllowed: isFlashAllowed,
            backgroundColor: backgroundColor,
            tintColor: tintColor
        )
    }
}
