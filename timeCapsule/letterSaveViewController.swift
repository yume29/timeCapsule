//
//  letterSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class letterSaveViewController: UIViewController {
    
    
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var explainField: UITextView!
    
    @IBOutlet weak var letterField: UITextView!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var okBtnShadow: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "f9f1d3")
        letterField.backgroundColor = UIColor.white
        explainField.backgroundColor = UIColor(hex: "f9f1d3")
        
        //FCEFB7
        
        //         影表示用のビュー

        okBtnShadow.layer.shadowColor = UIColor.black.cgColor
        okBtnShadow.layer.shadowOpacity = 0.5
        okBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        okBtnShadow.layer.shadowRadius = 5
    
        //丸角にする
        
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
        letterField.layer.cornerRadius = 10
        letterField.layer.masksToBounds = true
        
        //キーボードにDoneをつける
        keyBoardDone()
        
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
        self.letterField.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
    
    @IBAction func showDateSet(_ sender: Any) {
        print("okPush")
    }
    
}
