//
//  reminderViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/15.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import RealmSwift

class reminderViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var reminderView: UICollectionView!
    
    @IBOutlet weak var reminderPic: UIImageView!
    
    
    let userdefaults = UserDefaults.standard
    var reminderList:[[String: String]] = []
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var scrollView:UIScrollView!
    var selectedImage:String?
    var selectedMemo:String?
    var selectedCellNum:Int?
    var path:String?
    var imageName:String?
    
    var indexNum:Int?
    var newMemo:String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        reminderView.backgroundColor = UIColor(hex: "f9f1d3")
        
        //ユーザーデフォルト
        userdefaults.register(defaults: ["imgNum": 0])
        fetchReminders()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func takePic(_ sender: UIBarButtonItem) {
        
        //撮影用の画面を起動する
        let camera = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera){
            
            let picker = UIImagePickerController()
            
            picker.sourceType = camera
            picker.delegate = self //イベントの指示をする人は自分（この画面）
            present (picker, animated: true) //表示
            
        }
    }
    //        撮影ボタンが押されたら、発動するメゾット
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        画像情報を取得
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageName = fileName()
        let path = getDocumentsURL()
        print("URL",path)
        print("保存する画像",image)
        
        //配列に撮った写真を追加
        let list = ["fileName": imageName, "memo": ""]
        reminderList.append(list)
        
        let strUrl = path.absoluteString
        //ファイルに画像を保存
        saveImage(image: image, path: strUrl!)
        
        //アルバムに保存（カメラロール）
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        //   撮影用の画面を閉じる
        dismiss(animated: true, completion: nil)
        self.reminderView.reloadData()
        
    }
    
    //画像保存時のPathを生成.ドキュメントフォルダまでのPathを取得.
    func getDocumentsURL()->NSURL{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsURL! as NSURL
    }
    //    画像をロードする関数
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        return image
    }
    //Pathの最後に保存する画像の名前を追加
    func fileInDocumentsDirectory(filename: String)->String{
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    //画像の保存.
    func saveImage(image: UIImage, path: String){
        let pngImageData = image.pngData()
        do {
            try pngImageData!.write(to: URL(string: path)!, options: .atomic)
        }catch{
            print("memo:保存失敗 \(error)")
        }
        print("memo:保存の成功")
    }
    //PathからUIImageへの変換
    func loadImage(fileName:String)->UIImage{
        let path = getDocumentsURL().appendingPathComponent(fileName)?.path
        let image = UIImage(contentsOfFile: path!)
        return image!
    }
    //ファイル名の生成
    func fileName()->String{
        var imgNum = userdefaults.object(forKey: "imgNum") as! Int
        imgNum = imgNum + 1
        userdefaults.set(imgNum, forKey: "imgNum")
        return "reminder\(imgNum)"
    }
    

//    DB上のデータをおろしてくるメゾット
    func fetchReminders() {
        // TODO: todo一覧を取得する
        do{
            let realm = try Realm()
            //todoListに保存されているものすべて取得
            var results = realm.objects(Reminder.self)
            //createを基準にソート
            results = results.sorted(byKeyPath: "created", ascending: false)
            //todoListに格納
//            reminderList = Array(results)
            //テーブルビューを更新
            reminderView.reloadData()
            print("読み込んだよ")
        }catch{
            print("失敗したよ")
        }
    }
}
//UIScrollViewの拡張
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        print("touchesBegan")
    }
}
extension reminderViewController: UICollectionViewDelegate{
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        print("セルが選択されました")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! reminderCollectionViewCell
        // [indexPath.row] から画像名を探し、UImage を設定
        
        selectedImage = reminderList[indexPath.row]["path"]
        selectedMemo = reminderList[indexPath.row]["memo"]
        selectedCellNum = indexPath.row
        // SubViewController へ遷移するために Segue を呼び出す
        performSegue(withIdentifier: "showDetailSegue",sender: nil)
    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.receiveImage = selectedImage
            //vc.receiveMemo = selectedMemo
            vc.receiveCellNum = selectedCellNum
        }
    }
    
}

//セルの個数の反映
extension reminderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reminderList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! reminderCollectionViewCell
        //セルのプロパティ設定
        cell.memoField.text = "MEMO"
        let imagePath = getDocumentsURL().absoluteString
        let loadImage = loadImageFromPath(path: imagePath)
        cell.reminderPic.image = loadImage
        cell.reminderPic.innerShadow()
        //        丸角にする
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
}
extension UIView {
    func innerShadow() {
        let path = UIBezierPath(rect: CGRect(x: -5.0, y: -5.0, width: self.bounds.size.width + 5.0, height: 5.0 ))
        let innerLayer = CALayer()
        innerLayer.frame = self.bounds
        innerLayer.masksToBounds = true
        innerLayer.shadowColor = UIColor.black.cgColor
        innerLayer.shadowOffset = CGSize(width: 5, height: 5)
        innerLayer.shadowOpacity = 0.5
        innerLayer.shadowPath = path.cgPath
        self.layer.addSublayer(innerLayer)
    }
}
