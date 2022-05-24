//
//  HoroscopeVC.swift
//  iStrology
//
//  Created by Admin on 11/7/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import OneSignal
import SwiftyStoreKit
import MBProgressHUD

class HoroscopeVC: UIViewController {
    
    @IBOutlet weak var imgShape: UIImageView!
    @IBOutlet weak var lblHoroscope: UILabel!
    
    var capricornStartDate_1: Date!
    var capricornEndDate_1: Date!
    
    var capricornStartDate_2: Date!
    var capricornEndDate_2: Date!
    
    var aquariusStartDate: Date!
    var aquariusEndDate: Date!
    
    var piscesStartDate: Date!
    var piscesEndDate: Date!
    
    var ariesStartDate: Date!
    var ariesEndDate: Date!
    
    var taurusStartDate: Date!
    var taurusEndDate: Date!
    
    var geminiStartDate: Date!
    var geminiEndDate: Date!
    
    var cancerStartDate: Date!
    var cancerEndDate: Date!
    
    var leoStartDate: Date!
    var leoEndDate: Date!
    
    var virgoStartDate: Date!
    var virgoEndDate: Date!
    
    var libraStartDate: Date!
    var libraEndDate: Date!
    
    var scorpioStartDate: Date!
    var scorpioEndDate: Date!
    
    var sagittariusStartDate: Date!
    var sagittariusEndDate: Date!
    
    var birthday: Date!
    var name: String!
    var isPurchased: Bool!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppManager.shared.values_1 = [Double(random(max: 100)), Double(random(max: 100)), Double(random(max: 100)), Double(random(max: 100))]
        print(UserDefaults.standard.value(forKey: "userId") as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        
        AppManager.shared.checkSubscription(callback: { (error, success) in
            if error == nil && success == true{
                
                let birthdate: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                
                self.isPurchased = true
                self.nextButton.backgroundColor = .clear
                self.nextButton.layer.cornerRadius = 5
                self.nextButton.layer.borderWidth = 1
                self.nextButton.layer.borderColor = UIColor.white.cgColor
                self.nextButton.setTitle(dateFormatter.string(from: birthdate), for: .normal)
                self.nextButton.setTitleColor(UIColor.white, for: .normal)
            }
            if error == nil && success == false{
                self.isPurchased = false
                self.nextButton.backgroundColor = .clear
                self.nextButton.layer.cornerRadius = 5
                self.nextButton.layer.borderWidth = 1
                self.nextButton.layer.borderColor = UIColor.init(red: 118 / 255.0, green: 184 / 255.0, blue: 98 / 255.0, alpha: 1).cgColor
                self.nextButton.setTitle("Try For Free", for: .normal)
                self.nextButton.setTitleColor(UIColor.init(red: 118 / 255.0, green: 184 / 255.0, blue: 98 / 255.0, alpha: 1), for: .normal)
            }
            if error != nil && success == false{
                AppManager.shared.showAlert(msg: (error?.localizedDescription)!, activity: self)
                
                self.isPurchased = false
                self.nextButton.backgroundColor = .clear
                self.nextButton.layer.cornerRadius = 5
                self.nextButton.layer.borderWidth = 1
                self.nextButton.layer.borderColor = UIColor.init(red: 118 / 255.0, green: 184 / 255.0, blue: 98 / 255.0, alpha: 1).cgColor
                self.nextButton.setTitle("Try For Free", for: .normal)
                self.nextButton.setTitleColor(UIColor.init(red: 118 / 255.0, green: 184 / 255.0, blue: 98 / 255.0, alpha: 1), for: .normal)
            }
            loadingNotification.hide(animated: true)
        })
        
        
        birthday = UserDefaults.standard.value(forKey: "birthdate") as! Date
        name = UserDefaults.standard.value(forKey: "name") as! String
        print(birthday)
        
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let year: String = String(describing: componenets.year!)
        let month: String = String(describing: componenets.month!)
        let day: String = String(describing: componenets.day!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        capricornStartDate_1 = dateFormatter.date(from: year + "-01-01T12:00:00")
        capricornEndDate_1 = dateFormatter.date(from: year + "-01-19T23:59:59")
        
        capricornStartDate_2 = dateFormatter.date(from: year + "-12-22T12:00:00")
        capricornEndDate_2 = dateFormatter.date(from: year + "-12-31T23:59:59")
        
        aquariusStartDate = dateFormatter.date(from: year + "-01-20T12:00:00")
        aquariusEndDate = dateFormatter.date(from: year + "-02-18T23:59:59")
        
        piscesStartDate = dateFormatter.date(from: year + "-02-19T12:00:00")
        piscesEndDate = dateFormatter.date(from: year + "-03-20T23:59:59")
        
        ariesStartDate = dateFormatter.date(from: year + "-03-21T12:00:00")
        ariesEndDate = dateFormatter.date(from: year + "-04-19T23:59:59")
        
        taurusStartDate = dateFormatter.date(from: year + "-04-20T12:00:00")
        taurusEndDate = dateFormatter.date(from: year + "-05-20T23:59:59")
        
        geminiStartDate = dateFormatter.date(from: year + "-05-21T12:00:00")
        geminiEndDate = dateFormatter.date(from: year + "-06-20T23:59:59")
        
        cancerStartDate = dateFormatter.date(from: year + "-06-21T12:00:00")
        cancerEndDate = dateFormatter.date(from: year + "-06-22T23:59:59")
        
        leoStartDate = dateFormatter.date(from: year + "-07-23T12:00:00")
        leoEndDate = dateFormatter.date(from: year + "-08-22T23:59:59")
        
        virgoStartDate = dateFormatter.date(from: year + "-08-23T12:00:00")
        virgoEndDate = dateFormatter.date(from: year + "-09-22T23:59:59")
        
        libraStartDate = dateFormatter.date(from: year + "-09-23T12:00:00")
        libraEndDate = dateFormatter.date(from: year + "-10-22T23:59:59")
        
        scorpioStartDate = dateFormatter.date(from: year + "-10-23T12:00:00")
        scorpioEndDate = dateFormatter.date(from: year + "-11-21T23:59:59")
        print(scorpioStartDate)
        print(scorpioEndDate)
        
        sagittariusStartDate = dateFormatter.date(from: year + "-11-22T12:00:00")
        sagittariusEndDate = dateFormatter.date(from: year + "-12-21T23:59:59")
        
        if (birthday >= capricornStartDate_1 && birthday <= capricornEndDate_1) || (birthday >= capricornStartDate_2 && birthday <= capricornEndDate_2){
            imgShape.image = UIImage(named: "Capricorn_white")
            lblHoroscope.text = "Capricorn, " + name
        }
        if birthday >= aquariusStartDate && birthday <= aquariusEndDate{
            imgShape.image = UIImage(named: "Aquarius_white")
            lblHoroscope.text = "Aquarius, " + name
        }
        if birthday >= piscesStartDate && birthday <= piscesEndDate{
            imgShape.image = UIImage(named: "Pisces_white")
            lblHoroscope.text = "Pisces, " + name
        }
        if birthday >= ariesStartDate && birthday <= ariesEndDate{
            imgShape.image = UIImage(named: "Aries_white")
            lblHoroscope.text = "Aries, " + name
        }
        if birthday >= taurusStartDate && birthday <= taurusEndDate{
            imgShape.image = UIImage(named: "Taurus_white")
            lblHoroscope.text = "Taurus, " + name
        }
        if birthday >= geminiStartDate && birthday <= geminiEndDate{
            imgShape.image = UIImage(named: "Gemini_white")
            lblHoroscope.text = "Gemini, " + name
        }
        if birthday >= cancerStartDate && birthday <= cancerEndDate{
            imgShape.image = UIImage(named: "Cancer_white")
            lblHoroscope.text = "Cancer, " + name
        }
        if birthday >= leoStartDate && birthday <= leoEndDate{
            imgShape.image = UIImage(named: "Leo_white")
            lblHoroscope.text = "Leo, " + name
        }
        if birthday >= virgoStartDate && birthday <= virgoEndDate{
            imgShape.image = UIImage(named: "Virgo_white")
            lblHoroscope.text = "Virgo, " + name
        }
        if birthday >= libraStartDate && birthday <= libraEndDate{
            imgShape.image = UIImage(named: "Libra_white")
            lblHoroscope.text = "Libra, " + name
        }
        if birthday >= scorpioStartDate && birthday <= scorpioEndDate{
            imgShape.image = UIImage(named: "Scorpio_white")
            lblHoroscope.text = "Scorpio, " + name
        }
        if birthday >= sagittariusStartDate && birthday <= sagittariusEndDate{
            imgShape.image = UIImage(named: "Sagittarius_white")
            lblHoroscope.text = "Sagittarius, " + name
        }
        
    }
    
    @IBAction func onSettingBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onNextBtn(_ sender: Any) {
        isPurchased = true
        if isPurchased == true{
            self.performSegue(withIdentifier: "MainSegue", sender: nil)
        }else{
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Subscribing..."
            
            SwiftyStoreKit.retrieveProductsInfo(["com.istrology.weeklysubscription"]) { result in
                
                if let product = result.retrievedProducts.first {
                    
                    SwiftyStoreKit.purchaseProduct(product, atomically: true) { result in
                        loadingNotification.hide(animated: true)
                        if case .success(let purchase) = result {
                            // Deliver content from server, then:
                            if purchase.needsFinishTransaction {
                                SwiftyStoreKit.finishTransaction(purchase.transaction)
                            }
                            self.performSegue(withIdentifier: "MainSegue", sender: nil)
                        }
                        if let alert = self.alertForPurchaseResult(result) {
                            self.showAlert(alert)
                        }
                    }
                }else{
                    loadingNotification.hide(animated: true)
                    self.showAlert(self.alertForProductRetrievalInfo(result))
                }
            }
        }
        
    }
    
    func random(max maxNumber: Int) -> Int {
        srandom(UInt32(time(nil)))
        return Int(arc4random_uniform(UInt32(100)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HoroscopeVC {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return alertWithTitle("Thank You", message: "Purchase completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            case .privacyAcknowledgementRequired:
                break
            case .unauthorizedRequestData:
                break
            case .invalidOfferIdentifier:
                break
            case .invalidSignature:
                break
            case .missingOfferParams:
                break
            case .invalidOfferPrice:
                break
            case .overlayCancelled:
                break
            case .overlayInvalidConfiguration:
                break
            case .overlayTimeout:
                break
            case .ineligibleForOffer:
                break
            case .unsupportedPlatform:
                break
            case .overlayPresentedInBackgroundScene:
                break
            }
        }
        return nil;
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscription(_ result: VerifySubscriptionResult) -> UIAlertController {
        
        switch result {
        case .purchased(let expiryDate):
            print("Product is valid until \(expiryDate)")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate):
            print("Product is expired since \(expiryDate)")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult) -> UIAlertController {
        
        switch result {
        case .purchased:
            print("Product is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
