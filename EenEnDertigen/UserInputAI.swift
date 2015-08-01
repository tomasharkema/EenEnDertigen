//
//  UserInputAI.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 31-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

class UserInputAI: PlayerMove {
  
  static let algoName = "UserInputAI"
  
  required init() {}
  
  private func getBeurtFromUser(tafel: Tafel, speler: Speler) -> Beurt {
    
    let kaartenString = " ".join(speler.kaarten.map { $0.description })
    HandPosition >>> "Hand:  \(kaartenString)"
    InputPosition >>> "Maak je keuze: Type '11' om kaart 1 te pakken, en kaart 1 te gooien. Type 'p' om te passen. Type 'w' om alle kaarten met de tafel te wisselen."
    
    let input = getKeyboardInput()
    
    if input == "p" {
      return .Pass
    } else if input == "w" {
      return .Wissel
    } else {
      if let keuze = getKeuzeFromInput(input) {
        return .Switch(PossibleBeurt(throwKaart: speler.kaarten[keuze.1], grabKaart: tafel[keuze.0]))
      } else {
        return getBeurtFromUser(tafel, speler: speler)
      }
    }
  }
  
  func move(speler: Speler, tafel: Tafel) -> Beurt {
    return getBeurtFromUser(tafel, speler: speler)
  }
}