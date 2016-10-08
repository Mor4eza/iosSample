//
//  SabadBanUITests.swift
//  SabadBanUITests
//
//  Created by Morteza Gharedaghi on 10/8/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import XCTest

class SabadBanUITests: XCTestCase {
        
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

        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["شاخص"].tap()
        tablesQuery.staticTexts["شاخص قيمت(وزني-ارزشي)"].tap()
        tablesQuery.staticTexts["شاخص كل (هم وزن)"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["شرکت های موجود در شاخص"].tap()
        app.tables["Empty list"].tap()
        tablesQuery.staticTexts["پرتفوی"].tap()
        
        let buttonTable = app.tables.containingType(.StaticText, identifier:"Button").element
        buttonTable.tap()
        tablesQuery.staticTexts["مظنه فروش:"].tap()
        tabBarsQuery.buttons["جزییات"].tap()
        app.navigationBars["آپ"].buttons["بازگشت"].tap()
        buttonTable.tap()
        buttonTable.tap()

    }
    
}
