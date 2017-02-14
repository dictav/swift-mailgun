import XCTest
@testable import Mailgun

class MailgunTests: XCTestCase {
    static var allTests : [(String, (MailgunTests) -> () throws -> Void)] {
        return [
            ("testResult", testResult),
            ("testFuncResult", testFuncResult),
            ("testDateFrom", testDateFrom),
        ]
    }
}
