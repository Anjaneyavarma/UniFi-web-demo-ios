//
//  ViewController.swift
//  UniFIIntegration
//
//  Created by Penumatsa Anjaneya varma on 15/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton();
        button.backgroundColor = .white;
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    func makeD2DApiCall(){
        guard let baseUrl = URL(string: "**")
        else{
            return
        }
        
        print("navigation to POST call")
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "waterfallFinance":"N",
            "applicantInfo":[
                "emailAddress":"**",
                "saleAmount":"850",
                "initialPurchaseAmount":850
            ],
            "merchantInfo":[
                "associateId": "N123456",
                "merchantName": "SYF ZETAIL Merchant",
                "productName":"ZETAIL VISA Rewards Card",
                "channelId":"BC",
                "productCodeGroupCode":"A600",
                "merchantId":"**",
                "storeMid":"**",
                "partnerId":"**"
            ],
            "strategyInfo":[
                "viaCode":"H"
            ],
            "deliveryMethod":"EMAIL_AND_MERCHANT",
            "d2dUrl":"**",
            "applicationType":"**"
        ]
        print("body ==== \(body)")
        let requestBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        print("requestBody ==== \(requestBody)")
        
        let jsonString = String(data: requestBody, encoding: String.Encoding.ascii)
        print("jsonString ==== \(jsonString!)")
        
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("Success ===== \(response)")
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        button.frame = CGRect(x: 20,
                              y: view.frame.height-100-view.safeAreaInsets.bottom,
                              width: view.frame.size.width-40,
                              height: 50)
    }
    
    @objc func tapWebView(){
        guard let url = URL(string: "**")
        else{
            return
        }
        print("Hello world")

        let jsonDictionary: [String: Any] = ["partnerId":"**", "amount":"1300", "pcgc":"GR10"]

        let json = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: [])

        let jsonString = String(data:json, encoding: String.Encoding.ascii)
        print(jsonString!)
        
//        makeD2DApiCall()
        
        let wvc = WebViewController(url: url, title: "Synchrony Checkout Page", jsonData: jsonString!)
        let navc = UINavigationController(rootViewController: wvc)
        present(navc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapWebView ), for: .touchUpInside)
    }


}

