import XCTest
@testable import Mailgun

extension MailgunTests {
    func testDomainList() {
        guard let key = ProcessInfo.processInfo.environment["MAILGUN_API_KEY"] else {
            XCTAssert(false, "PLEASE SET $MAILGUN_API_KEY")
            return
        }

        Mailgun(key: key)
        let result = Domain.list()
        XCTAssertNil(result.error)
    }
}
