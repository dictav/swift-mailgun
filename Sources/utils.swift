import Foundation

protocol JSON {}
typealias JSONObject = [String:JSON]
typealias JSONArray = [JSON]

extension String: JSON {}
extension Int: JSON {}
extension Float: JSON {}
extension Bool: JSON {}
extension Dictionary: JSON {}
extension Array: JSON {}


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

struct Result<T> {
    var val: T?
    var error: Swift.Error?

    init(value: T, error: Swift.Error?) {
        self.val = value
    }

    init(value: T?, error: Swift.Error) {
        self.error = error
    }

    var value: T {
        get {
            return val!
        }
    }
}

typealias ResultCompletion<T> = (Result<T>) -> ()

func result<T>(_ closure: @autoclosure () throws -> T) -> Result<T> {
    do {
        let val = try closure()
        return Result(value: val, error: nil)
    } catch (let err) {
        return Result<T>(value: nil, error: err)
    }
}
