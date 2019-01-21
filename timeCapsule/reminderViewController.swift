//
//  reminderViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/15.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class reminderViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var reminderView: UICollectionView!
//    @IBOutlet weak var reminderPic: UIImageView!    
//    @IBOutlet weak var memoField: UITextField!
    

    var picList:[UIImage?] = []
    var textList:[String] = []
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var scrollView:UIScrollView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        
        //        キーボードにDoneをつける
        keyBoardDone()
        
        view.backgroundColor = UIColor.white
        reminderView.backgroundColor = UIColor(hex: "f9f1d3")
    
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
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //    配列に撮った写真を追加
        picList += [image]
        
        //アルバムに保存（カメラロール）
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        //        撮影用の画面を閉じる
        dismiss(animated: true, completion: nil)
        self.reminderView.reloadData()
        
    }
    
    @IBAction func longPush(_ sender: UILongPressGestureRecognizer) {
        print("長押し")
    }
    
}
//UIScrollViewの拡張
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        print("touchesBegan")
    }
}
//キーボード関連の関数をまとめる。
    //キーボードが表示された時に呼ばれる
extension reminderViewController{
    //キーボードに「Done」ボタンを追加
    func keyBoardDone(){
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // Doneボタン。押された時に「closeKeybord」関数が呼ばれる。
        let commitButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
//        self.memoField.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
}

extension reminderViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // スタンプが押された時の処理を書く
    }

}
//セルの個数の反映
extension reminderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.picList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! reminderCollectionViewCell
        //セルのラベルに番号を設定する。
        cell.memoField.text = "test"
        cell.reminderPic.image = picList[indexPath.row]
        cell.reminderPic.innerShadow()
        cell.backgroundColor = UIColor(hex: "E8E7E7")
    
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
