//
//  passwordViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class passwordViewController: UIViewController {
    
    
    @IBOutlet weak var purupuru: UIView!
    @IBOutlet weak var capsuleImg: UIImageView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "f9f1d3")
        capsuleImg.backgroundColor = UIColor(hex: "f9f1d3")
        vibrated(vibrated: true, view: purupuru)
        let password = randomString(length: 10) // 10桁のランダムな英数字を生成
        passwordLabel.text = "このカプセルのパスワード:\(password)"
    

        
        //         影表示用のビュー
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
        shadowView.center = CGPoint(x: 375/2, y:667/2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5
        
    }
//    揺れる角度を決める処理
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(M_PI) / 180.0
    }
    
//    カプセルを揺らす処理
    func vibrated(vibrated:Bool, view: UIView) {
        if vibrated {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.15
            animation.fromValue = degreesToRadians(degrees: 3.0)
            animation.toValue = degreesToRadians(degrees: -3.0)
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            view.layer .add(animation, forKey: "VibrateAnimationKey")
        }
        else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }
    }
    
//    パスワードをランダムで生成する処理
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    @IBAction func goBackHome(_ sender: UIButton) {
    self.navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
    }
    
}
