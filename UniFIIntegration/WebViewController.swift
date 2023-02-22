//
//  WebViewController.swift
//  UniFIIntegration
//
//  Created by Penumatsa Anjaneya varma on 15/02/23.
//

import Foundation
import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler{
    
    private let url: URL
    private let jsonData: String
    
//    private let scriptSource = "var jsonObj =  {syfPartnerId:\"PI53421676\",tokenId:\"185df7a6fefPI5342167627741\",encryptKey:\"\",modalType:\"\",childMid:\"\",childPcgc:\"\",childTransType:\"\",pcgc:\"\",partnerCode:\"\",clientToken:\"\",postbackid:\"d979e5b7-6382-4e4e-b269-aab027bbed58\",clientTransId:\"\",cardNumber:\"\",custFirstName:\"\",custLastName:\"\",expMonth:\"\",expYear:\"\",custZipCode:\"\",custAddress1:\"\",phoneNumb:\"\",appartment:\"\",emailAddr:\"\",custCity:\"\",upeProgramName:\"\",custState:\"\",transPromo1:\"\",iniPurAmt:\"\",mid:\"\",productCategoryNames:\"\",transAmount1:\"700\",transAmounts:\"\",initialAmount:\"\",envUrl:\"https://dpdpone.syfpos.com/mitservice/\",productAttributes:\"\",processInd:\"3\"};"
    
//    lazy var jsonData: String = createJson(data: scriptSource)
    
    init(url: URL, title: String, jsonData: String) {
        self.url = url
        self.jsonData = jsonData
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        var jsonObject = jsonData
        
        let contentController = WKUserContentController()
        let script = WKUserScript(source: jsonObject, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        let configuration = WKWebViewConfiguration();
        configuration.defaultWebpagePreferences = preferences
        configuration.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: configuration);
        return webView
        
    }()
    
    private func createJson(data: String) -> String{
        let jsonString: String = data
        print("print jsonString from the createJson === \(jsonString)")
        return jsonString
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("jsonData from the webview === \(jsonData)")
        webView.evaluateJavaScript("loadJsonData('\(jsonData)')") { (result, error) in
            dump(error)
            print(result)
        }
    }
                        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        let myRequest = URLRequest(url: url)
        webView.navigationDelegate = self
        
        webView.load(myRequest)
        
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
    }
    
    @objc private func didTapDone() {
        webView.evaluateJavaScript("onCloseModal()")
        dismiss(animated: true, completion: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("user sent an message====\(message.body)")
    }
}
