//
//  DateSetViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class DateSetViewController: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var closeBtnShadow: UIView!
    
    @IBOutlet weak var openDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "f9f1d3")
        
        set5YearValidation()
        
        // 影表示用のビュー
        // closeボタン用
        closeBtnShadow.layer.shadowColor = UIColor.black.cgColor
        closeBtnShadow.layer.shadowOpacity = 0.5
        closeBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        closeBtnShadow.layer.shadowRadius = 5
        
        
        //        丸角にする
        
        closeBtn.layer.cornerRadius = 10
        closeBtn.layer.masksToBounds = true
        
    }
    
    //    今日の日付を取得し、5年後までをdatepickerで指定。
    func set5YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        
        components.year = 5
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = 0
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        openDatePicker.minimumDate = minDate
        openDatePicker.maximumDate = maxDate
    }
    
    
    @IBAction func getDate(_ sender: UIDatePicker) {
        print(openDatePicker.date)
    }
    
    
    @IBAction func showPassword(_ sender: Any) {
        print("close btn pushed ")
    }
}
