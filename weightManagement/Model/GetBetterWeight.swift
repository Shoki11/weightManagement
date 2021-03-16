//
//  GetBetterWeight.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import Foundation

class GetBetterWeight {
    
    // 適正体重を返す
    func calcBetterWeight() -> String{
        
        // GetUserDataのgetUserDataメソッドはstaticだからGetUserDataをインスタンス化しないで直接使用
        var betterWeight = pow(Double(GetUserData.getUserData(key: "height"))! / 100.00,2) * 22
        
        betterWeight = round(betterWeight * 10)/10
        
        return String(betterWeight)
        
    }
    
}
