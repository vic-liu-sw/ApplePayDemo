//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by vic_liu on 2019/5/16.
//  Copyright © 2019 ios-class. All rights reserved.
//

import UIKit
import PassKit
import AddressBook

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    @IBOutlet var payActionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func payAction(_ sender: Any) {
        //訂單請求對象
        let request = PKPaymentRequest()
        //商品訂單訊息對象
        let item1 = PKPaymentSummaryItem(label: "BMW車一輛", amount: NSDecimalNumber(string: "100"))
        let item2 = PKPaymentSummaryItem(label: "真皮座椅一只", amount: NSDecimalNumber(string: "200"))
        let item3 = PKPaymentSummaryItem(label: "自動雨刷兩只", amount: NSDecimalNumber(string: "50"))
        request.paymentSummaryItems = [item1, item2, item3]

        //指定國家地區代碼
        request.countryCode = "TW"
        //指定國家貨幣種類--新台幣
        request.currencyCode = "TWD"
        //指定支持的网上银行支付方式
        request.supportedNetworks = [
            .visa,
            .chinaUnionPay,
            .masterCard
        ]

        //指定APP需要的商業ID
        request.merchantIdentifier = "merchant.com.ios-class.applepay.ApplePayDemo"
        //指定支付的範圍限制
        request.merchantCapabilities = .capabilityEMV
        //指定訂單接受的地址是哪裡
      //  request.requiredBillingContactFields = [.name, .postalAddress]
        //支付界面顯示對象
        let pvc = PKPaymentAuthorizationViewController(paymentRequest: request)
        pvc?.delegate = self

        if pvc == nil {
            print("出問題了，請注意檢查,創建支付顯示界面不成功")
        } else {
            if let pvc = pvc {
                present(pvc, animated: true)
            }
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        /*
        var error: Error?
        var addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty)
        var addressDictionary = ABMultiValueCopyValueAtIndex(addressMultiValue as ABMultiValue?, 0) as? [AnyHashable : Any]
        //这里模拟取出地址里的每一个信息。
        print("\(String(describing: addressDictionary?["State"]))")
        var json: Data? = nil
        do {
            if let addressDictionary = addressDictionary {
                json = try JSONSerialization.data(withJSONObject: addressDictionary, options: .prettyPrinted)
            }
        } catch {
            print(error)
        }
        // 这里需要将Token和地址信息发送到自己的服务器上，进行订单处理，处理之后，根据自己的服务器返回的结果调用completion()代码块，根据传进去的参数界面的显示结果会不同
        var status: PKPaymentAuthorizationResult? // From your server
        guard let newStatus = status  else { print(error as Any) }
        completion(newStatus)
        */

        //拿到token，
        let token: PKPaymentToken = payment.token
        //拿到訂單地址
        let city = payment.billingContact?.postalAddress?.city
        print("city:\(city ?? "")")
        ///在这里将token和地址发送到自己的服务器，有自己的服务器与银行和商家进行接口调用和支付将结果返回到这里
        //我们根据结果生成对应的状态对象，根据状态对象显示不同的支付结构
        //状态对象

        // Let the Operating System know that the payment was accepted successfully
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

