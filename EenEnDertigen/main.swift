//
//  main.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let game = Game()

func startGame() {
  game.start()
  
  print("\n\nType 'r' om het spel te herstarten...")
  let input = getKeyboardInput()
  if input == "r" {
      startGame()
  } else {
    exit(0)
  }
}

startGame()