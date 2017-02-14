import Foundation

// typealias JSON = Any
// typealias JSONObject = [String:Any]
// typealias JSONArray = [JSONObject]
// extension JSONObject: JSON {}
// extension JSONArray: JSON {}

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
