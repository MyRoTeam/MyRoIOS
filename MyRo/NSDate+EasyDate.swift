//
//  NSDate+EasyDate.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/11/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

internal enum TimeAgo: CustomStringConvertible {
    case Future
    case JustNow
    case MinutesAgo(Int)
    case HoursAgo(Int)
    case Yesterday(NSDate)
    case LastWeek(NSDate)
    case LastMonth(NSDate)
    case LastYear(NSDate)
    case MoreThanAYear(NSDate)
    
    internal var description: String {
        switch(self) {
        case .Future:
            return "Future"
            
        case .JustNow:
            return "Just now"
            
        case .MinutesAgo(let mins):
            return "\(mins) \(mins > 1 ? "mins" : "min") ago"
            
        case .HoursAgo(let hours):
            return "\(hours) \(hours > 1 ? "hours" : "hour") ago"
            
        case .Yesterday(let date):
            EasyDateShared.sharedDateFormatter.dateFormat = "h:mm a"
            return "Yesterday at \(EasyDateShared.sharedDateFormatter.stringFromDate(date))"
            
        case .LastWeek(let date):
            EasyDateShared.sharedDateFormatter.dateFormat = "EEEE 'at' h:mm a"
            return EasyDateShared.sharedDateFormatter.stringFromDate(date)
            
        case .LastMonth(let date):
            EasyDateShared.sharedDateFormatter.dateFormat = "MMM d 'at' h:mm a"
            return EasyDateShared.sharedDateFormatter.stringFromDate(date)
            
        case .LastYear(let date):
            EasyDateShared.sharedDateFormatter.dateFormat = "MMM d"
            return EasyDateShared.sharedDateFormatter.stringFromDate(date)
            
        case .MoreThanAYear(let date):
            EasyDateShared.sharedDateFormatter.dateFormat = "MMM d, yyyy"
            return EasyDateShared.sharedDateFormatter.stringFromDate(date)
        }
    }
}

extension NSDate {
    private static let secsInMin = 60
    private static let secsInHour = secsInMin * 60
    private static let secsInDay = secsInHour * 24
    private static let secsInWeek = secsInDay * 7
    private static let secsInMonth = secsInDay * 31
    private static let secsInYear = secsInDay * 365
    
    public var timeAgoString: String {
        let seconds = -Int(self.timeIntervalSinceNow)
        var timeAgo = TimeAgo.JustNow
        
        if (seconds < 0) {
            timeAgo = .Future
        } else if (seconds < NSDate.secsInMin) {
            timeAgo = .JustNow
        } else if (seconds < NSDate.secsInHour) {
            timeAgo = .MinutesAgo(seconds / NSDate.secsInMin)
        } else if (self.isToday()) {
            timeAgo = .HoursAgo(seconds / NSDate.secsInHour)
        } else if (self.isYesterday()) {
            timeAgo = .Yesterday(self)
        } else if (seconds < NSDate.secsInWeek) {
            timeAgo = .LastWeek(self)
        } else if (seconds < NSDate.secsInMonth) {
            timeAgo = .LastMonth(self)
        } else if (seconds < NSDate.secsInYear) {
            timeAgo = .LastYear(self)
        } else {
            timeAgo = .MoreThanAYear(self)
        }
        
        return timeAgo.description
    }
    
    public func dateString(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String? {
        let formatter = EasyDateShared.sharedDateFormatter
        formatter.dateFormat = format
        
        return formatter.stringFromDate(self)
    }
    
    public convenience init(month: Int, day: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        let date = EasyDate(month: month, day: day, year: year, hour: hour, minute: minute, second: second).date
        self.init(timeIntervalSinceNow: date.timeIntervalSinceNow)
    }
    
    private func isToday() -> Bool {
        let now = NSDate()
        EasyDateShared.sharedDateFormatter.dateFormat = "yyyy-MM-dd"
        
        return EasyDateShared.sharedDateFormatter.stringFromDate(self) == EasyDateShared.sharedDateFormatter.stringFromDate(now)
    }
    
    private func isYesterday() -> Bool {
        let yesterday = 1.days.ago()
        EasyDateShared.sharedDateFormatter.dateFormat = "yyyy-MM-dd"
        
        return EasyDateShared.sharedDateFormatter.stringFromDate(self) == EasyDateShared.sharedDateFormatter.stringFromDate(yesterday)
    }
}