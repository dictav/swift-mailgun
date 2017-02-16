import XCTest
@testable import Mailgun

extension MailgunTests {
    func testDomainList() {
        let result = Domain.list()
        XCTAssertNil(result.error)
    }
}
