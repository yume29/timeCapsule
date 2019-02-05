//
//  videoSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/08.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import YPImagePicker

class videoSaveViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var willSavePic:[UIImage] = []
    var willSaveVoice:[String] = []
    var willPostVideo:[URL] = []
    var IntPlayTime:[Double] = []
    var postCount:Int?
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var videoBtn: UIButton!
    
    @IBOutlet weak var videoBtnShadow: UIView!
    
    @IBOutlet weak var videoLabel: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var okBtnShadow: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        videoLabel.backgroundColor = UIColor(hex: "f9f1d3")
        videoLabel.borderStyle = UITextField.BorderStyle.none
        
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
        //動画ボタン
        videoBtnShadow.layer.shadowColor = UIColor.black.cgColor
        videoBtnShadow.layer.shadowOpacity = 0.5
        videoBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        videoBtnShadow.layer.shadowRadius = 5
        
        //OKボタン
        okBtnShadow.layer.shadowColor = UIColor.black.cgColor
        okBtnShadow.layer.shadowOpacity = 0.5
        okBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        okBtnShadow.layer.shadowRadius = 5
        
        //        ボタンの編集
        //        丸角にする
        videoBtn.layer.cornerRadius = 10
        videoBtn.layer.masksToBounds = true
        
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        postCount = willPostVideo.count
        if postCount! == 0{
            countLabel.text = "Select from library"
        }else{
            countLabel.text = "\(postCount!) Videos selected"
        }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        
        willPostVideo = []
        IntPlayTime = []
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in
        
            for item in items {
                switch item {
                case .photo(let photo):
                    print("photo",photo.image)
                case .video(let video):
                    print("video",video)
                    self.willPostVideo.append(video.url)
                    self.IntPlayTime.append((video.asset?.duration)!)
                    print(self.IntPlayTime)
                    print("配列の中身チェック", self.willPostVideo)
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
                guard let videoSaveViewController = storyboard.instantiateViewController(withIdentifier: "videoSaveViewController") as? videoSaveViewController
                    else {
                        return
                }
//                videoViewController.getVideo = self.willPostVideo
//                picker.pushViewController(videoViewController, animated: true)
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        self.present(picker, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //インスタ風ImagePickerの設定
    func YPImagePickerConfig(){
        var config = YPImagePickerConfiguration()
        //保存するビデオについての管理
        config.video.fileType = .mov
        //        config.video.recordingTimeLimit = 60.0
        config.video.libraryTimeLimit = 300.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 300.0
        config.video.trimmerMinDuration = 3.0
        //開いたときにゔ動画のわライブラリだけだす
        config.library.mediaType = .video
        //正方形以外もそのまま表示
        config.onlySquareImagesFromCamera = false
        //どのスクリーンを最初に表示するか。
        config.startOnScreen = .video
        //ライブラリの写真を表示する際、1行に何枚写真を並べるか。
        config.library.numberOfItemsInRow = 4
        //ステータスバーを隠すかどうか
        config.hidesStatusBar = false
        //写真はカメラロールに保存されない
        config.shouldSaveNewPicturesToAlbum = false
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
    @IBAction func tapShowLetter(_ sender: UIButton) {
        print ("OKpush")
        
        let check = IntPlayTime.sum()
        
        if check > 300{
            
            //       アラートオブジェクトを作る
            let alert = UIAlertController(title: "Alert", message :"保存できる動画は合計５分までです", preferredStyle: .alert)
            
            //        OKボタンが押されたら、myMassageの中に書いた処理を実行するように設定する
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            //        アラートを画面に表示する
            present(alert,animated: true)
        }else{
            
            //       アラートオブジェクトを作る
            let alert = UIAlertController(title: "確認", message :"\(willPostVideo.count)件の動画を保存しますか？", preferredStyle: .alert)
            
            //OKボタン追加
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
                
                //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // 0.5秒後に実行したい処理
                    self.performSegue(withIdentifier: "showLetterSegue", sender: nil)
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
        if (segue.identifier == "showLetterSegue") {
            let vc: letterSaveViewController = (segue.destination as? letterSaveViewController)!
            vc.willSavePic = willSavePic
            vc.willSaveVoice = willSaveVoice
            vc.willSaveVideo = willPostVideo
        }
    }
}

