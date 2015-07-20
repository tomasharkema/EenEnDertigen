//
//  Ai.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

struct PossibleBeurt: Equatable {
  let throwKaart: Kaart
  let grabKaart: Kaart
  let points: Double?
}

func ==(lhs: PossibleBeurt, rhs: PossibleBeurt) -> Bool {
  return
    lhs.grabKaart == rhs.grabKaart &&
    lhs.points == rhs.points &&
    lhs.throwKaart == rhs.throwKaart
}

enum Beurt: Equatable {
  case Switch(PossibleBeurt)
  case Pass
  case Wissel
  
  func toInt() -> Int {
    switch self {
    case .Switch(_):
      return 1
    case .Pass:
      return 2
    case .Wissel:
      return 3
    }
  }
}

func ==(lhs: Beurt, rhs: Beurt) -> Bool {
  if lhs.toInt() == rhs.toInt() {
    if case .Switch(let possibleLhs) = lhs {
      if case .Switch(let possibleRhs) = rhs {
        return possibleLhs == possibleRhs
      }
      return false
    }
    
    return true
  }
  
  return false
}

func AIbeurt(hand: Speler, tafel: Tafel) -> Beurt {
  
  var possibleBeurten = [PossibleBeurt]()
  
  for tafelKaart in tafel {
    for (handIndex, handKaart) in hand.kaarten.enumerate() {
      
      possibleBeurten.append(
        PossibleBeurt(
          throwKaart: handKaart,
          grabKaart: tafelKaart,
          points: calculatePoints(tafelKaart, additions: hand.kaarten.without(handIndex)))
      )
    }
  }
  
  let commitBeurt = bestBeurt(possibleBeurten)
  
  if (hand.points > commitBeurt.points) {
    return .Pass
  } else {
    return .Switch(commitBeurt)
  }
}

func bestBeurt(beurten: [PossibleBeurt]) -> PossibleBeurt {
  return beurten.maxElement { (lhs, rhs) -> Bool in
    lhs.points < rhs.points
  }!
}