//
//  TournamentTest.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 01-08-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class TournamentTest: XCTestCase {

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      Tournament(roundsPerGame: 1, startoffSticks: 1).playTournament()
    }
  }

}
