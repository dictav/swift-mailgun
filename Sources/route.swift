import Foundation

func extractMatchRecipient(_ str: String) -> String? {
    // Matches a string like 'match_recipient(".*@bar.com")'
    let regexp = try! NSRegularExpression(pattern: "^match_recipient\\(\"([^\"]+)\"\\)$")
    let range = NSRange(location: 0, length: str.characters.count)
    guard let m = regexp.firstMatch(in: str, options: [], range: range) else {
        return nil
    }

    return substring(in: str, range: m.rangeAt(1))
}

func extractMatchHeader(_ str: String) -> (key: String, value: String)? {
    // Matches a string like 'match_header("subject", ".*support")'
    let regexp = try! NSRegularExpression(pattern: "^match_header\\(\"([^\"]+)\", *\"([^\"]+)\"\\)$")
    let range = NSRange(location: 0, length: str.characters.count)
    guard let m = regexp.firstMatch(in: str, options: [], range: range) else {
        return nil
    }

    guard let key = substring(in: str, range: m.rangeAt(1)) else {
        return nil
    }

    guard let value = substring(in: str, range: m.rangeAt(2)) else {
        return nil
    }

    return (key: key, value: value)
}

enum RouteFilter {
    case matchRecipient(NSRegularExpression)
    case matchMatchHeader(key: String, value: NSRegularExpression)
    case catchAll

    init(expression: String) throws {
        if expression == "catch_all()" {
            self = .catchAll
            return
        }

        if let recipient = extractMatchRecipient(expression) {
            self = .matchRecipient(try! NSRegularExpression(pattern: recipient))
            return
        }

        if let (key, value) = extractMatchHeader(expression) {
            self = .matchMatchHeader(key: key, value: try! NSRegularExpression(pattern: value))
            return
        }

        throw Error(message: "Unexpected expression for RouteFilter: \(expression)")
    }

    var description: String {
        switch self {
        case .matchRecipient(let recipient):
            return "match_recipient(\"\(recipient)\")"
        case .matchMatchHeader(let key, let value):
            return "match_header(\"\(key)\", \"\(value)\")"
        case .catchAll:
            return "catch_all()"
        }
    }
}

enum RouteAction {
    case forward(String)
    case store
    case stop

    init?(expression: String) {
        if expression == "store()" {
            self = .store
            return
        }

        if expression == "stop()" {
            self = .stop
            return
        }

        guard !expression.hasPrefix("forward(\"") || !expression.hasSuffix("\")") else {
            return nil
        }

        let s = expression.index(expression.startIndex, offsetBy: 9)
        let e = expression.index(expression.endIndex, offsetBy: -2)

        self = .forward(expression.substring(with: s..<e))
    }

    var description: String {
        switch self {
        case .forward(let email):
            return "forward(\"\(email)\")"
        case .store:
            return "store()"
        case .stop:
            return "stop()"
        }
    }
}

struct Route {
    var id: String
    var description: String
    var createdAt: Date
    var actions: [RouteAction]
    var priority: Int
    var expression: RouteFilter
}

extension Route {
    init?(JSON: JSONObject) {
        guard
            let id = JSON["id"] as? String,
            let description = JSON["description"] as? String,
            let createdAt = JSON["created_at"] as? String,
            let actions = JSON["actions"] as? JSONArray,
            let priority = JSON["priority"] as? Int,
            let expression = JSON["expression"] as? String
            else { return nil }

        guard let date = DateFrom(createdAt) else {
            return nil
        }

        let filterResult = result {
            try RouteFilter(expression: expression)
        }
        guard filterResult.error == nil else {
            return nil
        }

        var routeActions = [RouteAction]()
        for json in actions {
            guard let exp = json as? String else {
                continue
            }
            if let act = RouteAction(expression: exp) {
                routeActions.append(act)
            }
        }

        self.id = id
        self.description = description
        self.createdAt = date
        self.actions = routeActions
        self.priority = priority
        self.expression = filterResult.value
    }

}

extension Route {
    static func list(limit: Int = 100, skip: Int = 0) -> Result<JSON> {
        return getSync(path: "/routes", opts: ["skip": skip.description, "limit": limit.description])
    }

    static func create(description: String, filter: RouteFilter, actions: [RouteAction], priority: Int = 0) -> Result<JSON> {
        let err = Error(message: "please implement")
        return Result<JSON>(value: nil, error: err)
    }

    static func update(_ route: Route) -> Error? {
        return Error(message: "please implement")
    }

    static func delete(id: String) -> Error? {
        return Error(message: "please implement")
    }
}
