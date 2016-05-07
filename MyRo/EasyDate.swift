//
//  EasyDate.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

public struct EasyDate {
    public let region: DateRegion!
    public var calendar: NSCalendar! { return region.calendar }
    public var timeZone: NSTimeZone! { return region.timeZone }
    public var locale: NSLocale! { return region.locale }
    public let date: NSDate!
    
    internal init(dateComponents: NSDateComponents) {
        let region = DateRegion(dateComponents: dateComponents)
        self.init(date: region.calendar.dateFromComponents(dateComponents), region: region)
    }
    
    internal init(
        date: NSDate? = nil,
        region: DateRegion? = nil)
    {
        self.date = date ?? NSDate()
        self.region = region ?? DateRegion()
    }
    
    public init(
        month: Int,
        day: Int,
        year: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        nanosecond: Int = 0,
        region: DateRegion? = nil)
    {
        let dateComponents = NSDateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.nanosecond = nanosecond
        dateComponents.calendar = region?.calendar
        dateComponents.timeZone = region?.timeZone
        
        self.init(dateComponents: dateComponents)
    }
    
    public init?(string: String, format: String, region: DateRegion = DateRegion()) {
        let formatter = EasyDateShared.sharedDateFormatter
        formatter.calendar = region.calendar
        formatter.timeZone = region.timeZone
        formatter.locale = region.locale
        
        formatter.dateFormat = format
        guard let date = formatter.dateFromString(string) else { return nil }
        
        self.init(date: date, region: region)
    }
}
