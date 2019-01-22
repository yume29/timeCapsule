//
//  DetailViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/01/22.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var reminderPic: UIImageView!
    @IBOutlet weak var reminderMemo: UITextField!
    
    // CollectionViewControllerから渡されるデータ
    var receiveImage:UIImage? = UIImage(named: "stopBtn.png")
    var receiveMemo:String? = "hoge"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reminderPic.image = receiveImage
        reminderMemo.text = receiveMemo
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
