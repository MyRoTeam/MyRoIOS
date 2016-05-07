//
//  Int+EasyDate.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

extension Int {
    public var months: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.month = self
        
        return dateComponents
    }
    
    public var days: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.day = self
        
        return dateComponents
    }
    
    public var years: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.year = self
        
        return dateComponents
    }
    
    public var hours: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.hour = self
        
        return dateComponents
    }
    
    public var minutes: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.minute = self
        
        return dateComponents
    }
    
    public var seconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.second = self
        
        return dateComponents
    }
    
    public var nanoseconds: NSDateComponents {
        let dateComponents = NSDateComponents()
        dateComponents.nanosecond = self
        
        return dateComponents
    }
}
