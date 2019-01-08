//
//  picsSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/17.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit
import YPImagePicker

class picsSaveViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var willPostImage:UIImage!
    
    @IBOutlet weak var libraryBtn: UIButton!
    
    @IBOutlet weak var photoLabel: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        photoLabel.backgroundColor = UIColor(hex: "f9f1d3")
        photoLabel.borderStyle = UITextField.BorderStyle.none
        
        let coloredImage = UIImage(named:"navcolor.jpg")
        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        
        //ナビゲーションバーのTextColor
        //タイトル
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hex: "F55050")]
        //左のボタン
        UINavigationBar.appearance().tintColor = UIColor(hex: "F55050")
        
        
        //ImagePickerの設定
        YPImagePickerConfig()
        
        
        
        //         影表示用のビュー
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
        shadowView.center = CGPoint(x: 375/2, y:667/2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5
        
        //        ボタンの編集
        
        //        丸角にする
        libraryBtn.layer.cornerRadius = 10
        libraryBtn.layer.masksToBounds = true
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
        
        //        影とボタンをくっつける
        shadowView.addSubview(libraryBtn)
        shadowView.addSubview(okBtn)
        //        くっつけたものをviewに乗せる
        view.addSubview(shadowView)
        
    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            for item in items {
                switch item {
                case .photo(let photo):
                    print("photo",photo.image)
                    self.willPostImage = photo.image
                case .video(let video):
                    print("video",video)
                }
            }
            
            
            if cancelled {
                //「cansel」ボタンが押された時の処理
                
            }else{
                //「Next」ボタンが押された時の処理
                print("memo:次の画面に遷移します。")
                //ストーリーボードを指定
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // フォトライブラリーで画像が選択された時の処理
                guard let voiceSaveViewController = storyboard.instantiateViewController(withIdentifier: "voiceSaveViewController") as? voiceSaveViewController
                    else {
                        return
                }
                //                photoViewController.getPhoto = self.willPostImage
                //                picker.pushViewController(photoViewController, animated: true)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //インスタ風ImagePickerの設定
    func YPImagePickerConfig(){
        var config = YPImagePickerConfiguration()
        //開いたときに写真だけ表示
        config.library.mediaType = .photo
        //ライブラリの写真を表示する際、1行に何枚写真を並べるか。
        config.library.numberOfItemsInRow = 4
        //どのスクリーンを最初に表示するか。
        config.startOnScreen = .library
        //ステータスバーを隠すかどうか
        config.hidesStatusBar = false
        
        //下のバー（カメラとライブラリの選択）を隠す
        config.hidesBottomBar = true
        
        //ナビゲーションの右側のボタン「Next」
        config.colors.tintColor = UIColor(hex: "F55050")
        
        //選べる写真の数
        config.library.maxNumberOfItems = 20
        //上記設定
        YPImagePickerConfiguration.shared = config
        
    }
    
    
    //    OKボタンで次のページへ
    
    @IBAction func tapShoeVice(_ sender: UIButton) {
        print ("OKpush")
    }
    //self.performSegue(withIdentifier: "showVoiceView", sender: nil)
    //        let storyboard: UIStoryboard = self.storyboard!
    //        let voice = storyboard.instantiateViewController(withIdentifier: "showVoiceView")
    //        self.present(voice, animated: true, completion: nil)
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


////
////  picsSaveViewController.swift
////  timeCapsule
////
////  Created by 一ノ瀬由芽 on 2018/12/17.
////  Copyright © 2018年 Yume Ichinose. All rights reserved.
////
//
//import UIKit
//import YPImagePicker
//
//class picsSaveViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    var willPostImage:UIImage!
//
//
//    @IBOutlet weak var stepLabel: UILabel!
//
//    @IBOutlet weak var libraryBtn: UIButton!
//
//    @IBOutlet weak var photoLabel: UITextField!
//
//    @IBOutlet weak var okBtn: UIButton!
//
//    @IBOutlet weak var explainLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//         view.backgroundColor = UIColor(hex: "f9f1d3")
//        photoLabel.backgroundColor = UIColor(hex: "f9f1d3")
//        photoLabel.borderStyle = UITextField.BorderStyle.none
//
//        let coloredImage = UIImage(named:"navcolor.jpg")
//        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
//
//        //ナビゲーションバーのTextColor
//        //タイトル
//       UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hex: "F55050")]
//        //左のボタン
//        UINavigationBar.appearance().tintColor = UIColor(hex: "F55050")
//
//
//        //ImagePickerの設定
//        YPImagePickerConfig()
//
//
////         影表示用のビュー
//    let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
//    shadowView.center = CGPoint(x: 375/2, y:667/2)
//    shadowView.layer.shadowColor = UIColor.black.cgColor
//    shadowView.layer.shadowOpacity = 0.5
//    shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
//    shadowView.layer.shadowRadius = 5
//
////        ボタンの編集
//
////        丸角にする
//        libraryBtn.layer.cornerRadius = 10
//        libraryBtn.layer.masksToBounds = true
//
//        okBtn.layer.cornerRadius = 10
//        okBtn.layer.masksToBounds = true
////        影とボタンをくっつける
//        shadowView.addSubview(libraryBtn)
//        shadowView.addSubview(okBtn)
////        くっつけたものをviewに乗せる
//        view.addSubview(shadowView)
//
//    }
//
//
//    @IBAction func openLibrary(_ sender: Any) {
//
//
//        let picker = YPImagePicker()
//        picker.didFinishPicking { [unowned picker] items, cancelled in
//
//            for item in items {
//                switch item {
//                case .photo(let photo):
//                    print("photo",photo.image)
//                    self.willPostImage = photo.image
//                case .video(let video):
//                    print("video",video)
//                }
//
//            if cancelled {
//                //「cansel」ボタンが押された時の処理
//
//            }else{
//                //「Next」ボタンが押された時の処理
//                print("memo:次の画面に遷移します。")
//                //ストーリーボードを指定
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                // フォトライブラリーで画像が選択された時の処理
//                guard let voiceSaveViewController = storyboard.instantiateViewController(withIdentifier: "voiceSaveViewController") as? voiceSaveViewController
//                    else {
//                    return
//                }
////                photoViewController.getPhoto = self.willPostImage
////                picker.pushViewController(photoViewController, animated: true)
//
//            picker.dismiss(animated: true, completion: nil)
//        }
//        self.present(picker, animated: true, completion: nil)
//    }
//
//
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //インスタ風ImagePickerの設定
//    func YPImagePickerConfig(){
//        var config = YPImagePickerConfiguration()
//
//        //写真を正方形以外も表示
//        config.onlySquareImagesFromCamera = false
//        //ライブラリの写真を表示する際、1行に何枚写真を並べるか。
//        config.library.numberOfItemsInRow = 4
//        //どのスクリーンを最初に表示するか。
//        config.startOnScreen = .video
//        //ステータスバーを隠すかどうか
//        config.hidesStatusBar = false
//
//        //下のバー（カメラとライブラリの選択）を隠す
//        config.hidesBottomBar = true
//        //写真はカメラロールに保存されない
//        config.shouldSaveNewPicturesToAlbum = false
//
//        //ナビゲーションの右側のボタン「Next」
//        config.colors.tintColor = UIColor(hex: "F55050")
//
//        //選べる写真の数
//        config.library.maxNumberOfItems = 20
////        //上記設定
////        YPImagePickerConfiguration.shared = config
//
//    }
//
//
////    OKボタンで次のページへ
//
//    @IBAction func tapShoeVice(_ sender: UIButton) {
//    print ("OKpush")
//    }
//
//
