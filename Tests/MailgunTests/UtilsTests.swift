import XCTest
@testable import Mailgun

extension MailgunTests {
    func testResult() {
        let ret = Result(value: 1, error: nil)
        XCTAssertNil(ret.error)
        XCTAssertEqual(ret.val, 1)
    }

    func testFuncResult() {
        func throwFunc(str: String?) throws -> String {
            guard let s = str else {
                throw Error(message:"string is nil")
            }
            return s
        }

        var ret = result{ try throwFunc(str: "hoge") }
        XCTAssertNil(ret.error)
        XCTAssertEqual(ret.value, "hoge")

        ret = result{ try throwFunc(str: nil) }
        XCTAssertNotNil(ret.error)
        XCTAssertNil(ret.val)
    }

    func testDateFrom() {
        var date = DateFrom("Wed, 10 Jul 2013 19:26:52 GMT")
        XCTAssertNotNil(date)

        date = DateFrom("Wed Feb 15 00:16:07 JST 2017")
        XCTAssertNil(date)
    }
}
