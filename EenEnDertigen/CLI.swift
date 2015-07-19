//
//  CLI.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

struct Position {
  let x: Int
  let y: Int
  
  var cliRep: String {
    return "\u{1B}[\(y);\(x)H"
  }
  
  func down(n: Int) -> Position {
    return Position(x: x, y: y+n)
  }
  
  func right(n: Int) -> Position {
    return Position(x: x+n, y: y)
  }
}

let ClearChar = "\u{1B}[2J"

func clear() {
  print(ClearChar)
}

func print(pos: Position, string: String) {
  print("\(pos.cliRep)\(string)")
}

infix operator >>> {}

func >>>(lhs: Position, rhs: String) {
  print(lhs, string: rhs)
}