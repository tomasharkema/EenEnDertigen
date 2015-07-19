//
//  EenEnDertigenTest.swift
//  EenEnDertigenTest
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class EenEnDertigenTest: XCTestCase {
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPickLosers() {
      let game = Game()
      
      // Speler Noord: [♠B, ♠10, ♣10] 20.0
      // Speler Oost: [♥A, ♥9, ♥10] 30.0
      // Speler Zuid: [♣9, ♥B, ♣A] 20.0
      // Speler West: [♠9, ♣B, ♥7] 10.0 --> Verliezer
      
      game.spelers = [
        Speler(kaarten: [
          Kaart(symbool: .Schoppen, nummer: .Boer),
          Kaart(symbool: .Schoppen, nummer: .Tien),
          Kaart(symbool: .Klaver, nummer: .Tien)
        ], name: "Noord"),
        Speler(kaarten: [
          Kaart(symbool: .Harten, nummer: .Aas),
          Kaart(symbool: .Harten, nummer: .Negen),
          Kaart(symbool: .Harten, nummer: .Tien)
        ], name: "Oost"),
        Speler(kaarten: [
          Kaart(symbool: .Klaver, nummer: .Negen),
          Kaart(symbool: .Harten, nummer: .Boer),
          Kaart(symbool: .Klaver, nummer: .Aas)
        ], name: "Zuid"),
        Speler(kaarten: [
          Kaart(symbool: .Schoppen, nummer: .Negen),
          Kaart(symbool: .Klaver, nummer: .Boer),
          Kaart(symbool: .Harten, nummer: .Zeven)
        ], name: "West")
      ]
      
      XCTAssertEqual(game.pickLosers(), [game.spelers[3]])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
