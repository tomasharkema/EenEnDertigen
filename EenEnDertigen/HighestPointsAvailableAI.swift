//
//  HighestPointsAvailableAI.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 31-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

class HighestPointsAvailableAI: PlayerMove {
  
  static let algoName = "HighestPointsAvailableAI"
  
  required init() {}
  
  func move(hand: Speler, tafel: Tafel) -> Beurt {
    var possibleBeurten = [(PossibleBeurt, Punten)]()
    
    let kaarten = hand.kaarten
    
    for tafelKaart in tafel {
      for handKaart in hand.kaarten {
        let additions = kaarten.without(handKaart)
        possibleBeurten.append(
          (PossibleBeurt(
            throwKaart: handKaart,
            grabKaart: tafelKaart), calculatePoints(tafelKaart, additions: additions))
        )
      }
    }
    
    let commitBeurt = possibleBeurten.maxElement { (lhs, rhs) -> Bool in
      lhs.1 < rhs.1
    }!
    
    if (hand.points > commitBeurt.1) {
      return .Pass
    } else {
      let additions = tafel.without(tafel[0])
      let wisselPoints = calculatePoints(tafel[0], additions: additions)
      if wisselPoints > commitBeurt.1 {
        return .Wissel
      }
      return .Switch(commitBeurt.0)
    }
  }
}

class HighestPointsAvailableKeepHighCardsAI: PlayerMove {
  
  static let algoName = "HighestPointsAvailableKeepHighCardsAI"
  
  required init() {}
  
  var didHighCardSwitch: Int? = nil
  
  private func getDifferentCard(kaarten: [Kaart]) -> Kaart? {
    
    let differences: [Bool] = kaarten.map { (kaart: Kaart) -> Bool in
      return kaarten.without(kaart).contains { (el: Kaart) -> Bool in
        return el.symbool == kaart.symbool
      }
    }
    
    if let index = differences.indexOf(false) {
      return kaarten[index]
    } else {
      return nil
    }
  }
  
  func move(hand: Speler, tafel: Tafel) -> Beurt {
    var possibleBeurten = [(PossibleBeurt, Punten)]()
    
    let kaarten = hand.kaarten
    
    for tafelKaart in tafel {
      for handKaart in hand.kaarten {
        let additions = kaarten.without(handKaart)
        possibleBeurten.append(
          (PossibleBeurt(
            throwKaart: handKaart,
            grabKaart: tafelKaart), calculatePoints(tafelKaart, additions: additions))
        )
      }
    }
    
    let commitBeurt = possibleBeurten.maxElement { (lhs, rhs) -> Bool in
      return lhs.1 < rhs.1 || (lhs.0.grabKaart < rhs.0.grabKaart && lhs.0.throwKaart < rhs.0.throwKaart)
    }!
    
    if (hand.points > commitBeurt.1) {
      
      if let didHighCardSwitch = didHighCardSwitch where didHighCardSwitch > 10 {
        return .Pass
      }
      
      let aasIndex = tafel.indexOf { (el: Kaart) -> Bool in
        el.nummer == .Aas
      }
      
      if let aasIndex = aasIndex {
        if let differentCard = getDifferentCard(hand.kaarten) {
          didHighCardSwitch = (didHighCardSwitch ?? 0) + 1
          return .Switch(PossibleBeurt(throwKaart: differentCard, grabKaart: tafel[aasIndex]))
        }
      }
      
      let highIndex = tafel.indexOf { (el: Kaart) -> Bool in
        el.nummer.points >= 10
      }
      
      if let highIndex = highIndex {
        if let differentCard = getDifferentCard(hand.kaarten) {
          didHighCardSwitch = (didHighCardSwitch ?? 0) + 1
          return .Switch(PossibleBeurt(throwKaart: differentCard, grabKaart: tafel[highIndex]))
        }
      }
      
      return .Pass
    } else {
      let additions = tafel.without(tafel[0])
      let wisselPoints = calculatePoints(tafel[0], additions: additions)
      if wisselPoints > commitBeurt.1 {
        return .Wissel
      }
      return .Switch(commitBeurt.0)
    }
  }
}

class HighestPointsPlusWisselAvailableAI: PlayerMove {
  
  static let algoName = "HighestPointsPlusWisselAvailableAI"
  
  required init() {}
  
  func move(hand: Speler, tafel: Tafel) -> Beurt {
    var possibleBeurten = [(PossibleBeurt, Punten)]()
    
    for tafelKaart in tafel {
      for handKaart in hand.kaarten {
        let additions = hand.kaarten.without(handKaart)
        
        possibleBeurten.append(
          (PossibleBeurt(
            throwKaart: handKaart,
            grabKaart: tafelKaart), calculatePoints(tafelKaart, additions: additions))
        )
      }
    }
    
    let commitBeurt = possibleBeurten.maxElement { (lhs, rhs) -> Bool in
      lhs.1 < rhs.1
    }!
    
    let wisselPoints = calculatePoints(tafel[0], additions: tafel.without(tafel[0]))
    if wisselPoints > hand.points {
      return .Wissel
    } else if (hand.points > commitBeurt.1) {
      return .Pass
    } else {
      return .Switch(commitBeurt.0)
    }
  }
}

class HighestPointsPlusWisselAbove25AI: PlayerMove {
  
  static let algoName = "HighestPointsPlusWisselAbove25AI"
  
  required init() {}
  
  func move(hand: Speler, tafel: Tafel) -> Beurt {
    var possibleBeurten = [(PossibleBeurt, Punten)]()
    
    for tafelKaart in tafel {
      for handKaart in hand.kaarten {
        let additions = hand.kaarten.without(handKaart)
        
        possibleBeurten.append(
          (PossibleBeurt(
            throwKaart: handKaart,
            grabKaart: tafelKaart), calculatePoints(tafelKaart, additions: additions))
        )
      }
    }
    
    let commitBeurt = possibleBeurten.maxElement { (lhs, rhs) -> Bool in
      lhs.1 < rhs.1
    }!
    
    let wisselPoints = calculatePoints(tafel[0], additions: tafel.without(tafel[0]))
    if wisselPoints > hand.points && wisselPoints.punten() > 25 {
      return .Wissel
    } else if (hand.points > commitBeurt.1) {
      return .Pass
    } else {
      return .Switch(commitBeurt.0)
    }
  }
}

class HighestPointsPlusWisselAbove20AI: PlayerMove {
  
  static let algoName = "HighestPointsPlusWisselAbove20AI"
  
  required init() {}
  
  func move(hand: Speler, tafel: Tafel) -> Beurt {
    var possibleBeurten = [(PossibleBeurt, Punten)]()
    
    for tafelKaart in tafel {
      for handKaart in hand.kaarten {
        let additions = hand.kaarten.without(handKaart)
        
        possibleBeurten.append(
          (PossibleBeurt(
            throwKaart: handKaart,
            grabKaart: tafelKaart), calculatePoints(tafelKaart, additions: additions))
        )
      }
    }
    
    let commitBeurt = possibleBeurten.maxElement { (lhs, rhs) -> Bool in
      lhs.1 < rhs.1
      }!
    
    let wisselPoints = calculatePoints(tafel[0], additions: tafel.without(tafel[0]))
    if wisselPoints > hand.points && wisselPoints.punten() > 20 {
      return .Wissel
    } else if (hand.points > commitBeurt.1) {
      return .Pass
    } else {
      return .Switch(commitBeurt.0)
    }
  }
}