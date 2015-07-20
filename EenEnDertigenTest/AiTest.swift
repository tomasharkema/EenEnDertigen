//
//  AiTest.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 20-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class AiTest: XCTestCase {

  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }

  func testAIbeurt() {
    // ♥V ♣B ♠H
    let tafel: Tafel = [
      Kaart(symbool: .Harten, nummer: .Vrouw),
      Kaart(symbool: .Klaver, nummer: .Boer),
      Kaart(symbool: .Schoppen, nummer: .Heer)]
    
    //♥A ♦9 ♦V
    let speler = Speler(kaarten: [
      Kaart(symbool: .Harten, nummer: .Aas),
      Kaart(symbool: .Ruiten, nummer: .Negen),
      Kaart(symbool: .Ruiten, nummer: .Vrouw)],
      name: "Test", beurten: [], position: NoordPosition)
    
    let aiBeurt = AIbeurt(speler, tafel: tafel)
    
    XCTAssertTrue(aiBeurt == Beurt.Switch(
      PossibleBeurt(
        throwKaart: Kaart(symbool: .Ruiten, nummer: .Negen),
        grabKaart: Kaart(symbool: .Harten, nummer: .Vrouw),
        points: 21)))
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measureBlock {
          // Put the code you want to measure the time of here.
      }
  }

}
