//
//  videoViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/08.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class videoViewController: UIViewController {

    
    //前の画面がら画像データを受け取るための、変数。
    
    var getVideo:UIImage!
    
    
    @IBOutlet weak var getVideoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageViewに画像を入れる
        
        getVideoView.image = getVideo
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    }
    

