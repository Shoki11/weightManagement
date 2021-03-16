//
//  GetUserData.swift
//  weightManagement
//
//  Created by cmStudent on 2021/03/15.
//

import Foundation

class GetUserData {
    
    // Key値を指定して取ってくる
    static func getUserData(key : String) -> String {
        
        var result = String()
        
        // もしUserDefaultsのKeyがnilじゃなかったらresultの中に入れる
        if UserDefaults.standard.object(forKey: key) != nil {
            
            result = UserDefaults.standard.object(forKey: key) as! String
            
        }
        
        return result
        
    }
    
}

