//
//  main.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let args = Process.arguments

var tournament = false

if args.count > 1 {
  let arg = args[1]
  
  if arg == "test-ai" {
    tournament = true
  }
}

if tournament {
  Tournament(roundsPerGame: 10, startoffSticks: 5).playTournament()
} else {
  let game = Game(shouldPrint: true)
  game.startGame(true, restartClosure: {
    InputPosition >>> "Type 'r' om het spel te herstarten..."
    let input = getKeyboardInput()
    if input == "r" {
      fflush(__stdoutp)
      return true
    } else {
      return false
    }
    }, finishClosure: {
      InputPosition >>> "Einde!"
      let input = getKeyboardInput()
      if input == "r" {
        fflush(__stdoutp)
        return true
      } else {
        return false
      }
  })
}