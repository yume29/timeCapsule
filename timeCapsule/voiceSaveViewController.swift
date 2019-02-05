//
//  voiceSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/20.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation




class voiceSaveViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate,
UITableViewDelegate,UITableViewDataSource{
    
    
    
    //    使う部品の宣言
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordBtnShadow: UIView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var okBtnShadow: UIView!
    @IBOutlet weak var soundTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    //    使う変数の宣言
    //    falseはレコードオフの状態
    var audioRecorder: AVAudioRecorder!
    var player:AVAudioPlayer = AVAudioPlayer()
    var playerItem:AVPlayerItem?
    var isRecording = false
    var isPlaying = false
    var currentTimer:Float = 0
    var timer: Timer!
    var recordSound:[String] = []
    var playTime:[String] = []
    var IntPlayTime:[Float] = []
    let userdefaults = UserDefaults.standard
    
    //セルの高さを設定
    var tappedCell:Int = 0
    var toggle = true
    var startTime:NSDate?
    var willSavePic:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(willSavePic)
        
        userdefaults.register(defaults: ["Num": 0])
        view.backgroundColor = UIColor(hex: "f9f1d3")
        recordButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
        //ShadowViewの準備
        // 録音ボタン
        recordBtnShadow.layer.shadowColor = UIColor.black.cgColor
        recordBtnShadow.layer.shadowOpacity = 0.5
        recordBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        recordBtnShadow.layer.shadowRadius = 5
        //   OKボタン
        okBtnShadow.layer.shadowColor = UIColor.black.cgColor
        okBtnShadow.layer.shadowOpacity = 0.5
        okBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
        okBtnShadow.layer.shadowRadius = 5
        //        丸角にする
        okBtn.layer.cornerRadius = 10
        okBtn.layer.masksToBounds = true
    }
    //    録音ボタンが押されたときに呼ばれる
    
    @IBAction func record(){
        
        
        if !isRecording {
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(.playAndRecord, mode: .default, options:.allowBluetoothA2DP)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            //生成時間でファイル名作成
            var recordTime = fileName()
            recordSound += [recordTime]
            
            //レコーダーをセット
            audioRecorder = try! AVAudioRecorder(url: getURL(file: recordTime), settings: settings)
            
            // ゲーム開始時の時刻を取得
            startTime = NSDate()
            
            //レコードスタート
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
            
            //タイマーをセットしスタート
            if timer != nil{
                // timerが起動中なら一旦破棄する
                timer.invalidate()
            }
            
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(self.timerCounter),
                userInfo: nil,
                repeats: true)
            
            startTime = Date() as NSDate
            //ボタンの色変更
            recordButton.setBackgroundImage(UIImage(named: "microphone2.png"), for: .normal)
            
        }else{
            //レコーダーを止める
            audioRecorder.stop()
            isRecording = false
            
            //再生時間を配列に格納
            playTime += [getPlayTime()]
            print(getPlayTime())
            
            //タイマーを止めよう
            if timer != nil{
                timer.invalidate()
            }
            //タイマーを戻す
            timeLabel.text = "00:00"
            
            //合計時間を配列に格納
            let currentTime = Date().timeIntervalSince(startTime as! Date)
            print("currentTime", currentTime)
            IntPlayTime.append(Float(floor(currentTime)))
            print("intPlayTime",IntPlayTime)
            
            //テーブルビューを更新
            self.soundTableView.reloadData()
            recordButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
            //            playButton.isEnabled = true
            
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
    //テーブルセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordSound.count
    }
    //   セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! voiceTableViewCell
        
        cell.nameLabel!.text = recordSound[indexPath.row]
        cell.playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
        cell.playSound = recordSound[indexPath.row]
        cell.player = try! AVAudioPlayer(contentsOf: getURL(file: recordSound[indexPath.row]))
        cell.totalLabel.text = playTime[indexPath.row]
        return cell
    }
    
    //    現在時刻をstringで生成する関数
//    func getNowClockString() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"
//        let now = Date()
//        return formatter.string(from: now)
//    }
    //ファイルの名前を生成
    func fileName()->String{
        var Num = userdefaults.object(forKey: "Num") as! Int
        Num = Num + 1
        userdefaults.set(Num, forKey: "Num")
        return  "New recording\(Num)"
    }
    
    //再生時間を生成する
    func getPlayTime() -> String{
        let time = NSDate().timeIntervalSince(startTime as! Date) // 現在時刻と開始時刻の差
        let hh = Int(time / 3600)
        let mm = Int((time - Double(hh * 3600)) / 60)
        let ss = Int(time - Double(hh * 3600 + mm * 60))
        let  timeString = String(format: "%02d:%02d", mm, ss)
        
        return timeString
    }
    //録音時間を生成
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime as! Date)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
 
        let mm = String(format:"%02d", minute)
        let ss = String(format:"%02d", second)
//        let sMsec = String(format:"%02d", msec)
        timeLabel.text = "\(mm):\(ss)"
        
    }
//    //画面が消えるときはタイマーオフ
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        timer.invalidate()
//    }
    
    //    テーブルビューセルのタッチイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let playingIndexPath = IndexPath(row: tappedCell, section: 0)
        let playingCell = tableView.cellForRow(at: playingIndexPath) as! voiceTableViewCell
        playingCell.player.stop()
        
        let cell = tableView.cellForRow(at: indexPath) as! voiceTableViewCell
        //変数に何行目がを保持
        tappedCell = indexPath.row
        
        // toggle = true 選択されていない
        toggle = !toggle
        
        //選択されたセルを更新
        self.soundTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        //セルが選択状態だったら
        if toggle {
            //playerを止める
            cell.player.stop()
        }
    }
    
    //選択されたセルの高さを返す
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == tappedCell {
            if toggle {
                return 44
            } else {
                return 100
            }
        } else {
            return 44
        }
    }

    //    次の画面へ遷移
    @IBAction func tapShowVideo(_ sender: UIButton) {
        print("OKpush")

       let check =  IntPlayTime.sum()
     
        if check > 600{
            
            //       アラートオブジェクトを作る
            let alert = UIAlertController(title: "Alert", message :"保存できる音声は10分までです", preferredStyle: .alert)
            
            //        OKボタンが押されたら、myMassageの中に書いた処理を実行するように設定する
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            //        アラートを画面に表示する
            present(alert,animated: true)
        }else{
            
            //       アラートオブジェクトを作る
            let alert = UIAlertController(title: "確認", message :"\(recordSound.count)件の音声を保存しますか？", preferredStyle: .alert)
            
            //OKボタン追加
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
                
                //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // 0.5秒後に実行したい処理
                    self.performSegue(withIdentifier: "showVideoSegue", sender: nil)
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
        if (segue.identifier == "showVideoSegue") {
            let vc: videoSaveViewController = (segue.destination as? videoSaveViewController)!
            vc.willSavePic = willSavePic
            vc.willSaveVoice = recordSound
            
        }
    }
}
extension Collection where Element: Numeric {
    /// Returns the sum of all elements in the collection
    func sum() -> Element { return reduce(0, +) }
}
