//
//  NSDateFormatter+EasyDate.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

extension NSDateComponents {
    internal func fromDate(date: NSDate, region: DateRegion = DateRegion()) -> NSDate? {
        return region.calendar.dateByAddingComponents(self, toDate: date, options: [])
    }
    
    public func fromNow(region: DateRegion = DateRegion()) -> NSDate {
        return self.fromDate(NSDate(), region: region)!
    }
    
    public func ago(region: DateRegion = DateRegion()) -> NSDate {
        for unit in [NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Year, NSCalendarUnit.Hour, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond] {
            let value = self.valueForComponent(unit)
            guard value != NSDateComponentUndefined else { continue }
            self.setValue(-1 * value, forComponent: unit)
        }
        
        return region.calendar.dateByAddingComponents(self, toDate: NSDate(), options: [])!
    }
}
