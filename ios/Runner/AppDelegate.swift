import UIKit
import Flutter
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // WebView ko retain karne ke liye global variable
    var webView: WKWebView?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.app/word_to_pdf", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "convertWordToPdf" {
                let args = call.arguments as! [String: Any]
                let inputPath = args["inputPath"] as! String
                let outputPath = args["outputPath"] as! String
                
                // Main thread par run karna zaroori hai
                DispatchQueue.main.async {
                    self?.convertWordToPdf(input: inputPath, output: outputPath, completion: { path in
                        result(path)
                    })
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func convertWordToPdf(input: String, output: String, completion: @escaping (String?) -> Void) {
        let url = URL(fileURLWithPath: input)
        
        // Configuration ke saath webview create karein
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        
        // Isay hidden rakh kar view mein add karna crash se bachata hai
        self.webView?.isHidden = true
        self.window?.addSubview(self.webView!)
        
        self.webView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        
        // Word files load hone mein thora waqt leti hain
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if let data = self.webView?.createPDFData() {
                do {
                    try data.write(to: URL(fileURLWithPath: output))
                    // Cleanup
                    self.webView?.removeFromSuperview()
                    self.webView = nil
                    completion(output)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
}

extension WKWebView {
    func createPDFData() -> Data? {
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(self.viewPrintFormatter(), startingAtPageAt: 0)
        
        // A4 Page size
        let paperRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        renderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: paperRect), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, paperRect, nil)
        
        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at: i, in: paperRect)
        }
        
        UIGraphicsEndPDFContext()
        return pdfData as Data
    }
}
