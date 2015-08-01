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

class Tournament {
  let roundsPerGame: Int
  let startoffSticks: Int
  
  init(roundsPerGame: Int, startoffSticks: Int) {
    self.roundsPerGame = roundsPerGame
    self.startoffSticks = startoffSticks
  }
  
  func peformanceOfAI(ai: [(PlayerMove.Type, String)], gameId: Int = 0) -> PlayedGame {
    let game = Game(shouldPrint: false)
    
    var playedGames = [[Speler]]()
    
    for _ in 1...roundsPerGame {
      game.spelers = ai.map { (ai, name) in
        return Speler(kaarten: [], name: name, sticks: startoffSticks, beurten: [], position: NoordPosition, ai: ai.init())
      }
      
      game.startGame(false)
      playedGames.append(game.spelers)
    }
    
    return PlayedGame(scores: playedGames.map { spelerArr in
      Score(spelers: spelerArr)
    })
  }
  
  func playTournament() {
    let AIs: [PlayerMove.Type] = [HighestPointsAvailableKeepHighCardsAI.self, HighestPointsAvailableAI.self, WisselBot.self, PassBot.self, RandomBot.self, HighestPointsPlusWisselAvailableAI.self]
    
    var stats = SynchronizedArray<[String: Int]>()
    
    let dispatchGroup = dispatch_group_create()
    let dispatchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    
    let watch = StopWatch()
    watch.start()
    
    var potje = 0
    
    for ai1 in AIs {
      for ai2 in AIs {
        for ai3 in AIs {
          for ai4 in AIs {
            potje++
            let potjeIndex = potje
            dispatch_group_async(dispatchGroup, dispatchQueue) {
              let duration = StopWatch()
              duration.start()
              let ais = [(ai1, "\(ai1.algoName) 1"), (ai2, "\(ai2.algoName) 2"), (ai3, "\(ai3.algoName) 3"), (ai4, "\(ai4.algoName) 4")]
              let res = self.peformanceOfAI(ais, gameId: potjeIndex)
              let winnings = res.winnigs()
              stats.append(winnings)
              
              let aisPrint = ais.map {
                $0.1
              }
              print("\(potjeIndex)/\(potje) \(winnings) : \(aisPrint)\ntime: \(watch.getLap()) - \(duration.getLap())")
            }
          }
        }
      }
    }
    
    dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
    
    let scores = flatten(stats.toArray()).sort { lhs, rhs in
      return lhs.1 > rhs.1
    }
    
    print("\n\nSCORES: (potjes van \(roundsPerGame) gewonnen)\n")
    
    print(scores.reduce("") { prev, el in
      return prev + "\(el.0): \(el.1)\n"
    })
    
    print("Tijd: \(watch.getLap())")
  }
}