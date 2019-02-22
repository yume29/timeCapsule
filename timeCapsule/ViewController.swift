//
//  ViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/14.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit
import Accounts


class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    //    リマインダーのボタン
    @IBOutlet weak var reminderBtn: UIButton!
    
    @IBOutlet weak var reminderBtnShadow: UIView!
    //    タイムカプセルのボタン
    @IBOutlet weak var timeCapsuleBtn: UIButton!
    
    @IBOutlet weak var timeCapsuleBtnShadow: UIView!
    
    //シェアボタン
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var shareBtnShadow: UIView!
    
    //スクロールビュー
    var scrollView:UIScrollView!
    
    
    //    パスワード関係
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordShadow: UIView!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var okBtnShadow: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        
        // UIScrollViewインスタンス生成
        scrollView = UIScrollView()
        
        scrollView.delegate = self
        passwordField.delegate = self
        
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
        
        //OKボタン
        okBtnShadow.layer.shadowColor = UIColor.black.cgColor
        okBtnShadow.layer.shadowOpacity = 0.5
        okBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        okBtnShadow.layer.shadowRadius = 5
        
        
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
        openBtn.layer.cornerRadius = 7
        openBtn.layer.masksToBounds = true

        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処
        scrollView.addSubview(reminderBtnShadow)
        scrollView.addSubview(timeCapsuleBtnShadow)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(okBtnShadow)
        scrollView.addSubview(shareBtnShadow)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        // ビューに追加
        self.view.addSubview(scrollView)
        //キーボードにDoneをつける
        keyBoardDone()

        
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
    
    //    Doneボタンをつけ、押すとキーボードが消える関数
    func keyBoardDone(){
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // Doneボタン。押された時に「closeKeybord」関数が呼ばれる。
        let commitButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
        self.passwordField.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }    //キーボードが表示された時に呼ばれる
    @objc func keyboardWillShow(notification: NSNotification) {
        let insertHeight:CGFloat = 250
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight + insertHeight)
        let offset = CGPoint(x: 0, y: insertHeight)
        scrollView.setContentOffset(offset, animated: true)
        print("スクリーンのサイズをキーボードの高さ分伸ばし伸ばした分動かす。")
    }
    //キーボードが閉じる時に呼ばれる
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        print("元の大きさへ")
    }
    
    //リターンキーを押した時に、
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func openCapsule(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "showFutureSegue", sender: nil)
    }
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFutureSegue" {
            let vc = segue.destination as! futureViewController
      
        }
    }
}

