//
//  voiceSaveViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2018/12/20.
//  Copyright © 2018年 Yume Ichinose. All rights reserved.
//

import UIKit

class voiceSaveViewController: UIViewController {

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

        // Do any additional setup after loading the view.
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
