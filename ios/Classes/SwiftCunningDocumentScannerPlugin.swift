import Flutter
import UIKit
import Vision
import VisionKit

@available(
    iOS 13.0,
    *
)
public class SwiftCunningDocumentScannerPlugin: NSObject, FlutterPlugin, VNDocumentCameraViewControllerDelegate {
    var resultChannel: FlutterResult?
    var presentingController: VNDocumentCameraViewController?
    public static var backgroundColor: UIColor =  UIColor.white;
    public static var tintColor: UIColor =  UIColor.blue;
    var scannerOptions: CunningScannerOptions = CunningScannerOptions()
    
    public static func register(
        with registrar: FlutterPluginRegistrar
    ) {
        let channel = FlutterMethodChannel(
            name: "cunning_document_scanner",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftCunningDocumentScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        scannerOptions = CunningScannerOptions.fromArguments(args: call.arguments)
        if (scannerOptions.useWeScan && scannerOptions.noOfPages == 1) {
            handleWeScan(call, result: result, options: scannerOptions)
            return
        }
        // Handle the method call
        if call.method == "getPictures" {
            scannerOptions = CunningScannerOptions
                .fromArguments(
                    args: call.arguments
                )
            let presentedVC: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            self.resultChannel = result
            if VNDocumentCameraViewController.isSupported {
                self.presentingController = VNDocumentCameraViewController()
                self.presentingController!.delegate = self
                presentedVC?
                    .present(
                        self.presentingController!,
                        animated: true
                    )
            } else {
                result(
                    FlutterError(
                        code: "UNAVAILABLE",
                        message: "Document camera is not available on this device",
                        details: nil
                    )
                )
            }
        } else {
            result(
                FlutterMethodNotImplemented
            )
            return
        }
    }  
    
    func handleWeScan(_ call: FlutterMethodCall, result: @escaping FlutterResult, options: CunningScannerOptions) {
        let args = call.arguments as! Dictionary<String, Any>
        
        if (options.backgroundColor != nil) {
            SwiftCunningDocumentScannerPlugin.backgroundColor = UIColor(
                hexa: options.backgroundColor!
            )
        }
        if (options.tintColor != nil) {
            SwiftCunningDocumentScannerPlugin.tintColor = UIColor(
                hexa: options.tintColor!
            )
        }
        if (call.method == "getPictures") {
            if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                let storyboard = UIStoryboard(
                    name: "DocumentScannerStoryboard",
                    bundle:  Bundle(
                        for: CunningDocumentScannerPlugin.self
                    )
                )
                guard let controller = storyboard.instantiateInitialViewController() as? UINavigationController else {
                    result(nil)
                    return
                } 
                (
                    controller.viewControllers.first as? ScanCameraViewController
                )?.setParams(
                    result: result,
                    isGalleryImportAllowed: options.isGalleryImportAllowed,
                    isAutoScanEnabled: options.isAutoScanEnabled,
                    isAutoScanAllowed: options.isAutoScanAllowed,
                    isFlashAllowed: options.isFlashAllowed
                )
                
                viewController.present(controller, animated: true, completion: nil)
            } else {
                result(nil)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let tempDirPath = self.getDocumentsDirectory()
        let currentDateTime = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd-HHmmss"
        let formattedDate = df.string(
            from: currentDateTime
        )
        var filenames: [String] = []
        for i in 0 ..< scan.pageCount {
            let page = scan.imageOfPage(
                at: i
            )
            let url = tempDirPath.appendingPathComponent(
                formattedDate + "-\(i).\(scannerOptions.imageFormat.rawValue)"
            )
            switch scannerOptions.imageFormat {
            case CunningScannerImageFormat.jpg:
                try? page
                    .jpegData(
                        compressionQuality: scannerOptions.jpgCompressionQuality
                    )?
                    .write(
                        to: url
                    )
                break
            case CunningScannerImageFormat.png:
                try? page
                    .pngData()?
                    .write(
                        to: url
                    )
                break
            }
            
            filenames.append(url.path)
        }
        resultChannel?(filenames)
        presentingController?.dismiss(animated: true)
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        resultChannel?(nil)
        presentingController?.dismiss(animated: true)
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        resultChannel?(
            FlutterError(
                code: "ERROR",
                message: error.localizedDescription,
                details: nil
            )
        )
        presentingController?.dismiss(animated: true)
    }
}
