//
//  DataService.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/16/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import Foundation

/// Wrapper class of Firebase services
class DataService {
    static let dataService = DataService()
    
    /// Firebase base url reference
    private let _BASE_REF = Firebase(url: "https://myro.firebaseio.com")
    
    /// Firebase image reference
    private let _IMG_REF = Firebase(url: "https://myro.firebaseio.com/images")
    
    /// Firebase diary entries reference
    private let _DIARY_ENTRY_REF = Firebase(url: "https://myro.firebaseio.com/diary_entries")
    
    var BASE_REF: Firebase {
        return _BASE_REF
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
    
    /**
     Saves the diary entry to firebase
     
     - parameter entry: Diary entry to save to firebase
     */
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