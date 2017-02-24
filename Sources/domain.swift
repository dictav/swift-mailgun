import Foundation
import Result

enum SpamAction: String {
    case disabled
    case tag
}

struct Domain {
    var createdAt: Date
    var name: String
    var smtpLogin: String
    var smtpPassword: String
    var spamAction: SpamAction
    var state: String
    var wildcard: Bool
}

extension Domain {
    init?(JSON: [String:Any]) {
        guard
            let createdAt = JSON["created_at"] as? String,
            let name = JSON["name"] as? String,
            let smtpLogin = JSON["smtp_login"] as? String,
            let smtpPassword = JSON["smtp_password"] as? String,
            let spamAction = JSON["spam_action"] as? String,
            let state = JSON["state"] as? String,
            let wildcard = JSON["wildcard"] as? Bool
            else { return nil }

        guard let date = DateFrom(createdAt) else {
            return nil
        }

        self.createdAt = date
        self.name = name
        self.smtpLogin = smtpLogin
        self.smtpPassword = smtpPassword
        self.spamAction = SpamAction(rawValue: spamAction) ?? SpamAction.disabled
        self.state = state
        self.wildcard = wildcard
    }
}

extension Domain {
    static func list(limit: Int = 100, skip: Int = 0) -> Result<JSON,Error> {
        return getSync(path: "/domains", opts: ["skip": skip.description, "limit": limit.description])
    }
}
