//
//  letterSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class letterSaveViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate{
    
    
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var explainField: UITextView!
    
    @IBOutlet weak var letterField: UITextView!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var okBtnShadow: UIView!
    
    @IBOutlet weak var commentNumLabel: UILabel!
    
    var willSavePic:[UIImage] = []
    var willSaveVoice:[String] = []
    var willSaveVideo:[URL] = []
    var scrollView:UIScrollView!
    
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()

        scrollView.delegate = self
        letterField.delegate = self
        
        

        view.backgroundColor = UIColor(hex: "f9f1d3")
        letterField.backgroundColor = UIColor.white
        explainField.backgroundColor = UIColor(hex: "f9f1d3")
        

        
        letterField.delegate = self
        
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
        
        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処
        scrollView.addSubview(stepLabel)
        scrollView.addSubview(commentNumLabel)
        scrollView.addSubview(explainField)
        scrollView.addSubview(letterField)
        scrollView.addSubview(okBtnShadow)
        scrollView.addSubview(okBtnShadow)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight*1.4)
        
        // ビューに追加
        self.view.addSubview(scrollView)
        
        
        explainField.text = "手紙を登録してください。\n 最大で5000字まで登録できます。"
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
    
    //テキストビュー内の文字数をラベルに表示
    func textViewDidChange(_ textView: UITextView) {
        let commentNum = letterField.text.count
        commentNumLabel.text = "\(String(commentNum))/5000"
        
        if commentNum > 5000{
            commentNumLabel.textColor = UIColor.red
        }else{
            commentNumLabel.textColor = UIColor.darkGray
        }
    }
    
    @IBAction func showDateSet(_ sender: Any) {
        print("okPush")
        
        if letterField.text.count > 5000{
            
            //       アラートオブジェクトを作る
            let alert = UIAlertController(title: "Alert", message :"入力文字数は5000字までです。", preferredStyle: .alert)
            
            //        OKボタンが押されたら、myMassageの中に書いた処理を実行するように設定する
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            //        アラートを画面に表示する
            present(alert,animated: true)
        }else{
            let alert = UIAlertController(title: "確認", message :"入力された文章を保存しますか？", preferredStyle: .alert)
            
            //OKボタン追加
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
                
                //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // 0.5秒後に実行したい処理
                    self.performSegue(withIdentifier: "showDateSetSegue", sender: nil)
                }
            }
            )
            
            let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelButton)
            
            //アラートを表示する
            present(alert, animated: true, completion: nil)
        }
    }
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDateSetSegue") {
            let vc: DateSetViewController = (segue.destination as? DateSetViewController)!
            vc.willSavePic = willSavePic
            vc.willSaveVoice = willSaveVoice
            vc.willSaveVideo = willSaveVideo
            vc.willSaveLetter = letterField.text
            
        }
    }
    

    
}
