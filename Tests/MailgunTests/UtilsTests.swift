import XCTest
@testable import Mailgun

extension MailgunTests {
    func testDateFrom() {
        var date = DateFrom("Wed, 10 Jul 2013 19:26:52 GMT")
        XCTAssertNotNil(date)

        date = DateFrom("Wed Feb 15 00:16:07 JST 2017")
        XCTAssertNil(date)
    }
}
