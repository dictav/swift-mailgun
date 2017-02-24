import Foundation
import Result

func DateFrom(_ str: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
    return dateFormatter.date(from: str)
}

struct Error: Swift.Error {
    var message: String
}

typealias ResultCompletion<Value,Error: Swift.Error> = (Result<Value,Error>) -> ()

func substring(in str: String, range: NSRange) -> String? {
    guard range.location != NSNotFound else {
        return nil
    }

    let start = str.index(str.startIndex, offsetBy: range.location)
    let end = str.index(str.startIndex, offsetBy: range.location + range.length)
    return str.substring(with: start..<end)
}
