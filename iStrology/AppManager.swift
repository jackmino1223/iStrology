//
//  AppManager.swift
//  Parikramas
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import Alamofire

final class AppManager {
    
    // MARK: Shared Instance
    
    static let shared: AppManager = {
        return AppManager()
    }()
    
    // Can't init is singleton
    private init() { }
    
    // MARK: Local Variable
    
    var values_1: [Double]!
    var isComingFromSettings: Bool = false
    
    func showAlert(msg: String, activity: UIViewController) -> Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        activity.present(alert, animated: true, completion: nil)
    }
    
    func setInitNotification(){
        
        let birthday: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
        print(birthday)
        
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let year: String = String(describing: componenets.year!)
        let month: String = String(describing: componenets.month!)
        let day: String = String(describing: componenets.day!)
        
        //get local time zone

        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        print(localTimeZoneAbbreviation)
        let gmtString = localTimeZoneAbbreviation.substring(to: 4)
        let timeString = localTimeZoneAbbreviation.substring(from: 4)
        let components : [String] = timeString.components(separatedBy: ":")
        var hour: String!
        var minute: String!
        
        if components.count == 1{
            if components[0].count == 1{
                hour = "0" + components[0]
            }else{
                hour = components[0]
            }
            minute = "00"
        }else{
            if components[0].count == 1{
                hour = "0" + components[0]
            }else{
                hour = components[0]
            }
            
            if components[1].count == 1{
                minute = "0" + components[1]
            }else{
                minute = components[1]
            }
        }
        
        let newTimezoneString = gmtString + hour + minute
        let newString = newTimezoneString.replacingOccurrences(of: "+", with: "plus", options: .literal, range: nil)
        let timeZone = newString.replacingOccurrences(of: "-", with: "minus", options: .literal, range: nil)
        
        let userId: String = UserDefaults.standard.string(forKey: "userId")!
        var url: String = "http://istrology.me/addTimeZone.php?notification_id=" + userId +
            "&timezone=" + timeZone +
            "&birthday=" + month + "-" + day
        
        if UserDefaults.standard.string(forKey: "notification_date") == nil{
            url = url + "&time=12:00:00"
        }
        
        Alamofire.request(url, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func checkSubscription(callback: ((Error?, Bool)->Void)!){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "37af729f1d8f427ca08650c79164d21e")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    type: .autoRenewable, // or .nonRenewing (see below)
                    productId: "com.istrology.weeklysubscription",
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, _):
                    callback(nil, true)
                    print("Product is valid until \(expiryDate)")
                case .expired(let expiryDate, _):
                    callback(nil, false)
                    print("Product is expired since \(expiryDate)")
                case .notPurchased:
                    callback(nil, false)
                    print("The user has never purchased this product")
                }
                
            case .error(let error):
                callback(error, false)
                print("Receipt verification failed: \(error)")
            }
        }
    }
}
