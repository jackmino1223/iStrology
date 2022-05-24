//
//  NameVC.swift
//  iStrology
//
//  Created by Admin on 11/7/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit

class NameVC: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nameEditText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.backgroundColor = .clear
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func onNextBtn(_ sender: Any) {
        
        if (nameEditText.text == ""){
            alertWithTitle("", message: " enter your name.")
        }else{
            UserDefaults.standard.set(nameEditText.text, forKey: "name")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nc: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nc
            
            if UserDefaults.standard.value(forKey: "birthdate") != nil && UserDefaults.standard.value(forKey: "userId") != nil{
                AppManager.shared.setInitNotification()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NameVC {
    
    func alertWithTitle(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
