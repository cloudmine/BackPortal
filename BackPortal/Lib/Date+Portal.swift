import Foundation

extension Date {
    
    var isToday: Bool {
        return isSameDay(as: Date())
    }
    
    var isYesterday: Bool {
        let yesterDate = Date(timeInterval: -24*60*60, since: Date())
        return isSameDay(as: yesterDate)
    }
    
    func isSameDay(as date: Date) -> Bool {
        let selfComponents = NSDateComponents(date: self, calendar: Calendar.current) as DateComponents
        let otherComponents = NSDateComponents(date: date, calendar: Calendar.current) as DateComponents
        
        return
            selfComponents.year == otherComponents.year &&
            selfComponents.month == otherComponents.month &&
            selfComponents.day == otherComponents.day
    }
}
