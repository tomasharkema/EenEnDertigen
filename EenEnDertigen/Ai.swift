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
}

func ==(lhs: PossibleBeurt, rhs: PossibleBeurt) -> Bool {
  return
    lhs.grabKaart == rhs.grabKaart &&
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

func getKeuzeFromInput(input: String) -> (Int, Int)? {
  
  //input checking:
  if input.characters.count != 2 {
    InputPosition.down(1) >>> "Je moet p of 2 cijfers invoeren..."
    return nil
  }
  
  let firstChar = String(input[advance(input.startIndex, 0)])
  let lastChar = String(input[advance(input.startIndex, 1)])
  
  let first = Int(firstChar)
  let last = Int(lastChar)
  
  if let first = first, last = last {
    if first < 4 && last < 4 && first > 0 && last > 0 {
      return (first-1, last-1)
    }
  }
  
  return nil
}

protocol PlayerMove {
  static var algoName: String { get }
  
  init()
  
  func move(speler: Speler, tafel: Tafel) -> Beurt
}

