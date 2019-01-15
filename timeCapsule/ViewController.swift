//
//  ViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/14.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit
import Accounts


class ViewController: UIViewController {
    
//    リマインダーのボタン
    @IBOutlet weak var reminderBtn: UIButton!
    
    @IBOutlet weak var reminderBtnShadow: UIView!
    //    タイムカプセルのボタン
    @IBOutlet weak var timeCapsuleBtn: UIButton!
    
    @IBOutlet weak var timeCapsuleBtnShadow: UIView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var shareBtnShadow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = UIColor(hex: "f9f1d3")
    
//FCEFB7
        
//         影表示用のビュー
        //REMINDERボタン
        reminderBtnShadow.layer.shadowColor = UIColor.black.cgColor
        reminderBtnShadow.layer.shadowOpacity = 0.5
        reminderBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        reminderBtnShadow.layer.shadowRadius = 5
        //タイムカプセルボタン
        timeCapsuleBtnShadow.layer.shadowColor = UIColor.black.cgColor
        timeCapsuleBtnShadow.layer.shadowOpacity = 0.5
        timeCapsuleBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        timeCapsuleBtnShadow.layer.shadowRadius = 5
        //シェアボタン
        shareBtnShadow.layer.shadowColor = UIColor.black.cgColor
        shareBtnShadow.layer.shadowOpacity = 0.5
        shareBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        shareBtnShadow.layer.shadowRadius = 5

//        リマインダーボタン画像
        reminderBtn.setBackgroundImage(UIImage(named: "reminder btn.png"), for: .normal)
//        丸角にする
        
            reminderBtn.layer.cornerRadius = 10
            reminderBtn.layer.masksToBounds = true
        
//        タイムカプセルボタン画像
        timeCapsuleBtn.setBackgroundImage(UIImage(named: "time capsule btn.jpg"), for: .normal)
//        丸角にする
           timeCapsuleBtn.layer.cornerRadius = 10
           timeCapsuleBtn.layer.masksToBounds = true


    }

//　シェアボタンのメゾット
    @IBAction func tapShare(_ sender: UIButton) {
        // 共有する項目
        let shareText = "Apple - Time Capsule"
        let shareImage = UIImage(named: "Time capsule.png")!
        
        let activityItems = [shareText, shareImage] as [Any]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
}

