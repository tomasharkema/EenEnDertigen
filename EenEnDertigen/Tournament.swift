//
//  TestAI.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 31-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

struct PlayedGame {
  let scores: [Score]
  
  func winnigs() -> [String: Int] {
    var playerAndScores = [String: Int]()
    
    for score in scores {
      playerAndScores[score.winner().ai.dynamicType.algoName] = (playerAndScores[score.winner().ai.dynamicType.algoName] ?? 0) + 1
    }
    
    return playerAndScores
  }
}

struct Score {
  let spelers: [Speler]
  
  func winner() -> Speler {
    return spelers.maxElement {
      $0.sticks < $1.sticks
    }!
  }
}

class TestAI {
  
  static func peformanceOfAI(ai: [(PlayerMove.Type, String)]) -> PlayedGame {
    let game = Game(print: false)
    
    var playedGames = [[Speler]]()
    
    for _ in 0..<10 {
      
      game.spelers = ai.map { (ai, name) in
        return Speler(kaarten: [], name: name, sticks: 5, beurten: [], position: NoordPosition, ai: ai.init())
      }
      
      game.startGame(false)
      playedGames.append(game.spelers)
    }
    
    return PlayedGame(scores: playedGames.map { spelerArr in
      Score(spelers: spelerArr)
    })
  }
  
  static func testAI() {
    let AIs: [PlayerMove.Type] = [HighestPointsAvailableAI.self, WisselBot.self, PassBot.self, RandomBot.self, HighestPointsPlusWisselAvailableAI.self]
    
    var stats = SynchronizedArray<[String: Int]>()
    
    let dispatchGroup = dispatch_group_create()
    let dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    
    for ai1 in AIs {
      for ai2 in AIs {
        for ai3 in AIs {
          for ai4 in AIs {
            dispatch_group_async(dispatchGroup, dispatchQueue) {
              let ais = [(ai1, "\(ai1.algoName) 1"), (ai2, "\(ai2.algoName) 2"), (ai3, "\(ai3.algoName) 3"), (ai4, "\(ai4.algoName) 4")]
              let res = peformanceOfAI(ais)
              let winnings = res.winnigs()
              stats.append(winnings)
              
              let aisPrint = ais.map {
                $0.1
              }
              print("\(winnings) : \(aisPrint)")
            }
          }
        }
      }
    }
    
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
    
    print(flatten(stats.toArray()))
  }
}