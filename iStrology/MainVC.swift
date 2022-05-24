//
//  MainVC.swift
//  iStrology
//
//  Created by Admin on 11/8/17.
//  Copyright © 2017 Han. All rights reserved.
//

import UIKit
import CircleProgressView
import Alamofire
import MBProgressHUD

let LUCKY_NUMBER = "lucky_number"
let UNLUCKY_NUMBER = "unlucky_number"
let HEALTH_NUMBER = "health_number"
let ENERGY_NUMBER = "energy_number"
let FINANCE_NUMBER = "finance_number"
let LUCK_NUMBER = "luck_number"

class MainVC: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var luckyNumLabel: UILabel!
    @IBOutlet weak var unluckyNumLabel: UILabel!
    
    @IBOutlet weak var healthCircle: CircleProgressView!
    @IBOutlet weak var healthLabel: UILabel!
    
    @IBOutlet weak var energyCircle: CircleProgressView!
    @IBOutlet weak var energyLabel: UILabel!
    
    @IBOutlet weak var financeCircle: CircleProgressView!
    @IBOutlet weak var financeLabel: UILabel!
    
    @IBOutlet weak var luckCircle: CircleProgressView!
    @IBOutlet weak var luckLabel: UILabel!
    
    let curveColor_1 = UIColor.init(red: 195 / 255.0, green: 129 / 255.0, blue: 126 / 255.0, alpha: 1)
    let curveColor_2 = UIColor.init(red: 102 / 255.0, green: 140 / 255.0, blue: 196 / 255.0, alpha: 1)
    
    var values_1: [Double]!
    var values_2: [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: contentView.frame.size.height)
        lblText.sizeToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AppManager.shared.isComingFromSettings == true{
            return;
        }
        
        // show today's horoscope
        
        let birthday: Date = UserDefaults.standard.value(forKey: "birthdate") as! Date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        lblBirthday.text = dateFormatter.string(from: birthday)
        
        let compos = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let birth_month: String = String(describing: compos.month!)
        let birth_day: String = String(describing: compos.day!)
        
        let url: String = "http://istrology.me/getHoroscope.php?birthday=" + birth_month + "-" + birth_day
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        
        Alamofire.request(url, method:.get).responseJSON { response in
            switch response.result {
            case .success:

                let res = response.result.value as! [String: Any]
                let description = res["description"] as! [String: String]
                
                let height: CGFloat = (description["0"]?.height(withConstrainedWidth: self.contentView.frame.size.width - 22, font: UIFont.systemFont(ofSize: 17)))!
                print(self.lblText.frame.size.width)
                
                self.lblText.frame = CGRect(x: self.lblText.frame.origin.x, y: self.lblText.frame.origin.y, width: self.contentView.frame.size.width - 22, height: height)
                self.lblText.text = description["0"]
                self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height + height)
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.contentView.frame.size.height)
                self.bottomView.frame = CGRect(x: self.bottomView.frame.origin.x, y: self.bottomView.frame.origin.y + height, width: self.bottomView.frame.size.width, height: self.bottomView.frame.size.height)
                loadingNotification.hide(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
                loadingNotification.hide(animated: true)
            }
        }
        
        
        drawGraph()
        
        let todayDate: Date = Date()
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: todayDate)
        let day = componenets.day
        
        var luckyNum: Int!
        var unluckyNum: Int!
        var healthNum: Int!
        var energyNum: Int!
        var financeNum: Int!
        var luckNum: Int!
        
        if UserDefaults.standard.integer(forKey: "updatedDay") != day{
            luckyNum = random(max: 99)
            unluckyNum = random(max: 99)
            UserDefaults.standard.set(luckyNum, forKey: LUCKY_NUMBER)
            UserDefaults.standard.set(unluckyNum, forKey: UNLUCKY_NUMBER)

            healthNum = random(max: 100)
            healthNum = healthNum < 30 ? healthNum + 30 : healthNum
            UserDefaults.standard.set(healthNum, forKey: HEALTH_NUMBER)
            
            
            energyNum = random(max: 100)
            energyNum = energyNum < 30 ? energyNum + 30 : energyNum
            UserDefaults.standard.set(energyNum, forKey: ENERGY_NUMBER)
            
            financeNum = random(max: 100)
            financeNum = financeNum < 30 ? financeNum + 30 : financeNum
            UserDefaults.standard.set(financeNum, forKey: FINANCE_NUMBER)
            
            
            luckNum = random(max: 100)
            luckNum = luckNum < 30 ? luckNum + 30 : luckNum
            UserDefaults.standard.set(luckNum, forKey: LUCK_NUMBER)
            
        }else{
            luckyNum = UserDefaults.standard.integer(forKey: LUCKY_NUMBER)
            unluckyNum = UserDefaults.standard.integer(forKey: UNLUCKY_NUMBER)
            
            healthNum = UserDefaults.standard.integer(forKey: HEALTH_NUMBER)
            energyNum = UserDefaults.standard.integer(forKey: ENERGY_NUMBER)
            financeNum = UserDefaults.standard.integer(forKey: FINANCE_NUMBER)
            luckNum = UserDefaults.standard.integer(forKey: LUCK_NUMBER)
        }
        
        luckyNumLabel.text = String(luckyNum < 11 ? luckyNum + 11 : luckyNum)
        unluckyNumLabel.text = String(unluckyNum < 11 ? unluckyNum + 11 : unluckyNum)
        
        healthLabel.text = String(healthNum) + "%"
        healthCircle.progress = Double(healthNum) / 100.0
        
        energyLabel.text = String(energyNum) + "%"
        energyCircle.progress = Double(energyNum) / 100.0
        
        financeLabel.text = String(financeNum) + "%"
        financeCircle.progress = Double(financeNum) / 100.0
        
        luckLabel.text = String(luckNum) + "%"
        luckCircle.progress = Double(luckNum) / 100.0
        
        UserDefaults.standard.set(day, forKey: "updatedDay")
        
    }

    func drawGraph(){
        let todayDate: Date = Date()
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: todayDate)
        let day = componenets.day
        
        self.chartView.layer.masksToBounds = true;
        self.chartView.layer.cornerRadius = 3.0;
        self.chartView.backgroundColor = UIColor.clear
        
        var values_1: [Double]!
        var values_2: [Double]!
        
        if UserDefaults.standard.integer(forKey: "updatedDay") != day{
            values_2 = [Double(random(max: 100)), Double(random(max: 100)), Double(random(max: 100))]
            values_1 = AppManager.shared.values_1
            
            UserDefaults.standard.set(values_1, forKey: "chart1_values")
            UserDefaults.standard.set(values_2, forKey: "chart2_values")
        }else{
            values_1 = UserDefaults.standard.value(forKey: "chart1_values") as! [Double]
            values_2 = UserDefaults.standard.value(forKey: "chart2_values") as! [Double]
        }
        
        let chart_1 = JTChartView.init(frame: chartView.bounds, values: values_1, curve: curveColor_1, curveWidth: 10, topGradientColor: UIColor.clear, bottomGradientColor: UIColor.clear, minY: 0.6, maxY: 1, topPadding: 40)
        let chart_2 = JTChartView.init(frame: chartView.bounds, values: values_2, curve: curveColor_2, curveWidth: 10, topGradientColor: UIColor.clear, bottomGradientColor: UIColor.clear, minY: 0.6, maxY: 1, topPadding: 40)
        
        chartView.addSubview(chart_1!)
        chartView.addSubview(chart_2!)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func random(max maxNumber: Int) -> Int {
        srandom(UInt32(time(nil)))
        return Int(arc4random_uniform(UInt32(100)))
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    @IBAction func onSettingsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingVC")
        self.present(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
