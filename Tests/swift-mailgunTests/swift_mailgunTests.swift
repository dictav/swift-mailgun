import XCTest
@testable import swift_mailgun

class swift_mailgunTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(swift_mailgun().text, "Hello, World!")
    }


    static var allTests : [(String, (swift_mailgunTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
