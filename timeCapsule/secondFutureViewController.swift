//
//  secondFutureViewController.swift
//  timeCapsule
//
//  Created by 一ノ瀬由芽 on 2019/02/05.
//  Copyright © 2019年 Yume Ichinose. All rights reserved.
//

import UIKit

class secondFutureViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
 
    @IBOutlet weak var voiceTable: UITableView!
    
    @IBOutlet weak var letterField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    view.backgroundColor = UIColor(hex: "f9f1d3")
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceCell", for: indexPath)
        
        return cell
        
    }
    

}
