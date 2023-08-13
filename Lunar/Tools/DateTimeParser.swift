//
//  DateTimeParser.swift
//  Lunar
//
//  Created by Mani on 13/08/2023.
//

import Foundation

class DateTimeParser {
  private let dateFormatter = DateFormatter()

  init() {
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
  }

  func parseDateTime(_ dateString: String) -> Date? {
    let possibleFormats = [
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
      "yyyy-MM-dd'T'HH:mm:ss",
      "yyyy-MM-dd'T'HH:mm:ss.SSS",
    ]

    for format in possibleFormats {
      dateFormatter.dateFormat = format
      if let date = dateFormatter.date(from: dateString) {
        return date
      }
    }

    return nil
  }

  func timeAgoString(from dateString: String) -> String {
    guard let parsedDate = parseDateTime(dateString) else {
      return ""
    }

    let currentDate = Date()
    let timeInterval = Int(currentDate.timeIntervalSince(parsedDate))

    if timeInterval < 60 {
      return "\(timeInterval) minute\(timeInterval == 1 ? "" : "s") ago"
    } else if timeInterval < 3600 {  // 60 minutes
      let hours = timeInterval / 3600
      let minutes = (timeInterval % 3600) / 60
      if minutes == 0 {
        return "\(hours) hour\(hours == 1 ? "" : "s") ago"
      } else {
        return
          "\(hours) hour\(hours == 1 ? "" : "s") \(minutes) minute\(minutes == 1 ? "" : "s") ago"
      }
    } else if timeInterval < 86400 {  // 24 hours
      let hours = timeInterval / 3600
      return "\(hours) hour\(hours == 1 ? "" : "s") ago"
    } else {
      let days = timeInterval / 86400
      return "\(days) day\(days == 1 ? "" : "s") ago"
    }
  }
}
