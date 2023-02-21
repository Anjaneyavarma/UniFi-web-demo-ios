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
//        webView.evaluateJavaScript("loadJsonData('\(jsonData)')") { (result, error) in
//            dump(error)
//            print(result)
//        }
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
