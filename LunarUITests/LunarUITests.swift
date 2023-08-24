//
//  LunarUITests.swift
//  LunarUITests
//
//  Created by Mani on 24/08/2023.
//

import XCTest

final class LunarUITests: XCTestCase {
  
  override func setUpWithError() throws {
    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
    XCUIDevice.shared.orientation = .portrait
    let tabBarsQuery = XCUIApplication().tabBars
    tabBarsQuery.buttons.element(boundBy: 0).tap()
    snapshot("0FeedView")
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
