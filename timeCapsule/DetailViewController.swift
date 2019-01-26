//
//  DetailViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/22.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var reminderPic: UIImageView!
    @IBOutlet weak var reminderMemo: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    // CollectionViewControllerから渡されるデータ
    var receiveImage:String?
    var receiveMemo:String?
    var receiveCellNum:Int?
    var selectedDate:Date?
    var reminderList:[Reminder] = []
    
    //アラートに表示するDatePicker
    var setTime:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        
        //        TODO: ここ調整する
        //        reminderPic.image = receiveImage
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
        let currentDate: Date = Date()
        // TODO: 入力値をreminderに登録する
        do{
            //Realmをつかえるようにする
            let realm = try Realm()
            //保存する対象のインスタンスを作成
            let reminder = Reminder()
            //値を設定する
            reminder.image = receiveImage!
            reminder.memo = reminderMemo.text!
            reminder.alerm  = selectedDate!
            reminder.created = currentDate
            
            //保存処理
            try!  realm.write {
                realm.add(reminder)
                //更新
                fetchReminders()
                print("書き込んだよ", reminder)
            }
        }catch{
            print("失敗したよ")
        }
        func fetchReminders() {
            // TODO: todo一覧を取得する
            do{
                let realm = try Realm()
                //todoListに保存されているものすべて取得
                var results = realm.objects(Reminder.self)
                //createを基準にソート
                results = results.sorted(byKeyPath: "created", ascending: false)
                //todoListに格納
                reminderList = Array(results)
//                //テーブルビューを更新
//                todoTable.reloadData()
                print("読み込んだよ")
            }catch{
                print("失敗したよ")
            }
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

