//
//  Game.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

func getKeyboardInput() -> String {
  var keyboard = NSFileHandle.fileHandleWithStandardInput()
  var inputData = keyboard.availableData
  var strData = NSString(data: inputData, encoding: NSUTF8StringEncoding)!
  
  return strData.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet()).lowercaseString
}

func calculatePoints(base: Kaart, additions: [Kaart]) -> Double {
  var sameCount = 0
  
  for addition in additions {
    if addition.nummer.rawValue == base.nummer.rawValue {
      sameCount++
    }
    
    if sameCount == additions.count {
      return 30.5
    }
  }
  
  var points = base.nummer.points
  
  for addition in additions {
    if addition.symbool.rawValue == base.symbool.rawValue {
      points += addition.nummer.points
    }
  }
  return Double(points)
}

struct Speler: CustomStringConvertible, Equatable, Hashable {
  var kaarten: [Kaart]
  let name: String
  
  var points: Double {
    return [
      calculatePoints(kaarten[0], additions: [kaarten[1], kaarten[2]]),
      calculatePoints(kaarten[1], additions: [kaarten[0], kaarten[2]]),
      calculatePoints(kaarten[2], additions: [kaarten[0], kaarten[1]]),
      ].reduce(0, combine: { max($0, $1) })
  }
  
  func throwAndGrab(beurt: PossibleBeurt) -> Speler {
    var newKaarten = kaarten
    newKaarten.removeAtIndex(beurt.throwKaart.1)
    newKaarten.insert(beurt.grabKaart.0, atIndex: beurt.grabKaart.1)
    return Speler(kaarten: newKaarten, name: name)
  }
  
  var description: String {
    return "\(kaarten[0]) \(kaarten[1]) \(kaarten[2]) : \(points)"
  }
  
  var hashValue: Int {
    return name.hashValue
  }
}

func ==(lhs: Speler, rhs: Speler) -> Bool {
  return lhs.kaarten == rhs.kaarten && lhs.name == rhs.name
}

struct Deck {
  var cards: [Kaart]
  
  mutating func draw() -> Kaart {
    let drawnCard = cards[0]
    cards.removeAtIndex(0)
    return drawnCard
  }
}

func newDeck() -> Deck {
  var cards = [Kaart]()
  for symbool in AllSymbols {
    for nummer in AllNummers {
      cards.append(Kaart(symbool: symbool, nummer: nummer))
    }
  }
  cards.shuffle()
  return Deck(cards: cards)
}

typealias Tafel = [Kaart]

class Game {
  
  init() {}
  
  var deck: Deck!

  var spelers: [Speler]!
  var tafel: Tafel!
  
  // playState
  var hasPassed: Int?
  
  func shuffle() {
    deck = newDeck()
  }
  
  func deel() {
    spelers = [
      Speler(kaarten: [deck.draw(), deck.draw(), deck.draw()], name: "Noord"),
      Speler(kaarten: [deck.draw(), deck.draw(), deck.draw()], name: "Oost"),
      Speler(kaarten: [deck.draw(), deck.draw(), deck.draw()], name: "Zuid"),
      Speler(kaarten: [deck.draw(), deck.draw(), deck.draw()], name: "West")
    ]
    tafel = [deck.draw(), deck.draw(), deck.draw()]
  }
  
  func commitBeurt(spelerIndex: Int, speler: Speler, beurt: Beurt) -> Speler {
    switch beurt {
    case let .Switch(possibleBeurt):
      print("Speler \(speler.name): pakt: \(possibleBeurt.grabKaart.0), gooit: \(possibleBeurt.throwKaart.0)")
      
      tafel.removeAtIndex(possibleBeurt.grabKaart.1)
      tafel.insert(possibleBeurt.throwKaart.0, atIndex: possibleBeurt.grabKaart.1)
      
      return speler.throwAndGrab(possibleBeurt)
    case .Pass:
      print("Speler \(speler.name): passt")
      if hasPassed == nil {
        hasPassed = spelerIndex
      }
      return speler
    }
  }
  
  private func getKeuzeFromInput(input: String) -> (Int, Int)? {
    //input checking:
    if input.characters.count != 2 {
      print("Je moet p of 2 cijfers invoeren...\n\n")
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
  
  func getBeurtFromUser(speler: Speler) -> Beurt {
    print("\n\nMaak je keuze: Type '11' om kaart 1 te pakken, en kaart 1 te gooien. Type 'p' om te passen. \nTafel: \(tafel)\nHand:  \(speler.kaarten)")
    let input = getKeyboardInput()
    
    if input == "p" {
      return .Pass
    } else {
      if let keuze = getKeuzeFromInput(input) {
        return .Switch(PossibleBeurt(throwKaart: (speler.kaarten[keuze.1], keuze.1), grabKaart: (tafel[keuze.0], keuze.0), points: nil))
      } else {
        return getBeurtFromUser(speler)
      }
    }
  }
  
  func commitUserBeurt(speler: Speler) -> Speler {
    let beurt = getBeurtFromUser(speler)
    print("\n")
    return commitBeurt(0, speler: speler, beurt: beurt)
  }
  
  func beurt() {
    let max = hasPassed ?? spelers.count
    let hasPassedThisTurn = hasPassed
    for index in 0..<max {
      
      var speler: Speler!
      
      if index == 0 {
        speler = commitUserBeurt(spelers[index])
      } else {
        speler = commitBeurt(index, speler: spelers[index], beurt: AIbeurt(spelers[index], tafel: tafel))
      }
      
      spelers[index] = speler
      printState()
      if speler.points == 31 {
        print("Speler \(speler.name): VERBIED")
        return
      }
    }
    
    if hasPassedThisTurn == nil {
      beurt()
    }
  }
  
  func printState() {
    print("Tafel: \(tafel)")
  }
  
  func printEndState() {
    print("Status:")
    for speler in spelers {
      print("Speler \(speler.name): \(speler.kaarten) \(speler.points)")
    }
  }
  
  func pickLosers() -> Set<Speler> {
    var losers = Set<Speler>()
    
    for speler in spelers {
      if losers.count == 0 {
        losers.insert(speler)
      } else {
        for loser in losers {
          if speler.points < loser.points {
            losers.removeAll()
            losers.insert(speler)
          } else if speler.points == loser.points {
            losers.insert(speler)
          }
        }
      }
    }
    
    return losers
  }
  
  func start() {
    shuffle()
    
    deel()
    
    print("-------------------")
    printState()
    print("-------------------")
    beurt()
    print("-------------------")
    print("FINISH:")
    printEndState()
    
    let losers = ", ".join(pickLosers().map { $0.name })
    print("Verliezer: \(losers)")
  }
}