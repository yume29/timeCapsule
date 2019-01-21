//
//  voiceTableViewCell.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/21.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation

class voiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var soundSlider: UISlider!
    @IBOutlet weak var playBtnShadow: UIView!
    @IBOutlet weak var playBtn: UIButton!
    
    var player:AVAudioPlayer = AVAudioPlayer()
    var playerItem:AVPlayerItem?
    var isRecording = false
    var isPlaying = false
    var currentTimer:Float = 0
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //    セルを開くときの関数
    func expand() {
        if self.subView.isHidden {
            //再生ボタン
            playBtnShadow.layer.shadowColor = UIColor.black.cgColor
            playBtnShadow.layer.shadowOpacity = 0.5
            playBtnShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
            playBtnShadow.layer.shadowRadius = 5
            
            self.subView.isHidden = false
            self.soundSlider.isHidden = false
            self.playBtnShadow.isHidden = false
            self.playBtn.isHidden = false
        }
    }
    //    セルを閉じるときの関数
    func contract() {
        if !self.subView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.soundSlider.isHidden = true
                self.playBtnShadow.isHidden = true
                self.playBtn.isHidden = true
                self.subView.isHidden = true
            }
        }
    }
    //    再生のボタンが押されたとき、停止ボタンが押されたとき
    @IBAction func play(){
        
        if !isPlaying {
            print("memo:再生false",isPlaying)
            
            //スライダー.音楽ファイルの長さと同期.
            soundSlider.maximumValue = Float(player.duration)
            
            player.play()
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(voiceTableViewCell.timerUpdate), userInfo: nil, repeats: true)
            //再生中モードにする
            isPlaying = true
            
            playBtn.setBackgroundImage(UIImage(named: "stopBtn.png"),for: .normal)
//            recordButton.isEnabled = false
            
        }else{
            player.currentTime = TimeInterval(currentTimer)
            player.stop()
            isPlaying = false
            playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
//            recordButton.isEnabled = true
            
        }
    }

    //    再生終了時に発生する関数
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        isPlaying = false
        playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
//        recordButton.isEnabled = true
    }
    //    スライダーが動かされたときに呼ばれる
    @IBAction func valueChanged(_ sender: UISlider) {
        player.currentTime = TimeInterval(sender.value)
    }
    //スライダーのつまみを自動で動かす
    @objc func timerUpdate(){
        print("memo:currentTimer",currentTimer)
        currentTimer = Float(player.currentTime)
        soundSlider.value = currentTimer
    }
}
