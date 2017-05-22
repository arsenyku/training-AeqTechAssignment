//
//  AeqTechnicalAssignmentTests.swift
//  AeqTechnicalAssignmentTests
//
//  Created by asu on 2017-05-19.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import XCTest

class AeqCastleTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCastle() {
    
    let emptyList = numberOfCastles(fromElevations: []);
    XCTAssertEqual(emptyList, 0)
    
    let singleSite = numberOfCastles(fromElevations: [23]);
    XCTAssertEqual(singleSite, 1)
    
    let upThenDown = numberOfCastles(fromElevations: [1,5,3]);
    XCTAssertEqual(upThenDown, 3)
    
    let upThenFlatThenDown = numberOfCastles(fromElevations: [1,5,5,5,5,3]);
    XCTAssertEqual(upThenFlatThenDown, 3)
    
    let upUpPeakDown = numberOfCastles(fromElevations: [1, 2, 3, 2])
    XCTAssertEqual(upUpPeakDown, 3)
    
    let downDownValleyUp = numberOfCastles(fromElevations: [7,6,5,8])
    XCTAssertEqual(downDownValleyUp, 3)
    
    let upDownUpDownUpDown = numberOfCastles(fromElevations: [1,8,6,9,5,6,3])
    XCTAssertEqual(upDownUpDownUpDown, 7)
    
    let singleSiteWithRepeat = numberOfCastles(fromElevations: [5,5,5,5,5,5]);
    XCTAssertEqual(singleSiteWithRepeat, 1)
    
  }
  
  
}
