import XCTest
@testable import PaybackCommon
import SwiftUI

final class PaybackCommonTests: XCTestCase {
    func testBrandBackgroundColorDefined() throws {
        XCTAssertNotNil(Color.brandBackground)
    }
    func testErrorBannerBackgroundColorDefined() throws {
        XCTAssertNotNil(Color.errorBannerBackground)
    }
    func testWarningBannerBackgroundColorDefined() throws {
        XCTAssertNotNil(Color.errorBannerBackground)
    }
    func testInfoBannerBackgroundColorDefined() throws {
        XCTAssertNotNil(Color.errorBannerBackground)
    }
}
