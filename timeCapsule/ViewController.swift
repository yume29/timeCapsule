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
    
//    タイムカプセルのボタン
    @IBOutlet weak var timeCapsuleBtn: UIButton!
    
    
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = UIColor(hex: "f9f1d3")
    
//FCEFB7
        
//         影表示用のビュー
            let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
            shadowView.center = CGPoint(x: 375/2, y:667/2)
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOpacity = 0.5
            shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
            shadowView.layer.shadowRadius = 5

//        リマインダーボタン画像
        reminderBtn.setBackgroundImage(UIImage(named: "reminder btn.png"), for: .normal)
//        丸角にする
        
            reminderBtn.layer.cornerRadius = 10
            reminderBtn.layer.masksToBounds = true
        
//          影表示用のビューに画像ボタンを乗せる
            shadowView.addSubview(reminderBtn)
        
//           影表示+画像ボタンのビューを乗せる
            view.addSubview(shadowView)



//        タイムカプセルボタン画像
        timeCapsuleBtn.setBackgroundImage(UIImage(named: "time capsule btn.jpg"), for: .normal)
//        丸角にする
           timeCapsuleBtn.layer.cornerRadius = 10
           timeCapsuleBtn.layer.masksToBounds = true
        
//          影表示用のビューに画像ボタンを乗せる
          shadowView.addSubview(timeCapsuleBtn)
        
//           影表示+画像ボタンのビューを乗せる
          view.addSubview(shadowView)
        
//        シェアボタン
//          影表示用のビューに画像ボタンを乗せる
        shadowView.addSubview(shareBtn)
//           影表示+画像ボタンのビューを乗せる
        view.addSubview(shadowView)
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

