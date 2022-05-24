//
//  BirthdayVC.swift
//  iStrology
//
//  Created by Admin on 11/7/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit

class BirthdayVC: UIViewController{

    @IBOutlet weak var pickerView: UIDatePicker!
    @IBOutlet weak var nextBtn: UIButton!
    
    var birthday: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.backgroundColor = .clear
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.white.cgColor
        
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        pickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        birthday = Date()
        
    }
    
    @IBAction func onNextBtn(_ sender: Any) {
        
        UserDefaults.standard.set(birthday, forKey: "birthdate")
        self.performSegue(withIdentifier: "NameVC", sender: nil)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        birthday = sender.date
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
