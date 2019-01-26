//
//  reminder.swift
//  
//
//  Created by 一ノ瀬由芽 on 2019/01/25.
//

import Foundation
import RealmSwift

//管理するデータ構造を定義
//必ずobjectを継承する
class Reminder: Object{
    //保持したい値の宣言
    //dynamic　var 変数名：型　= 初期値
    @objc dynamic var image: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var alerm: Date = Date()
    @objc dynamic var created: Date = Date()
    
}

