//
//  BesedkaUITests.swift
//  BesedkaUITests
//
//  Created by Ivan Kopiev on 05.05.2021.
//

import XCTest

class BesedkaUITests: XCTestCase {

    func testProfileVCHasTwoTextfileds() throws {

         let app = XCUIApplication()
         app.launch()
         app.navigationBars["Tinckoff Chat"].otherElements.children(matching: .image).element.tap()

         let editButton = app.buttons["Edit"]
         editButton.tap()

         let nameTextfield = app.textFields["NameTextfield"]
         XCTAssertTrue(nameTextfield.exists)

         nameTextfield.tap()
         nameTextfield.typeText("Ivan Kopiev")
         app.buttons["Next:"].tap()

         let descriptionTextView = app.textViews["DescriptionTextView"]
         descriptionTextView.typeText("iOS Developer :D")

         let cityTextField = app.textFields["CityTextfield"]
         XCTAssertTrue(cityTextField.exists)
         cityTextField.tap()
         cityTextField.typeText("Moscow, Russia")

         app.buttons["Done"].tap()
         app.buttons["Save"].tap()
         app.alerts["!!!"].otherElements.buttons["Ok"].tap()

     }

}
