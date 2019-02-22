//
//  futureViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/02/05.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import YRCoverFlowLayout
import Firebase
import SDWebImage //スムーズに下ろすときに便利
import FirebaseUI //SDWedImageを呼ぶときに必要
import AVFoundation
import Photos

class futureViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate{
    
    
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var picFlowView: YRCoverFlowLayout!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var videoFlowView: YRCoverFlowLayout!
    @IBOutlet weak var nextBtn: UIButton!
    
    //DBに必要な変数と定義
    var db:Firestore!
    //ストレージサービスへの参照を取得。
    let storage = Storage.storage()
    //ストレージへの参照を入れるための変数。
    var storageRef:StorageReference!
    //DBから取り出した画像を保持
    var gotPicList:[String] = []
    var gotVideoList:[String] = []
    var gotVideoUrlList:[String] = []
    var gotVoiceList:[String] = []
    var gotLetterList:[String] = []
    
    var scrollView:UIScrollView!
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    //パスワードを保持
    let password:String = "53oA08C5WW"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.layer.masksToBounds = true

        view.backgroundColor = UIColor(hex: "f9f1d3")
        picCollectionView.backgroundColor = UIColor(hex: "FBFBEF")
        
        videoCollectionView.backgroundColor = UIColor(hex: "FBFBEF")
        
        
        //ストレージサービスへの参照
        db = Firestore.firestore()
        //ストレージへの参照
        storageRef = storage.reference(forURL:"gs://time-capsule-ca57c.appspot.com/")
        readURL()
        picCollectionView.reloadData()
        
        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処
        scrollView.addSubview(picCollectionView)
        scrollView.addSubview(videoCollectionView)
        scrollView.addSubview(nextBtn)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        // ビューに追加
        self.view.addSubview(scrollView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1{
                        print("ビデオの数\(gotVideoList.count)")
                        print("音声の数\(gotVoiceList.count)")
                        print("手紙\(gotLetterList)")
            return gotVideoList.count

        }
        return gotPicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! videoCollectionViewCell
        
            
            let url = URL(string: gotVideoUrlList[indexPath.row])
            print("memo: url \(url!)")
            cell.player = AVPlayer(url: url!)
            cell.backgroundColor = .white
            
            let playerLayer = AVPlayerLayer(player: cell.player)
            playerLayer.frame = cell.bounds
            cell.layer.addSublayer(playerLayer)
//            self.view.layer.addSublayer(playerLayer)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! pictureCollectionViewCell
        
        let reference = storageRef.child("\(password)/\(gotPicList[indexPath.row])")

        print("memo:reference",reference)
        cell.gotImage.isUserInteractionEnabled = true
        cell.gotImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.saveImage(_:))))
        let imageview: UIImageView = cell.gotImage
        
        imageview.sd_setImage(with: reference, placeholderImage:UIImage(named: "loading.png"))
        
        return cell
    
    }
    
    //画像の読み込み
    func readURL(){
        db.collection(password).getDocuments(){getData,err in
            if let err = err{
                print("読み込み失敗",err)
            }else{
                for document in (getData?.documents)!{
                    
                    if document.data()["image"] != nil {
                        print("image",document.data()["image"] as! String)
                        self.gotPicList.append(document.data()["image"] as! String)
                    } else if document.data()["voice"] != nil {
                        print("voice",document.data()["voice"] as! String)
                        self.gotVoiceList.append(document.data()["voice"] as! String)
                    }else if document.data()["video"] != nil{
                        print("video",document.data()["video"] as! String)
                        self.gotVideoList.append(document.data()["video"] as! String)
                        self.gotVideoUrlList.append(document.data()["url"] as! String)
                        print("memo: gotVideoList \(self.gotVideoList)")
                    }else if document.data()["letter"] != nil{
                        print("letter",document.data()["letter"] as! String)
                        self.gotLetterList.append(document.data()["letter"] as! String)
                    }
                }
                self.picCollectionView.reloadData()
                self.videoCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1{
            
            print("再生できないかな",indexPath.row)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! videoCollectionViewCell
            let url = URL(string: gotVideoUrlList[indexPath.row])
            
            print(url!)
            cell.player = AVPlayer(url: url!)
            cell.player.play()
            }
    }
    
    //画像の保存
    // セーブを行う
    @objc func saveImage(_ sender: UITapGestureRecognizer) {
        
        print("セルタップ")
        
        // クリックした UIImageView を取得
        let targetImageView = sender.view! as! UIImageView
        
        // その中の UIImage を取得
        let targetImage = targetImageView.image!
        
        // UIImage の画像をカメラロールに画像を保存
        UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    // 保存を試みた結果をダイアログで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func pushNext(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "showSecondFuture", sender: nil)
    }
    
    // 画面遷移先のViewControllerを取得し、データを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondFuture" {
            let vc = segue.destination as! secondFutureViewController
            vc.gotVoiceList = gotVoiceList
            vc.gotLetterList = gotLetterList
            
            
        
        }
    }
}

