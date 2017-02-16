import XCTest
@testable import Mailgun

extension MailgunTests {
    func testRouteList() {
        let result = Route.list()
        XCTAssertNil(result.error)

        let obj = result.value as! JSONObject
        let arr = obj["items"] as! JSONArray
        for json in arr {
            XCTAssertNotNil(Route(JSON: json as! JSONObject))
        }
    }
    func testRoutePost() {
        // var result = Route.create(
        //     description: "test route",
        //     filter: RouteFilter.matchRecipient(
        //         try! NSRegularExpression(pattern: "dictav@gmail.com")
        //     ),
        //     actions: [
        //         RouteAction.stop
        //     ],
        //     priority: 0
        // )

        // XCTAssertNil(result.error)
        // let obj = result.value as! JSONObject
        // let routeObject = obj["route"] as! JSONObject

        // var route = Route(JSON: routeObject)!
        // route.description = "updated test route"
        // XCTAssertNil(Route.update(route))


        // XCTAssertNil(Route.delete(id: route.id))
    }
}
