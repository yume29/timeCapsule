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
    //    使う変数の宣言
    //    falseはレコードオフの状態
    var audioRecorder: AVAudioRecorder!
    var player:AVAudioPlayer = AVAudioPlayer()
    var playerItem:AVPlayerItem?
    var isRecording = false
    var isPlaying = false
    var currentTimer:Float = 0
    var timer: Timer?
    var recordSound:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            var recordTime = "\(getNowClockString()).m4a"
            print("recordTime:",recordTime)
            recordSound += [recordTime]
            print("recordSound:",recordSound)
            
            audioRecorder = try! AVAudioRecorder(url: getURL(file: recordTime), settings: settings)
            print("保存するとき",recordTime)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            recordButton.setBackgroundImage(UIImage(named: "microphone2.png"), for: .normal)
            //            playButton.isEnabled = false
            
            
            
        }else{
            
            audioRecorder.stop()
            isRecording = false
            self.soundTableView.reloadData()
            //プレーヤーに音声をセット
            
            print("取り出すとき",recordSound)
            player = try! AVAudioPlayer(contentsOf: getURL(file: recordSound[0]))
            
            
            recordButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
            //            playButton.isEnabled = true
            
        }
    }
    
    ////    再生のボタンが押されたとき、停止ボタンが押されたとき
    //    @IBAction func play(){
    //
    //        if !isPlaying {
    //            print("memo:再生false",isPlaying)
    //
    //            //スライダー.音楽ファイルの長さと同期.
    //            soundSlider.maximumValue = Float(player.duration)
    //
    //            player.play()
    //            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(voiceSaveViewController.timerUpdate), userInfo: nil, repeats: true)
    //            //再生中モードにする
    //            isPlaying = true
    //
    //            playBtn.setBackgroundImage(UIImage(named: "stopBtn.png"),for: .normal)
    //            recordButton.isEnabled = false
    //
    //        }else{
    //            player.currentTime = TimeInterval(currentTimer)
    //            player.stop()
    //            isPlaying = false
    //            playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
    //            recordButton.isEnabled = true
    //
    //        }
    //    }
    
    //    再生終了時に発生する関数
    //    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //        player.stop()
    //        isPlaying = false
    //        playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
    //        recordButton.isEnabled = true
    //    }
    
    //    スライダーが動かされたときに呼ばれる
    //    @IBAction func valueChanged(_ sender: UISlider) {
    //        player.currentTime = TimeInterval(sender.value)
    //    }
    //    音声のURLを取得する
    func getURL(file:String) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent(file)
        print(url)
        return url
    }
    //スライダーのつまみを自動で動かす
    //    @objc func timerUpdate(){
    //        print("memo:currentTimer",currentTimer)
    //        currentTimer = Float(player.currentTime)
    //        soundSlider.value = currentTimer
    //    }
    //テーブルセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordSound.count
    }
    //   セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "voiceTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! voiceTableViewCell
        
        cell.nameField!.text = recordSound[indexPath.row]
        cell.playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
        cell.subView.isHidden = false
        
        return cell
    }
    //    現在時刻をstringで生成する関数
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    //    テーブルビューセルのタッチイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルが選択されました")
        let cell = tableView.cellForRow(at: indexPath) as! voiceTableViewCell
        tableView.beginUpdates()
        cell.expand()
        print("セルが広がりました")
    }
    
    //    次の画面へ遷移
    @IBAction func tapShowVideo(_ sender: UIButton) {
        print("OKpush")
    }
}



