//
//  main.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let game = Game()
game.startGame({
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

//func startGame() {
//  game.startRound()
//  
//  InputPosition >>> "Type 'r' om het spel te herstarten..."
//  
//  let input = getKeyboardInput()
//  if input == "r" {
//    fflush(__stdoutp)
//    startGame()
//  } else {
//    exit(0)
//  }
//}
//
//startGame()