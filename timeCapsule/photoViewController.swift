//
//  photoViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/18.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit

class photoViewController: UIViewController {
    
    //前の画面がら画像データを受け取るための、変数。
    
    var getPhoto:UIImage!


    @IBOutlet weak var getPhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageViewに画像を入れる
        
        getPhotoView.image = getPhoto
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


