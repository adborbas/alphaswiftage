import XCTest

@testable import AlphaSwiftage

class APIHostFactoryTestCase: XCTestCase {
    func testExpectedHostIsCreated() {
        let native = APIHostFactory.shared.host(for: .native(apiKey: ""))
        XCTAssert(native is NativeAPIHost)
        
        let rapid = APIHostFactory.shared.host(for: .rapidAPI(apiKey: ""))
        XCTAssert(rapid is RapidAPIHost)
    }
}
