import XCTest
@testable import Mailgun

class MailgunTests: XCTestCase {
    override func setUp() {
        guard let key = ProcessInfo.processInfo.environment["MAILGUN_API_KEY"] else {
            XCTAssert(false, "PLEASE SET $MAILGUN_API_KEY")
            return
        }

        Mailgun(key: key)
    }

    static var allTests : [(String, (MailgunTests) -> () throws -> Void)] {
        return [
            ("testResult", testResult),
            ("testFuncResult", testFuncResult),
            ("testDateFrom", testDateFrom),
        ]
    }
}
