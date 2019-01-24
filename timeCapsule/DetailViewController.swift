//
//  DetailViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/22.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var reminderPic: UIImageView!
    @IBOutlet weak var reminderMemo: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    // CollectionViewControllerから渡されるデータ
    var receiveImage:UIImage?
//    var receiveMemo:String?
    var receiveCellNum:Int?
    
    //アラートに表示するDatePicker
    var setTime:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        reminderPic.image = receiveImage
//        reminderMemo.text = receiveMemo
        
        // キーボードにDoneをつける
        navigationController?.delegate = self
        reminderMemo.delegate = self
        keyBoardDone()
        
    }
    //キーボードに「Done」ボタンを追加
    func keyBoardDone(){
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // Doneボタン。押された時に「closeKeybord」関数が呼ばれる。
        let commitButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
        self.reminderMemo.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
//    通知時間を設定する関数
    @IBAction func tapSetTime(_ sender: UIButton) {
        print("picker表示")
        
        RPicker.selectDate(title: "Select Date & Time", datePickerMode: .dateAndTime, minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: { (selectedDate) in
            // TODO: Your implementation for date
            self.outputLabel.text = "通知: \(selectedDate.dateString())"
        })
    }

    @IBAction func tapSaveBtn(_ sender: UIButton) {

            // 表示の大元がViewControllerかNavigationControllerかで戻る場所を判断する
            if self.presentingViewController is UINavigationController {
                //  表示の大元がNavigationControllerの場合
                let nc = self.presentingViewController as! UINavigationController
                
                // 前画面のViewControllerを取得
                let vc = nc.topViewController as! reminderViewController
                
                // 前画面のViewControllerの値を更新
                vc.newMemo = self.reminderMemo.text
                vc.indexNum = self.receiveCellNum
                
                // 今の画面を消して、前画面を表示させる&amp;amp;amp;lt;span data-mce-type="bookmark" style="display: inline-block; width: 0px; overflow: hidden; line-height: 0;" class="mce_SELRES_start"&amp;amp;amp;gt;&amp;amp;amp;lt;/span&amp;amp;amp;gt;
                self.dismiss(animated: true, completion: nil)

            }
    }
}
extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

