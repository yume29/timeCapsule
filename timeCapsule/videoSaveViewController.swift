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
    
    var willPostImage:UIImage!
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var videoBtn: UIButton!
    
    @IBOutlet weak var videoLabel: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    

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
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
        shadowView.center = CGPoint(x: 375/2, y:667/2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5
        
        //        ボタンの編集
        
        //        丸角にする
        videoBtn.layer.cornerRadius = 10
        videoBtn.layer.masksToBounds = true
        
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
        //        影とボタンをくっつける
        shadowView.addSubview(videoBtn)
        shadowView.addSubview(okBtn)
        //        くっつけたものをviewに乗せる
        view.addSubview(shadowView)
        
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, cancelled in


                if let video = items.singleVideo {
                    print(video.fromCamera)
                    print(video.thumbnail)
                    print(video.url)
                }
                
                    if cancelled {
                        //「cansel」ボタンが押された時の処理

                    }else{
                        //「Next」ボタンが押された時の処理
                        print("memo:次の画面に遷移します。")
                        //ストーリーボードを指定
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        // フォトライブラリーで画像が選択された時の処理
                        guard let videoViewController = storyboard.instantiateViewController(withIdentifier: "videoViewController") as? videoViewController
                            else {
                                return
                        }
                        videoViewController.getVideo = self.willPostImage
                        picker.pushViewController(videoViewController, animated: true)
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
        //開いたときに録画画面になる
        //   config.screens = [.library, .video]

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
    


    @IBAction func tapShoeVice(_ sender: UIButton) {
                print ("OKpush")
            }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
