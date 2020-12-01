//
//  PersonalKanbanUITests.swift
//  PersonalKanbanUITests
//
//  Created by Hunter Buxton on 10/17/20.
//

import XCTest
//@testable import PersonalKanban

// https://www.swiftbysundell.com/articles/getting-started-with-xcode-ui-testing-in-swift/

class PersonalKanbanUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - XCTestCase

    override func setUpWithError() throws {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: - Tests

    func testDisplayingEditTaskScreen() {

        XCTAssertTrue(app.isDisplayingMainScreen, "UI test failed in \(#function) app.isDisplayingMainScreen returned false")

        let navigationBarButtons = app.navigationBars.buttons
        let addButton = navigationBarButtons["addBBI"]
        addButton.tap()

        XCTAssertTrue(app.isDisplayingTaskEditor, "UI test failed in \(#function) app.isDisplayingTaskEditor returned false")

        let saveBtn = navigationBarButtons["saveBtn"]
        XCTAssertFalse(saveBtn.isEnabled, "UI test failed in \(#function) saveBtn.isEnabled was true when AddEditTaskScreen had not recieved any inputs")

        let titleTextField = app.textFields["titleTextField"]
        titleTextField.tap()
        titleTextField.typeText("alphanumeric string example")
        XCTAssertTrue(saveBtn.isEnabled, "UI test failed in \(#function) saveBtn.isEnabled was false when AddEditTaskScreen had already recieved alphanumeric input")

        let cancelBtn = navigationBarButtons["cancelBtn"]
        XCTAssertTrue(cancelBtn.isEnabled, "UI test failed in \(#function) cancelBtn.isEnabled was true")

        cancelBtn.tap()
        //saveBtn.tap() // this one isn't working in the test. does it need a delay?
        XCTAssertFalse(app.isDisplayingTaskEditor, "UI test failed in \(#function), addEditTaskScreen was still presented after saveBtn was enabled and tapped")

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIApplication {
    var isDisplayingMainScreen: Bool {
        return otherElements["mainParentVCID"].exists
    }
    var isDisplayingTaskEditor: Bool {
        return otherElements["taskEditorVCID"].exists
    }
}
