//
//  main.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let game = Game()

print("\u{1B}[2J")
print("\u{1B}[0;0HEENENDERTIGEN")

func startGame() {
  game.start()
  
  print("\n\nType 'r' om het spel te herstarten...")
  let input = getKeyboardInput()
  if input == "r" {
    fflush(__stdoutp)
    startGame()
  } else {
    exit(0)
  }
}

startGame()