import XCTest
@testable import Mailgun

extension MailgunTests {
    func testGetList() {
        guard let key = ProcessInfo.processInfo.environment["MAILGUN_API_KEY"] else {
            XCTAssert(false, "PLEASE SET $MAILGUN_API_KEY")
            return
        }

        Mailgun(key: key)
        let result = Domain.getList()
        XCTAssertNil(result.error)
    }
}
