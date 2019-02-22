//
//  secondFutureViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/02/05.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation

class secondFutureViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate{
 
    @IBOutlet weak var voiceTable: UITableView!
    
    @IBOutlet weak var letterField: UITextView!
    
    var gotVoiceList:[String] = []
    var gotLetterList:[String] = []
    
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
    
    //セルの高さを設定
    var tappedCell:Int = 0
    var toggle = true
    var startTime:NSDate?
    
    var scrollView:UIScrollView!
    // Screenの高さ
    var screenHeight:CGFloat!
    // Screenの幅
    var screenWidth:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        letterField.text = gotLetterList[0]

        view.backgroundColor = UIColor(hex: "f9f1d3")
      
        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処
        scrollView.addSubview(voiceTable)
        scrollView.addSubview(letterField)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        // ビューに追加
        self.view.addSubview(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gotVoiceList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceCell", for: indexPath) as! futureTableViewCell
        cell.nameLabel!.text = gotVoiceList[indexPath.row]
        cell.playBtn.setBackgroundImage(UIImage(named: "playBtn.png"), for: .normal)
            cell.soundSlider.value = 0
        
        return cell
        
    }
    
    //    テーブルビューセルのタッチイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let playingIndexPath = IndexPath(row: tappedCell, section: 0)
        let playingCell = tableView.cellForRow(at: playingIndexPath) as! futureTableViewCell
//        if playingCell.player.play(){
//        playingCell.player.stop()
//        }
        
        
        let cell = tableView.cellForRow(at: indexPath) as! futureTableViewCell
        //変数に何行目がを保持
        tappedCell = indexPath.row
        
        // toggle = true 選択されていない
        toggle = !toggle
        
        //選択されたセルを更新
        self.voiceTable.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        //セルが選択状態だったら
//        if toggle {
//            //playerを止める
//            cell.player.stop()
//        }
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

    

}
