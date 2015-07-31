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
    if addition.nummer == base.nummer {
      sameCount++
    }
    
    if sameCount == additions.count {
      if base.nummer == .Aas {
        return 33
      }
      
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
  var sticks: Int
  
  var points: Double {
    return [
      calculatePoints(kaarten[0], additions: [kaarten[1], kaarten[2]]),
      calculatePoints(kaarten[1], additions: [kaarten[0], kaarten[2]]),
      calculatePoints(kaarten[2], additions: [kaarten[0], kaarten[1]]),
    ].reduce(0, combine: { max($0, $1) })
  }
  
  func throwAndGrab(beurt: PossibleBeurt) -> Speler {
    var newKaarten = kaarten
    newKaarten.remove(beurt.throwKaart)
    newKaarten.append(beurt.grabKaart)
    return Speler(kaarten: newKaarten, name: name, sticks: sticks, beurten: beurten, position: position)
  }
  
  var description: String {
    return "\(kaarten[0]) \(kaarten[1]) \(kaarten[2]) : \(points)"
  }
  
  var hashValue: Int {
    return name.hashValue
  }
  
  var beurten: [Beurt]
  let position: Position
  
  var latestState: String {
    if let lastBeurt = beurten.last {
      switch lastBeurt {
      case let .Switch(possibleBeurt):
        return "pakt: \(possibleBeurt.grabKaart), gooit: \(possibleBeurt.throwKaart)"
      case .Pass:
        return "Pas"
      case .Wissel:
        return "Omgewisseld"
      }
    } else {
      return ""
    }
  }
  
  var isDowner: Bool {
    return sticks == 0
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

  var spelers: Array<Speler>!
  var tafel: Tafel!
  
  // playState
  var hasPassed: Int?
  
  func shuffle() {
    deck = newDeck()
  }
  
  func deel() {
    for (index, _) in spelers.enumerate() {
      spelers[index].kaarten = [deck.draw(), deck.draw(), deck.draw()]
    }
    tafel = [deck.draw(), deck.draw(), deck.draw()]
  }
  
  func pass(spelerIndex: Int) {
    if hasPassed == nil {
      hasPassed = spelerIndex
    }
  }
  
  func commitBeurt(spelerIndex: Int, var speler: Speler, beurt: Beurt) -> Speler {
    speler.beurten.append(beurt)
    switch beurt {
    case let .Switch(possibleBeurt):
      tafel[tafel.indexOf(possibleBeurt.grabKaart)!] = possibleBeurt.throwKaart
      
      return speler.throwAndGrab(possibleBeurt)
    case .Pass:
      pass(spelerIndex)
      return speler
    case .Wissel:
      pass(spelerIndex)
      let oldTafel = tafel
      tafel = speler.kaarten
      speler.kaarten = oldTafel
      return speler
    }
  }
  
  private func getKeuzeFromInput(input: String) -> (Int, Int)? {
    
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
  
  func getBeurtFromUser(speler: Speler) -> Beurt {
    
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
        return .Switch(PossibleBeurt(throwKaart: speler.kaarten[keuze.1], grabKaart: tafel[keuze.0], points: nil))
      } else {
        return getBeurtFromUser(speler)
      }
    }
  }
  
  func commitUserBeurt(speler: Speler) -> Speler {
    let beurt = getBeurtFromUser(speler)
    return commitBeurt(0, speler: speler, beurt: beurt)
  }
  
  func beurt() {
    let max = hasPassed ?? spelers.count
    let hasPassedThisTurn = hasPassed
    for index in 0..<max {
      
      var speler: Speler!
      
      if !spelers[index].isDowner {
      
        if index == 0 && !Test {
          speler = commitUserBeurt(spelers[index])
        } else {
          speler = commitBeurt(index, speler: spelers[index], beurt: AIbeurt(spelers[index], tafel: tafel))
        }
        
        spelers[index] = speler
        printState()
        if speler.points == 31 {
          return
        }
        
      }
    }
    
    if hasPassedThisTurn == nil {
      beurt()
    }
  }
  
  func printState() {
    setBackground()
    clear()
    HeaderPosition >>> "EENENDERTIGEN"
    TafelPosition >>> " ".join(tafel.map { $0.description })
    
    for speler in spelers {
      if !speler.isDowner {
        speler.position >>> "\(speler.name) - \(speler.sticks)"
        speler.position.down(1) >>> speler.latestState
      } else {
        speler.position >>> "\(speler.name) DOOD"
      }
    }
    
  }
  
  func finishRound() {
    for loser in pickLosers() {
      if let index = spelers.indexOf(loser) {
        spelers[index].sticks--
      }
    }
  }
  
  func printEndState() {
    setBackground()
    clear()
    HeaderPosition >>> "EENENDERTIGEN"
    TafelPosition >>> " ".join(tafel.map { $0.description })
    
    let losers = pickLosers()
    
    for speler in spelers {
      if !speler.isDowner {
        
        var extraMessage = ""
        if shouldDoAnotherRound() {
          extraMessage = " WINNAAR!"
        } else if losers.contains(speler) {
          extraMessage = " - Verliezer!"
        } else if speler.points == 31 {
          extraMessage = " - Verbied!"
        }
        
        speler.position >>> "\(speler.name)\(extraMessage) - \(speler.sticks)"
        
        let kaartenString = " ".join(speler.kaarten.map { $0.description })
        speler.position.down(1) >>> "\(kaartenString) \(speler.points)"
      } else {
        speler.position >>> "\(speler.name) DOOD"
      }
    }
  }
  
  func pickLosers() -> Set<Speler> {
    var losers = Set<Speler>()
    
    for speler in spelers {
      if !speler.isDowner {
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
    }
    
    return losers
  }
  
  func pickDowners() -> [Speler] {
    return spelers.filter({ (el) -> Bool in
      el.isDowner
    })
  }
  
  func shouldDoAnotherRound() -> Bool {
    return pickDowners().count != (spelers.count - 1) && pickDowners().count != spelers.count
  }
  
  func resetBeurten() {
    for (index, _) in spelers.enumerate() {
      spelers[index].beurten = []
    }
  }
  
  func startRound() {
    
    resetBeurten()
    
    // reset
    hasPassed = nil
    
    shuffle()
    deel()
    printState()
    beurt()
    finishRound()
    printEndState()
  }
  
  private func startGameRec(restartClosure: (() -> Bool)?, finishClosure: (() -> Bool)?) {
    startRound()
    
    let restart: () -> Bool = {
      if self.spelers[0].isDowner {
        return true
      } else {
        return restartClosure?() ?? true
      }
    }
    
    if shouldDoAnotherRound() && restart() {
      startGameRec(restartClosure, finishClosure: finishClosure)
    } else {
      showFinishedState()
      if finishClosure?() ?? false {
        startGame(restartClosure, finishClosure: finishClosure)
      }
    }
  }
  
  func startGame(restartClosure: (() -> Bool)? = nil, finishClosure: (() -> Bool)? = nil) {
    spelers = [
      Speler(kaarten: [], name: "Zuid (JIJ)", sticks: 5, beurten: [], position: ZuidPosition),
      Speler(kaarten: [], name: "Oost", sticks: 5, beurten: [], position: OostPosition),
      Speler(kaarten: [], name: "Noord", sticks: 5, beurten: [], position: NoordPosition),
      Speler(kaarten: [], name: "West", sticks: 5, beurten: [], position: WestPosition)
    ]
    
    startGameRec(restartClosure, finishClosure: finishClosure)
  }
}