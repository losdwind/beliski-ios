//
//  Helplers.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/17.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}


func convertFIRTimestamptoString(timestamp: Timestamp?) -> String {
    if timestamp != nil {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp!.dateValue(), to: Date()) ?? "Timestamp cannot be converted"
    } else {
        return "nil"
    }

}

func convertFIRTimetamptoWeekdayString(timestamp:Timestamp?) -> String {
    if timestamp != nil {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: timestamp!.dateValue())
    } else {
        return "Timestamp is nil"
    }
}
