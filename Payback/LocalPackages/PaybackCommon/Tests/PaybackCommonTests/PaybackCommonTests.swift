import XCTest
@testable import PaybackCommon
import SwiftUI

final class PaybackCommonTests: XCTestCase {
    func testBrandBackgroundColorDefined() throws {
        XCTAssertNotNil(Color.brandBackground)
    }
}
