//
//  LunarUITests.swift
//  LunarUITests
//
//  Created by Mani on 24/08/2023.
//

import XCTest

final class LunarUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    
    app = XCUIApplication()
    setupSnapshot(app)
    app.launch()
    
  }
  
  func testTakeScreenshots() {
    let scrollView = app.scrollViews.element(boundBy: 0)    
    snapshot("01-WelcomeScreen")

    scrollView.swipeLeft()
    snapshot("02-WelcomeScreen")
    
    scrollView.swipeLeft()
    snapshot("03-WelcomeScreen")
    
    scrollView.swipeLeft()
    snapshot("04-WelcomeScreen")
    
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
