//
//  ExtensionTest.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 20-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class ExtensionTest: XCTestCase {

    func remove() {
      var arr = [1,2,3,4,5,6,7]
      arr.remove(1)
      
      XCTAssertEqual(arr, [2,3,4,5,6,7])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
