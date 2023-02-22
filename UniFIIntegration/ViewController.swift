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
        guard let baseUrl = URL(string: "https://omni-apply.app.qa.pcf.syfbank.com/omniApply/application-link")
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
                "emailAddress":"penumatsa.anjaneyavarma@syf.com",
                "saleAmount":"850",
                "initialPurchaseAmount":850
            ],
            "merchantInfo":[
                "associateId": "N123456",
                "merchantName": "SYF ZETAIL Merchant",
                "productName":"ZETAIL VISA Rewards Card",
                "channelId":"BC",
                "productCodeGroupCode":"A600",
                "merchantId":"5348120820046126",
                "storeMid":"5348120820030393",
                "partnerId":"PI1000011702"
            ],
            "strategyInfo":[
                "viaCode":"H"
            ],
            "deliveryMethod":"EMAIL_AND_MERCHANT",
            "d2dUrl":"https://qpdpone.syfpos.com/mppcore/d2d",
            "applicationType":"MPP"
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
        guard let url = URL(string: "https://qpdpone.syfpos.com/mppcore/d2d/XNceLw7g")
        else{
            return
        }
        print("Hello world")

//        let jsonObject = "  {syfPartnerId:\"PI53421676\",tokenId:\"185df7a6fefPI5342167627741\",encryptKey:\"\",modalType:\"\",childMid:\"\",childPcgc:\"\",childTransType:\"\",pcgc:\"\",partnerCode:\"\",clientToken:\"\",postbackid:\"d979e5b7-6382-4e4e-b269-aab027bbed58\",clientTransId:\"\",cardNumber:\"\",custFirstName:\"\",custLastName:\"\",expMonth:\"\",expYear:\"\",custZipCode:\"\",custAddress1:\"\",phoneNumb:\"\",appartment:\"\",emailAddr:\"\",custCity:\"\",upeProgramName:\"\",custState:\"\",transPromo1:\"\",iniPurAmt:\"\",mid:\"\",productCategoryNames:\"\",transAmount1:\"700\",transAmounts:\"\",initialAmount:\"\",envUrl:\"https://dpdpone.syfpos.com/mitservice/\",productAttributes:\"\",processInd:\"3\"};"

        let jsonDictionary: [String: Any] = ["partnerId":"P153421676", "amount":"1300", "pcgc":"GR10"]

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

