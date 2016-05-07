//
//  DateRegion.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

public struct DateRegion: Equatable {
    public let calendar: NSCalendar!
    
    public var timeZone: NSTimeZone {
        return self.calendar.timeZone
    }
    
    public var locale: NSLocale {
        return self.calendar.locale ?? NSLocale.currentLocale()
    }
    
    internal init (
        calendar: NSCalendar,
        timeZone: NSTimeZone? = nil,
        locale: NSLocale? = nil)
    {
        self.calendar = calendar
        self.calendar.timeZone = timeZone ?? calendar.timeZone ?? NSTimeZone.defaultTimeZone()
        self.calendar.locale = locale ?? calendar.locale ?? NSLocale.currentLocale()
    }
    
    internal init(dateComponents: NSDateComponents) {
        let calendar = dateComponents.calendar ?? NSCalendar.currentCalendar()
        
        self.init(calendar: calendar, timeZone: dateComponents.timeZone, locale: calendar.locale)
    }
    
    internal init() {
        self.init(calendar: NSCalendar.currentCalendar())
    }
}

public func ==(left: DateRegion, right: DateRegion) -> Bool {
    return left.calendar.calendarIdentifier == right.calendar.calendarIdentifier &&
           left.timeZone.secondsFromGMT == right.timeZone.secondsFromGMT         &&
           left.locale.localeIdentifier == right.locale.localeIdentifier
}
