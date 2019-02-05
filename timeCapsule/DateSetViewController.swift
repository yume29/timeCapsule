//
//  DateSetViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/09.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase
import FirebaseFirestore
import FirebaseUI
import FirebaseCore





class DateSetViewController: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var closeBtnShadow: UIView!
    @IBOutlet weak var openDatePicker: UIDatePicker!
    @IBOutlet weak var explainview: UITextView!
    
    
    
    //設定日
    var sDate:String!
    var DBDate:Date?
    //保存するデータ
    var willSavePic:[UIImage] = []
    var willSaveVoice:[String] = []
    var willSaveVideo:[URL] = []
    var willSaveLetter:String = ""
    var password:String!

    //保存するための準備
    let userdefaults = UserDefaults.standard
    var db:Firestore!
    //ストレージサービスへの参照を取得。
    let storage = Storage.storage()
    //ストレージへの参照を入れるための変数。
    var storageRef:StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "f9f1d3")
        
        userdefaults.register(defaults: ["imgNum": 0])
        print("写真",willSavePic)
        print("音声",willSaveVoice)
        print("動画",willSaveVideo)
        print("手紙",willSaveLetter)
        
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
        explainview.backgroundColor = UIColor(hex: "f9f1d3")
        
        explainview.text = "一度カプセルを閉じると\n 選択した日まで開くことができません。\n 本当に閉じてよろしいですか？\n カプセルは5年後まで設定できます。"
        
        //ストレージサービスへの参照
         db = Firestore.firestore()
        //ストレージへの参照
        storageRef = storage.reference(forURL:"gs://time-capsule-ca57c.appspot.com/")
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
        print("ピッカー",
              openDatePicker.date)
        
        DBDate = openDatePicker.date
        print("DBDate",DBDate)
        sDate = ""
        //現在の日付を取得
        let date:Date = openDatePicker.date
        
        //日付のフォーマットを指定する。
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        
        //日付をStringに変換する
        sDate = format.string(from: date)
        
        print("次のページ用",sDate)
        
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
    
    
    @IBAction func showPassword(_ sender: Any) {
        print("close btn pushed ")
        
        //Firestorageに画像を保存。URLをFirestoreへ。
        //saveToStrage(image:willPostImages)
        //       アラートオブジェクトを作る
        //TODO: nilを消す
        let alert = UIAlertController(title: "確認", message :"開封日は\(sDate!)で\nよろしいですか？", preferredStyle: .alert)
        
        //OKボタン追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            
            self.password = self.randomString(length: 10) // 10桁のランダムな英数字を生成
            
            print("password",self.password)
            //Firestorageに画像を保存。URLをFirestoreへ
            //画像
            self.saveImageToStrage(image:self.willSavePic)
            
            //動画
            self.saveVideoToStrage(url: self.willSaveVideo)
            
            //音声
            self.saveVoiceToStrage(file: self.willSaveVoice)
            
            //手紙
            let letterDetail:String = self.willSaveLetter
            self.saveURL(data:["letter":letterDetail])
        
            
            //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒後に実行したい処理
                self.performSegue(withIdentifier: "showPasswordSegue", sender: nil)
            }
        }
        )
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelButton)
        
        //アラートを表示する
        present(alert, animated: true, completion: nil)

    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPasswordSegue" {
            let vc = segue.destination as! passwordViewController
            vc.selectedDate = sDate
            vc.password = password
        }
    }
}
//Firestore、storageに関して
extension DateSetViewController{
    //ストレージに画像を保存
    func saveImageToStrage(image:[UIImage]){
        for (index, pic) in willSavePic.enumerated() {
                print(index, pic)
        //保存する画像を置く場所のPath生成
        let picName:String = fileName()
        let reference = storageRef.child("\(password!)/\(picName)")
        //pathをFirestoreへ
        saveURL(data:["image":picName])

        //保存する画像をNSData型へ
        let data = image[index].pngData()
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        //storageに画像を保存
        reference.putData(data!, metadata: meta, completion: { metaData, error in
            print("memo:metaData",metaData)
            print("memo:error",error)
            print("memo:データの保存完了")
        })
        }
    }
    
    //ストレージに動画を保存
    func saveVideoToStrage(url:[URL]){
        for (index, video) in willSaveVideo.enumerated() {
            print(index, video)
            //保存する画像を置く場所のPath生成
        let videoName:String = fileName()
        let reference = storageRef.child("\(password!)/\(videoName)")
            
//        //pathをfireStore
//            saveURL(data:["video":videoName])
        //保存する画像をNSData型へ
        let path = url[index]
        let meta = StorageMetadata()
            meta.contentType = "video/quicktime"
        let uploadTask = reference.putFile(from: path, metadata: nil){ (metadata, error) in
            
            
            guard let metadata = metadata else {
                print("memo:アップロードエラー")
                return
            }
            reference.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("memo:アップロードエラー")
                    return
                }
                print("memo:動画URL",url!)
                let urlString = url?.absoluteString
                self.saveURL(data:["video":self.fileName(),"url":urlString])
            }
            print("memo:ストレージ動画保存の関数動作")
            }
        }
    }
    
    //ストレージに音声を保存
    func saveVoiceToStrage(file:[String]){
        for (index, voice) in willSaveVoice.enumerated() {
            print(index, voice)
            //保存する画像を置く場所のPath生成
            let voiceName:String = file[index]
            let reference = storageRef.child("\(password!)/\(voiceName)")
            
//            //pathをfireStore
//            saveURL(data:["voice":voiceName])
            //保存する画像をNSData型へ
            let path = getURL(file: voiceName)
//            let meta = StorageMetadata()
//            meta.contentType = "video/quicktime"
            let uploadTask = reference.putFile(from: path, metadata: nil){ (metadata, error) in
                
                guard let metadata = metadata else {
                    print("memo:アップロードエラー")
                    return
                }
                reference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("memo:アップロードエラー")
                        return
                    }
                    print("memo:動画URL",url!)
                    let urlString = url?.absoluteString
                    self.saveURL(data:["voice":voiceName] )
                }
                print("memo:ストレージ動画保存の関数動作")
            }
        }
    }
    
    //    音声のURLを取得する
    func getURL(file:String) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent(file)
        print(url)
        return url
    }
    
    //ファイル名の生成
    func fileName()->String{
        var imgNum = userdefaults.object(forKey: "imgNum") as! Int
        imgNum = imgNum + 1
        userdefaults.set(imgNum, forKey: "imgNum")
        return  "data\(imgNum)"
    }
    
    //URLをFirestoreに保存する関数
    func saveURL(data:[String:Any]){
        print("memo:FirestoreにURLを保存",data)
        db.collection(password!).addDocument(data: data){err in
            if let err = err{
                print("memo:失敗",err)
            }else{
                print("memo:データの書き込み成功")
            }
        }
    }

////画像の読み込み
//    func readURL(){
//        imageNameList = []
//        db.collection("ImageName").getDocuments(){getData,err in
//            if let err = err{
//                print("読み込み失敗",err)
//            }else{
//                for document in (getData?.documents)!{
//                    self.imageNameList.append(document.data()["fileName"] as! String)
//                }
//                self.myCollectionView.reloadData()
//            }
//            print("memo",self.imageNameList)
//        }
//    }
}
