//
//  Ai.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

struct PossibleBeurt {
  let throwKaart: (Kaart, Int)
  let grabKaart: (Kaart, Int)
  let points: Double?
}

enum Beurt {
  case Switch(PossibleBeurt)
  case Pass
}

func AIbeurt(hand: Speler, tafel: Tafel) -> Beurt {
  
  var possibleBeurten = [PossibleBeurt]()
  
  for (tafelIndex, tafelKaart) in tafel.enumerate() {
    for (handIndex, handKaart) in hand.kaarten.enumerate() {
      
      possibleBeurten.append(
        PossibleBeurt(throwKaart: (handKaart, handIndex), grabKaart: (tafelKaart, tafelIndex), points: calculatePoints(tafelKaart, additions: hand.kaarten.without(handIndex)))
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
  var bestBeurt = beurten[0]

  for beurt in beurten {
    if bestBeurt.points < beurt.points {
      bestBeurt = beurt
    }
  }

  return bestBeurt
}