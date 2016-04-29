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
    private let _IMG_REF = Firebase(url: "https://myro.firebaseio.com/images")
    private let _DIARY_ENTRY_REF = Firebase(url: "https://myro.firebaseio.com/diary_entries")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var INS_REF : Firebase {
        return _INS_REF
    }
    
    var IMG_REF : Firebase {
        return _IMG_REF
    }
    
    var DIARY_ENTRY_REF: Firebase {
        return _DIARY_ENTRY_REF
    }
    
    /*func sendInstruction(ins: Dictionary<String, AnyObject>){
        let newInstruction = INS_REF.childByAutoId()
        newInstruction.setValue(ins)
    }*/
    
    func sendInstruction(instruction: RobotInstruction) {
        let newInstruction = INS_REF.childByAutoId()
        newInstruction.setValue(instruction.toJSON())
        newInstruction.removeValue()
    }
    
    func sendInstruction(instruction: String) {
        let newInstruction = INS_REF.childByAutoId()
        newInstruction.setValue(instruction)
        newInstruction.removeValue()
    }
    
    func saveDiaryEntry(entry: DiaryEntry) {
        let newEntry = DIARY_ENTRY_REF.childByAutoId()
        newEntry.setValue(entry.toJSON())
    }
    
    /*func savePhoto(imageData : NSData){
        let base64String = imageData.base64EncodedStringWithOptions([])
        //let base64string : String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let baseString = ["baseString" : base64String]
        let image = ["image" : baseString]
        
        let newImage = IMG_REF.childByAutoId()
        newImage.setValue(image)
    }*/
}