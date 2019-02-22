//
//  videoCollectionViewCell.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/02/05.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit
import AVFoundation
import Photos



class videoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoName: UILabel!
    var videoURL:String!
    var player:AVPlayer!
}
