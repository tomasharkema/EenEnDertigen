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
      ], name: "Noord", sticks: 5, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Harten, nummer: .Aas),
        Kaart(symbool: .Harten, nummer: .Negen),
        Kaart(symbool: .Harten, nummer: .Tien)
      ], name: "Oost", sticks: 5, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Negen),
        Kaart(symbool: .Harten, nummer: .Boer),
        Kaart(symbool: .Klaver, nummer: .Aas)
      ], name: "Zuid", sticks: 5, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Klaver, nummer: .Boer),
        Kaart(symbool: .Harten, nummer: .Zeven)
      ], name: "West", sticks: 5, beurten: [], position: WestPosition)
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
      ], name: "Noord", sticks: 5, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
      ], name: "Oost", sticks: 5, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
      ], name: "Zuid", sticks: 5, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
      ], name: "West", sticks: 5, beurten: [], position: WestPosition)
    ]
    
    XCTAssertEqual(game.pickLosers(), [game.spelers[1], game.spelers[3]])
  }

  func testVerbied() {
    
    let speler = Speler(kaarten: [
      Kaart(symbool: .Schoppen, nummer: .Aas),
      Kaart(symbool: .Schoppen, nummer: .Heer),
      Kaart(symbool: .Schoppen, nummer: .Vrouw)
    ], name: "Test ", sticks: 5, beurten: [], position: NoordPosition)
    
    XCTAssertEqual(speler.points, 31)
  }
  
  func testDertigHalf() {
    
    let speler = Speler(kaarten: [
      Kaart(symbool: .Schoppen, nummer: .Vrouw),
      Kaart(symbool: .Klaver, nummer: .Vrouw),
      Kaart(symbool: .Ruiten, nummer: .Vrouw)
    ], name: "Test", sticks: 5, beurten: [], position: NoordPosition)
    
    XCTAssertEqual(speler.points, 30.5)
  }
  
  func testDrieEnDertig() {
    
    let speler = Speler(kaarten: [
      Kaart(symbool: .Schoppen, nummer: .Aas),
      Kaart(symbool: .Klaver, nummer: .Aas),
      Kaart(symbool: .Ruiten, nummer: .Aas)
    ], name: "Test", sticks: 5, beurten: [], position: NoordPosition)
    
    XCTAssertEqual(speler.points, 33)
  }
  
  func testUniqueDeck() {
    let game = Game()
    game.shuffle()
    
    var crossReference = [Kaart]()
    var foundDoubles = false
    
    for kaart in game.deck.cards {
      if crossReference.contains(kaart) {
        foundDoubles = true
      } else {
        crossReference.append(kaart)
      }
    }
    
    XCTAssertFalse(foundDoubles)
  }
  
  func testDeckDraw() {
    
    let game = Game()
    game.shuffle()
    
    let firstCard = game.deck.cards.first!
    let drawnCard = game.deck.draw()
    
    XCTAssertEqual(firstCard, drawnCard)
    XCTAssertEqual(game.deck.cards.contains(firstCard), false)
  }
  
  
  func testFullRoundScore() {
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Klaver, nummer: .Tien)
        ], name: "Noord", sticks: 5, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Harten, nummer: .Aas),
        Kaart(symbool: .Harten, nummer: .Negen),
        Kaart(symbool: .Harten, nummer: .Tien)
        ], name: "Oost", sticks: 5, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Negen),
        Kaart(symbool: .Harten, nummer: .Boer),
        Kaart(symbool: .Klaver, nummer: .Aas)
        ], name: "Zuid", sticks: 5, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Klaver, nummer: .Boer),
        Kaart(symbool: .Harten, nummer: .Zeven)
        ], name: "West", sticks: 5, beurten: [], position: WestPosition)
    ]
    
    game.startRound()
    
    for loser in game.pickLosers() {
      XCTAssertEqual(loser.sticks, 4)
    }
    
    for winner in game.spelers.without(game.pickLosers()) {
      XCTAssertEqual(winner.sticks, 5)
    }
  }
  
  func testShouldDoAnotherRound() {
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Heer),
        Kaart(symbool: .Harten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Heer)
        ], name: "Noord", sticks: 1, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
        ], name: "Oost", sticks: 0, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
        ], name: "Zuid", sticks: 0, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
        ], name: "West", sticks: 0, beurten: [], position: WestPosition)
    ]
    
    XCTAssertFalse(game.shouldDoAnotherRound())
    
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Heer),
        Kaart(symbool: .Harten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Heer)
        ], name: "Noord", sticks: 1, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
        ], name: "Oost", sticks: 1, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
        ], name: "Zuid", sticks: 0, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
        ], name: "West", sticks: 0, beurten: [], position: WestPosition)
    ]
    
    XCTAssertTrue(game.shouldDoAnotherRound())
    
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Heer),
        Kaart(symbool: .Harten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Heer)
        ], name: "Noord", sticks: 4, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
        ], name: "Oost", sticks: 4, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
        ], name: "Zuid", sticks: 4, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
        ], name: "West", sticks: 0, beurten: [], position: WestPosition)
    ]
    
    XCTAssertTrue(game.shouldDoAnotherRound())
    
    game.spelers = [
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Heer),
        Kaart(symbool: .Harten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Heer)
        ], name: "Noord", sticks: 4, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
        ], name: "Oost", sticks: 4, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
        ], name: "Zuid", sticks: 4, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
        ], name: "West", sticks: 4, beurten: [], position: WestPosition)
    ]
    
    XCTAssertTrue(game.shouldDoAnotherRound())
  }
  
  func testExcludeDowner() {
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
      ], name: "Noord", sticks: 5, beurten: [], position: NoordPosition),
      Speler(kaarten: [
        Kaart(symbool: .Klaver, nummer: .Zeven),
        Kaart(symbool: .Schoppen, nummer: .Negen),
        Kaart(symbool: .Schoppen, nummer: .Aas)
      ], name: "Oost", sticks: 0, beurten: [], position: OostPosition),
      Speler(kaarten: [
        Kaart(symbool: .Schoppen, nummer: .Tien),
        Kaart(symbool: .Schoppen, nummer: .Boer),
        Kaart(symbool: .Schoppen, nummer: .Zeven)
      ], name: "Zuid", sticks: 5, beurten: [], position: ZuidPosition),
      Speler(kaarten: [
        Kaart(symbool: .Ruiten, nummer: .Boer),
        Kaart(symbool: .Ruiten, nummer: .Heer),
        Kaart(symbool: .Klaver, nummer: .Boer)
      ], name: "West", sticks: 5, beurten: [], position: WestPosition)
    ]
    
    XCTAssertEqual(game.pickLosers(), [game.spelers[3]])
  }
  
  func testPerformanceFullGame() {
    // This is an example of a performance test case.
    self.measureBlock {
      self.game.startGame()
    }
  }
    
}
