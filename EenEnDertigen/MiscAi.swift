//
//  MiscAi.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 31-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

class WisselBot: PlayerMove {
  
  static let algoName = "WisselBot"
  
  required init() {}
  
  func move(speler: Speler, tafel: Tafel) -> Beurt {
    return .Wissel
  }
}

class PassBot: PlayerMove {
  
  static let algoName = "PassBot"
  
  required init() {}
  
  func move(speler: Speler, tafel: Tafel) -> Beurt {
    return .Pass
  }
}

class RandomBot: PlayerMove {
  
  static let algoName = "RandomBot"
  
  required init() {}
  
  func move(speler: Speler, tafel: Tafel) -> Beurt {
    let keuze = Int.random(0...3)
    
    switch keuze {
    case 0:
      return .Pass
    case 1:
      return .Wissel
    default:
      let grabCard = Int.random(0..<3)
      let throwCard = Int.random(0..<3)
      
      return .Switch(PossibleBeurt(throwKaart: speler.kaarten[throwCard], grabKaart: tafel[grabCard]))
    }
  }
}