//
//  SabadBanDevUITests.swift
//  SabadBanDevUITests
//
//  Created by PC22 on 11/16/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import XCTest

class SabadBanDevUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPortfolioAdd() {
        
        let app = XCUIApplication()
        app.buttons["ورود مهمان"].tap()
        app.navigationBars["شاخص"].buttons["Menu"].tap()
        app.tables.staticTexts["پرتفوی"].tap()
//        app.tables.containingType(.StaticText, identifier:"Button").element.tap()

        app.coordinateWithNormalizedOffset(CGVector(dx: app.frame.maxX, dy: app.frame.maxY)).tap()
        
//        XCUIApplication().tables.containingType(.StaticText, identifier:"Button").element.tap()
        
        app.coordinateWithNormalizedOffset(CGVector(dx: 275 , dy: 465)).tap()
        
        debugPrint("salam")
        
    }
    
}
