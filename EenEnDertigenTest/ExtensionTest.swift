//
//  ExtensionTest.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 20-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class ExtensionTest: XCTestCase {

  func testRemove() {
    var arr = [1,2,3,4,5,6,7]
    arr.remove(1)
    
    XCTAssertEqual(arr, [2,3,4,5,6,7])
  }
  
  func testWithout() {
    let arr = [1,2,3,4,5,6]
    let newArr = arr.without(1)
    XCTAssertEqual(newArr, [2,3,4,5,6])
  }
  
  func testFlatten() {
    let dict: [[String: Int]] = [["A": 1, "B": 1], ["A": 1, "B": 1], ["A": 1, "B": 1, "C": 3], ["C": 2]]
    
    XCTAssertEqual(flatten(dict), ["A": 3, "B": 3, "C": 5])
  }
}
