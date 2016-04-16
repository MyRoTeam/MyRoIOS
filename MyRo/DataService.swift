//
//  DataService.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/16/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import Foundation


class DataService {
    
    static let dataService = DataService()
    
    
    private let _BASE_REF = Firebase(url: "https://myro.firebaseio.com")
    
    private let _INS_REF = Firebase(url: "https://myro.firebaseio.com/instructions")
    
    var BASE_REF: Firebase {
        
        return _BASE_REF
        
    }
    

    var INS_REF : Firebase {
        
        return _INS_REF
        
    }
    
    func sendInstruction(ins: Dictionary<String, AnyObject>){
        
        let newInstruction = INS_REF.childByAutoId()
        
        newInstruction.setValue(ins)
        
        
        
    }
    
    
    
}