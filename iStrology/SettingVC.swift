//
//  SettingVC.swift
//  iStrology
//
//  Created by Admin on 11/8/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import SwiftyStoreKit
import MBProgressHUD

class SettingVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var notificationDatePicker: UIDatePicker!
    
    let birthday: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        notificationDatePicker.addTarget(self, action: #selector(notificationDateChanged(_:)), for: .valueChanged)
        notificationDatePicker.locale = NSLocale(localeIdentifier: "da_DK") as Locale

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let birthdate: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        birthdateTextField.text = dateFormatter.string(from: birthdate)
        nameTextField.text = UserDefaults.standard.value(forKey: "name") as? String

        restoreBtn.backgroundColor = .clear
        restoreBtn.layer.cornerRadius = 10
        restoreBtn.layer.borderWidth = 1
        restoreBtn.layer.borderColor = UIColor.white.cgColor
        
        dismissBtn.backgroundColor = .clear
        dismissBtn.layer.cornerRadius = 10
        dismissBtn.layer.borderWidth = 1
        dismissBtn.layer.borderColor = UIColor.white.cgColor
        
        birthdateTextField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdateTextField{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            textField.inputView = datePicker
        }
        return true
    }
    
    @objc func notificationDateChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        UserDefaults.standard.setValue(dateFormatter.string(from: sender.date), forKey: "notification_date")
        print(dateFormatter.string(from: sender.date))

        let url = "http://istrology.me/addTimeZone.php?notification_id=" + UserDefaults.standard.string(forKey: "userId")! +
            "&time=" + dateFormatter.string(from: sender.date)
        
        Alamofire.request(url, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        UserDefaults.standard.setValue(sender.date, forKey: "birthdate")
        UserDefaults.standard.set(-1, forKey: "updatedDay")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        birthdateTextField.text = dateFormatter.string(from: sender.date)
        
        let birthday: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
        
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let year: String = String(describing: componenets.year!)
        let month: String = String(describing: componenets.month!)
        let day: String = String(describing: componenets.day!)
        
        let userId: String = UserDefaults.standard.string(forKey: "userId")!
        
        let url = "http://istrology.me/addTimeZone.php?notification_id=" + userId + "&birthday=" + month + "-" + day
        
        Alamofire.request(url, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        let nameTextField: UITextField = sender as! UITextField
        UserDefaults.standard.set(nameTextField.text, forKey: "name")
    }
    
    @IBAction func onRestoreBtn(_ sender: Any) {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Restoring..."
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            else {
                print("Nothing to Restore")
            }
            
            loadingNotification.hide(animated: true)
            self.showAlert(self.alertForRestorePurchases(results))
            
        }
    }
    
    @IBAction func onDismissBtn(_ sender: Any) {
        AppManager.shared.isComingFromSettings = true
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingVC {
    
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
        return nil
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
