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
    
    var willPostImages:[UIImage] = []
    var postCount:Int?
    
    @IBOutlet weak var libraryBtn: UIButton!
    
    @IBOutlet weak var libraryBtnShadow: UIView!
    
    @IBOutlet weak var photoLabel: UITextField!
    
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var okBtnShadow: UIView!
    
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

        okBtnShadow.layer.shadowColor = UIColor.black.cgColor
        okBtnShadow.layer.shadowOpacity = 0.5
        okBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        okBtnShadow.layer.shadowRadius = 5
        
        libraryBtnShadow.layer.shadowColor = UIColor.black.cgColor
        libraryBtnShadow.layer.shadowOpacity = 0.5
        libraryBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        libraryBtnShadow.layer.shadowRadius = 5
        
        //        ボタンの編集
        //        丸角にする
        libraryBtn.layer.cornerRadius = 10
        libraryBtn.layer.masksToBounds = true
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        postCount = willPostImages.count
        if postCount! == 0{
            countLabel.text = "Select from library"
        }else{
            countLabel.text = "\(postCount!) pictures selected"
        }
    }
        
    
    
    @IBAction func openLibrary(_ sender: Any) {
        
        willPostImages = []
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            for item in items {
                switch item {
                case .photo(let photo):
                    print("photo",photo.image)
                    self.willPostImages.append(contentsOf: [photo.image])
                    print("配列の中身チェック", self.willPostImages)
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
                guard let picsSaveViewController = storyboard.instantiateViewController(withIdentifier: "picsSaveViewController") as? picsSaveViewController
                    
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
        //保存するときに正方形じゃない
        config.onlySquareImagesFromCamera = false
        //フィルターなし
        config.showsFilters = true
        //カメラモードオフ
        config.screens = [.library,]
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


