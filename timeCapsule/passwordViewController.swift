//
//  passwordViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class passwordViewController: UIViewController , UIScrollViewDelegate{
    
    
    @IBOutlet weak var purupuru: UIView!
    @IBOutlet weak var capsuleImg: UIImageView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var explainView: UITextView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var homeBtn: UIButton!
    
    var selectedDate:String!
    var password:String!
    var scrollView:UIScrollView!
    
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self

        view.backgroundColor = UIColor(hex: "f9f1d3")
        capsuleImg.backgroundColor = UIColor(hex: "f9f1d3")
        vibrated(vibrated: true, view: purupuru)

        passwordLabel.text = "Password:\(password!)"
        explainView.backgroundColor = UIColor(hex: "f9f1d3")
        explainView.text = "カプセルを閉じました。\n\(selectedDate!)まで\nこのカプセルは開封できません。\n開封の際に下記のパスワードが必要です。\nアプリは消してもカプセルは保存されます。\nパスワードの再発行はできかねますので、\nスクリーンショットだけでなく、\n紙媒体での保存をおすすめします。"
    

        
        //         影表示用のビュー
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
        shadowView.center = CGPoint(x: 375/2, y:667/2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5
        
        
        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処
        scrollView.addSubview(completeLabel)
        scrollView.addSubview(purupuru)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(homeBtn)
        scrollView.addSubview(explainView)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        // ビューに追加
        self.view.addSubview(scrollView)
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
    
    @IBAction func goBackHome(_ sender: UIButton) {
    self.navigationController?.popToViewController((navigationController?.viewControllers[0])!, animated: true)
    }
    
}
