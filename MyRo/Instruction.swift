//
//  Instruction.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/16/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import Foundation

class Instruction {
    
    private var _insRef: Firebase!
    private var _insKey: String!
    private var _insSpeed: Int!
    private var _insDirection: String!
    private var _insTarget : String!
    
    
    var insKey : String {
        return _insKey
    }
    
    var insSpeed : Int {
        
        return _insSpeed
        
    }
    
    var insDirection : String {
        
        return _insDirection
    }
    

    var insTarget : String {
        
        return _insTarget
        
    }
    
    
    init(key: String, dictionary: Dictionary<String,AnyObject>){
        
        self._insKey = key
        
        if let speed = dictionary["speed"] as? Int {
            
            self._insSpeed = speed
            
        }
        
        if let direction = dictionary["direction"] as? String {
            
            self._insDirection = direction
            
        }
        
        if let target = dictionary["target"] as? String {
            
            self._insTarget = target
            
        }
        
        self._insRef = DataService.dataService.INS_REF.childByAppendingPath(self._insKey)
        
        
    }
    
    
    
}
