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

enum Punten: Equatable, Comparable {
  case AasVerbied
  case Verbied
  case DertigHalf
  case Punten(Int)
  
  func punten() -> Double {
    switch self {
    case .AasVerbied:
      return 33
    case .Verbied:
      return 31
    case .DertigHalf:
      return 30.5
    case let .Punten(punten):
      return Double(punten)
    }
  }
}

func ==(lhs: Punten, rhs: Punten) -> Bool {
  return lhs.punten() == rhs.punten()
}

func >(lhs: Punten, rhs: Punten) -> Bool {
  return lhs.punten() > rhs.punten()
}
func <(lhs: Punten, rhs: Punten) -> Bool {
  return lhs.punten() < rhs.punten()
}
func >=(lhs: Punten, rhs: Punten) -> Bool {
  return lhs.punten() >= rhs.punten()
}
func <=(lhs: Punten, rhs: Punten) -> Bool {
  return lhs.punten() <= rhs.punten()
}

func max(lhs: Punten, rhs: Punten) -> Punten {
  return [lhs, rhs].maxElement({ (lhs, rhs) -> Bool in
    lhs.punten() < rhs.punten()
  })!
}

func calculatePoints(base: Kaart, additions: [Kaart]) -> Punten {
  var sameCount = 0
  
  for addition in additions {
    if addition.nummer == base.nummer {
      sameCount++
    }
    
    if sameCount == additions.count {
      if base.nummer == .Aas {
        return .AasVerbied
      }
      
      return .DertigHalf
    }
  }
  
  var points = base.nummer.points
  
  for addition in additions {
    if addition.symbool == base.symbool {
      points += addition.nummer.points
    }
  }
  
  if points == 31 {
    return .Verbied
  }
  
  return .Punten(points)
}

var pointsCache = [Int: Punten]()

struct Speler: CustomStringConvertible, Equatable, Hashable {
  var kaarten: [Kaart] {
    didSet {
      pointsCache.removeValueForKey(name.hashValue)
    }
  }
  let name: String
  var sticks: Int
  var beurten: [Beurt]
  let position: Position
  let ai: PlayerMove
  
  var points: Punten {
    return [
      calculatePoints(kaarten[0], additions: [kaarten[1], kaarten[2]]),
      calculatePoints(kaarten[1], additions: [kaarten[0], kaarten[2]]),
      calculatePoints(kaarten[2], additions: [kaarten[0], kaarten[1]]),
    ].reduce(Punten.Punten(0)) { max($0, rhs: $1) }
  }
  
  func throwAndGrab(beurt: PossibleBeurt) -> Speler {
    var newKaarten = kaarten
    newKaarten[newKaarten.indexOf(beurt.throwKaart)!] = beurt.grabKaart
    
    return Speler(kaarten: newKaarten, name: name, sticks: sticks, beurten: beurten, position: position, ai: ai)
  }
  
  var description: String {
    return "\(kaarten[0]) \(kaarten[1]) \(kaarten[2]) : \(points)"
  }
  
  var hashValue: Int {
    return name.hashValue
  }
  
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
  
  let shouldPrint: Bool
  
  init(shouldPrint: Bool) {
    self.shouldPrint = shouldPrint
    shouldPrintGlbl = shouldPrint
  }
  
  var deck: Deck!

  var spelers: [Speler]!
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
  
  func commitBeurt(spelerIndex: Int, var speler: Speler) -> Speler {
    
    let beurt = speler.ai.move(speler, tafel: tafel)
    
    let count = speler.beurten.filter {$0 == beurt}.count
    if count > 50 {
      //bail out when player is in a loop
      pass(spelerIndex)
      return speler
    }
    
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
  
  func beurt() {
    let max = hasPassed ?? spelers.count
    let hasPassedThisTurn = hasPassed
    for index in 0..<max {
      
      var speler: Speler!
      
      if !spelers[index].isDowner {
      
        speler = commitBeurt(index, speler: spelers[index])
        
        spelers[index] = speler
        printState()
        if speler.points == .Verbied || speler.points == .AasVerbied {
          return
        }
        
      }
    }
    
    if hasPassedThisTurn == nil {
      beurt()
    }
  }
  
  func printState() {
    if !shouldPrint {
      return
    }
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
    if !shouldPrint {
      return
    }
  
    setBackground()
    clear()
    HeaderPosition >>> "EENENDERTIGEN"
    TafelPosition >>> " ".join(tafel.map { $0.description })
    
    let losers = pickLosers()
    
    for speler in spelers {
      if !speler.isDowner {
        
        var extraMessage = ""
        if !shouldDoAnotherRound() {
          extraMessage = " WINNAAR!"
        } else if losers.contains(speler) {
          extraMessage = " - Verliezer!"
        } else if speler.points == .Verbied || speler.points == .AasVerbied {
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
  
  private func startGameRec(defaultPlayers: Bool = true, restartClosure: (() -> Bool)?, finishClosure: (() -> Bool)?) {
    startRound()
    
    let restart: () -> Bool = {
      if self.spelers[0].isDowner {
        return true
      } else {
        return restartClosure?() ?? true
      }
    }
    
    if shouldDoAnotherRound() && restart() {
      startGameRec(defaultPlayers, restartClosure: restartClosure, finishClosure: finishClosure)
    } else {
      if finishClosure?() ?? false {
        startGame(defaultPlayers, restartClosure: restartClosure, finishClosure: finishClosure)
      }
    }
  }
  
  func startGame(defaultPlayers: Bool = true, restartClosure: (() -> Bool)? = nil, finishClosure: (() -> Bool)? = nil) {
    if defaultPlayers {
      spelers = [
        Speler(kaarten: [], name: "Zuid (JIJ)", sticks: 5, beurten: [], position: ZuidPosition, ai: UserInputAI()),
        Speler(kaarten: [], name: "Oost", sticks: 5, beurten: [], position: OostPosition, ai: HighestPointsAvailableAI()),
        Speler(kaarten: [], name: "Noord", sticks: 5, beurten: [], position: NoordPosition, ai: HighestPointsAvailableAI()),
        Speler(kaarten: [], name: "West", sticks: 5, beurten: [], position: WestPosition, ai: HighestPointsAvailableAI())
      ]
    } else {
      if spelers == nil {
        //print("WAT?")
      }
    }
    
    startGameRec(defaultPlayers, restartClosure: restartClosure, finishClosure: finishClosure)
  }
}