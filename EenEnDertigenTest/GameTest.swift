//
//  EenEnDertigenTest.swift
//  EenEnDertigenTest
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class GameTest: XCTestCase {
  
  var game: Game!
  
  override func setUp() {
    super.setUp()
    game = Game()
  }
  
  override func tearDown() {
    game = nil
    super.tearDown()
  }
  
  func testPickLosersDoublesButLower() {
    
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

  func testPickLosersDoubles() {
    
    let game = Game()
    
    //Speler Noord: [♠H, ♥H, ♣H] 30.5
    //Speler Oost: [♣7, ♠9, ♠A] 20.0
    //Speler Zuid: [♠10, ♠B, ♠7] 27.0
    //Speler West: [♦B, ♦H, ♣B] 20.0
    
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Heer),
        Kaart(symbool: .Harten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Heer)
      ], name: "Noord"),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
      ], name: "Oost"),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
      ], name: "Zuid"),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
      ], name: "West")
    ]
    
    XCTAssertEqual(game.pickLosers(), [game.spelers[1], game.spelers[3]])
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measureBlock {
        self.game.start()
      }
  }
    
}
