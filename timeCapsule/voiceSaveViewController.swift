//
//  voiceSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/20.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation

class voiceSaveViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
//    使う部品の宣言
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
//    使う変数の宣言
//    falseはレコードオフの状態
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(hex: "f9f1d3")
        
        //         影表示用のビュー
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height:  667))
        shadowView.center = CGPoint(x: 375/2, y:667/2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 5

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    @IBAction func record(){
        if !isRecording {
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.allowBluetoothA2DP)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            label.text = "録音中"
            recordButton.setBackgroundImage(UIImage(named: "microphone2.png"), for: .normal)
            playButton.isEnabled = false
            
        }else{
            
            audioRecorder.stop()
            isRecording = false
            
            label.text = "待機中"
            recordButton.setBackgroundImage(UIImage(named: "microphone.png"), for: .normal)
            playButton.isEnabled = true
            
        }
    }
    
    @IBAction func play(){
        if !isPlaying {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
            
            label.text = "再生中"
            playButton.setBackgroundImage(UIImage(named: "stopBtn.png"),for: .normal)
            recordButton.isEnabled = false
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
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
