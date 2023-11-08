//
//  TimestampParser.swift
//  Lunar
//
//  Created by Mani on 08/11/2023.
//

import Foundation

class TimestampParser {
  func parse(originalTimestamp: String) -> String? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [
      .withInternetDateTime,
      .withFractionalSeconds,
      .withTimeZone,
      .withColonSeparatorInTime,
      .withDashSeparatorInDate,
    ]

    if let date = dateFormatter.date(from: originalTimestamp) {
      let timeAgo = formatToTimeAgo(date: date)
      return timeAgo
    } else if let date = dateFormatter.date(from: "\(originalTimestamp)Z") {
      let timeAgo = formatToTimeAgo(date: date)
      return timeAgo
    } else if let date = dateFormatter.date(from: "\(originalTimestamp).000Z") {
      let timeAgo = formatToTimeAgo(date: date)
      return timeAgo
    } else {
      print("Error parsing timestamp: \(originalTimestamp)")
      return nil
    }
  }

  private func formatToCustomString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS Z"
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter.string(from: date)
  }

  private func formatToTimeAgo(date: Date) -> String {
    let secondsAgo = date.timeIntervalSinceNow.magnitude
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
    formatter.unitsStyle = .full
    formatter.maximumUnitCount = 1
    let string = formatter.string(from: secondsAgo)
    return string ?? "formatToTimeAgo error"
  }
}
