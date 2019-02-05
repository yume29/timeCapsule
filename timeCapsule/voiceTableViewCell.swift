//
//  voiceTableViewCell.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/21.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation

class voiceTableViewCell: UITableViewCell, AVAudioPlayerDelegate{
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var soundSlider: UISlider!
    @IBOutlet weak var playBtnShadow: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var playSound:String!
    var playTime:String!
    var player:AVAudioPlayer = AVAudioPlayer()
    var playerItem:AVPlayerItem?
    var isPlaying = false
    var currentTimer:Float = 0
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //    再生のボタンが押されたとき、停止ボタンが押されたとき
    @IBAction func play(){
        
        if !isPlaying {
            print("memo:再生false",isPlaying)
            //スライダー.音楽ファイルの長さと同期.
            soundSlider.maximumValue = Float(player.duration)
            print("音の長さ",player.duration)
            player.volume = 2.0
            player.play()
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(voiceTableViewCell.timerUpdate), userInfo: nil, repeats: true)
            //再生中モードにする
            isPlaying = true
            playBtn.setBackgroundImage(UIImage(named: "stopBtn.png"),for: .normal)
            //            recordButton.isEnabled = false
            
        }else{
            player.currentTime = TimeInterval(currentTimer)
            player.stop()
            print("停止中")
            isPlaying = false
            playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
        }
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
        
        if currentTimer == 0.0 || isPlaying == false{
            playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
            isPlaying = false
            
        }else{
            playBtn.setBackgroundImage(UIImage(named: "stopBtn.png"),for: .normal)
            isPlaying = true
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
}
