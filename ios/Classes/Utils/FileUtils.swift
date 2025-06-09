//
//  FolderUtils.swift
//  cunning_document_scanner
//
//  Created by Romain Boucher on 18/04/2024.
//

import Foundation
import WeScan

class FileUtils{
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func saveImage(image: UIImage, imageFormat: CunningScannerImageFormat, jpgCompressionQuality: Double) -> String? {
        if imageFormat == .jpg {
            return saveJpgImage(image: image, jpgCompressionQuality: jpgCompressionQuality)
        } else {
            return savePngImage(image: image)
        }        
    }

    static func saveJpgImage(image: UIImage, jpgCompressionQuality: Double) -> String? {
        guard let data = image.jpegData(compressionQuality: CGFloat(jpgCompressionQuality)) else {
            return nil
        }
        
        let tempDirPath = getDocumentsDirectory()
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        let formattedDate = df.string(from: currentDateTime)
        let filePath = tempDirPath.appendingPathComponent(formattedDate + ".jpg")
        
        do {
            try data.write(to: filePath)
            return filePath.path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func savePngImage(image: UIImage) -> String? {
        guard let data = image.pngData() else {
            return nil
        }

        let tempDirPath = getDocumentsDirectory()
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        let formattedDate = df.string(from: currentDateTime)
        let filePath = tempDirPath.appendingPathComponent(formattedDate + ".png")

        do {
            try data.write(to: filePath)
            return filePath.path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
