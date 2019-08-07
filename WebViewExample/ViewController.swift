import UIKit
import WebKit

func imageForBase64String(_ strBase64: String) -> UIImage? {
    
    do{
        let imageData = try Data(contentsOf: URL(string: strBase64)!)
        let image = UIImage(data: imageData)
        return image!
    }
    catch{
        return nil
    }
}

class ViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "example", withExtension: "html", subdirectory: "local_html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            let url = navigationAction.request.url
            if(url != nil) {
                let filenameSplits = url?.absoluteString.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: false)
                let dataSplits = filenameSplits?[1].split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
                let fileData = Data(base64Encoded: String(dataSplits?[1] ?? ""))!
                let image = UIImage(data: fileData)!
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                decisionHandler(WKNavigationActionPolicy.cancel)
                return
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

