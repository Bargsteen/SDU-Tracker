//
//  Converters.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 16/09/2018.
//

import Foundation

func maybeStringToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ssZ"
    return dateFormatter.date(from: dateString)
}

// Remember to change the values here, if EventType is changed.
func eventTypeToString(_ eventType: Int) -> String {
    return eventType == 1 ? "Started" : "Ended"
}
