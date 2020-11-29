////
////  InputValidatorTests.swift
////  InputValidatorTests
////
////  Created by Hunter Buxton on 10/26/20.
////
//
//import XCTest
//@testable import PersonalKanban
//
//class InputValidatorTests: XCTestCase {
//
//    var sut: InputValidationManager!
//
//    override func setUpWithError() throws {
//        super.setUp()
//        sut = InputValidationManager()
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//        super.tearDown()
//    }
//
//    func testExample() throws {
//        let titleTracker = sut.inputTrackers[.title]
//        XCTAssertTrue(titleTracker != nil, "inputvalidationmanager had a nil value for the 'title' tracker")
//
//        sut.inputUpdate(nil, from: .title)
//        XCTAssertFalse(titleTracker!.approved, "inputvalidationmanager accepted nil for the title input")
//
//        sut.inputUpdate("", from: .title)
//        XCTAssertFalse(titleTracker!.approved, "inputvalidationmanager accepted an empty string for the title input")
//
//        sut.inputUpdate("    ", from: .title)
//        XCTAssertFalse(titleTracker!.approved, "inputvalidationmanager accepted an all-whitespace string for the title input")
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
